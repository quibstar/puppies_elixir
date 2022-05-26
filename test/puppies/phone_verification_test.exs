defmodule Puppies.User.PhoneNumber do
  use ExUnit.Case
  use Puppies.DataCase

  import Puppies.AccountsFixtures
  alias Puppies.Accounts

  describe "User phone number" do
    test "should not save phone number" do
      user = user_fixture()
      {:error, changeset} = Accounts.save_phone_number(user, %{})
      assert "Please supply a phone number" in errors_on(changeset).phone_number

      assert "Missing international version, please try again" in errors_on(changeset).phone_intl_format
    end

    test "should not save missing intl format" do
      user = user_fixture()
      {:error, changeset} = Accounts.save_phone_number(user, %{phone_number: "616 555 5555"})

      assert "Missing international version, please try again" in errors_on(changeset).phone_intl_format
    end

    test "should not save missing phone number" do
      user = user_fixture()
      {:error, changeset} = Accounts.save_phone_number(user, %{phone_intl_format: "+16165555555"})
      assert "Please supply a phone number" in errors_on(changeset).phone_number
    end

    test "should save a phone number" do
      user = user_fixture()

      {:ok, user} =
        Accounts.save_phone_number(user, %{
          phone_number: "616 555 5555",
          phone_intl_format: "+16165555555"
        })

      assert user.phone_number == "616 555 5555"
      assert user.phone_intl_format == "+16165555555"
    end

    test "should save twilio sid" do
      user = user_fixture()
      res = Puppies.Verifications.Phone.insert_verification(%{sid: "some id", user_id: user.id})
      assert(!is_nil(res))
    end
  end
end
