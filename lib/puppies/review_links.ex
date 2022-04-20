defmodule Puppies.ReviewLinks do
  @moduledoc """
  The ReviewLinks context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.ReviewLinks.ReviewLink

  @doc """
  Returns the list of review_links.

  ## Examples

      iex> list_review_links()
      [%ReviewLink{}, ...]

  """
  def list_review_links do
    Repo.all(ReviewLink)
  end

  def get_review_link_by_uuid(uuid) do
    from(r in ReviewLink,
      where: r.uuid == ^uuid
    )
    |> Repo.one()
  end

  @doc """
  Gets a single review_link.

  Raises `Ecto.NoResultsError` if the Review link does not exist.

  ## Examples

      iex> get_review_link!(123)
      %ReviewLink{}

      iex> get_review_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_review_link!(id), do: Repo.get!(ReviewLink, id)

  @doc """
  Creates a review_link.

  ## Examples

      iex> create_review_link(%{field: value})
      {:ok, %ReviewLink{}}

      iex> create_review_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_review_link(attrs \\ %{}) do
    %ReviewLink{}
    |> ReviewLink.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a review_link.

  ## Examples

      iex> update_review_link(review_link, %{field: new_value})
      {:ok, %ReviewLink{}}

      iex> update_review_link(review_link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_review_link(%ReviewLink{} = review_link, attrs) do
    review_link
    |> ReviewLink.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a review_link.

  ## Examples

      iex> delete_review_link(review_link)
      {:ok, %ReviewLink{}}

      iex> delete_review_link(review_link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_review_link(%ReviewLink{} = review_link) do
    Repo.delete(review_link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking review_link changes.

  ## Examples

      iex> change_review_link(review_link)
      %Ecto.Changeset{data: %ReviewLink{}}

  """
  def change_review_link(%ReviewLink{} = review_link, attrs \\ %{}) do
    ReviewLink.changeset(review_link, attrs)
  end
end
