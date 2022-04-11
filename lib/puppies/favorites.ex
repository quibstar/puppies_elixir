defmodule Puppies.Favorites do
  @moduledoc """
  The Favorites context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.Favorite

  def get_favorite_ids(user_id) do
    q =
      from(f in Favorite,
        where: f.user_id == ^user_id,
        select: f.listing_id
      )

    Repo.all(q)
  end

  def create_favorite(attrs \\ %{}) do
    %Favorite{}
    |> Favorite.changeset(attrs)
    |> Repo.insert()
  end

  def delete_favorite(user_id, listing_id) do
    q =
      from(f in Favorite,
        where: f.user_id == ^user_id and f.listing_id == ^listing_id
      )

    Repo.delete_all(q)
  end
end
