defmodule PuppiesWeb.Admin.BlackListContent do
  @moduledoc """
  ContentBlacklist component modal
  """
  use PuppiesWeb, :live_component
  alias Puppies.{Blacklists, Blacklists.ContentBlacklist}

  def update(assigns, socket) do
    changeset = ContentBlacklist.changeset(%ContentBlacklist{}, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:contents, Blacklists.list_content_blacklists())}
  end

  def handle_event("validate", %{"content_blacklist" => params}, socket) do
    changeset = ContentBlacklist.changeset(%ContentBlacklist{}, params)

    {:noreply,
     assign(socket,
       changeset: changeset
     )}
  end

  def handle_event("save_content_blacklist", %{"content_blacklist" => params}, socket) do
    exists = Blacklists.check_for_content(params)

    if exists do
      {:noreply,
       socket
       |> put_flash(:error, "Content already blacklisted")
       |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}
    else
      case Blacklists.create_content_blacklist(params) do
        {:ok, _content_blacklist} ->
          {:noreply,
           socket
           |> assign(:contents, Blacklists.list_content_blacklists())
           |> put_flash(:info, "Content added")
           |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply,
           socket
           |> assign(:changeset, changeset)
           |> put_flash(:error, "Content was not added")
           |> push_patch(to: Routes.live_path(socket, PuppiesWeb.Admin.BlackLists))}
      end
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="w-80">
        <.form let={form} for={@changeset}  phx_target={@myself} phx_change="validate" phx_submit="save_content_blacklist">
          <div class="my-2">
            <%= label form, :content, class: "block text-sm font-medium text-gray-700" %>
            <div class="mt-1">
              <%= text_input form, :content,  class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"  %>
            </div>
          </div>
          <%= hidden_input form, :admin_id, value: @admin.id %>
          <%= submit "Submit", phx_disable_with: "Saving...",  disabled: !@changeset.valid?,  class: "w-full px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
        </.form>
      </div>
      <%= for content <- @contents do %>
        <div>
          <%= content.content %>
        </div>
      <% end %>
    </div>
    """
  end
end
