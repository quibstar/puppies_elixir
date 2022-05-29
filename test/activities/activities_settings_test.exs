defmodule Puppies.ActivitiesSettingsTest do
  use Puppies.DataCase

  import Puppies.{AccountsFixtures, SettingsFixtures}
  alias Puppies.{Accounts, Activities, Settings}

  describe "Activities" do
    test "updates user settings" do
      user = user_fixture()
      old_settings = settings_fixture(%{user_id: user.id})

      {ok, new_settings} =
        Settings.update_user_settings(old_settings, %{
          email_new_favorites: false,
          email_new_matches: false,
          email_offers: false,
          push_new_favorites: false,
          push_new_matches: false,
          push_offers: false
        })

      res = Activities.user_settings_changes(old_settings, new_settings)

      assert(
        res == [
          %{
            field: :email_new_favorites,
            new_value: false,
            old_value: true
          },
          %{field: :email_new_matches, new_value: false, old_value: true},
          %{field: :email_offers, new_value: false, old_value: true},
          %{field: :push_new_favorites, new_value: false, old_value: true},
          %{field: :push_new_matches, new_value: false, old_value: true},
          %{field: :push_offers, new_value: false, old_value: true}
        ]
      )
    end
  end
end
