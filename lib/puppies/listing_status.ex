defmodule Puppies.ListingStatus do
  use Ecto.Schema
  import Ecto.Changeset

  schema "listing_statuses" do
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(listing_status, attrs) do
    listing_status
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end
