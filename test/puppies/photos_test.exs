defmodule Puppies.PhotosTest do
  use Puppies.DataCase

  alias Puppies.Photos

  describe "photos" do
    alias Puppies.Photos.Photo

    import Puppies.PhotosFixtures

    @invalid_attrs %{name: nil, url: nil}

    test "list_photos/0 returns all photos" do
      photo = photo_fixture()
      assert Photos.list_photos() == [photo]
    end

    test "get_photo!/1 returns the photo with given id" do
      photo = photo_fixture()
      assert Photos.get_photo!(photo.id) == photo
    end

    test "create_photo/1 with valid data creates a photo" do
      valid_attrs = %{name: "some name", url: "some url"}

      assert {:ok, %Photo{} = photo} = Photos.create_photo(valid_attrs)
      assert photo.name == "some name"
      assert photo.url == "some url"
    end

    test "create_photo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Photos.create_photo(@invalid_attrs)
    end

    test "update_photo/2 with valid data updates the photo" do
      photo = photo_fixture()
      update_attrs = %{name: "some updated name", url: "some updated url"}

      assert {:ok, %Photo{} = photo} = Photos.update_photo(photo, update_attrs)
      assert photo.name == "some updated name"
      assert photo.url == "some updated url"
    end

    test "update_photo/2 with invalid data returns error changeset" do
      photo = photo_fixture()
      assert {:error, %Ecto.Changeset{}} = Photos.update_photo(photo, @invalid_attrs)
      assert photo == Photos.get_photo!(photo.id)
    end

    test "delete_photo/1 deletes the photo" do
      photo = photo_fixture()
      assert {:ok, %Photo{}} = Photos.delete_photo(photo)
      assert_raise Ecto.NoResultsError, fn -> Photos.get_photo!(photo.id) end
    end

    test "change_photo/1 returns a photo changeset" do
      photo = photo_fixture()
      assert %Ecto.Changeset{} = Photos.change_photo(photo)
    end
  end
end
