defmodule Puppies.ReviewLinks.ReviewLink do
  use Ecto.Schema
  import Ecto.Changeset

  schema "review_links" do
    field(:email, :string)
    field(:uuid, Ecto.UUID, autogenerate: true)
    field(:expired, :boolean, default: false)
    belongs_to(:listing, Puppies.Listings.Listing)

    timestamps()
  end

  @doc false
  def changeset(review_link, attrs) do
    review_link
    |> cast(attrs, [:email, :uuid, :listing_id, :expired])
    |> validate_required([:email])
  end
end
