defmodule Puppies.ES.StateCitySearch do
  alias Puppies.{ES.Api}

  def query_state(state, page, size) do
    s =
      if String.length(state) > 2 do
        %{region_slug: state}
      else
        %{region_short_code: state}
      end

    body = %{
      sort: [
        %{updated_at: "desc"}
      ],
      from: page,
      size: size,
      query: %{
        bool: %{
          must: [
            %{term: s}
          ]
        }
      }
    }

    Api.post("/listings/_search", body)
  end

  def state(state, page, size) do
    page = String.to_integer(page)
    size = String.to_integer(size)
    {:ok, results} = query_state(state, page * size, size)
    {:ok, res} = Jason.decode(results)
    %{matches: res["hits"]["hits"], count: res["hits"]["total"]["value"]}
  end
end
