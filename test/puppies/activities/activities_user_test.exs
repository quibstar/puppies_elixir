defmodule Puppies.ActivitiesUserTest do
  use Puppies.DataCase

  import Puppies.{AccountsFixtures}
  alias Puppies.{Accounts, Activities}

  describe "Activities" do
    test "records reputation level" do
      user = user_fixture()
      {:ok, updated_user} = Accounts.update_reputation_level(user, %{reputation_level: 2})
      res = Activities.user_changes(user, updated_user)
      assert(res == [%{field: :reputation_level, new_value: 2, old_value: 0}])
    end

    test "records profile changes" do
      user = user_fixture()

      {:ok, updated_user} =
        Accounts.update_user_profile(user, %{first_name: "Ilav", last_name: "Turtles"})

      res = Activities.user_changes(user, updated_user)

      assert(
        res == [
          %{field: :first_name, new_value: "Ilav", old_value: "Joe"},
          %{field: :last_name, new_value: "Turtles", old_value: "Smith"}
        ]
      )
    end

    test "updates user password" do
      user = user_fixture()

      {:ok, updated_user} =
        Accounts.update_user_password(user, "superSecret!", %{password: "I like turtles"})

      res = Activities.user_changes(user, updated_user)

      assert(
        res == [
          %{
            field: :hashed_password,
            new_value: "Redacted",
            old_value: "Redacted"
          }
        ]
      )
    end

    test "updates user email" do
      user = user_fixture()

      {:ok, updated_user} =
        Accounts.apply_user_email(user, "superSecret!", %{email: "dude@aol.com"})

      {:ok, updated_user_1} =
        Accounts.apply_user_email(user, "superSecret!", %{email: "dude1@aol.com"})

      res = Activities.user_changes(updated_user, updated_user_1)

      assert(res == [%{field: :email, new_value: "dude1@aol.com", old_value: "dude@aol.com"}])
    end
  end
end
