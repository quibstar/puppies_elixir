defmodule Puppies.Blacklists.IPAddress do
  use Ecto.Schema
  import Ecto.Changeset

  schema "blacklisted_ip_addresses" do
    field(:ip_address, :string)
    belongs_to(:admin, Puppies.Admins.Admin)
    timestamps()
  end

  @doc false
  def changeset(ip_address_blacklist, attrs) do
    ip_address_blacklist
    |> cast(attrs, [:ip_address, :admin_id])
    |> validate_required([:ip_address])
    |> unique_constraint(:ip_address, message: "Already added")
  end
end
