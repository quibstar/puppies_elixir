defmodule Puppies.Settings do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.UserSettings

  # User setting
  def get_user_settings(user_id) do
    Repo.one(from(us in UserSettings, where: us.user_id == ^user_id))
  end

  def change_user_settings(%UserSettings{} = user_settings, attrs \\ %{}) do
    UserSettings.changeset(user_settings, attrs)
  end

  def create_user_settings(attrs \\ %{}) do
    %UserSettings{}
    |> UserSettings.changeset(attrs)
    |> Repo.insert()
  end

  def update_user_settings(user_settings, attrs \\ %{}) do
    user_settings
    |> UserSettings.changeset(attrs)
    |> Repo.update()
  end
end
