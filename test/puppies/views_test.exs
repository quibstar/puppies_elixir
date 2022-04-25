defmodule Puppies.ViewsTest do
  use Puppies.DataCase

  alias Puppies.Views
  import Puppies.ListingsFixtures
  import Puppies.AccountsFixtures
  import Puppies.BusinessesFixtures

  setup do
    user = user_fixture()
    buyer = user_fixture()
    business = business_fixture(%{user_id: user.id, location_autocomplete: "some place"})
    listing = listing_fixture(%{user_id: user.id})

    {:ok, user: user, buyer: buyer, listing: listing}
  end

  describe "views" do
    alias Puppies.Views.View

    import Puppies.ViewsFixtures

    @invalid_attrs %{}

    test "create_view/1 with valid data creates a view", %{user: user, listing: listing} do
      assert {:ok, %View{} = view} =
               Views.create_view(%{user_id: user.id, listing_id: listing.id})
    end

    test "create_view/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Views.create_view(@invalid_attrs)
    end
  end
end
