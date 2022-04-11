defmodule Puppies.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "favorites" do
    belongs_to(:user, Puppies.Accounts.User)
    belongs_to(:listing, Puppies.Listings.Listing)

    timestamps()
  end

  @doc false
  def changeset(favorites, attrs) do
    favorites
    |> cast(attrs, [:user_id, :listing_id])
  end
end
