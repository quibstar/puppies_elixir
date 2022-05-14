defmodule Puppies.Admin.Photos do
  @moduledoc """
  Photos context
  """
  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.Photos.Photo
  alias Puppies.Utilities

  def get_photo!(id), do: Repo.get!(Photo, id)

  def change_photo(%Photo{} = photo, attrs \\ %{}) do
    Photo.changeset(photo, attrs)
  end

  def update(%Photo{} = photo, attrs) do
    photo
    |> Photo.changeset(attrs)
    |> Repo.update()
  end

  def photos_that_need_approval(page, limit) do
    offset =
      Utilities.convert_string_to_integer(page) * Utilities.convert_string_to_integer(limit) -
        Utilities.convert_string_to_integer(limit)

    q =
      from(p in Photo,
        where: p.approved == false and p.mark_for_deletion == false
      )

    photos = Repo.all(limit_offset(q, limit, offset))

    p =
      Repo.aggregate(
        q,
        :count,
        :id
      )

    pagination = Puppies.Pagination.pagination(p, page, limit)

    %{photos: photos, pagination: pagination}
  end

  def limit_offset(q, limit, offset) do
    from(p in q, limit: ^limit, offset: ^offset)
  end

  def photos_that_need_approval_count() do
    q =
      from(p in Photo,
        where: p.approved == false and p.mark_for_deletion == false
      )

    Repo.aggregate(
      q,
      :count,
      :id
    )
  end

  def photos_marked_for_deletion() do
    q =
      from(p in Photo,
        where: p.mark_for_deletion == true
      )

    Repo.all(q)
  end

  def photos_ids(is_for_photos) do
    q = from(p in Photo)

    q =
      where_query(q, is_for_photos)
      |> select_photo_id

    Repo.all(q)
  end

  def where_query(q, is_for_photos) do
    if is_for_photos == "photos" do
      from([p] in q, where: p.approved == false and p.mark_for_deletion == false)
    else
      from([p] in q, where: p.mark_for_deletion == true)
    end
  end

  def select_photo_id(q) do
    from(p in q, select: p.id)
  end
end
