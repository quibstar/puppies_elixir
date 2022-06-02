defmodule Puppies.ES.UserQuery do
  alias Puppies.{ES.Api}

  alias Puppies.SearchUser

  def user_query(term) do
    {:ok, results} = query(term)
    {:ok, res} = Jason.decode(results)
    IO.inspect(res)

    users =
      Enum.reduce(res["hits"]["hits"], [], fn user, acc ->
        source = user["_source"]
        u = SearchUser.transform(source)
        [u | acc]
      end)

    count = res["total"]["value"]
    %{users: users, count: count}
  end

  defp query(term) do
    body = %{
      query: %{
        bool: %{
          should: [
            %{match_bool_prefix: %{name: term}},
            %{match_bool_prefix: %{email: term}},
            %{match_bool_prefix: %{phone_number: term}},
            %{match_bool_prefix: %{business_phone_number: term}},
            %{match_bool_prefix: %{business_name: term}},
            %{match_bool_prefix: %{transactions: term}},
            %{match_bool_prefix: %{listing_descriptions: term}}
          ]
        }
      },
      highlight: %{
        fields: %{
          *: %{}
        }
      }
    }

    Api.post("/users/_search", body)
  end
end
