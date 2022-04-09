defmodule Puppies.Breeds do
  @moduledoc """
  The Matches context.
  """
  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.{Pagination, Utilities, Dogs.Breed}

  def breeds_list() do
    Repo.all(Breed)
  end

  def get_breed_by_slug(slug) do
    from(b in Breed,
      where: b.slug == ^slug
    )
    |> Repo.one()
  end

  def get_breed(
        slug,
        opt \\ %{limit: "12", page: "1", sort: "reputation_level", number_of_links: 7}
      ) do
    q =
      from(l in Puppies.Listings.Listing,
        right_join: b in assoc(l, :breeds),
        where: b.slug == ^slug,
        preload: [:breeds, :photos, [user: [business: :photo]]]
      )

    matches =
      limit_offset(q, opt.limit, Utilities.set_offset(opt.page, opt.limit))
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

  def limit_offset(q, limit, offset) do
    limit = Utilities.convert_string_to_integer(limit)
    from([l, b] in q, limit: ^limit, offset: ^offset)
  end
end
