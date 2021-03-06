defmodule Puppies.Threads do
  @moduledoc """
  The Threads context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Ecto.Multi

  alias Puppies.{Thread, Messages, Message}

  def create_thread(attrs \\ %{}) do
    %Thread{}
    |> Thread.changeset(attrs)
    |> Repo.insert()
  end

  def updated_threads(uuid, attrs) do
    threads =
      from(t in Thread,
        where: t.uuid == ^uuid
      )
      |> Repo.all()

    Enum.each(threads, fn thread ->
      thread
      |> Thread.changeset(attrs)
      |> Repo.update()
    end)
  end

  # Changeset for validating a message from a listing profile
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

  def create_threads(%{
        "listing_id" => listing_id,
        "message" => message,
        "receiver_id" => receiver_id,
        "sender_id" => sender_id,
        "business_id" => business_id
      }) do
    uuid = Ecto.UUID.generate()

    seller =
      thread_changes(%{
        uuid: uuid,
        sender_id: sender_id,
        receiver_id: receiver_id,
        listing_id: listing_id,
        business_id: business_id
      })

    buyer =
      thread_changes(%{
        uuid: uuid,
        sender_id: receiver_id,
        receiver_id: sender_id,
        listing_id: listing_id,
        business_id: business_id
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
    threads =
      from(t in Thread,
        where: t.sender_id == ^user_id,
        distinct: t.listing_id,
        preload: [[listing: :photos], messages: ^unread_messages()]
      )
      |> Repo.all()

    # threads =
    #   Thread
    #   |> where([t], t.user_id == ^user_id)
    #   |> distinct([t], t.listing_id)
    #   # |> order_by([t], desc: t.updated_at)
    #   |> preload([t], [[listing: :photos], messages: ^unread_messages()])
    #   |> Repo.all()

    Enum.sort_by(threads, & &1.updated_at)
  end

  def unread_messages() do
    from(m in Message,
      where: m.read == false,
      order_by: [desc: :inserted_at]
    )
  end

  def get_first_listing_thread_and_messages(user_id) do
    from(t in Thread,
      where: t.sender_id == ^user_id,
      order_by: [desc: :updated_at],
      limit: 1,
      preload: [
        [listing: :photos],
        receiver: [business: :photo],
        sender: [business: :photo],
        messages: ^get_first_100_messages()
      ]
    )
    |> Repo.one()
  end

  def get_threads_by_user_and_listing(user_id, listing_id) do
    from(t in Thread,
      where: t.sender_id == ^user_id and t.listing_id == ^listing_id,
      order_by: [desc: :updated_at],
      preload: [
        [listing: :photos],
        messages: ^get_first_100_messages(),
        receiver: [business: :photo],
        sender: [business: :photo]
      ]
    )
    |> Repo.all()
  end

  def buyer_threads(user_id) do
    from(t in Thread,
      where: t.sender_id == ^user_id,
      order_by: [desc: t.updated_at],
      preload: [
        [listing: :photos],
        messages: ^get_first_100_messages(),
        receiver: [business: :photo],
        sender: [business: :photo]
      ]
    )
    |> Repo.all()
  end

  def current_thread(user_id, uuid) do
    from(t in Thread,
      where: t.sender_id == ^user_id and t.uuid == ^uuid,
      preload: [
        [listing: :photos],
        receiver: [business: :photo],
        sender: [business: :photo],
        messages: ^get_first_100_messages()
      ]
    )
    |> Repo.one()
  end

  def get_first_100_messages() do
    from(m in Message,
      order_by: [asc: :inserted_at],
      limit: 100
    )
  end

  def conversation_started(user_id, receiver_id, listing_id) do
    from(t in Thread,
      where:
        t.sender_id == ^user_id and t.receiver_id == ^receiver_id and t.listing_id == ^listing_id
    )
    |> Repo.one()
  end

  # not seller dashboard
  def get_user_communication_with_business(user_id) do
    businesses =
      from(t in Thread,
        where: t.sender_id == ^user_id,
        distinct: :business_id,
        preload: [business: [:photo, :user]]
      )
      |> Repo.all()

    listings =
      from(t in Thread,
        where: t.sender_id == ^user_id,
        preload: [[listing: :photos], messages: ^not_read()]
      )
      |> Repo.all()

    %{businesses: businesses, listings: listings}
  end

  def not_read() do
    from(m in Message,
      where: m.read == false,
      select: %{sent_by: m.sent_by}
    )
  end

  def real_time_count(user_id) do
    from(t in Thread,
      where: t.receiver_id == ^user_id,
      join: m in Message,
      where: m.thread_uuid == t.uuid and m.read == false and m.received_by == ^user_id,
      group_by: [t.uuid, t.listing_id],
      select: %{id: t.uuid, listing_id: t.listing_id, count: count(m)}
    )
    |> Repo.all()
  end
end
