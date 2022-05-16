defmodule PuppiesWeb.Admin.ThreadComponent do
  @moduledoc """
  Profile component
  """
  use PuppiesWeb, :live_component

  alias PuppiesWeb.{UI.Drawer}
  alias Puppies.{Admin.Messages}

  def handle_event("thread", %{"thread_uuid" => thread_uuid}, socket) do
    messages = Messages.get_messages_by_thread_uuid(thread_uuid)

    thread =
      Enum.find(socket.assigns.threads, fn thread ->
        if thread.uuid == thread_uuid do
          thread
        end
      end)

    {
      :noreply,
      socket
      |> assign(:messages, messages)
      |> assign(:thread, thread)
    }
  end

  def render(assigns) do
    ~H"""
    <div class="mt-4" x-data="{ show_drawer: false}">

      <Drawer.drawer key="show_drawer" max_width={"max-w-4xl"}>
        <:drawer_title>
          Conversation
        </:drawer_title>
        <:drawer_body>
          <.live_component module={PuppiesWeb.Admin.MessagesComponent} id="messages" messages={@messages} thread={@thread} user={@user}/>
        </:drawer_body>
      </Drawer.drawer>

      <%= if @user.is_seller do %>
        <ul class="space-y-2">
          <%= for thread <- @threads do %>
            <li phx-target={@myself} phx-click="thread" phx-value-thread_uuid={thread.uuid} x-on:click.debounce="show_drawer = !show_drawer" class="p-2 flex rounded-lg border border hover:shadow-md hover:border-primary-500 cursor-pointer">
                <div class="relative">
                  <%= PuppiesWeb.PuppyAvatar.show(%{listing: thread.listing, square: 10, extra_classes: "text8_5xl"}) %>
                </div>
                <div class="ml-3 flex justify-between flex-grow items-center">
                  <div class="text-sm text-gray-900">
                    <div class="text-xs text-gray-600">
                      Conversation with <%= thread.receiver.first_name %> <%= thread.receiver.last_name %> about:
                    </div>
                    <div>
                      <%= thread.listing.name %>
                    </div>
                  </div>
                  <span data-date={thread.updated_at} class="text-xs text-gray-400 messages-date"></span>
                </div>
            </li>
          <% end %>
        </ul>
      <% else %>
        not seller
      <% end %>
    </div>
    """
  end
end
