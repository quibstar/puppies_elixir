defmodule Puppies.Admin.Business do
  @moduledoc """
  The Business context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.Businesses.Business

  def get_user_business(user_id) do
    q =
      from(b in Business,
        where: b.user_id == ^user_id
      )
      |> preload([:photo])

    Repo.one(q)
  end
end
