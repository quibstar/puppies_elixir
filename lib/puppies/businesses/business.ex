defmodule Puppies.Businesses.Business do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :name,
             :slug,
             :phone,
             :state_license,
             :federal_license,
             :website,
             :description,
             :breeds,
             :photo,
             :location
           ]}
  schema "businesses" do
    field(:description, :string)
    field(:federal_license, :boolean, default: false)
    field(:name, :string)
    field(:slug, :string)
    field(:phone, :string)
    field(:state_license, :boolean, default: false)
    field(:website, :string)
    field(:location_autocomplete, :string, virtual: true)
    belongs_to(:user, Puppies.Accounts.User)
    has_many(:reviews, Puppies.Reviews.Review)
    has_many(:business_breeds, Puppies.BusinessBreed, on_replace: :delete)
    many_to_many(:breeds, Puppies.Breed, join_through: Puppies.BusinessBreed)
    has_one(:location, Puppies.Location, on_replace: :delete)
    has_one(:photo, Puppies.Photos.Photo)

    timestamps()
  end

  @doc false
  def changeset(business, attrs) do
    business
    |> cast(attrs, [
      :name,
      :slug,
      :website,
      :phone,
      :description,
      :state_license,
      :federal_license,
      :user_id,
      :location_autocomplete
    ])
    |> validate_required([:phone], message: "Phone can't be blank")
    |> validate_required([:name], message: "Name can't be blank")
    |> unique_constraint([:name], message: "Name taken, please choose another")
    |> validate_required([:location_autocomplete], message: "Location can't be blank")
    |> cast_assoc(:location)
    |> cast_assoc(:business_breeds)
  end
end
