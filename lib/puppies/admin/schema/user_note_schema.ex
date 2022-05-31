defmodule Puppies.User.Note do
  @moduledoc """
  Schema for user notes used by admins
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_notes" do
    field(:created_by, :string)
    field(:note, :string)
    belongs_to(:user, Puppies.Accounts.User)
    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:note, :created_by, :user_id])
    |> validate_required([:note, :created_by], message: "Note cannot be blank")
  end
end
