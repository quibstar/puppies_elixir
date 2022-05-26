defmodule Puppies.BusinessesTest do
  use Puppies.DataCase

  alias Puppies.Businesses

  describe "businesses" do
    alias Puppies.Businesses.Business

    import Puppies.BusinessesFixtures

    @invalid_attrs %{
      description: nil,
      federal_license: nil,
      name: nil,
      phone: nil,
      state_license: nil,
      website: nil,
      location_autocomplete: "grand rapids"
    }

    test "list_businesses/0 returns all businesses" do
      business = business_fixture()
      business = Map.put(business, :location_autocomplete, nil)
      assert Businesses.list_businesses() == [business]
    end

    test "get_business!/1 returns the business with given id" do
      business = business_fixture()
      business = Map.put(business, :location_autocomplete, nil)
      assert Businesses.get_business!(business.id) == business
    end

    test "create_business/1 with valid data creates a business" do
      valid_attrs = %{
        description: "some description",
        federal_license: true,
        name: "some name",
        phone: "some phone",
        state_license: true,
        website: "some website",
        location_autocomplete: "grand rapids"
      }

      assert {:ok, %Business{} = business} = Businesses.create_business(valid_attrs)
      assert business.description == "some description"
      assert business.federal_license == true
      assert business.name == "some name"
      assert business.phone == "some phone"
      assert business.state_license == true
      assert business.website == "some website"
    end

    test "create_business/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Businesses.create_business(@invalid_attrs)
    end

    test "update_business/2 with valid data updates the business" do
      business = business_fixture()

      update_attrs = %{
        description: "some updated description",
        federal_license: false,
        name: "some updated name",
        phone: "some updated phone",
        state_license: false,
        website: "some updated website",
        location_autocomplete: "grand rapids"
      }

      assert {:ok, %Business{} = business} = Businesses.update_business(business, update_attrs)
      assert business.description == "some updated description"
      assert business.federal_license == false
      assert business.name == "some updated name"
      assert business.phone == "some updated phone"
      assert business.state_license == false
      assert business.website == "some updated website"
    end

    test "update_business/2 with invalid data returns error changeset" do
      business = business_fixture()
      assert {:error, %Ecto.Changeset{}} = Businesses.update_business(business, @invalid_attrs)
      business = Map.put(business, :location_autocomplete, nil)
      assert business == Businesses.get_business!(business.id)
    end

    test "delete_business/1 deletes the business" do
      business = business_fixture()
      assert {:ok, %Business{}} = Businesses.delete_business(business)
      assert_raise Ecto.NoResultsError, fn -> Businesses.get_business!(business.id) end
    end

    test "change_business/1 returns a business changeset" do
      business = business_fixture()
      assert %Ecto.Changeset{} = Businesses.change_business(business)
    end
  end
end
