defmodule Puppies.Admin.ActivitiesComponent do
  @moduledoc """
  Profile component
  """
  use PuppiesWeb, :live_component

  alias Puppies.{
    Admin.Activities
  }

  def handle_event("page-to", %{"page_id" => page_id}, socket) do
    data =
      Activities.get_activities(socket.assigns.user_id, %{
        page: page_id,
        limit: socket.assigns.limit,
        number_of_links: 7
      })

    {:noreply,
     assign(
       socket,
       activities: data.activities,
       pagination: Map.get(data, :pagination, %{count: 0}),
       page: page_id
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-white overflow-hidden shadow rounded-lg divide-y px-4 mt-4">
      <div class="px-4 py-5">
        <div class="text-lg font-semibold mb-2">Activity</div>
        <ul class="">
          <%= for {activity, index} <- Enum.with_index(@activities) do  %>
            <%= if Puppies.Utilities.check_date(@activities, index, activity.inserted_at) do %>
              <li class="relative">
                <div class="absolute inset-0 flex items-center" aria-hidden="true">
                  <div class="w-full border-t border-gray-300"></div>
                </div>
                <div class="relative flex justify-center">
                  <span  data-date={activity.inserted_at} class="messages-date px-2 bg-gray-50 text-xs text-gray-500">wtf</span>
                </div>
              </li>
            <% end %>
            <li class="py-2">
              <div class="text-gray-900 flex justify-between">
                <span><%= activity.action %></span>
                <span data-time={activity.inserted_at} class="text-xs text-gray-400 mt-1 messages-time"></span>
              </div>
              <%= unless is_nil(activity.data) do %>
                <div class="text-sm text-gray-500">
                  <%= for datum <- activity.data do %>
                    <div>
                      Changed <span class="font-bold"><%= datum["field"] %></span> from: <span class="text-red-500"><%= datum["old_value"] %></span> to: <span class="text-blue-500"><%= datum["new_value"] %></span>
                    </div>
                  <% end %>
                </div>
              <% end %>
            </li>
          <% end %>
        </ul>
      </div>
      <%= if @pagination.count > String.to_integer(@limit) do %>
        <%= live_component PuppiesWeb.Admin.PaginationComponent, pagination: @pagination, socket: @socket, page: @page, limit: @limit, myself: @myself %>
      <% end %>
    </div>
    """
  end
end
