defmodule Puppies.IPData do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ip_data" do
    field(:city, :string)
    field(:continent_code, :string)
    field(:continent_name, :string)
    field(:country_code, :string)
    field(:country_name, :string)
    field(:ip, :string)
    field(:isp, :string)
    field(:latitude, :float)
    field(:longitude, :float)
    field(:region_code, :string)
    field(:region_name, :string)
    field(:time_zone, :string)
    field(:type, :string)
    field(:zip, :string)
    belongs_to(:user, Puppies.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(ip_data, attrs) do
    ip_data
    |> cast(attrs, [
      :user_id,
      :ip,
      :type,
      :continent_code,
      :continent_name,
      :country_code,
      :country_name,
      :region_code,
      :region_name,
      :city,
      :zip,
      :latitude,
      :longitude,
      :time_zone,
      :isp
    ])
    |> validate_required([
      :ip,
      :type,
      :continent_code,
      :continent_name,
      :country_code,
      :country_name,
      :region_code,
      :region_name,
      :city,
      :zip,
      :latitude,
      :longitude
    ])
  end
end
