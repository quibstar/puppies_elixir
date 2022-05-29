defmodule Puppies.UserLocation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_locations" do
    field(:city, :string)
    field(:country, :string)
    field(:postal_code, :string)
    field(:region, :string)
    field(:street_address, :string)
    belongs_to(:user, Puppies.Accounts.User)
    timestamps()
  end

  @doc false
  def changeset(user_location, attrs) do
    user_location
    |> cast(attrs, [:country, :street_address, :city, :region, :postal_code])
  end
end
