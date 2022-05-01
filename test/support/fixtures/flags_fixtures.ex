defmodule Puppies.FlagsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puppies.Flags` context.
  """

  @doc """
  Generate a flag.
  """
  def flag_fixture(attrs \\ %{}) do
    {:ok, flag} = Puppies.Flags.create(attrs)
    flag
  end
end
