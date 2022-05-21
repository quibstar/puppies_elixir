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
        category: "some category",
        name: "some name"
      })
      |> Puppies.Breeds.create_breed()

    breed
  end
end