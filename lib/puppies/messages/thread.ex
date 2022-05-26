defmodule Puppies.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  schema "threads" do
    field(:uuid, Ecto.UUID)
    field(:receiver_id, :integer)
    field(:sender_id, :integer)
    belongs_to(:listing, Puppies.Listings.Listing)
    belongs_to(:business, Puppies.Businesses.Business)

    has_many(:messages, Puppies.Message,
      references: :uuid,
      foreign_key: :thread_uuid
    )

    has_one(:receiver, Puppies.Accounts.User,
      references: :receiver_id,
      foreign_key: :id
    )

    has_one(:sender, Puppies.Accounts.User,
      references: :sender_id,
      foreign_key: :id
    )

    field(:last_message, :string)

    timestamps()
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:uuid, :listing_id, :sender_id, :receiver_id, :business_id, :last_message])
    |> validate_required([:uuid, :listing_id, :sender_id, :receiver_id, :business_id])
  end
end
