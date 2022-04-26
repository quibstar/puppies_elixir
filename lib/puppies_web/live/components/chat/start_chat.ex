defmodule PuppiesWeb.StartChat do
  @moduledoc """
  Message component when clicked from profile drawer
  """
  use PuppiesWeb, :live_component
  alias Puppies.Threads

  def update(assigns, socket) do
    changeset = Threads.changes(%{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  def handle_event("validate", %{"initial_message" => initial_message}, socket) do
    changeset = Threads.changes(initial_message)

    {:noreply, socket |> assign(:changeset, changeset)}
  end

  def handle_event("send_message", %{"initial_message" => initial_message}, socket) do
    case Threads.create_threads(initial_message) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Conversation started!.")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def photo(listing) do
    if listing.photos == [] do
    else
    end
  end

  def render(assigns) do
    ~H"""
      <div>
        <.form let={form} for={@changeset} as="initial_message" id="message-form", phx_target={@myself} phx_change="validate" phx_submit="send_message">
          <div class="space-y-4">

            <div class="flex justify-evenly">
              <%= PuppiesWeb.Avatar.show(%{business: @business, user: @business.user, square: 24, extra_classes: "text8_5xl"}) %>
              <%= PuppiesWeb.PuppyAvatar.show(%{listing: @listing, square: 24, extra_classes: "text8_5xl"}) %>
            </div>
            <div class="text-gray-500">
                Start a conversation with <span class="text-gray-800"><%= @business.name %> about <%= @listing.name %></span>.
            </div>

            <div class="">
                <%= textarea(form, :message, class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md", rows: 3) %>
            </div>

            <div>
              <%= hidden_input form, :listing_id, value: @listing.id %>
              <%= hidden_input form, :business_id, value: @business.id %>
              <%= hidden_input form, :receiver_id, value: @business.user_id %>
              <%= hidden_input form, :sender_id, value: @user.id %>
              <%= submit "Submit", phx_disable_with: "Saving...",  disabled: !@changeset.valid?,  class: "w-full px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
            </div>
          </div>
    	</.form>
    </div>
    """
  end
end
