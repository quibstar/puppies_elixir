defmodule Puppies.PhoneVerification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "phone_verifications" do
    field(:sid, :string)
    field(:user_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(phone_verification, attrs) do
    phone_verification
    |> cast(attrs, [:user_id, :sid])
    |> validate_required([:user_id, :sid])
  end
end
