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
        coat: "some coat",
        description: "some description",
        dob: ~N[2022-03-27 21:17:00],
        limitations: "some limitations",
        name: "some name",
        price: 42,
        requirements: "some requirements",
        sex: "some sex",
        status: "some status"
      })
      |> Puppies.Listings.create_listing()

    listing
  end
end
