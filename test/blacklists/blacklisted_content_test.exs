defmodule Puppies.BlacklistsContentTest do
  use Puppies.DataCase

  import Puppies.{ListingsFixtures, AccountsFixtures, BusinessesFixtures}
  alias Puppies.{BlacklistsProcessor, Accounts}

  setup do
    Puppies.BlacklistsFixtures.content_blacklist_fixture(%{content: "dick"})

    user = user_fixture()

    business =
      business_fixture(%{
        user_id: user.id,
        location_autocomplete: "some place",
        description: "this is a test dick"
      })

    listing = listing_fixture(%{user_id: user.id, description: "this is a test dick"})

    {:ok, user: user, listing: listing, business: business}
  end

  describe "Scan content for bad words" do
    test "test listing for blacklisted content", %{user: user, listing: listing} do
      BlacklistsProcessor.check_content_has_blacklisted_phrase(
        user,
        listing.description,
        "listing description"
      )

      flags = Puppies.Flags.get_offender_flags(user.id)

      assert(flags != [])
      user = Accounts.get_user!(user.id)
      assert(user.status == "suspended")
    end

    test "test buiness for blacklisted content", %{user: user, business: business} do
      BlacklistsProcessor.check_content_has_blacklisted_phrase(
        user,
        business.description,
        "business description"
      )

      flags = Puppies.Flags.get_offender_flags(user.id)

      assert(flags != [])
      user = Accounts.get_user!(user.id)
      assert(user.status == "suspended")
    end
  end
end
