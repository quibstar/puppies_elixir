defmodule Puppies.BlacklistsEmailTest do
  use Puppies.DataCase
  import Ecto

  import Puppies.{AccountsFixtures, BlacklistsFixtures, BusinessesFixtures}
  alias Puppies.{BlacklistsProcessor, Accounts}

  setup do
    Puppies.BlacklistsFixtures.phone_blacklist_fixture(%{phone_number: "6164015666"})

    user = user_fixture(%{phone_number: "6164015666"})

    business =
      business_fixture(%{
        user_id: user.id,
        location_autocomplete: "some place",
        phone_number: "6164015666"
      })

    {:ok, user: user, business: business}
  end

  describe "Blacklisted email" do
    test "test user email", %{user: user} do
      BlacklistsProcessor.check_for_banned_phone_number(
        user.id,
        "6164015666"
      )

      flags = Puppies.Flags.get_offender_flags(user.id)

      assert(flags != [])
      user = Accounts.get_user!(user.id)
      assert(user.status == "suspended")
    end
  end
end
