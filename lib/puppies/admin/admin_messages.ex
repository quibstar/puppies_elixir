defmodule Puppies.Admin.Messages do
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
end
