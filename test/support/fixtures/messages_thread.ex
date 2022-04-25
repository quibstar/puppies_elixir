defmodule Puppies.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puppies.Messages` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        category: "some category",
        name: "some name"
      })
      |> Puppies.Messages.create_message()

    message
  end
end
