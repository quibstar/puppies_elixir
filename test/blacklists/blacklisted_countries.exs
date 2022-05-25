defmodule Puppies.BlacklistsCountryTests do
  use ExUnit.Case
  use Puppies.DataCase

  import Puppies.AccountsFixtures
  alias Puppies.{Blacklists, BlacklistsProcessor, IPStack, Accounts}

  setup do
    user = user_fixture()

    Blacklists.create_country_blacklist(%{name: "Afghanistan", code: "AF", selected: true})

    data =
      IpStackFixtures.response_data(%{"country_code" => "AF", "country_name" => "Afghanistan"})

    IPStack.get_required_fields(data, user.id)
    |> IPStack.create_ip_data()

    data = IpStackFixtures.response_data()

    IPStack.get_required_fields(data, user.id)
    |> IPStack.create_ip_data()

    {:ok, user: user}
  end

  describe "Scans ip data" do
    test "creates flag and suspends user for blacklisted country", %{user: user} do
      BlacklistsProcessor.check_users_country_origin(user.id)
      flags = Puppies.Flags.get_offender_flags(user.id)

      assert(flags != [])
      user = Accounts.get_user!(user.id)
      assert(user.status == "suspended")
    end
  end
end
