defmodule Puppies.FindPuppy do
  @moduledoc """
  The Matches context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.{Pagination, Utilities, Location}

  def city_state(
        city,
        state,
        opt \\ %{limit: "12", page: "1", sort: "newest", number_of_links: 7}
      ) do
    q =
      from(l in Location,
        where:
          l.place_slug == ^city and (l.region_slug == ^state or l.region_short_code == ^state),
        join: b in assoc(l, :business),
        join: u in assoc(b, :user),
        join: list in assoc(u, :listings),
        where: list.is_approved == true,
        preload: [space: [:locations, [profile: [:photos, space: :locations]]]]
      )

    matches =
      sort_by(q, opt.sort)
      |> limit_offset(opt.limit, Utilities.set_offset(opt.page, opt.limit))
      |> Repo.all()

    paginate =
      Repo.aggregate(
        q,
        :count,
        :id
      )

    pagination = Pagination.pagination(paginate, opt.page, opt.limit, opt.number_of_links)

    %{matches: matches, pagination: pagination}
  end

  def sort_by(q, _order) do
    q
  end

  def limit_offset(q, limit, offset) do
    limit = Utilities.convert_string_to_integer(limit)
    from([l, b, u, list] in q, limit: ^limit, offset: ^offset)
  end

  def state(
        state,
        opt \\ %{limit: "12", page: "1", sort: "newest", number_of_links: 7}
      ) do
    q =
      from(l in Location,
        where: l.region_slug == ^state or l.region_short_code == ^state,
        join: b in assoc(l, :business),
        join: u in assoc(b, :user),
        join: list in assoc(u, :listings),
        # where: u.approved_to_sell == true,
        preload: [business: [user: [listings: [:photos, :breeds, [user: [business: :photo]]]]]]
      )

    matches =
      sort_by(q, opt.sort)
      |> limit_offset(opt.limit, Utilities.set_offset(opt.page, opt.limit))
      |> Repo.all()

    paginate =
      Repo.aggregate(
        q,
        :count,
        :id
      )

    pagination = Pagination.pagination(paginate, opt.page, opt.limit, opt.number_of_links)

    %{matches: matches, pagination: pagination}
  end
end
