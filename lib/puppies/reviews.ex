defmodule Puppies.Reviews do
  @moduledoc """
  The Reviews context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.Reviews.Review

  @doc """
  Returns the list of reviews.

  ## Examples

      iex> list_reviews()
      [%Review{}, ...]

  """
  def list_reviews do
    Repo.all(Review)
  end

  @doc """
  Gets a single review.

  Raises `Ecto.NoResultsError` if the Review does not exist.

  ## Examples

      iex> get_review!(123)
      %Review{}

      iex> get_review!(456)
      ** (Ecto.NoResultsError)

  """
  def get_review!(id), do: Repo.get!(Review, id)

  @doc """
  Creates a review.

  ## Examples

      iex> create_review(%{field: value})
      {:ok, %Review{}}

      iex> create_review(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_review(attrs \\ %{}) do
    %Review{}
    |> Review.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a review.

  ## Examples

      iex> update_review(review, %{field: new_value})
      {:ok, %Review{}}

      iex> update_review(review, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_review(%Review{} = review, attrs) do
    review
    |> Review.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a review.

  ## Examples

      iex> delete_review(review)
      {:ok, %Review{}}

      iex> delete_review(review)
      {:error, %Ecto.Changeset{}}

  """
  def delete_review(%Review{} = review) do
    Repo.delete(review)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking review changes.

  ## Examples

      iex> change_review(review)
      %Ecto.Changeset{data: %Review{}}

  """
  def change_review(%Review{} = review, attrs \\ %{}) do
    Review.changeset(review, attrs)
  end

  def review_stats(business_id) do
    res = from(r in Review, where: r.business_id == ^business_id)

    stars =
      from(r in res,
        group_by: :rating,
        select: %{rating: count(r.rating), stars: r.rating}
      )
      |> Repo.all()

    stars_map =
      Enum.reduce(stars, %{}, fn star, acc ->
        case star.stars do
          5 ->
            Map.put(acc, :stars_5, star.rating)

          4 ->
            Map.put(acc, :stars_4, star.rating)

          3 ->
            Map.put(acc, :stars_3, star.rating)

          2 ->
            Map.put(acc, :stars_2, star.rating)

          1 ->
            Map.put(acc, :stars_1, star.rating)

          _ ->
            acc
        end
      end)

    average =
      from(r in res,
        select: avg(r.rating)
      )
      |> Repo.one()
      |> Decimal.round(1)
      |> Decimal.to_float()

    Map.merge(%{average: average}, stars_map)
  end
end
