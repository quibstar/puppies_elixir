defmodule Puppies.Admin.Threads do
  @moduledoc """
  The Threads context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.{Thread}

  def seller_threads(user_id) do
    from(t in Thread,
      where: t.sender_id == ^user_id,
      preload: [
        [listing: :photos],
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
        receiver: [business: :photo],
        sender: [business: :photo]
      ]
    )
    |> Repo.all()
  end
end
