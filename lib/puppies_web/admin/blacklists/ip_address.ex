defmodule PuppiesWeb.Admin.BlackListIpAddress do
  @moduledoc """
  IPAddressBlacklist component modal
  """
  use PuppiesWeb, :live_component
  alias Puppies.{Blacklists, Blacklists.IPAddressBlacklist}

  def update(assigns, socket) do
    changeset = Blacklists.change_ip_address_blacklist(%IPAddressBlacklist{}, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:ip_addresses, Blacklists.get_blacklisted_items(Blacklists.IPAddressBlacklist))}
  end

  def handle_event("validate", %{"ip_address_blacklist" => params}, socket) do
    changeset = Blacklists.change_ip_address_blacklist(%IPAddressBlacklist{}, params)

    {:noreply,
     assign(socket,
       changeset: changeset
     )}
  end

  def handle_event("save_ip_address_blacklist", %{"ip_address_blacklist" => params}, socket) do
    %{"ip_address" => ip_address} = params

    exists =
      Blacklists.check_for_existence_of(Blacklists.IPAddressBlacklist, :ip_address, ip_address)

    if exists do
      {:noreply,
       socket
       |> put_flash(:error, "Content already blacklisted")
       |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}
    else
      case Blacklists.create_ip_address_blacklist(params) do
        {:ok, _ip_address_blacklist} ->
          {:noreply,
           socket
           |> assign(
             :ip_addresses,
             Blacklists.get_blacklisted_items(Blacklists.IPAddressBlacklist)
           )
           |> put_flash(:info, "Ip address added")
           |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply,
           socket
           |> assign(:changeset, changeset)
           |> put_flash(:error, "Ip address was not added")
           |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}
      end
    end
  end

  def handle_event("delete", %{"ip_address_id" => id}, socket) do
    ip_address =
      Enum.find(socket.assigns.ip_addresses, fn ip_address ->
        ip_address.id == String.to_integer(id)
      end)

    case Blacklists.delete_ip_address_blacklist(ip_address) do
      {:ok, _ip_address_blacklist} ->
        {:noreply,
         socket
         |> assign(:ip_addresses, Blacklists.get_blacklisted_items(Blacklists.IPAddressBlacklist))
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

  def render(assigns) do
    ~H"""
    <div>
      <div class="md:w-80">
        <.form let={form} for={@changeset}  phx_target={@myself} phx_change="validate" phx_submit="save_ip_address_blacklist">
          <div class="my-2">
            <%= label form, :ip_address, class: "block text-sm font-medium text-gray-700" %>
            <div class="mt-1">
              <%= text_input form, :ip_address,  class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"  %>
            </div>
            <div class="text-xs text-gray-500 my-2">Example: 192.168.1.1.</div>
          </div>
          <%= hidden_input form, :admin_id, value: @admin.id %>
          <%= submit "Submit", phx_disable_with: "Saving...",  disabled: !@changeset.valid?,  class: "w-full px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
        </.form>
      </div>
      <div class="mt-8 flex flex-col">
        <div class="-my-2 -mx-4 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div class="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
            <div class="overflow-hidden shadow ring-1 ring-black ring-opacity-5 md:rounded-lg">
              <table class="min-w-full divide-y divide-gray-300">
                <thead class="bg-gray-50">
                  <tr>
                    <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6">Content</th>
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
    </div>
    """
  end
end
