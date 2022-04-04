defmodule Puppies.PhotosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puppies.Photos` context.
  """

  @doc """
  Generate a photo.
  """
  def photo_fixture(attrs \\ %{}) do
    {:ok, photo} =
      attrs
      |> Enum.into(%{
        name: "some name",
        url: "some url"
      })
      |> Puppies.Photos.create_photo()

    photo
  end
end
