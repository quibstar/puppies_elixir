defmodule Puppies.ES.ListingFixture do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puppies.Photos` context.
  """

  @doc """
  Generate a photo.
  """
  def es_listing(attrs \\ %{}) do
    %{
      email: Map.get(attrs, :email, "stest@example"),
      first_name: Map.get(attrs, :first_name, "Jon"),
      last_name: Map.get(attrs, :last_name, "doe"),
      user_status: Map.get(attrs, :user_status, "active"),
      user_phone_number: Map.get(attrs, :user_phone_number, "something"),
      deliver_on_site: Map.get(attrs, :deliver_on_site, false),
      deliver_pick_up: Map.get(attrs, :deliver_pick_up, false),
      delivery_shipped: Map.get(attrs, :delivery_shipped, false),
      champion_sired: Map.get(attrs, :champion_sired, false),
      show_quality: Map.get(attrs, :show_quality, false),
      champion_bloodline: Map.get(attrs, :champion_bloodline, false),
      registered: Map.get(attrs, :registered, false),
      registrable: Map.get(attrs, :registrable, false),
      current_vaccinations: Map.get(attrs, :current_vaccinations, false),
      veterinary_exam: Map.get(attrs, :veterinary_exam, false),
      health_certificate: Map.get(attrs, :health_certificate, false),
      health_guarantee: Map.get(attrs, :health_guarantee, false),
      pedigree: Map.get(attrs, :pedigree, false),
      hypoallergenic: Map.get(attrs, :hypoallergenic, false),
      microchip: Map.get(attrs, :microchip, false),
      purebred: Map.get(attrs, :purebred, false),
      coat_color_pattern: Map.get(attrs, :coat_color_pattern, "something"),
      description: Map.get(attrs, :description, "this is a description"),
      dob: Map.get(attrs, :dob, "2022-07-27"),
      name: Map.get(attrs, :name, "Jon"),
      price: Map.get(attrs, :price, 100),
      sex: Map.get(attrs, :sex, "something"),
      status: Map.get(attrs, :status, "something"),
      breeds_slug: Map.get(attrs, :breeds_slug, "something"),
      business_name: Map.get(attrs, :business_name, "something"),
      business_slug: Map.get(attrs, :business_slug, "something"),
      business_phone_number: Map.get(attrs, :business_phone_number, "something"),
      state_license: Map.get(attrs, :state_license, false),
      federal_license: Map.get(attrs, :federal_license, false),
      website: Map.get(attrs, :website, "test.com"),
      place_name:
        Map.get(
          attrs,
          :place_name,
          "7358 Pine Valley Drive, Allendale, Michigan 49401, United States"
        ),
      region_slug: Map.get(attrs, :region_slug, "michigan"),
      place_slug: Map.get(attrs, :place_slug, "allendale"),
      region_short_code: Map.get(attrs, :region_short_code, "mi"),
      place: Map.get(attrs, :place, "Allendale"),
      region: Map.get(attrs, :region, "Michigan"),
      location: %{
        lat: Map.get(attrs, :lat, 42.9652),
        lon: Map.get(attrs, :lng, -85.9677)
      }
    }
  end
end
