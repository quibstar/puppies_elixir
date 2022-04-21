defmodule Puppies.Photos.Photo do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :url]}
  schema "photos" do
    field(:name, :string)
    field(:url, :string)
    belongs_to(:business, Puppies.Businesses.Business)
    belongs_to(:listing, Puppies.Listings.Listing)
    belongs_to(:user, Puppies.Accounts.User)
    field(:delete, :boolean, virtual: true, default: false)

    timestamps()
  end

  def changeset(photo, %{delete: true}) do
    %{Ecto.Changeset.change(photo) | action: :delete}
  end

  @doc false
  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:business_id, :user_id, :listing_id, :url, :name])
    |> validate_required([:url, :name])
  end
end
