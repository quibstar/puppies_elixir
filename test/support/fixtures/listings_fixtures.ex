defmodule Puppies.ListingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puppies.Listings` context.
  """

  @doc """
  Generate a listing.
  """
  def listing_fixture(attrs \\ %{}) do
    {:ok, listing} =
      attrs
      |> Enum.into(%{
        coat_color_pattern: "some value",
        description: "some value",
        dob: ~N[2022-03-27 21:17:00],
        name: "spike",
        price: 500,
        sex: "Male",
        status: "available",
        views: 200,
        deliver_on_site: true,
        deliver_pick_up: true,
        delivery_shipped: true,
        champion_sired: true,
        show_quality: true,
        champion_bloodline: true,
        registered: true,
        registrable: true,
        current_vaccinations: true,
        veterinary_exam: true,
        health_certificate: true,
        health_guarantee: true,
        pedigree: true,
        hypoallergenic: true,
        microchip: true,
        purebred: true,
        breeds: [],
        listing_breeds: [],
        photos: [],
        user: nil
      })
      |> Puppies.Listings.create_listing()

    listing
  end
end
