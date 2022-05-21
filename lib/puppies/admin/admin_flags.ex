defmodule Puppies.Admin.Flags do
  @moduledoc """
  Flags context
  """
  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.{Flag, Utilities, Accounts.User}

  def open_flags(page, limit \\ "12", is_system_reported \\ false) do
    offset =
      Utilities.convert_string_to_integer(page) * Utilities.convert_string_to_integer(limit) -
        Utilities.convert_string_to_integer(limit)

    p =
      Repo.aggregate(
        from(f in Flag, where: f.resolved == false and f.system_reported == ^is_system_reported),
        :count,
        :id
      )

    pagination = Puppies.Pagination.pagination(p, page, limit)

    users = Repo.all(fetch_flags(limit, offset, is_system_reported))

    %{users: users, pagination: pagination}
  end

  def fetch_flags(limit, offset, is_system_reported) do
    from(u in User,
      join: f in Flag,
      on: f.offender_id == u.id,
      where: f.resolved == false and f.system_reported == ^is_system_reported,
      distinct: u.id,
      preload: [:flags, business: :photo],
      order_by: [desc: f.inserted_at],
      limit: ^limit,
      offset: ^offset
    )
  end

  def flag_count(is_system_flag \\ false) do
    q =
      from(f in Flag,
        where: f.resolved == false and f.system_reported == ^is_system_flag
      )

    Repo.aggregate(
      q,
      :count,
      :id
    )
  end

  def update(%Flag{} = flag, attrs) do
    flag
    |> Flag.changeset(attrs)
    |> Repo.update()
  end

  def open_flags_user_ids() do
    f =
      from(f in Flag,
        where: f.resolved == false,
        distinct: f.offender_id,
        order_by: [desc: f.inserted_at],
        select: f.offender_id
      )

    Repo.all(f)
  end

  @spec flags_by_user_id(any) :: Ecto.Query.t()
  def flags_by_user_id(user_id) do
    from(f in Flag,
      where: f.offender_id == ^user_id,
      preload: [:reporter, :admin]
    )
    |> Repo.all()
  end
end
