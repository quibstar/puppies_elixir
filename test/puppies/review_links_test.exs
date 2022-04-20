defmodule Puppies.ReviewLinksTest do
  use Puppies.DataCase

  alias Puppies.ReviewLinks

  describe "review_links" do
    alias Puppies.ReviewLinks.ReviewLink

    import Puppies.ReviewLinksFixtures

    @invalid_attrs %{email: nil, uuid: nil}

    test "create_review_link/1 with valid data creates a review_link" do
      valid_attrs = %{email: "some email", uuid: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %ReviewLink{} = review_link} = ReviewLinks.create_review_link(valid_attrs)
      assert review_link.email == "some email"
      assert review_link.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_review_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ReviewLinks.create_review_link(@invalid_attrs)
    end

    test "delete_review_link/1 deletes the review_link" do
      review_link = review_link_fixture()
      assert {:ok, %ReviewLink{}} = ReviewLinks.delete_review_link(review_link)
      assert_raise Ecto.NoResultsError, fn -> ReviewLinks.get_review_link!(review_link.id) end
    end
  end
end
