defmodule Puppies.BusinessesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puppies.Businesses` context.
  """

  @doc """
  Generate a business.
  """
  def business_fixture(attrs \\ %{}) do
    {:ok, business} =
      attrs
      |> Enum.into(%{
        description: "some description",
        federal_license: true,
        name: "some name",
        phone: "some phone",
        state_license: true,
        website: "some website"
      })
      |> Puppies.Businesses.create_business()

    business
  end
end
