defmodule PuppiesSeeds do
  import Jason

  alias Puppies.{
    Repo,
    Dogs,
    ListingStatus,
    Accounts,
    Accounts.User,
    Businesses,
    Photos,
    Location,
    Utilities,
    Listings,
    Businesses.Business
  }

  "#{__DIR__}/breeds.json"
  |> File.read!()
  |> Jason.decode!()
  |> Enum.map(fn breed ->
    res = Dogs.create_breed(%{name: breed, slug: Utilities.string_to_slug(breed)})
  end)

  Enum.each(["available", "on hold", "sold"], fn opt ->
    %ListingStatus{}
    |> ListingStatus.changeset(%{status: opt})
    |> Repo.insert()
  end)

  def create_user(x) do
    u = %{
      email: "test#{x}@example.com",
      password: "superSecret!",
      first_name: Faker.Person.first_name(),
      last_name: Faker.Person.last_name(),
      status: "active",
      terms_of_service: true
    }

    {:ok, user} = Accounts.register_user(u)
    Accounts.seed_confirm_user(user)
    user
  end

  def create_business(user) do
    name = Faker.Company.name()
    loc = location_list() |> Enum.random()

    bus = %{
      name: name,
      slug: Utilities.string_to_slug(name),
      website: Faker.Internet.domain_name(),
      phone: Faker.Phone.EnUs.phone(),
      description: Enum.join(Faker.Lorem.paragraphs(1..3), " "),
      state_license: yes_or_no(),
      federal_license: yes_or_no(),
      user_id: user.id,
      location_autocomplete: loc.place_name,
      location: loc,
      business_breeds: [%{breed_id: Enum.random(1..10)}]
    }

    {:ok, business} = Businesses.create_business(bus)
    num = Enum.random(1..9) |> Integer.to_string()
    name = "#{num}.jpg"
    url = "/uploads/business/" <> name
    create_photo(business.id, nil, url, name)
    business
  end

  def create_photo(business_id, listing_id, url, name) do
    Photos.change_photo(%Photos.Photo{}, %{
      url: url,
      name: name,
      business_id: business_id,
      listing_id: listing_id
    })
    |> Repo.insert!()
  end

  def create_listing(user) do
    listing = %{
      user_id: user.id,
      coat_color_pattern: coat(),
      description: Enum.join(Faker.Lorem.paragraphs(1..3), " "),
      dob:
        Faker.Date.between(
          Date.add(NaiveDateTime.utc_now(), -5),
          Date.add(NaiveDateTime.utc_now(), 10)
        ),
      name: Faker.Person.first_name(),
      price: Enum.random(100..2500//100),
      sex: male_or_female(),
      status: "available",
      deliver_on_site: yes_or_no(),
      deliver_pick_up: yes_or_no(),
      delivery_shipped: yes_or_no(),
      champion_sired: yes_or_no(),
      show_quality: yes_or_no(),
      champion_bloodline: yes_or_no(),
      registered: yes_or_no(),
      registrable: yes_or_no(),
      current_vaccinations: yes_or_no(),
      veterinary_exam: yes_or_no(),
      health_certificate: yes_or_no(),
      health_guarantee: yes_or_no(),
      pedigree: yes_or_no(),
      hypoallergenic: yes_or_no(),
      microchip: yes_or_no(),
      purebred: yes_or_no(),
      approved_to_sell: true,
      listing_breeds: [%{breed_id: Enum.random(1..10)}]
    }

    {:ok, listing} = Listings.create_listing(listing)

    listing_image(listing)
    listing_image(listing)
    listing_image(listing)
    listing_image(listing)
  end

  def listing_image(listing) do
    num = Enum.random(1..16) |> Integer.to_string()
    name = "#{num}.jpg"
    url = "/uploads/dogs/" <> name
    create_photo(nil, listing.id, url, name)
  end

  def yes_or_no() do
    Enum.random([true, false])
  end

  def male_or_female() do
    Enum.random(["male", "female"])
  end

  def coat() do
    Enum.random([
      nil,
      "Black & Tan",
      "Bicolor",
      "Tricolor",
      "Merle",
      "Tuxedo",
      "Harlequin",
      "Spotted",
      "Flecked",
      "Brindle",
      "Saddle",
      "Sable",
      "Solid"
    ])
  end

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

  def seed_db do
    Enum.each(1..50, fn x ->
      user = create_user(x)
      business = create_business(user)

      Enum.each(1..50, fn x ->
        create_listing(user)
      end)
    end)

    Puppies.ES.IndexListings.create_mappings_and_index()
  end
end

PuppiesSeeds.seed_db()
