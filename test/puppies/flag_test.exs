defmodule Puppies.FlagsTest do
  use Puppies.DataCase

  import Puppies.AccountsFixtures

  import Puppies.FlagsFixtures
  alias Puppies.Flags

  setup do
    offender = user_fixture()
    reporter = user_fixture()

    {:ok, offender: offender, reporter: reporter}
  end

  describe "Flags" do
    test "create new flag", %{offender: offender, reporter: reporter} do
      {:ok, flag} =
        Flags.create(%{
          offender_id: offender.id,
          reporter_id: reporter.id,
          reason: "sucker"
        })

      assert(!is_nil(flag.offender_id))
      assert(!is_nil(flag.reporter_id))
      assert(!is_nil(flag.reason))
    end
  end
end
