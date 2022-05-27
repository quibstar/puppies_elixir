defmodule Puppies.BlacklistsDomainTests do
  use Puppies.DataCase

  import Puppies.AccountsFixtures
  alias Puppies.{Blacklists, BlacklistsProcessor, Accounts}

  setup do
    user = user_fixture()
    Blacklists.create_domain_blacklist(%{domain: "example.com"})
    {:ok, user: user}
  end

  describe "Scan email data" do
    test "creates flag and suspends user for blacklisted email", %{user: user} do
      BlacklistsProcessor.check_user_email_for_banned_domain(user.id, user.email)
      flags = Puppies.Flags.get_offender_flags(user.id)
      assert(flags != [])
      user = Accounts.get_user!(user.id)
      assert(user.status == "suspended")
    end
  end
end
