defmodule Puppies.BreedsTest do
  use Puppies.DataCase

  alias Puppies.Breeds

  describe "breeds" do
    alias Puppies.Breed

    import Puppies.BreedFixtures

    @invalid_attrs %{category: nil, name: nil}

    test "list_breeds/0 returns all breeds" do
      breed = breed_fixture()
      assert Breeds.list_breeds() == [breed]
    end

    test "get_breed!/1 returns the breed with given id" do
      breed = breed_fixture()
      assert Breeds.get_breed!(breed.id) == breed
    end

    test "create_breed/1 with valid data creates a breed" do
      valid_attrs = %{category: "some category", name: "some name"}

      assert {:ok, %Breed{} = breed} = Breeds.create_breed(valid_attrs)
      assert breed.category == "some category"
      assert breed.name == "some name"
    end

    test "create_breed/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Breeds.create_breed(@invalid_attrs)
    end

    test "update_breed/2 with valid data updates the breed" do
      breed = breed_fixture()
      update_attrs = %{category: "some updated category", name: "some updated name"}

      assert {:ok, %Breed{} = breed} = Breeds.update_breed(breed, update_attrs)
      assert breed.category == "some updated category"
      assert breed.name == "some updated name"
    end

    test "update_breed/2 with invalid data returns error changeset" do
      breed = breed_fixture()
      assert {:error, %Ecto.Changeset{}} = Breeds.update_breed(breed, @invalid_attrs)
      assert breed == Breeds.get_breed!(breed.id)
    end

    test "delete_breed/1 deletes the breed" do
      breed = breed_fixture()
      assert {:ok, %Breed{}} = Breeds.delete_breed(breed)
      assert_raise Ecto.NoResultsError, fn -> Breeds.get_breed!(breed.id) end
    end

    test "change_breed/1 returns a breed changeset" do
      breed = breed_fixture()
      assert %Ecto.Changeset{} = Breeds.change_breed(breed)
    end
  end
end
