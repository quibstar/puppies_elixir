defmodule Puppies.ImageRemoval do
  @moduledoc """
  Remove images set marked for deletion by admins.
  """
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    schedule_work()
    {:ok, state}
  end

  @impl true
  def handle_info(:remove_images, state) do
    remove_images()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :remove_images, 3_600_000)
  end

  defp remove_images() do
    Puppies.Photos.remove_photos_marked_for_deletion()
  end
end
