defmodule PuppiesWeb.Admin.BlackListPhone do
  @moduledoc """
  PhoneBlacklist component modal
  """
  use PuppiesWeb, :live_component
  alias Puppies.{Blacklists, Blacklists.PhoneBlacklist}

  def update(assigns, socket) do
    changeset = Blacklists.change_phone_blacklist(%PhoneBlacklist{}, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:phones, Blacklists.get_blacklisted_items(Blacklists.PhoneBlacklist))}
  end

  def handle_event("validate", %{"phone_blacklist" => params}, socket) do
    changeset = Blacklists.change_phone_blacklist(%PhoneBlacklist{}, params)
    IO.inspect(changeset)

    {:noreply,
     assign(socket,
       changeset: changeset
     )}
  end

  def handle_event("save_phone_blacklist", %{"phone_blacklist" => params}, socket) do
    %{"phone_number" => phone_number} = params

    exists =
      Blacklists.check_for_existence_of(Blacklists.PhoneBlacklist, :phone_number, phone_number)

    if exists do
      {:noreply,
       socket
       |> put_flash(:error, "Content already blacklisted")
       |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}
    else
      case Blacklists.create_phone_blacklist(params) do
        {:ok, _phone_blacklist} ->
          {:noreply,
           socket
           |> assign(
             :phones,
             Blacklists.get_blacklisted_items(Blacklists.PhoneBlacklist)
           )
           |> put_flash(:info, "Phone number added")
           |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply,
           socket
           |> assign(:changeset, changeset)
           |> put_flash(:error, "Phone number was not added")
           |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}
      end
    end
  end

  def handle_event("delete", %{"phone_id" => id}, socket) do
    phone =
      Enum.find(socket.assigns.phones, fn phone ->
        phone.id == String.to_integer(id)
      end)

    case Blacklists.delete_phone_blacklist(phone) do
      {:ok, _phone_blacklist} ->
        {:noreply,
         socket
         |> assign(:phones, Blacklists.get_blacklisted_items(Blacklists.PhoneBlacklist))
         |> put_flash(:info, "Phone number was removed")
         |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> put_flash(:error, "Phone number was not removed")
         |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="md:w-80">
        <.form let={form} for={@changeset} phx_target={@myself} phx_change="validate" phx_submit="save_phone_blacklist">
          <div class="my-2">
            <%= label form, :phone_number, class: "block text-sm font-medium text-gray-700" %>
            <div class="mt-1">
              <%= telephone_input form, :phone_number, phx_hook: "PhoneNumber", class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"  %>
            </div>
            <div class="text-xs text-gray-500 my-2">Example: 6164015666</div>
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
                    <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6">Phone Number</th>
                    <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-6">
                      <span class="sr-only">Delete</span>
                    </th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200 bg-white">
                  <%= for phone <- @phones do %>
                    <tr>
                        <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:pl-6"><%= phone.phone_number %></td>
                        <td class="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6">
                          <a href="#" class="text-red-600 hover:text-red-900" phx-target={@myself} phx-click="delete" phx-value-phone_id={phone.id}>Delete</a>
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
