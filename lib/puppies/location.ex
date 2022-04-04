defmodule Puppies.Location do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [:place_name, :lat, :lng, :region_slug, :place_slug, :region_short_code, :text]}
  schema "locations" do
    field :address, :string
    field :country, :string
    field :delete, :boolean, default: false
    field :lat, :float
    field :lng, :float
    field :place, :string
    field :place_id, :string
    field :place_name, :string
    field :place_slug, :string
    field :region, :string
    field :region_short_code, :string
    field :region_slug, :string
    field :text, :string
    field :business_id, :id

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [
      :place_id,
      :place_name,
      :place,
      :place_slug,
      :region,
      :region_slug,
      :region_short_code,
      :country,
      :address,
      :text,
      :delete,
      :lat,
      :lng,
      :business_id
    ])
    |> validate_required([
      :place_id,
      :place_name,
      :place,
      :place_slug,
      :region,
      :region_slug,
      :region_short_code,
      :country,
      :text,
      :lat,
      :lng
    ])
  end
end
