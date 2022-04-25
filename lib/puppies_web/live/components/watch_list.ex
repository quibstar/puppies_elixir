defmodule PuppiesWeb.WatchListComponent do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component

  alias PuppiesWeb.{ListView}

  def render(assigns) do
    ~H"""
      <div class="bg-white px-4 py-5 shadow sm:rounded-lg sm:px-6">
        <h2 id="timeline-title" class="text-xlg font-medium text-gray-900">Watch list</h2>
        <%= if  @listings == [] do %>
          <p class="mt-1 max-w-2xl text-sm text-gray-500">Add profiles to your watch list that you have interest in.</p>
        <% else %>
          <ul role="list" class="divide-y divide-gray-200">
            <%= for listing <- @listings do %>
              <.live_component module={ListView} id={"#{listing.id}-wl"}   listing={listing} />
            <% end %>
          </ul>
        <% end %>
      </div>
    """
  end
end
