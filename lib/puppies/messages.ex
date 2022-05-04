defmodule Puppies.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.Message

  def get_messages_by_thread_uuid(uuid) do
    from(m in Message,
      where: m.thread_uuid == ^uuid
    )
    |> Repo.all()
  end

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  def message_changes(attrs \\ %{}) do
    Message.changeset(%Message{}, attrs)
  end

  def total_unread_messages(received_by) do
    Repo.aggregate(
      from(m in Message,
        where: m.received_by == ^received_by and m.read == false
      ),
      :count,
      :id
    )
  end
end
