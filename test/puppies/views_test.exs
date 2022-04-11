defmodule Puppies.ViewsTest do
  use Puppies.DataCase

  alias Puppies.Views

  describe "views" do
    alias Puppies.Views.View

    import Puppies.ViewsFixtures

    @invalid_attrs %{}

    test "list_views/0 returns all views" do
      view = view_fixture()
      assert Views.list_views() == [view]
    end

    test "get_view!/1 returns the view with given id" do
      view = view_fixture()
      assert Views.get_view!(view.id) == view
    end

    test "create_view/1 with valid data creates a view" do
      valid_attrs = %{}

      assert {:ok, %View{} = view} = Views.create_view(valid_attrs)
    end

    test "create_view/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Views.create_view(@invalid_attrs)
    end

    test "update_view/2 with valid data updates the view" do
      view = view_fixture()
      update_attrs = %{}

      assert {:ok, %View{} = view} = Views.update_view(view, update_attrs)
    end

    test "update_view/2 with invalid data returns error changeset" do
      view = view_fixture()
      assert {:error, %Ecto.Changeset{}} = Views.update_view(view, @invalid_attrs)
      assert view == Views.get_view!(view.id)
    end

    test "delete_view/1 deletes the view" do
      view = view_fixture()
      assert {:ok, %View{}} = Views.delete_view(view)
      assert_raise Ecto.NoResultsError, fn -> Views.get_view!(view.id) end
    end

    test "change_view/1 returns a view changeset" do
      view = view_fixture()
      assert %Ecto.Changeset{} = Views.change_view(view)
    end
  end
end
