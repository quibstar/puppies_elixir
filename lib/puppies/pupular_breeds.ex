defmodule Puppies.PopularBreeds do
  @moduledoc """
  The PopularPlaces api.
  """

  import Ecto.Query, warn: false
  alias Puppies.{Repo, PopularBreed}

  def daily_generation_of_most_popular do
    {:ok, es_results} = Puppies.ES.BreedsSearch.popular_breeds_aggregate()
    {:ok, to_map} = Jason.decode(es_results)
    breeds = to_map["aggregations"]["breeds"]["buckets"]
    Repo.delete_all(PopularBreed)

    Enum.each(breeds, fn breed ->
      fetched_breed = Puppies.BreedsSearch.get_breed_by_slug(breed["key"])

      %PopularBreed{}
      |> PopularBreed.changeset(%{
        count: breed["doc_count"],
        slug: fetched_breed.slug,
        name: fetched_breed.name
      })
      |> Repo.insert()
    end)
  end

  def list_popular_breeds do
    Repo.all(PopularBreed)
  end
end
