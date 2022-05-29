defmodule Puppies.SettingsFixtures do
  @moduledoc """

  """

  @doc """
  Generate a user setting.
  """
  def settings_fixture(attrs \\ %{}) do
    {:ok, settings} =
      attrs
      |> Enum.into(%{
        email_new_favorites: true,
        email_new_matches: true,
        email_offers: true,
        push_new_favorites: true,
        push_new_matches: true,
        push_offers: true
      })
      |> Puppies.Settings.create_user_settings()

    settings
  end
end
