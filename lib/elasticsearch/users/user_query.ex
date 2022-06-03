defmodule Puppies.ES.UserQuery do
  alias Puppies.{ES.Api}

  alias Puppies.SearchUser

  def user_query(term) do
    {:ok, results} = query(term)
    {:ok, res} = Jason.decode(results)

    users =
      Enum.reduce(res["hits"]["hits"], [], fn user, acc ->
        source = user["_source"]
        highlight = user["highlight"]
        search_user = Map.merge(source, %{"highlight" => highlight})
        u = SearchUser.transform(search_user)
        [u | acc]
      end)

    count = res["hits"]["total"]["value"]
    %{users: users, count: count}
  end

  defp query(term) do
    body = %{
      query: %{
        bool: %{
          should: [
            %{match_bool_prefix: %{name: term}},
            %{match_bool_prefix: %{email: term}},
            %{match: %{phone_number: term}},
            %{match: %{business_phone_number: term}},
            %{match_bool_prefix: %{business_name: term}},
            %{match_phrase: %{business_description: term}},
            %{match: %{transactions_last_4: term}},
            %{match: %{transactions_reference_number: term}},
            %{match_phrase: %{listing_descriptions: term}}
          ]
        }
      },
      highlight: %{
        tags_schema: "styled",
        fields: %{
          name: %{},
          email: %{},
          phone_number: %{},
          business_phone_number: %{},
          business_name: %{},
          business_description: %{},
          transactions_last_4: %{},
          transactions_reference_number: %{},
          listing_descriptions: %{}
        }
      }
    }

    Api.post("/users/_search", body)
  end
end
