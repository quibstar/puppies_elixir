defmodule Puppies.LocationsFixture do
  Faker.start()

  def location_list() do
    grand_rapids = %{
      place_name: "Grand Rapids, Michigan, United States",
      text: Faker.Address.En.street_name(),
      address: "1234",
      lng: -85.6557,
      lat: 42.961,
      place: "Grand Rapids",
      region: "Michigan",
      region_short_code: "mi",
      place_slug: "grand-rapids",
      region_slug: "michigan",
      country: "United States"
    }

    detroit = %{
      place_name: "Detroit",
      region: "Michigan",
      country: "United States",
      text: Faker.Address.En.street_name(),
      address: "1234",
      lng: -83.0458,
      lat: 42.3314,
      place: "Detroit",
      region_short_code: "mi",
      place_slug: "detroit",
      region_slug: "michigan"
    }

    chicago = %{
      place_name: "Chicago",
      region: "Illinois",
      country: "United States",
      text: Faker.Address.En.street_name(),
      address: "1234",
      lng: -87.6298,
      lat: 41.8781,
      place: "Chicago",
      region_short_code: "il",
      place_slug: "chicago",
      region_slug: "illinois"
    }

    lansing = %{
      place_name: "Lansing",
      region: "Michigan",
      country: "United States",
      text: Faker.Address.En.street_name(),
      address: "1234",
      lng: -84.553932,
      lat: 42.733620,
      place: "Lansing",
      region_short_code: "mi",
      place_slug: "lansing",
      region_slug: "michigan"
    }

    los_angeles = %{
      place_name: "Los Angeles",
      region: "California",
      country: "United States",
      text: Faker.Address.En.street_name(),
      address: "1234",
      lng: -118.2437,
      lat: 34.0522,
      place: "Los Angeles",
      region_short_code: "ca",
      place_slug: "los-angeles",
      region_slug: "california"
    }

    phoenix = %{
      place_name: "Phoenix",
      region: "Arizona",
      country: "United States",
      text: Faker.Address.En.street_name(),
      address: "1234",
      lng: -112.0740,
      lat: 33.4484,
      place: "Phoenix",
      region_short_code: "az",
      place_slug: "phoenix",
      region_slug: "arizona"
    }

    [grand_rapids, detroit, chicago, lansing, los_angeles, phoenix]
  end
end
