defmodule Puppies.Admin.Listings do
  @moduledoc """
  The Listings context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.Listings.Listing

  def get_user_listings(user_id) do
    q =
      from(b in Listing,
        where: b.user_id == ^user_id
      )
      |> preload([:photos])

    Repo.all(q)
  end
end
