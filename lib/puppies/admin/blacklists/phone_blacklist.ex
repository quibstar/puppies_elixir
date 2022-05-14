defmodule Puppies.Blacklists.PhoneBlacklist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "phone_blacklists" do
    field(:phone_number, :string)
    belongs_to(:admin, Puppies.Admins.Admin)
    timestamps()
  end

  @doc false
  def changeset(phone_blacklist, attrs) do
    phone_blacklist
    |> cast(attrs, [:phone_number, :admin_id])
    |> validate_required([:phone_number])
    |> validate_length(:phone_number, min: 10, max: 10)
  end
end
