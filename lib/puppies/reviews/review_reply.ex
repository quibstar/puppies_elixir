defmodule Puppies.Review.Reply do
  use Ecto.Schema
  import Ecto.Changeset

  schema "review_replies" do
    field(:reply, :string)
    belongs_to(:review, Puppies.Reviews.Review)
    timestamps()
  end

  @doc false
  def changeset(review_reply, attrs) do
    review_reply
    |> cast(attrs, [:reply, :review_id])
    |> validate_required([:reply])
  end
end
