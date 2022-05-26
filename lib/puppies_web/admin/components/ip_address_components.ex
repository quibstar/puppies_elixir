defmodule PuppiesWeb.Admin.IpAddresses do
  @moduledoc """
  Profile component
  """
  use PuppiesWeb, :live_component

  alias Puppies.Admin.IPDatum

  def update(assigns, socket) do
    ip_addressses = IPDatum.get_ip_addresses_by_user_id(assigns.user.id)

    {:ok,
     assign(
       socket,
       ip_addresses: ip_addressses
     )}
  end

  def render(assigns) do
    ~H"""
      <div>
        <%= if @ip_addresses == [] do %>
          <div class="p-4">
            <%= live_component(PuppiesWeb.Admin.Empty, id: "no-ip-data", title: "No Ip Data", message: "") %>
          </div>
        <% else %>
          <div class="divide-y divide-gray-200">
            <%= for ip_address <- @ip_addresses do %>
              <dl class="py-4">
                <div class="sm:grid sm:grid-cols-3 sm:gap-4">
                  <dt class="text-sm font-medium text-gray-500">
                    IP
                  </dt>
                  <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                    <%= ip_address.ip %>
                  </dd>
                </div>

                <div class="sm:grid sm:grid-cols-3 sm:gap-4">
                  <dt class="text-sm font-medium text-gray-500">
                    Lasted Used
                  </dt>
                  <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                    <%= Puppies.Utilities.format_short_date_time(ip_address.updated_at) %>
                  </dd>
                </div>

                <div class="sm:grid sm:grid-cols-3 sm:gap-4">
                  <dt class="text-sm font-medium text-gray-500">
                    ISP
                  </dt>
                  <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                    <%= ip_address.isp %>
                  </dd>
                </div>

                <div class="sm:grid sm:grid-cols-3 sm:gap-4">
                  <dt class="text-sm font-medium text-gray-500">
                    Country
                  </dt>
                  <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                    <%= ip_address.country_name %>
                  </dd>
                </div>

                <div class="sm:grid sm:grid-cols-3 sm:gap-4">
                  <dt class="text-sm font-medium text-gray-500">
                    City
                  </dt>
                  <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                    <%= ip_address.city %>
                  </dd>
                </div>

                <div class="sm:grid sm:grid-cols-3 sm:gap-4">
                  <dt class="text-sm font-medium text-gray-500">
                    Time Zone
                  </dt>
                  <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                    <%= ip_address.time_zone %>
                  </dd>
                </div>
                <%=if ip_address.matches > 0 do %>
                  <div class="sm:grid sm:grid-cols-3 sm:gap-4">
                    <dt class="text-sm font-medium text-gray-500">
                      Matches
                    </dt>
                    <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                      <button phx-click="choose-ip-data" phx-value-ref={ip_address.id} class="underline"><%= ip_address.matches %></button>
                    </dd>
                  </div>
                <% end %>
              </dl>
            <% end %>
          </div>
        <% end %>
      </div>
    """
  end
end
