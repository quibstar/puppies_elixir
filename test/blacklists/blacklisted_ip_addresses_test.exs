defmodule Puppies.BlacklistsIPAddressTest do
  use Puppies.DataCase

  import Puppies.{AccountsFixtures}
  alias Puppies.{BlacklistsProcessor, Accounts}

  setup do
    Puppies.BlacklistsFixtures.ip_address_blacklist_fixture(%{ip_address: "10.10.10.10"})

    IpStackFixtures.response_data(%{
      "country_code" => "AF",
      "country_name" => "Afghanistan",
      "ip" => "10.10.10.10"
    })

    user = user_fixture()

    {:ok, user: user}
  end

  describe "Blacklisted IP Addresses" do
    test "test for baned ip address", %{user: user} do
      BlacklistsProcessor.check_for_banned_ip_address(
        user.id,
        "10.10.10.10"
      )

      flags = Puppies.Flags.get_offender_flags(user.id)
      assert(flags != [])
      user = Accounts.get_user!(user.id)
      assert(user.status == "suspended")
    end
  end
end
