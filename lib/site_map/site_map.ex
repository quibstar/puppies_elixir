defmodule Puppies.SiteMap do
  @moduledoc """
  Site map generator.

  """
  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.{Location, Listings.Listing}

  def puppies_city_state do
    city_state_short =
      from(l in Location,
        group_by: [:region_slug, :place_slug, :region_short_code],
        select: %{city: l.place_slug, state: l.region_short_code}
      )
      |> Repo.all()

    city_state_long =
      from(l in Location,
        group_by: [:region_slug, :place_slug],
        select: %{city: l.place_slug, state: l.region_slug}
      )
      |> Repo.all()

    state_short =
      from(l in Location,
        group_by: [:region_short_code],
        select: l.region_short_code
      )
      |> Repo.all()

    state_long =
      from(l in Location,
        group_by: [:region_slug],
        select: l.region_slug
      )
      |> Repo.all()

    %{
      city_state_short: city_state_short,
      city_state_long: city_state_long,
      state_short: state_short,
      state_long: state_long
    }
  end

  def site_map_generator do
    q =
      from(l in Listing,
        # join: b in assoc(lb, :breeds),
        # join: l in assoc(lb, :listings),
        # join: bus in assoc(l, :business),
        preload: [:breeds, [user: [business: :location]]]
      )

    listings = Repo.all(q)

    Enum.reduce(listings, [], fn listing, list ->
      state = listing.user.business.location.region_slug
      state_abbrev = listing.user.business.location.region_short_code
      city = listing.user.business.location.place_slug
      url = "http://localhost:4000/puppies-in"
      # state
      list = ["#{url}/#{state}" | list]
      list = ["#{url}/#{state_abbrev}" | list]

      # city/state
      list = ["#{url}/#{city}/#{state}" | list]
      list = ["#{url}/#{city}/#{state_abbrev}" | list]

      Enum.reduce(listing.breeds, list, fn breed, list ->
        slug = breed.slug
        # state/breed
        list = ["#{url}/#{state}/#{slug}" | list]
        list = ["#{url}/#{state_abbrev}/#{slug}" | list]

        # city/state/breed
        list = ["#{url}/#{city}/#{state}/#{slug}" | list]
        ["#{url}/#{city}/#{state_abbrev}/#{slug}" | list]
      end)
    end)
    |> Enum.uniq()
  end
end
