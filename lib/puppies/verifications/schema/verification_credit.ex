defmodule Puppies.VerificationCredit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "verification_credits" do
    field(:attempts, :integer)
    field(:type, :string)
    field(:user_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(credit, attrs) do
    credit
    |> cast(attrs, [:user_id, :type, :attempts])
    |> validate_required([:user_id, :type])
  end
end
