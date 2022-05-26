defmodule Puppies.BreedFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puppies.Dogs` context.
  """

  @doc """
  Generate a breed.
  """
  def breed_fixture(attrs \\ %{}) do
    {:ok, breed} =
      attrs
      |> Enum.into(%{
        name: "Shih Tzu",
        slug: "shih-tzu"
      })
      |> Puppies.Breeds.create_breed()

    breed
  end
end
