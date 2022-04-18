defmodule Puppies.Views do
  @moduledoc """
  The Views context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.{Views.View, Pagination, Utilities}

  def list_views(listing_id) do
    from(v in View,
      where: v.listing_id == ^listing_id,
      preload: [user: :business]
    )
    |> Repo.all()
  end

  def my_views(user_id, opt \\ %{limit: "5", page: "1", number_of_links: 7}) do
    q =
      from(v in View,
        where: v.user_id == ^user_id and v.unique == true
      )

    views =
      preload(q)
      |> limit_offset(opt.limit, Utilities.set_offset(opt.page, opt.limit))
      |> Repo.all()

    paginate =
      Repo.aggregate(
        q,
        :count,
        :id
      )

    pagination = Pagination.pagination(paginate, opt.page, opt.limit, opt.number_of_links)
    %{views: views, pagination: pagination}
  end

  def preload(q) do
    from([b] in q, preload: [listing: [:photos, [user: :business]]])
  end

  def limit_offset(q, limit, offset) do
    limit = Utilities.convert_string_to_integer(limit)
    from([b] in q, limit: ^limit, offset: ^offset)
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
