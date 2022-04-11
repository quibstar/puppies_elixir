defmodule Puppies.ES.IndexListings do
  @moduledoc """
  Elaticsearch: Health check, creating indexing and deleting indexing
  """
  alias Puppies.{ES.Api, ES.Indexing, Listings}

  def index_listings(index) do
    listings = Listings.list_listings()

    Enum.each(listings, fn listing ->
      res = transform_to_flat_data(listing)

      Api.post("/#{index}/_doc/#{listing.id}", res)
    end)
  end

  def create_mappings_and_index() do
    date_time = DateTime.utc_now() |> DateTime.to_unix()
    listing = "listings_#{date_time}"

    # Mappings
    listing_mapping = Puppies.Mappings.listings()
    Indexing.create_mappings(listing, listing_mapping)

    # Api.delete("/listings")
    Indexing.alias(listing, "listings")
    index_listings(listing)
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

  def transform_to_flat_data(listing) do
    %{
      id: listing.id,
      email: listing.user.email,
      first_name: listing.user.first_name,
      last_name: listing.user.last_name,
      user_status: listing.user.status,
      approved_to_sell: listing.user.approved_to_sell,
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
      business_name: listing.user.business.name,
      business_slug: listing.user.business.slug,
      business_photo: listing.user.business.photo.url,
      business_breeds_slug:
        Enum.reduce(listing.user.business.breeds, [], fn breed, acc -> [breed.slug | acc] end),
      phone: listing.user.business.phone,
      state_license: listing.user.business.state_license,
      federal_license: listing.user.business.federal_license,
      website: listing.user.business.website,
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
end
