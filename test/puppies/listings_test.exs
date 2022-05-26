defmodule Puppies.ListingsTest do
  use Puppies.DataCase

  alias Puppies.Listings

  describe "listings" do
    alias Puppies.Listings.Listing

    import Puppies.ListingsFixtures

    @invalid_attrs %{
      coat_color_pattern: nil,
      description: nil,
      dob: nil,
      name: nil,
      price: nil,
      sex: nil,
      status: nil
    }

    # test "list_listings/0 returns all listings" do
    #   listing = listing_fixture()
    #   assert Listings.list_listings() == [listing]
    # end

    # test "get_listing!/1 returns the listing with given id" do
    #   listing = listing_fixture()
    #   assert Listings.get_listing!(listing.id) == listing
    # end

    test "create_listing/1 with valid data creates a listing" do
      valid_attrs = %{
        coat_color_pattern: "some coat",
        description: "some description",
        dob: ~N[2022-03-27 21:17:00],
        name: "some name",
        price: 42,
        sex: "some sex",
        status: "some status"
      }

      assert {:ok, %Listing{} = listing} = Listings.create_listing(valid_attrs)
      assert listing.coat_color_pattern == "some coat"
      assert listing.description == "some description"
      assert listing.dob == ~D[2022-03-27]
      assert listing.name == "some name"
      assert listing.price == 42
      assert listing.sex == "some sex"
      assert listing.status == "some status"
    end

    test "create_listing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Listings.create_listing(@invalid_attrs)
    end

    test "update_listing/2 with valid data updates the listing" do
      listing = listing_fixture()

      update_attrs = %{
        coat_color_pattern: "some updated coat",
        description: "some updated description",
        dob: ~N[2022-03-28 21:17:00],
        name: "some updated name",
        price: 43,
        sex: "some updated sex",
        status: "some updated status"
      }

      assert {:ok, %Listing{} = listing} = Listings.update_listing(listing, update_attrs)
      assert listing.coat_color_pattern == "some updated coat"
      assert listing.description == "some updated description"
      assert listing.dob == ~D[2022-03-28]
      assert listing.name == "some updated name"
      assert listing.price == 43
      assert listing.sex == "some updated sex"
      assert listing.status == "some updated status"
    end

    test "update_listing/2 with invalid data returns error changeset" do
      listing = listing_fixture()
      assert {:error, %Ecto.Changeset{}} = Listings.update_listing(listing, @invalid_attrs)
    end

    test "delete_listing/1 deletes the listing" do
      listing = listing_fixture()
      assert {:ok, %Listing{}} = Listings.delete_listing(listing)

      assert_raise Ecto.NoResultsError, fn -> Listings.get_listing!(listing.id) end
    end

    test "change_listing/1 returns a listing changeset" do
      listing = listing_fixture()
      assert %Ecto.Changeset{} = Listings.change_listing(listing)
    end
  end
end
