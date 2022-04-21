defmodule Puppies.UserSettings do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_settings" do
    belongs_to(:user, Puppies.Accounts.User)
    field(:email_new_favorites, :boolean, default: true)
    field(:email_new_matches, :boolean, default: true)
    field(:email_offers, :boolean, default: true)
    field(:push_new_favorites, :boolean, default: true)
    field(:push_new_matches, :boolean, default: true)
    field(:push_offers, :boolean, default: true)

    timestamps()
  end

  @doc false
  def changeset(user_settings, attrs) do
    user_settings
    |> cast(attrs, [
      :user_id,
      :email_new_favorites,
      :email_new_matches,
      :email_offers,
      :push_new_favorites,
      :push_new_matches,
      :push_offers
    ])
  end
end
