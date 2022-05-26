defmodule PuppiesWeb.ReviewControllerTest do
  use PuppiesWeb.ConnCase, async: true

  import Puppies.ReviewLinksFixtures
  import Puppies.ListingsFixtures
  import Puppies.AccountsFixtures
  import Puppies.BusinessesFixtures
  import Ecto

  setup %{conn: conn} do
    user = user_fixture(%{email: "test@test.com"})
    business = business_fixture(%{user_id: user.id, location_autocomplete: "some place"})
    listing = listing_fixture(%{user_id: user.id})
    conn = conn |> log_in_user(user)

    review_link =
      review_link_fixture(
        email: user.email,
        listing_id: listing.id,
        uuid: Ecto.UUID.generate()
      )

    %{
      review_link: review_link,
      conn: conn,
      business: business,
      listing: listing
    }
  end

  describe "GET /review" do
    test "GET /review/new", %{conn: conn, review_link: review_link} do
      conn = get(conn, "/reviews/new?review=#{review_link.uuid}")
      assert html_response(conn, 200)
    end

    test "GET expired review", %{conn: conn, listing: listing} do
      reviewer = user_fixture(%{email: "test1@test.com"})

      expired_review_link =
        review_link_fixture(
          email: "test1@test.com",
          listing_id: listing.id,
          expired: true,
          uuid: Ecto.UUID.generate()
        )

      conn = get(conn, "/reviews/new?review=#{expired_review_link.uuid}")
      assert html_response(conn, 200) =~ "Review Expired"
    end
  end

  describe "POST /review" do
    test "creates a new review", %{conn: conn, review_link: review_link, business: business} do
      conn =
        post(conn, Routes.review_path(conn, :create), %{
          "review" => %{
            first_name: "test",
            rating: 5,
            review: "this is a review",
            email: review_link.email,
            business_id: business.id,
            uuid: review_link.uuid
          }
        })

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.review_path(conn, :show, id)

      conn = get(conn, Routes.review_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Thank you"
    end
  end

  describe "POST  bad data /review" do
    test "creates a new review", %{conn: conn, review_link: review_link, business: business} do
      conn =
        post(conn, Routes.review_path(conn, :create), %{
          "review" => %{
            rating: 5,
            email: review_link.email,
            business_id: business.id,
            uuid: review_link.uuid
          }
        })

      assert redirected_to(conn) == Routes.review_path(conn, :new, review: review_link.uuid)
    end
  end
end
