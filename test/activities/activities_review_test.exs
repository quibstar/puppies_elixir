defmodule Puppies.ActivitiesReviewTest do
  use Puppies.DataCase

  import Puppies.{AccountsFixtures, ReviewsFixtures}
  alias Puppies.{Accounts, Activities, Reviews}

  describe "Activities" do
    test "creates new review" do
      user = user_fixture()

      {:ok, new_review} =
        Reviews.create_review(%{
          review: "This is a review",
          rating: 5
        })

      res = Activities.review_changes(%Reviews.Review{}, new_review)

      assert(
        res == [
          %{field: :id, new_value: new_review.id, old_value: nil},
          %{
            field: :review,
            new_value: "This is a review",
            old_value: nil
          },
          %{field: :rating, new_value: 5, old_value: nil}
        ]
      )
    end

    test "updates new review" do
      user = user_fixture()
      old_review = review_fixture(%{user_id: user.id})

      {:ok, new_review} =
        Reviews.update_review(old_review, %{
          review: "I changed this",
          rating: 5
        })

      res = Activities.review_changes(old_review, new_review)

      assert(
        res == [
          %{field: :review, new_value: "I changed this", old_value: "some review"},
          %{field: :rating, new_value: 5, old_value: 42}
        ]
      )
    end
  end
end
