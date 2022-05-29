defmodule PuppiesWeb.Admin.BlackListIpAddress do
  @moduledoc """
  IPAddress component modal
  """
  use PuppiesWeb, :live_component
  alias Puppies.{Blacklists, Blacklists.IPAddress}

  def update(assigns, socket) do
    changeset = Blacklists.change_ip_address_blacklist(%IPAddress{})

    data =
      Blacklists.get_blacklisted_items(Blacklists.IPAddress, %{
        limit: assigns.limit,
        page: assigns.page,
        number_of_links: 7
      })

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:pagination, Map.get(data, :pagination, %{count: 0}))
     |> assign(:ip_addresses, data.blacklisted_items)}
  end

  def handle_event("validate", %{"ip_address" => params}, socket) do
    changeset = Blacklists.change_ip_address_blacklist(%IPAddress{}, params)

    {:noreply,
     assign(socket,
       changeset: changeset
     )}
  end

  def handle_event("save_ip_address_blacklist", %{"ip_address" => params}, socket) do
    case Blacklists.create_ip_address_blacklist(params) do
      {:ok, ip_address_blacklist} ->
        socket = blacklisted_items_with_pagination(socket)

        Puppies.BackgroundJobCoordinator.admin_added_new_content(
          ip_address_blacklist.ip_address,
          "ip_address"
        )

        {:noreply,
         socket
         |> assign(:changeset, Blacklists.change_ip_address_blacklist(%IPAddress{}))
         |> put_flash(:info, "Ip address added")
         |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("delete", %{"ip_address_id" => id}, socket) do
    ip_address =
      Enum.find(socket.assigns.ip_addresses, fn ip_address ->
        ip_address.id == String.to_integer(id)
      end)

    case Blacklists.delete_ip_address_blacklist(ip_address) do
      {:ok, ip_address_blacklist} ->
        socket = blacklisted_items_with_pagination(socket)

        {:noreply,
         socket
         |> put_flash(:info, "Ip address was removed")
         |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> put_flash(:error, "Ip address was not removed")
         |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}
    end
  end

  def blacklisted_items_with_pagination(socket) do
    data =
      Blacklists.get_blacklisted_items(Blacklists.IPAddress, %{
        limit: socket.assigns.limit,
        page: socket.assigns.page,
        number_of_links: 7
      })

    socket
    |> assign(:pagination, data.pagination)
    |> assign(:ip_addresses, data.blacklisted_items)
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="md:flex gap-4">
        <div class="md:w-80">
          <.form let={form} for={@changeset}  phx_target={@myself} phx_change="validate" phx_submit="save_ip_address_blacklist">
            <div class="my-2">
              <%= label form, :ip_address, class: "block text-sm font-medium text-gray-700" %>
              <div class="mt-1">
                <%= text_input form, :ip_address,  class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"  %>
                <%= error_tag form, :ip_address %>
              </div>
              <div class="text-xs text-gray-500 my-2">Example: 192.168.1.1</div>
            </div>
            <%= hidden_input form, :admin_id, value: @admin.id %>
            <%= submit "Submit", phx_disable_with: "Saving...",  disabled: !@changeset.valid?,  class: "w-full px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
          </.form>
        </div>
        <p class="text-sm text-gray-600 mt-8 w-80">
          When a user signs up/in there IP will be checked. If their IP is in the list below they will be automatically suspended.
        </p>
      </div>
      <div class="mt-8 flex flex-col">
        <div class="-my-2 -mx-4 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div class="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
            <div class="overflow-hidden shadow ring-1 ring-black ring-opacity-5 md:rounded-lg">
              <table class="min-w-full divide-y divide-gray-300">
                <thead class="bg-gray-50">
                  <tr>
                    <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6">IP Address</th>
                    <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-6">
                      <span class="sr-only">Delete</span>
                    </th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200 bg-white">
                  <%= for ip_address <- @ip_addresses do %>
                    <tr>
                        <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:pl-6"><%= ip_address.ip_address %></td>
                        <td class="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6">
                          <a href="#" class="text-red-600 hover:text-red-900" phx-target={@myself} phx-click="delete" phx-value-ip_address_id={ip_address.id}>Delete</a>
                        </td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
      <%= if @pagination.count > 12 do %>
        <%= live_component PuppiesWeb.PaginationComponent, id: "pagination-ip", pagination: @pagination, socket: @socket, params: %{"page" => @pagination.page, "limit" => @pagination.limit, "tab" => "ip-address"}, end_point: PuppiesWeb.Admin.BlackLists, segment_id: nil %>
      <% end %>
    </div>
    """
  end
end
