defmodule Puppies.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  schema "threads" do
    field(:uuid, Ecto.UUID)
    belongs_to(:user, Puppies.Accounts.User)
    field(:receiver_id, :integer)
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
      references: :user_id,
      foreign_key: :id
    )

    timestamps()
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:uuid, :listing_id, :user_id, :receiver_id, :business_id])
    |> validate_required([:uuid, :listing_id, :user_id, :receiver_id, :business_id])
  end
end
