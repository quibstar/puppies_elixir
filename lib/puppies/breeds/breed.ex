defmodule Puppies.Breed do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :slug]}
  schema "breeds" do
    field(:category, :string)
    field(:name, :string)
    field(:slug, :string)
    has_many(:listing_breeds, Puppies.ListingBreed, on_replace: :delete)
    many_to_many(:listings, Puppies.Listings.Listing, join_through: Puppies.Listings.Listing)
    has_one(:attributes, Puppies.BreedAttribute)
    timestamps()
  end

  @doc false
  def changeset(breed, attrs) do
    breed
    |> cast(attrs, [
      :name,
      :category,
      :slug
    ])
    |> validate_required([:name, :slug])
  end
end
