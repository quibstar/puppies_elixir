defmodule Puppies.ES.Breeds do
  @moduledoc """
  Elaticsearch: creating indexing and deleting indexing
  """
  alias Puppies.{ES.Api, ES.Indexing, Breeds}

  def create_mappings_and_index() do
    date_time = DateTime.utc_now() |> DateTime.to_unix()
    breed = "breeds_#{date_time}"

    # Mappings
    breed_mapping = data_type_mapping()
    Indexing.create_mappings(breed, breed_mapping)

    # Api.delete("/breeds")
    Indexing.alias(breed, "breeds")
    index_breeds(breed)
  end

  defp index_breeds(index) do
    breeds = Breeds.breeds_and_attributes()

    Enum.each(breeds, fn breed ->
      res = transform_to_flat_data(breed)

      Api.post("/#{index}/_doc/#{breed.id}", res)
    end)
  end

  def delete_all_breeds do
    {:ok, list} = Indexing.get_index("_aliases")
    new_list = Jason.decode!(list)

    Enum.each(new_list, fn l ->
      res = elem(l, 0)

      if String.contains?(res, "breeds") do
        Indexing.delete_index(res)
      end
    end)
  end

  defp transform_to_flat_data(breed) do
    %{
      id: breed.id,
      name: breed.name,
      slug: breed.slug,
      kid_friendly: breed.attributes.kid_friendly,
      dog_friendly: breed.attributes.dog_friendly,
      friendly_toward_strangers: breed.attributes.friendly_toward_strangers,
      affectionate_with_family: breed.attributes.affectionate_with_family,
      good_for_novice_owners: breed.attributes.good_for_novice_owners,
      intelligence: breed.attributes.intelligence,
      energy_level: breed.attributes.energy_level,
      tendency_to_bark_or_howl: breed.attributes.tendency_to_bark_or_howl,
      size: breed.attributes.size,
      intensity: breed.attributes.intensity,
      prey_drive: breed.attributes.prey_drive,
      adaptability: breed.attributes.adaptability,
      adapts_well_to_apartment_living: breed.attributes.adapts_well_to_apartment_living,
      exercise_needs: breed.attributes.exercise_needs,
      trainability: breed.attributes.trainability,
      wanderlust_potential: breed.attributes.wanderlust_potential
    }
  end

  # Mappings
  defp data_type_mapping() do
    %{
      mappings: %{
        properties: %{
          name: %{type: :text},
          slug: %{type: :text},
          kid_friendly: %{type: :integer},
          dog_friendly: %{type: :integer},
          friendly_toward_strangers: %{type: :integer},
          affectionate_with_family: %{type: :integer},
          good_for_novice_owners: %{type: :integer},
          intelligence: %{type: :integer},
          energy_level: %{type: :integer},
          tendency_to_bark_or_howl: %{type: :integer},
          size: %{type: :integer},
          intensity: %{type: :integer},
          prey_drive: %{type: :integer},
          adaptability: %{type: :integer},
          adapts_well_to_apartment_living: %{type: :integer},
          exercise_needs: %{type: :integer},
          trainability: %{type: :integer},
          wanderlust_potential: %{type: :integer}
        }
      }
    }
  end
end
