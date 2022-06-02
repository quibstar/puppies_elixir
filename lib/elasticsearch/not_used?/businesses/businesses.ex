defmodule Puppies.ES.Businesses do
  @moduledoc """
  Elasticsearch: creating indexing and deleting indexing
  """
  alias Puppies.{ES.Api, ES.Indexing, Businesses}

  def re_index_businesses_by_user_id(user_id) do
    ids = Businesses.get_business_by_user_id(user_id)

    Enum.each(ids, fn id ->
      re_index_business(id)
    end)
  end

  def re_index_business(id) do
    business = Businesses.get_business(id)
    res = transform_to_flat_data(business)
    Api.post("/businesses/_doc/#{business.id}", res)
  end

  def create_mappings_and_index() do
    date_time = DateTime.utc_now() |> DateTime.to_unix()
    business = "businesses_#{date_time}"

    # Mappings
    business_mapping = data_type_mapping()
    Indexing.create_mappings(business, business_mapping)

    Api.delete("/businesses")
    Indexing.alias(business, "businesses")
    index_businesses(business)
  end

  defp index_businesses(index) do
    businesses = Businesses.list_businesses()

    Enum.each(businesses, fn business ->
      res = transform_to_flat_data(business)

      Api.post("/#{index}/_doc/#{business.id}", res)
    end)
  end

  def delete_all_businesses do
    {:ok, list} = Indexing.get_index("_aliases")
    new_list = Jason.decode!(list)

    Enum.each(new_list, fn l ->
      res = elem(l, 0)

      if String.contains?(res, "businesses") do
        Indexing.delete_index(res)
      end
    end)
  end

  defp transform_to_flat_data(business) do
    %{
      user_id: business.user_id,
      id: business.id,
      name: business.name,
      slug: business.slug,
      photo: business.photo.url,
      breeds_slug: Enum.reduce(business.breeds, [], fn breed, acc -> [breed.slug | acc] end),
      phone_number: business.phone_number,
      state_license: business.state_license,
      federal_license: business.federal_license,
      website: business.website,
      place_name: business.location.place_name,
      region_slug: business.location.region_slug,
      place_slug: business.location.place_slug,
      region_short_code: business.location.region_short_code,
      place: business.location.place,
      region: business.location.region,
      location: %{
        lat: business.location.lat,
        lon: business.location.lng
      }
    }
  end

  defp data_type_mapping() do
    %{
      mappings: %{
        properties: %{
          user_id: %{type: :integer},
          id: %{type: :integer},
          name: %{type: :keyword},
          slug: %{type: :keyword},
          photo: %{type: :keyword},
          breeds_slug: %{type: :keyword},
          phone_number: %{type: :keyword},
          state_license: %{type: :boolean},
          federal_license: %{type: :boolean},
          website: %{type: :keyword},
          place_name: %{type: :keyword},
          region_slug: %{type: :keyword},
          place_slug: %{type: :keyword},
          region_short_code: %{type: :keyword},
          place: %{type: :keyword},
          region: %{type: :keyword},
          location: %{type: :geo_point}
        }
      }
    }
  end
end
