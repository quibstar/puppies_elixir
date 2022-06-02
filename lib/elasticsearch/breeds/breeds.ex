defmodule Puppies.ES.Breeds do
  @moduledoc """
  Elasticsearch: creating indexing and deleting indexing
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
      size: breed.attributes.size,
      dog_friendly: breed.attributes.dog_friendly,
      kid_friendly: breed.attributes.kid_friendly,
      friendly_toward_strangers: breed.attributes.friendly_toward_strangers,
      amount_of_shedding: breed.attributes.amount_of_shedding,
      trainability: breed.attributes.trainability,
      intelligence: breed.attributes.intelligence,
      tendency_to_bark_or_howl: breed.attributes.tendency_to_bark_or_howl,
      adaptability: breed.attributes.adaptability,
      adapts_well_to_apartment_living: breed.attributes.adapts_well_to_apartment_living,
      affectionate_with_family: breed.attributes.affectionate_with_family,
      all_around_friendliness: breed.attributes.all_around_friendliness,
      drooling_potential: breed.attributes.drooling_potential,
      easy_to_groom: breed.attributes.easy_to_groom,
      easy_to_train: breed.attributes.easy_to_train,
      energy_level: breed.attributes.energy_level,
      exercise_needs: breed.attributes.exercise_needs,
      general_health: breed.attributes.general_health,
      good_for_novice_owners: breed.attributes.good_for_novice_owners,
      health_and_grooming_needs: breed.attributes.health_and_grooming_needs,
      intensity: breed.attributes.intensity,
      physical_needs: breed.attributes.physical_needs,
      potential_for_mouthiness: breed.attributes.potential_for_mouthiness,
      potential_for_playfulness: breed.attributes.potential_for_playfulness,
      potential_for_weight_gain: breed.attributes.potential_for_weight_gain,
      prey_drive: breed.attributes.prey_drive,
      sensitivity_level: breed.attributes.sensitivity_level,
      tolerates_being_alone: breed.attributes.tolerates_being_alone,
      tolerates_cold_weather: breed.attributes.tolerates_cold_weather,
      tolerates_hot_weather: breed.attributes.tolerates_hot_weather,
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
          group: %{type: :text},
          size: %{type: :integer},
          dog_friendly: %{type: :integer},
          kid_friendly: %{type: :integer},
          friendly_toward_strangers: %{type: :integer},
          amount_of_shedding: %{type: :integer},
          trainability: %{type: :integer},
          intelligence: %{type: :integer},
          tendency_to_bark_or_howl: %{type: :integer},
          adaptability: %{type: :integer},
          adapts_well_to_apartment_living: %{type: :integer},
          affectionate_with_family: %{type: :integer},
          all_around_friendliness: %{type: :integer},
          drooling_potential: %{type: :integer},
          easy_to_groom: %{type: :integer},
          easy_to_train: %{type: :integer},
          energy_level: %{type: :integer},
          exercise_needs: %{type: :integer},
          general_health: %{type: :integer},
          good_for_novice_owners: %{type: :integer},
          health_and_grooming_needs: %{type: :integer},
          intensity: %{type: :integer},
          physical_needs: %{type: :integer},
          potential_for_mouthiness: %{type: :integer},
          potential_for_playfulness: %{type: :integer},
          potential_for_weight_gain: %{type: :integer},
          prey_drive: %{type: :integer},
          sensitivity_level: %{type: :integer},
          tolerates_being_alone: %{type: :integer},
          tolerates_cold_weather: %{type: :integer},
          tolerates_hot_weather: %{type: :integer},
          wanderlust_potential: %{type: :integer}
        }
      }
    }
  end
end
