defmodule Puppies.ES.BreedSearch do
  alias Puppies.{ES.Api}

  def autocomplete(term) do
    IO.inspect(term)
    {:ok, results} = query_breeds(term)
    {:ok, res} = Jason.decode(results)

    res = res["hits"]["hits"]

    unless res == [] do
      process_hits(res)
    end
  end

  defp query_breeds(term) do
    q = %{
      size: 400,
      query: %{
        match_bool_prefix: %{
          name: term.name
        }
        # bool: %{
        #   filter: [
        #     # %{term: %{size: term.size}},
        #     %{term: %{kid_friendly: term.kid_friendly}}
        #   ]
        # }
      }
    }

    Api.post("/breeds/_search", q)
  end

  defp process_hits(data) do
    res =
      Enum.reduce(data, [], fn d, acc ->
        map = %{name: d["_source"]["name"], slug: d["_source"]["slug"]}
        [map | acc]
      end)

    Enum.reverse(res)
  end
end
