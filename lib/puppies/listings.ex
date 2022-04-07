defmodule Puppies.Listings do
  @moduledoc """
  The Listings context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.Listings.Listing

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

  @doc """
  Gets a single listing.

  Raises `Ecto.NoResultsError` if the Listing does not exist.

  ## Examples

      iex> get_listing!(123)
      %Listing{}

      iex> get_listing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_listing_alt!(id), do: Repo.get!(Listing, id)

  def get_listing!(id) do
    q =
      from(b in Listing,
        where: b.id == ^id
      )
      |> preload([:breeds, :photos, :listing_breeds])

    Repo.one(q)
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
end
