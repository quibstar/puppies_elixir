defmodule PuppiesWeb.MessagesChannel do
  @moduledoc """
  Messages channel
  """
  use PuppiesWeb, :channel
  alias Puppies.Messages
  alias Puppies.Threads

  def join("messages:user:" <> _user_id, _params, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  @spec handle_info(:after_join, Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_info(:after_join, socket) do
    id = String.to_integer(socket.assigns.user_id)
    send_out(id, socket)
  end

  def handle_in("push_check_count", payload, socket) do
    if payload != %{} do
      # id = String.to_integer(payload["received_by"])
      send_out(payload["received_by"], socket)
    else
      {:noreply, socket}
    end
  end

  def send_out(id, socket) do
    listing_count = Threads.real_time_count(id)

    broadcast!(socket, "update_nav_messages_link", %{"listing_count" => listing_count, id: id})
    {:noreply, socket}
  end
end
