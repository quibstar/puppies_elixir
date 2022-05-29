defmodule Puppies.Admin.Activities do
  @moduledoc """
  The Business context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.{Pagination, Utilities}

  alias Puppies.{Activity, Pagination, Utilities}

  def get_activities(user_id, opt) do
    q =
      from(a in Activity,
        where: a.user_id == ^user_id
      )

    activities =
      limit_offset_order(q, opt.limit, Utilities.set_offset(opt.page, opt.limit))
      |> Repo.all()

    paginate =
      Repo.aggregate(
        q,
        :count,
        :id
      )

    pagination = Pagination.pagination(paginate, opt.page, opt.limit, opt.number_of_links)
    %{activities: activities, pagination: pagination}
  end

  def limit_offset_order(q, limit, offset) do
    limit = Utilities.convert_string_to_integer(limit)

    from([b] in q,
      limit: ^limit,
      offset: ^offset,
      order_by: [desc: :inserted_at]
    )
  end
end
