defmodule Puppies.ViewsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puppies.Views` context.
  """

  @doc """
  Generate a view.
  """
  def view_fixture(attrs \\ %{}) do
    {:ok, view} =
      attrs
      |> Enum.into(%{

      })
      |> Puppies.Views.create_view()

    view
  end
end
