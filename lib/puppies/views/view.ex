defmodule Puppies.Views.View do
  use Ecto.Schema
  import Ecto.Changeset

  schema "views" do
    belongs_to(:user, Puppies.Accounts.User)
    belongs_to(:listing, Puppies.Listings.Listing)
    field(:unique, :boolean, default: false)
    timestamps()
  end

  @doc false
  def changeset(view, attrs) do
    view
    |> cast(attrs, [:user_id, :listing_id, :unique])
    |> validate_required([:user_id, :listing_id])
  end
end
