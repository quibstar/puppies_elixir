defmodule Puppies.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field(:message, :string)
    field(:read, :boolean, default: false)
    field(:received_by, :integer)
    field(:sent_by, :integer)
    field(:thread_uuid, Ecto.UUID)

    has_one(:receiver, Puppies.Accounts.User,
      references: :received_by,
      foreign_key: :id
    )

    has_one(:sender, Puppies.Accounts.User,
      references: :sent_by,
      foreign_key: :id
    )

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:thread_uuid, :sent_by, :received_by, :read, :message])
    |> validate_required([:sent_by, :received_by, :message, :thread_uuid])
  end
end
