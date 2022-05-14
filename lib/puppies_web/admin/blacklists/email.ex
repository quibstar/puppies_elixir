defmodule PuppiesWeb.Admin.BlackListEmail do
  @moduledoc """
  EmailBlacklist component modal
  """
  use PuppiesWeb, :live_component
  alias Puppies.{Blacklists, Blacklists.EmailBlacklist}

  def update(assigns, socket) do
    changeset = Blacklists.change_email_blacklist(%EmailBlacklist{}, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:emails, Blacklists.get_blacklisted_items(Blacklists.EmailBlacklist))}
  end

  def handle_event("validate", %{"email_blacklist" => params}, socket) do
    changeset = Blacklists.change_email_blacklist(%EmailBlacklist{}, params)

    {:noreply,
     assign(socket,
       changeset: changeset
     )}
  end

  def handle_event("save_email_blacklist", %{"email_blacklist" => params}, socket) do
    %{"domain" => domain} = params
    exists = Blacklists.check_for_existence_of(Blacklists.EmailBlacklist, :domain, domain)

    if exists do
      {:noreply,
       socket
       |> put_flash(:error, "Domain already blacklisted")
       |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}
    else
      case Blacklists.create_email_blacklist(params) do
        {:ok, _email_blacklist} ->
          {:noreply,
           socket
           |> assign(:emails, Blacklists.get_blacklisted_items(Blacklists.EmailBlacklist))
           |> put_flash(:info, "Domain added")
           |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply,
           socket
           |> assign(:changeset, changeset)
           |> put_flash(:error, "Email was not added")
           |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}
      end
    end
  end

  def handle_event("delete", %{"email_id" => id}, socket) do
    email =
      Enum.find(socket.assigns.emails, fn email ->
        email.id == String.to_integer(id)
      end)

    case Blacklists.delete_email_blacklist(email) do
      {:ok, _email_blacklist} ->
        {:noreply,
         socket
         |> assign(:emails, Blacklists.get_blacklisted_items(Blacklists.EmailBlacklist))
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

  def render(assigns) do
    ~H"""
    <div>
      <div class="md:w-80">
        <.form let={form} for={@changeset}  phx_target={@myself} phx_change="validate" phx_submit="save_email_blacklist">
          <div class="my-2">
            <%= label form, :domain, class: "block text-sm font-medium text-gray-700" %>
            <div class="mt-1">
              <%= text_input form, :domain,  class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"  %>
              <div class="text-xs text-gray-500 my-2">Example: aol.com</div>
            </div>
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
                    <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6">Email</th>
                    <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-6">
                      <span class="sr-only">Delete</span>
                    </th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200 bg-white">
                  <%= for email <- @emails do %>
                    <tr>
                        <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:pl-6"><%= email.domain %></td>
                        <td class="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6">
                          <a href="#" class="text-red-600 hover:text-red-900" phx-target={@myself} phx-click="delete" phx-value-email_id={email.id}>Delete</a>
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
