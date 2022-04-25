defmodule PuppiesWeb.NotificationsLive do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_view

  alias Puppies.Accounts

  def mount(_params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(session, socket) do
    user =
      if connected?(socket) && Map.has_key?(session, "user_token") do
        %{"user_token" => user_token} = session
        Accounts.get_user_by_session_token(user_token)
      end

    socket =
      assign(
        socket,
        loading: false,
        user: user,
        my_notifications: []
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <div class="h-full">
        <%= if @loading  do%>
          <%= live_component PuppiesWeb.LoadingComponent, id: "notifications-loading" %>
        <% else  %>
          <%= if @my_notifications == [] do %>
            <div class="h-full flex justify-center items-center mx-auto">
              <div class="text-center">
                  <svg class="mx-auto h-12 w-12 text-gray-400" xmlns="http://www.w3.org/2000/svg"  fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                  </svg>
                  <h3 class="mt-2 text-sm font-medium text-gray-900">No notifications</h3>
                  <p class="mt-1 text-sm text-gray-500">
                    Don't worry, we'll let you know.
                  </p>
              </div>
            </div>
          <% else %>
            <div class=" bg-white max-w-md mx-auto px-4">
              <ul class="divide-y divide-gray-200">
                <%= for note <- @my_notifications do %>
                  <li class="py-4 grid grid-cols-6 relative">
                    <%= PuppiesWeb.Avatar.show(%{business: note.user.business, user: note.user, square: 10, extra_classes: "text-2xl"}) %>
                    <div class="col-span-4">

                    </div>
                    <div>
                      <div>
                        <%= if note.viewed do %>
                          <button phx-click="notification-action" phx-value-notification_id={note.id} phx-value-action="not-viewed" class="text-gray-700 block text-sm stroke-primary-500">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 inline-block" fill="none" viewBox="0 0 24 24" >
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 19v-8.93a2 2 0 01.89-1.664l7-4.666a2 2 0 012.22 0l7 4.666A2 2 0 0121 10.07V19M3 19a2 2 0 002 2h14a2 2 0 002-2M3 19l6.75-4.5M21 19l-6.75-4.5M3 10l6.75 4.5M21 10l-6.75 4.5m0 0l-1.14.76a2 2 0 01-2.22 0l-1.14-.76" />
                            </svg>
                          </button>
                        <% else %>
                          <button phx-click="notification-action" phx-value-notification_id={note.id} phx-value-action="viewed" class="text-gray-700 block text-sm stroke-primary-500">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 inline-block" fill="none" viewBox="0 0 24 24" >
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                            </svg>
                          </button>
                        <% end %>
                      </div>
                      <div>
                        <button phx-click="notification-delete" phx-value-notification_id={note.id} class="text-gray-700 block pt-2 text-sm stroke-red-500">
                          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 inline-block" fill="none" viewBox="0 0 24 24" >
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                          </svg>
                        </button>
                      </div>
                    </div>
                  </li>
                <% end %>
              </ul>
            </div>
          <% end %>
        <% end %>
      </div>
    """
  end
end
