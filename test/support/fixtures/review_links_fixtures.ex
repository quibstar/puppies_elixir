defmodule Puppies.ReviewLinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puppies.ReviewLinks` context.
  """

  @doc """
  Generate a review_link.
  """
  def review_link_fixture(attrs \\ %{}) do
    {:ok, review_link} =
      attrs
      |> Enum.into(%{
        email: "test@test.com",
        uuid: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> Puppies.ReviewLinks.create_review_link()

    review_link
  end
end
