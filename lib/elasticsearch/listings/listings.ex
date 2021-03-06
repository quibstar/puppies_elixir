defmodule Puppies.ES.Listings do
  @moduledoc """
  Elasticsearch: creating indexing and deleting indexing
  """
  alias Puppies.{ES.Api, ES.Indexing, Listings}

  def re_index_listings_by_user_id(user_id) do
    ids = Listings.get_listings_ids_for_user(user_id)

    Enum.each(ids, fn id ->
      re_index_listing(id)
    end)
  end

  def re_index_listing(id) do
    listing = Listings.listing_for_elastic_search_reindexing(id)
    res = transform_to_flat_data(listing)
    Api.post("/listings/_doc/#{listing.id}", res)
  end

  def create_mappings_and_index() do
    date_time = DateTime.utc_now() |> DateTime.to_unix()
    listing = "listings_#{date_time}"

    # Mappings
    listing_mapping = data_type_mapping()
    Indexing.create_mappings(listing, listing_mapping)

    Api.delete("/listings")
    Indexing.alias(listing, "listings")
    index_listings(listing)
  end

  defp index_listings(index) do
    listings = Listings.list_listings()

    Enum.each(listings, fn listing ->
      res = transform_to_flat_data(listing)

      Api.post("/#{index}/_doc/#{listing.id}", res)
    end)
  end

  def delete_all_listings do
    {:ok, list} = Indexing.get_index("_aliases")
    new_list = Jason.decode!(list)

    Enum.each(new_list, fn l ->
      res = elem(l, 0)

      if String.contains?(res, "listings") do
        Indexing.delete_index(res)
      end
    end)
  end

  defp transform_to_flat_data(listing) do
    business_photo_url =
      unless is_nil(listing.user.business.photo) do
        listing.user.business.photo.url
      else
        ""
      end

    %{
      id: listing.id,
      first_name: listing.user.first_name,
      last_name: listing.user.last_name,
      user_status: listing.user.status,
      reputation_level: listing.user.reputation_level,
      approved_to_sell: listing.user.approved_to_sell,
      locked: listing.user.locked,
      deliver_on_site: listing.deliver_on_site,
      deliver_pick_up: listing.deliver_pick_up,
      delivery_shipped: listing.delivery_shipped,
      champion_sired: listing.champion_sired,
      show_quality: listing.show_quality,
      champion_bloodline: listing.champion_bloodline,
      registered: listing.registered,
      registrable: listing.registrable,
      current_vaccinations: listing.current_vaccinations,
      veterinary_exam: listing.veterinary_exam,
      health_certificate: listing.health_certificate,
      health_guarantee: listing.health_guarantee,
      pedigree: listing.pedigree,
      hypoallergenic: listing.hypoallergenic,
      microchip: listing.microchip,
      purebred: listing.purebred,
      coat_color_pattern: listing.coat_color_pattern,
      description: listing.description,
      dob: listing.dob,
      name: listing.name,
      price: listing.price,
      sex: listing.sex,
      status: listing.status,
      photos: Enum.reduce(listing.photos, [], fn photo, acc -> [photo.url | acc] end),
      breeds_slug: Enum.reduce(listing.breeds, [], fn breed, acc -> [breed.slug | acc] end),
      breeds_name: Enum.reduce(listing.breeds, [], fn breed, acc -> [breed.name | acc] end),
      business_slug: listing.user.business.slug,
      business_name: listing.user.business.name,
      business_photo: business_photo_url,
      place_name: listing.user.business.location.place_name,
      region_slug: listing.user.business.location.region_slug,
      place_slug: listing.user.business.location.place_slug,
      region_short_code: listing.user.business.location.region_short_code,
      place: listing.user.business.location.place,
      region: listing.user.business.location.region,
      location: %{
        lat: listing.user.business.location.lat,
        lon: listing.user.business.location.lng
      },
      updated_at: listing.updated_at,
      views: listing.views
    }
  end

  defp data_type_mapping() do
    %{
      mappings: %{
        properties: %{
          id: %{type: :integer},
          email: %{type: :keyword},
          first_name: %{type: :text},
          user_phone_number: %{type: :keyword},
          approved_to_sell: %{type: :boolean},
          locked: %{type: :boolean},
          last_name: %{type: :text},
          user_status: %{type: :text},
          reputation_level: %{type: :integer},
          photos: %{type: :keyword},
          deliver_on_site: %{type: :boolean},
          deliver_pick_up: %{type: :boolean},
          delivery_shipped: %{type: :boolean},
          champion_sired: %{type: :boolean},
          show_quality: %{type: :boolean},
          champion_bloodline: %{type: :boolean},
          registered: %{type: :boolean},
          registrable: %{type: :boolean},
          current_vaccinations: %{type: :boolean},
          veterinary_exam: %{type: :boolean},
          health_certificate: %{type: :boolean},
          health_guarantee: %{type: :boolean},
          pedigree: %{type: :boolean},
          hypoallergenic: %{type: :boolean},
          microchip: %{type: :boolean},
          purebred: %{type: :boolean},
          coat_color_pattern: %{type: :keyword},
          description: %{type: :text},
          dob: %{type: :date},
          name: %{type: :text},
          price: %{type: :integer},
          sex: %{type: :keyword},
          status: %{type: :keyword},
          breeds_slug: %{type: :keyword},
          breeds_name: %{type: :keyword},
          business_slug: %{type: :keyword},
          business_name: %{type: :keyword},
          business_photo: %{type: :keyword},
          place_name: %{type: :keyword},
          region_slug: %{type: :keyword},
          place_slug: %{type: :keyword},
          region_short_code: %{type: :keyword},
          place: %{type: :keyword},
          region: %{type: :keyword},
          location: %{type: :geo_point},
          updated_at: %{type: :date},
          views: %{type: :integer}
        }
      }
    }
  end
end
