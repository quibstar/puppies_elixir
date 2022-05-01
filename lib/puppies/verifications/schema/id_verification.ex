defmodule Puppies.IdVerification do
  @moduledoc """
  Schema for user notes used by admins
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "id_verifications" do
    belongs_to(:user, Puppies.Accounts.User)
    field(:status, :string)
    field(:verification_session_id, :string)
    field(:error_code, :string)
    field(:error_reason, :string)

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [
      :status,
      :verification_session_id,
      :error_code,
      :error_reason,
      :user_id
    ])
    |> validate_required([:verification_session_id, :status, :user_id])
  end
end
