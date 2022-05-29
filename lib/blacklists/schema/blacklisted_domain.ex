defmodule Puppies.Blacklists.Domain do
  use Ecto.Schema
  import Ecto.Changeset

  schema "blacklisted_domains" do
    field(:domain, :string)
    belongs_to(:admin, Puppies.Admins.Admin)
    timestamps()
  end

  @doc false
  def changeset(email_blacklist, attrs) do
    email_blacklist
    |> cast(attrs, [:domain, :admin_id])
    |> validate_required([:domain])
    |> unique_constraint(:domain, message: "Already added")
  end
end
