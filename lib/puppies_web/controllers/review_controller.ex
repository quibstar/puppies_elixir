defmodule PuppiesWeb.ReviewController do
  use PuppiesWeb, :controller
  alias Puppies.{ReviewLinks, Listings, Reviews, Reviews.Review, Accounts}

  def new(conn, %{"review" => uuid}) do
    review_link = ReviewLinks.get_review_link_by_uuid(uuid)

    data =
      cond do
        is_nil(review_link) ->
          %{review_link: review_link}

        review_link.expired ->
          %{review_link: review_link}

        true ->
          user = Accounts.get_user_by_email(review_link.email)
          listing = Listings.get_listing_for_review(review_link.listing_id)
          changeset = Reviews.change_review(%Review{})

          status =
            if user.id == listing.user_id do
              "fraudulent"
            else
              "ready"
            end

          %{
            listing: listing,
            review_link: review_link,
            changeset: changeset,
            status: status,
            user: user
          }
      end

    render(conn, "new.html", data)
  end

  def show(conn, %{"id" => id}) do
    review = Reviews.get_review!(id)
    render(conn, "show.html", review: review)
  end

  def create(conn, %{"review" => review}) do
    uuid = review["uuid"]

    case Reviews.create_review(review) do
      {:ok, review} ->
        review_link = ReviewLinks.get_review_link_by_uuid(uuid)
        ReviewLinks.update_review_link(review_link, %{expired: true})
        # ReviewLinks.delete_review_link(review_link)

        conn
        |> put_flash(:info, "Review created successfully.")
        |> redirect(to: Routes.review_path(conn, :show, review.id))

      {:error, _} ->
        conn
        |> put_flash(:error, "Review not saved please try again.")
        |> redirect(to: Routes.review_path(conn, :new, review: uuid))
    end
  end
end
