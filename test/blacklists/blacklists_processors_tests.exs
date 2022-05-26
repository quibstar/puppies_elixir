defmodule Puppies.BlacklistsProcessorText do
  use Puppies.DataCase
  # doctest BlacklistsProcessor

  alias Puppies.BlacklistsProcessor
  import Puppies.{ListingsFixtures, AccountsFixtures, BusinessesFixtures, IPDatumFixtures}

  describe "Scan content duplicate content" do
    test "returns true for duplicate content" do
      res = BlacklistsProcessor.duplicate_content("this is a test", "this is a test")
      assert(res == true)
    end

    test "returns false for no bad word found" do
      res = BlacklistsProcessor.duplicate_content("this is a test", "this is a test!")
      assert(res == false)
    end
  end

  describe "check all users" do
    test "check listings for bad content" do
      create_listing_data()

      BlacklistsProcessor.check_users_listings_or_business_against_new_blacklist_content(
        "dick",
        Puppies.Listings.Listing,
        "listing description"
      )

      flags = get_flags()
      assert(length(flags) == 50)
    end

    test "check business for bad content" do
      create_business_data()

      BlacklistsProcessor.check_users_listings_or_business_against_new_blacklist_content(
        "dick",
        Puppies.Businesses.Business,
        "business description"
      )

      flags = get_flags()
      assert(length(flags) == 5)
    end

    test "check all users for blacklisted country" do
      create_ip_data()
      BlacklistsProcessor.check_users_against_new_blacklist_country("US")
      flags = get_flags()
      assert(length(flags) == 10)
    end

    test "check all users for blacklisted ip" do
      create_ip_data()
      BlacklistsProcessor.check_users_against_new_blacklist_ip("24.204.172.199")
      flags = get_flags()
      assert(length(flags) == 5)
    end

    test "check all users for blacklisted domain" do
      Enum.each(1..10, fn x ->
        domain = maybe_example_dot_com?(x)
        user = user_fixture(%{email: "test#{x}@#{domain}", is_seller: true})
      end)

      BlacklistsProcessor.check_users_against_new_blacklist_domain("example.com")
      flags = get_flags()
      assert(length(flags) == 5)
    end
  end

  # helper files
  defp create_listing_data() do
    Enum.each(1..10, fn x ->
      user = user_fixture(%{email: "test#{x}@example.com", is_seller: true})

      business_fixture(%{
        user_id: user.id,
        location_autocomplete: "some place",
        description: "this is a test #{maybe_bad_word?(x)}"
      })

      Enum.each(1..10, fn x ->
        listing =
          listing_fixture(%{user_id: user.id, description: "this is a test #{maybe_bad_word?(x)}"})
      end)
    end)
  end

  defp create_business_data() do
    Enum.each(1..10, fn x ->
      user = user_fixture(%{email: "test#{x}@example.com", is_seller: true})

      business_fixture(%{
        user_id: user.id,
        location_autocomplete: "some place",
        description: "this is a test #{maybe_bad_word?(x)}"
      })
    end)
  end

  defp create_ip_data() do
    Enum.each(1..10, fn x ->
      user = user_fixture(%{email: "test#{x}@example.com", is_seller: true})
      grand_rapids_or_los_angeles(x, user.id)
    end)
  end

  defp maybe_bad_word?(x) do
    if rem(x, 2) == 0 do
      "dick"
    else
      "man"
    end
  end

  defp maybe_example_dot_com?(x) do
    if rem(x, 2) == 0 do
      "example.com"
    else
      "test.com"
    end
  end

  defp grand_rapids_or_los_angeles(x, user_id) do
    if rem(x, 2) == 0 do
      ip_datum_fixture(%{
        user_id: user_id,
        ip: "24.204.172.199",
        type: "ipv4",
        continent_code: "NA",
        continent_name: "North America",
        country_code: "US",
        country_name: "United States",
        region_code: "MI",
        region_name: "Michigan",
        city: "Allendale",
        zip: 49401
      })
    else
      ip_datum_fixture(%{user_id: user_id})
    end
  end

  def get_flags() do
    from(f in Puppies.Flag) |> Repo.all()
  end
end
