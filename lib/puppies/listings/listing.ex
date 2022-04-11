defmodule Puppies.Listings.Listing do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :coat_color_pattern,
             :description,
             :dob,
             :name,
             :price,
             :sex,
             :status,
             :deliver_on_site,
             :deliver_pick_up,
             :delivery_shipped,
             :champion_sired,
             :show_quality,
             :champion_bloodline,
             :registered,
             :registrable,
             :current_vaccinations,
             :veterinary_exam,
             :health_certificate,
             :health_guarantee,
             :pedigree,
             :hypoallergenic,
             :microchip,
             :purebred,
             :breeds,
             :views
           ]}
  schema "listings" do
    field(:coat_color_pattern, :string)
    field(:description, :string)
    field(:dob, :date)
    field(:name, :string)
    field(:price, :integer)
    field(:sex, :string)
    field(:status, :string)
    field(:views, :integer, default: 0)
    field(:deliver_on_site, :boolean, default: false)
    field(:deliver_pick_up, :boolean, default: false)
    field(:delivery_shipped, :boolean, default: false)
    field(:champion_sired, :boolean, default: false)
    field(:show_quality, :boolean, default: false)
    field(:champion_bloodline, :boolean, default: false)
    field(:registered, :boolean, default: false)
    field(:registrable, :boolean, default: false)
    field(:current_vaccinations, :boolean, default: false)
    field(:veterinary_exam, :boolean, default: false)
    field(:health_certificate, :boolean, default: false)
    field(:health_guarantee, :boolean, default: false)
    field(:pedigree, :boolean, default: false)
    field(:hypoallergenic, :boolean, default: false)
    field(:microchip, :boolean, default: false)
    field(:purebred, :boolean, default: true)
    belongs_to(:user, Puppies.Accounts.User)
    has_many(:listing_breeds, Puppies.ListingBreed, on_replace: :delete)
    many_to_many(:breeds, Puppies.Dogs.Breed, join_through: Puppies.ListingBreed)
    has_many(:photos, Puppies.Photos.Photo)
    timestamps()
  end

  @doc false
  def changeset(listing, attrs) do
    listing
    |> cast(attrs, [
      :name,
      :dob,
      :price,
      :sex,
      :coat_color_pattern,
      :description,
      :status,
      :user_id,
      :deliver_on_site,
      :deliver_pick_up,
      :delivery_shipped,
      :champion_sired,
      :show_quality,
      :champion_bloodline,
      :registered,
      :registrable,
      :current_vaccinations,
      :veterinary_exam,
      :health_certificate,
      :health_guarantee,
      :pedigree,
      :hypoallergenic,
      :microchip,
      :purebred,
      :views
    ])
    |> validate_required([:name], message: "Name cannot be blank")
    |> validate_required([:dob], message: "DOB/Expected date cannot be blank")
    |> validate_required([:price], message: "Price cannot be blank")
    |> cast_assoc(:listing_breeds)
    |> cast_assoc(:photos)
  end
end
