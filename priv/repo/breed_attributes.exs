defmodule Puppies.BreedsAttributes do
  alias Puppies.{BreedAttribute, Breeds}
  alias Puppies.Repo

  def update_breed_attributes do
    {:ok, path} = File.cwd()

    json = File.read!(path <> "/priv/repo/breed_attributes.json")
    decoded = Jason.decode!(json)

    Enum.each(decoded, fn breed ->
      b = Puppies.Breeds.get_breed_by_name(breed["name"])

      change = Map.merge(breed, %{"breed_id" => b.id})

      %BreedAttribute{}
      |> BreedAttribute.changeset(change)
      |> Repo.insert()
    end)
  end
end

Puppies.BreedsAttributes.update_breed_attributes()
