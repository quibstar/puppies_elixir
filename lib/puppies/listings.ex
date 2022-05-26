defmodule Puppies.Listings do
  @moduledoc """
  The Listings context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.{Listings.Listing, Pagination, Utilities}

  @doc """
  Returns the list of listings.

  ## Examples

      iex> list_listings()
      [%Listing{}, ...]

  """
  def list_listings do
    q =
      from(b in Listing)
      |> preload([
        :photos,
        :breeds,
        :listing_breeds,
        user: [business: [:location, :breeds, :photo]]
      ])

    Repo.all(q)
  end

  def listing_for_elastic_search_reindexing(id) do
    q =
      from(l in Listing,
        where: l.id == ^id
      )
      |> preload([
        :photos,
        :breeds,
        :listing_breeds,
        user: [business: [:location, :breeds, :photo]]
      ])

    Repo.one(q)
  end

  @doc """
  Gets a single listing.

  Raises `Ecto.NoResultsError` if the Listing does not exist.

  ## Examples

      iex> get_listing!(123)
      %Listing{}

      iex> get_listing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_listing!(id), do: Repo.get!(Listing, id)

  def get_listing(id) do
    q =
      from(b in Listing,
        where: b.id == ^id
      )
      |> preload([:breeds, :photos, :listing_breeds])

    Repo.one(q)
  end

  def get_listing_for_review(id) do
    q =
      from(b in Listing,
        where: b.id == ^id
      )
      |> preload(user: :business)

    Repo.one(q)
  end

  def get_listing_by_user_id_and_status(id, status) do
    from(l in Listing,
      where: l.user_id == ^id and l.status == ^status,
      order_by: [desc: :views],
      preload: [:breeds, :photos, :listing_breeds]
    )
    |> Repo.all()
  end

  def get_active_listings_by_user_id(id, opt \\ %{limit: "12", page: "1", number_of_links: 7}) do
    q =
      from(l in Listing,
        where: l.user_id == ^id and l.status == "available",
        order_by: [desc: :views]
      )

    listings =
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

    %{listings: listings, pagination: pagination}
  end

  def preload(q) do
    from([b] in q, preload: [:breeds, :photos, :listing_breeds])
  end

  def limit_offset(q, limit, offset) do
    limit = Utilities.convert_string_to_integer(limit)
    from([b] in q, limit: ^limit, offset: ^offset)
  end

  def get_listing_by_user_id(id) do
    q =
      from(b in Listing,
        where: b.user_id == ^id
      )
      |> preload([:breeds, :photos, :listing_breeds])

    Repo.one(q)
  end

  @doc """
  Creates a listing.

  ## Examples

      iex> create_listing(%{field: value})
      {:ok, %Listing{}}

      iex> create_listing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_listing(attrs \\ %{}) do
    %Listing{}
    |> Listing.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a listing.

  ## Examples

      iex> update_listing(listing, %{field: new_value})
      {:ok, %Listing{}}

      iex> update_listing(listing, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_listing(%Listing{} = listing, attrs) do
    listing
    |> Listing.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a listing.

  ## Examples

      iex> delete_listing(listing)
      {:ok, %Listing{}}

      iex> delete_listing(listing)
      {:error, %Ecto.Changeset{}}

  """
  def delete_listing(%Listing{} = listing) do
    Repo.delete(listing)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking listing changes.

  ## Examples

      iex> change_listing(listing)
      %Ecto.Changeset{data: %Listing{}}

  """
  def change_listing(%Listing{} = listing, attrs \\ %{}) do
    Listing.changeset(listing, attrs)
  end

  def update_view_count(listing_id, views) do
    listing = __MODULE__.get_listing_alt!(listing_id)
    __MODULE__.update_listing(listing, %{views: views})
  end

  def get_listings_ids_for_user(user_id) do
    from(l in Listing,
      where: l.user_id == ^user_id,
      select: l.id
    )
    |> Repo.all()
  end
end
