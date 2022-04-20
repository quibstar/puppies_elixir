defmodule Puppies.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field(:review, :string)
    field(:email, :string)
    field(:rating, :integer)
    field(:approved, :boolean, default: false)
    belongs_to(:user, Puppies.Accounts.User)
    belongs_to(:business, Puppies.Businesses.Business)

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:rating, :review, :email, :business_id, :user_id, :approved])
    |> validate_required([:rating, :review])
  end
end
