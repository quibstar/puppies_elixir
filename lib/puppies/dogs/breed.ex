defmodule Puppies.Dogs.Breed do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :slug]}
  schema "breeds" do
    field(:category, :string)
    field(:name, :string)
    field(:slug, :string)
    field(:adaptable, :integer)
    field(:friendly, :integer)
    field(:grooming_and_health, :integer)
    field(:trainable, :integer)
    field(:attention_and_exercise, :integer)
    has_many(:listing_breeds, Puppies.ListingBreed, on_replace: :delete)
    many_to_many(:listings, Puppies.Listings.Listing, join_through: Puppies.Listings.Listing)
    timestamps()
  end

  @doc false
  def changeset(breed, attrs) do
    breed
    |> cast(attrs, [
      :name,
      :category,
      :slug,
      :adaptable,
      :friendly,
      :grooming_and_health,
      :trainable,
      :attention_and_exercise
    ])
    |> validate_required([:name, :slug])
  end
end
