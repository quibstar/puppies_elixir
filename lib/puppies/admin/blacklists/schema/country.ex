defmodule Puppies.Blacklists.Country do
  use Ecto.Schema
  import Ecto.Changeset

  schema "blacklisted_countries" do
    field(:code, :string)
    field(:name, :string)
    field(:selected, :boolean, default: false)
    timestamps()
  end

  @doc false
  def changeset(blacklisted_country, attrs) do
    blacklisted_country
    |> cast(attrs, [:name, :code, :selected])
    |> validate_required([:name, :code])
    |> unique_constraint(:name)
  end
end
