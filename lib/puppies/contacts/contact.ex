defmodule Puppies.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field(:email, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:message, :string)
    field(:read, :boolean)

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:first_name, :last_name, :email, :message, :read])
    |> validate_required([:first_name], message: "First name cannot be blank")
    |> validate_required([:last_name], message: "Last name cannot be blank")
    |> validate_required([:email], message: "Email cannot be blank")
    |> validate_required([:message], message: "Message cannot be blank")
  end
end
