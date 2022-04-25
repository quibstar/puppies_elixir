defmodule Puppies.Threads do
  @moduledoc """
  The Threads context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Ecto.Multi

  alias Puppies.{Thread, Messages, Message}

  def get_thread_by_uuid(uuid) do
    Repo.get_by(Thread, uuid: uuid)
  end

  def create_thread(attrs \\ %{}) do
    %Thread{}
    |> Thread.changeset(attrs)
    |> Repo.insert()
  end

  def create_threads(%{
        "listing_id" => listing_id,
        "message" => message,
        "receiver_id" => receiver_id,
        "sender_id" => sender_id
      }) do
    uuid = Ecto.UUID.generate()

    seller =
      thread_changes(%{
        uuid: uuid,
        user_id: sender_id,
        receiver_id: receiver_id,
        listing_id: listing_id
      })

    buyer =
      thread_changes(%{
        uuid: uuid,
        user_id: receiver_id,
        receiver_id: sender_id,
        listing_id: listing_id
      })

    message =
      Messages.message_changes(%{
        sent_by: sender_id,
        received_by: receiver_id,
        message: message,
        thread_uuid: uuid
      })

    Multi.new()
    |> Multi.insert(:seller, seller)
    |> Multi.insert(:buyer, buyer)
    |> Multi.insert(:message, message)
    |> Repo.transaction()
  end

  def thread_changes(attrs \\ %{}) do
    Thread.changeset(%Thread{}, attrs)
  end

  def get_user_threads(user_id) do
    from(t in Thread,
      where: t.user_id == ^user_id,
      distinct: t.listing_id,
      preload: [listing: :photos]
    )
    |> Repo.all()
  end

  def get_first_listing_thread_and_messages(user_id) do
    from(t in Thread,
      where: t.user_id == ^user_id,
      order_by: :updated_at,
      limit: 1,
      preload: [
        [listing: :photos],
        receiver: [business: :photo],
        sender: [business: :photo],
        messages: ^get_first_20_messages()
      ]
    )
    |> Repo.one()
  end

  def get_threads_by_user_and_listing(user_id, listing_id) do
    from(t in Thread,
      where: t.user_id == ^user_id and t.listing_id == ^listing_id,
      order_by: :updated_at,
      preload: [
        [listing: :photos],
        :messages,
        receiver: [business: :photo],
        sender: [business: :photo]
      ]
    )
    |> Repo.all()
  end

  def current_thread(user_id, uuid) do
    from(t in Thread,
      where: t.user_id == ^user_id and t.uuid == ^uuid,
      preload: [
        [listing: :photos],
        receiver: [business: :photo],
        sender: [business: :photo],
        messages: ^get_first_20_messages()
      ]
    )
    |> Repo.one()
  end

  def get_first_20_messages() do
    from(m in Message,
      order_by: :updated_at,
      limit: 20
    )
  end

  def changes(params) do
    data = %{}

    types = %{
      listing_id: :integer,
      receiver_id: :integer,
      sender_id: :integer,
      message: :string
    }

    {data, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required([:listing_id, :message, :receiver_id, :sender_id])
  end

  def conversation_started(user_id, listing_id) do
    from(t in Thread,
      where: t.user_id == ^user_id and t.listing_id == ^listing_id
    )
    |> Repo.one()
  end
end
