defmodule Puppies.Search do
  use Ecto.Schema
  import Ecto.Changeset

  schema "searches" do
    field(:breeds, {:array, :string})
    field(:champion_bloodline, :boolean, default: false)
    field(:champion_sired, :boolean, default: false)
    field(:coat_color_pattern, :string)
    field(:current_vaccinations, :boolean, default: false)
    field(:distance, :integer)
    field(:dob, :integer)
    field(:female, :boolean, default: false)
    field(:health_certificate, :boolean, default: false)
    field(:health_guarantee, :boolean, default: false)
    field(:hypoallergenic, :boolean, default: false)
    field(:is_filtering, :boolean, default: false)
    field(:lat, :float)
    field(:lng, :float)
    field(:male, :boolean, default: false)
    field(:max_price, :integer)
    field(:microchip, :boolean, default: false)
    field(:min_price, :integer)
    field(:order, :string)
    field(:pedigree, :boolean, default: false)
    field(:place_id, :string)
    field(:place_name, :string)
    field(:purebred, :boolean, default: false)
    field(:registered, :boolean, default: false)
    field(:registrable, :boolean, default: false)
    field(:search_by, :string)
    field(:show_quality, :boolean, default: false)
    field(:state, :string)
    field(:veterinary_exam, :boolean, default: false)
    belongs_to(:user, Puppies.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(search, attrs) do
    search
    |> cast(attrs, [
      :search_by,
      :breeds,
      :state,
      :is_filtering,
      :place_id,
      :lat,
      :lng,
      :place_name,
      :distance,
      :order,
      :male,
      :female,
      :coat_color_pattern,
      :dob,
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
      :min_price,
      :max_price
    ])
    |> validate_custom
  end

  defp validate_custom(%Ecto.Changeset{} = changeset) do
    value = Map.get(changeset.changes, :search_by)

    if value == "state" do
      validate_required(changeset, [:state])
    else
      validate_required(changeset, [:place_name])
    end
  end
end
