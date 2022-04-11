defmodule Puppies.Views do
  @moduledoc """
  The Views context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.Views.View

  def list_views(listing_id) do
    from(v in View,
      where: v.listing_id == ^listing_id,
      preload: [user: :business]
    )
    |> Repo.all()
  end

  def my_views(user_id) do
    from(v in View,
      where: v.user_id == ^user_id and v.unique == true,
      preload: [listing: [:photos, [user: :business]]]
    )
    |> Repo.all()
  end

  def list_views_users(listing_id) do
    from(v in View,
      where: v.listing_id == ^listing_id and v.unique == true,
      preload: [user: [business: :photo]]
    )
    |> Repo.all()
  end

  def unique(user_id, listing_id) do
    Repo.exists?(from(v in View, where: v.user_id == ^user_id and v.listing_id == ^listing_id))
  end

  def create_view(attrs \\ %{}) do
    %View{}
    |> View.changeset(attrs)
    |> Repo.insert()
  end

  def update_count(listing_id) do
    listing_count =
      Repo.one(
        from(v in View,
          where: v.listing_id == ^listing_id,
          select: count(v.listing_id)
        )
      )

    Puppies.Listings.update_view_count(listing_id, listing_count)
  end
end
