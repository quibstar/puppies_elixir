defmodule Puppies.IPDatumFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puppies.Flags` context.
  """

  @doc """
  Generate a flag.
  """
  def ip_datum_fixture(attrs \\ %{}) do
    {:ok, ip_datum} =
      attrs
      |> Enum.into(%{
        city: "Los Angeles",
        continent_code: "NA",
        continent_name: "North America",
        country_code: "US",
        country_name: "United States",
        ip: "134.201.250.155",
        isp: "some isp",
        latitude: "34.0453",
        longitude: "-118.2413",
        region_code: "CA",
        region_name: "California",
        time_zone: "America/Los_Angeles",
        type: "ipv4",
        zip: 90013
      })
      |> Puppies.IPData.create()

    ip_datum
  end
end
