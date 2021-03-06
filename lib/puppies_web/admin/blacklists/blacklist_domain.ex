defmodule PuppiesWeb.Admin.BlackListDomain do
  @moduledoc """
  Domain component modal
  """
  use PuppiesWeb, :live_component
  alias Puppies.{Blacklists, Blacklists.Domain}

  def update(assigns, socket) do
    changeset = Blacklists.change_domain_blacklist(%Domain{}, %{})

    data =
      Blacklists.get_blacklisted_items(Blacklists.Domain, %{
        limit: assigns.limit,
        page: assigns.page,
        number_of_links: 7
      })

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:pagination, Map.get(data, :pagination, %{count: 0}))
     |> assign(:domains, data.blacklisted_items)}
  end

  def handle_event("validate", %{"domain" => params}, socket) do
    changeset = Blacklists.change_domain_blacklist(%Domain{}, params)

    {:noreply,
     assign(socket,
       changeset: changeset
     )}
  end

  def handle_event("save_domain_blacklist", %{"domain" => params}, socket) do
    case Blacklists.create_domain_blacklist(params) do
      {:ok, domain_blacklist} ->
        socket = blacklisted_items_with_pagination(socket)

        Puppies.BackgroundJobCoordinator.admin_added_new_content(
          domain_blacklist.domain,
          "domain"
        )

        {:noreply,
         socket
         |> assign(:changeset, Blacklists.change_domain_blacklist(%Domain{}))
         |> put_flash(:info, "Domain added")
         |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("delete", %{"domain_id" => id}, socket) do
    domain =
      Enum.find(socket.assigns.domains, fn domain ->
        domain.id == String.to_integer(id)
      end)

    case Blacklists.delete_domain_blacklist(domain) do
      {:ok, _domain_blacklist} ->
        socket = blacklisted_items_with_pagination(socket)

        {:noreply,
         socket
         |> put_flash(:info, "Email was removed")
         |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> put_flash(:error, "Email was not removed")
         |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}
    end
  end

  def blacklisted_items_with_pagination(socket) do
    data =
      Blacklists.get_blacklisted_items(Blacklists.Domain, %{
        limit: socket.assigns.limit,
        page: socket.assigns.page,
        number_of_links: 7
      })

    socket
    |> assign(:pagination, data.pagination)
    |> assign(:domains, data.blacklisted_items)
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="md:flex gap-4">
        <div class="md:w-80">
          <.form let={form} for={@changeset}  phx_target={@myself} phx_change="validate" phx_submit="save_domain_blacklist">
            <div class="my-2">
              <%= label form, :domain, class: "block text-sm font-medium text-gray-700" %>
              <div class="mt-1">
                <%= text_input form, :domain,  class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"  %>
                <%= error_tag form, :domain %>
                <div class="text-xs text-gray-500 my-2">Example: aol.com</div>
              </div>

            </div>
            <%= hidden_input form, :admin_id, value: @admin.id %>
            <%= submit "Submit", phx_disable_with: "Saving...",  disabled: !@changeset.valid?,  class: "w-full px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
          </.form>
        </div>
        <p class="text-sm text-gray-600 mt-8 w-80">
          When a user signs up/in there email will be checked. If email is in the list below they will be automatically suspended.
        </p>
      </div>
      <div class="mt-8 flex flex-col">
        <div class="-my-2 -mx-4 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div class="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
            <div class="overflow-hidden shadow ring-1 ring-black ring-opacity-5 md:rounded-lg">
              <table class="min-w-full divide-y divide-gray-300">
                <thead class="bg-gray-50">
                  <tr>
                    <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6">Domain</th>
                    <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-6">
                      <span class="sr-only">Delete</span>
                    </th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200 bg-white">
                  <%= for domain <- @domains do %>
                    <tr>
                        <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:pl-6"><%= domain.domain %></td>
                        <td class="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6">
                          <a href="#" class="text-red-600 hover:text-red-900" phx-target={@myself} phx-click="delete" phx-value-domain_id={domain.id}>Delete</a>
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
        <%= live_component PuppiesWeb.PaginationComponent, id: "pagination-domain", pagination: @pagination, socket: @socket, params: %{"page" => @pagination.page, "limit" => @pagination.limit, "tab" => "domain"}, end_point: PuppiesWeb.Admin.BlackLists, segment_id: nil %>
      <% end %>
    </div>
    """
  end
end
