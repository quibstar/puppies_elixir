defmodule Puppies.ReviewsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puppies.Reviews` context.
  """

  @doc """
  Generate a review.
  """
  def review_fixture(attrs \\ %{}) do
    {:ok, review} =
      attrs
      |> Enum.into(%{
        review: "some review",
        email: "test@test.com",
        first_name: "some first_name",
        rating: 42
      })
      |> Puppies.Reviews.create_review()

    review
  end
end
