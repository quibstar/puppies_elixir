defmodule PuppiesWeb.Admin.IpMatches do
  @moduledoc """
  Profile component
  """
  use PuppiesWeb, :live_component
  alias Puppies.Admin.IPDatum

  def update(assigns, socket) do
    matches = IPDatum.get_ip_data_by_ip(assigns.id)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:matches, matches)}
  end

  def render(assigns) do
    ~H"""
      <div>
        <ul role="list" class="divide-y divide-gray-200">
          <%= for match <- @matches do %>
            <li class="py-4 flex">
              Image here!
              <div class="ml-3">
                <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.Admin.User, match.user.id) do %>
                  <p class="text-sm font-medium text-gray-900 underline"><%= match.user.first_name %> <%= match.user.last_name %></p>
                <% end %>
                <p class="text-sm text-gray-500"><%= match.user.email %></p>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    """
  end
end
