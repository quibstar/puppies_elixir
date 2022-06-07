defmodule Puppies.Review.Dispute do
  use Ecto.Schema
  import Ecto.Changeset

  schema "review_dispute" do
    field(:admin_id, :integer)
    field(:admin_note, :string)
    field(:disputed, :boolean, default: false)
    field(:reason, :string)
    belongs_to(:review, Puppies.Reviews.Review)
    timestamps()
  end

  @doc false
  def changeset(review_dispute, attrs) do
    review_dispute
    |> cast(attrs, [:admin_id, :review_id, :admin_note, :disputed, :reason])
    |> validate_required([:disputed, :reason])
  end
end
