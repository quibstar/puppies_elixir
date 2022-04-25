defmodule PuppiesWeb.ViewHistoryComponent do
  use Phoenix.Component
  alias PuppiesWeb.{ListView}

  def show(assigns) do
    ~H"""
      <div class="bg-white px-4 py-5 shadow sm:rounded-lg sm:px-6">
        <h2 id="timeline-title" class="text-xlg font-medium text-gray-900">Viewing History</h2>
        <%= if @viewing_history == [] do %>
            <p class="mt-1 text-sm text-gray-500 text-sm">We'll keep a history of profile you've viewed.</p>
          <% else %>
          <ul role="list" class="divide-y divide-gray-200">
            <%= for view <- @viewing_history do %>
              <.live_component module={ListView} id={view.id}  listing={view.listing}} />
            <% end %>
          </ul>
          <%= if @view_pagination.count > 6 do %>
            <%= live_component PuppiesWeb.PaginationComponent, id: "view_pagination", pagination: @view_pagination, socket: @socket, params: %{"page" => @view_pagination.page, "limit" => @view_pagination.limit, "prefix" => "view_"}, end_point: PuppiesWeb.UserDashboardLive, segment_id: nil %>
          <% end %>
        <% end %>
      </div>
    """
  end
end
