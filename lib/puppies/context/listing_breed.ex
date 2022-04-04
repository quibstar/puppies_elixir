defmodule Puppies.ListingBreed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "listing_breeds" do
    belongs_to :listing, Puppies.Listings.Listing
    belongs_to :breed, Puppies.Dogs.Breed

    timestamps()
  end

  @doc false
  def changeset(listing_breed, attrs) do
    listing_breed
    |> cast(attrs, [:breed_id, :listing_id])
  end
end
