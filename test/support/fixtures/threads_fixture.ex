defmodule Puppies.ThreadsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puppies.Threads` context.
  """

  @doc """
  Generate a thread.
  """
  def thread_fixture(attrs \\ %{}) do
    {:ok, thread} = Puppies.Threads.create_thread(attrs)
    thread
  end
end
