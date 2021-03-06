defmodule Puppies.Admin.History do
  @moduledoc """
  Admin history component
  """
  use PuppiesWeb, :live_component

  def render_class(history_user_id, user_id) do
    if history_user_id == user_id do
      "hover:text-gray-700 border-primary-500 text-primary-600"
    else
      "text-gray-500 hover:text-gray-700"
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    user_id = socket.assigns.user_id
    id = String.to_integer(id)
    vh = socket.assigns.admin_view_history
    delete_record(vh, id)

    if id == user_id do
      new_first_element = Enum.at(vh, 1)

      {:noreply,
       socket
       |> assign(user_id: new_first_element.user_id)
       |> push_patch(
         to: Routes.live_path(socket, PuppiesWeb.Admin.User, new_first_element.user_id)
       )}
    else
      admin_view_history =
        Enum.filter(socket.assigns.admin_view_history, fn item ->
          item.user.id != id
        end)

      {:noreply, assign(socket, admin_view_history: admin_view_history)}
    end
  end

  def delete_record(vh, id) do
    record =
      Enum.find(vh, fn item ->
        item.user.id == id
      end)

    Puppies.Admin.ViewHistories.delete(record)
  end

  def render(assigns) do
    ~H"""
      <div>
        <%= unless @admin_view_history == [] do %>
          <div>
            <nav class="-mb-px flex flex-wrap overflow-scroll" aria-label="Tabs">
              <%= for view_history <- @admin_view_history  do %>
                <div class={"border rounded-2xl mr-2 mb-2 p-1 space-x-2 flex items-center hover:border-gray-300 whitespace-nowrap text-xs #{render_class(view_history.user_id, @user_id)}"}>
                  <%= PuppiesWeb.Avatar.show(%{business: view_history.user.business, user: view_history.user, square: 6, extra_classes: ""}) %>
                    <div  class="block w-24 overflow-hidden text-ellipsis">
                      <%= live_patch to: Routes.live_path(@socket, PuppiesWeb.Admin.User, view_history.user_id, %{tab: @tab, sub_tab: @sub_tab}) do %>
                        <%= view_history.user.first_name %> <%= view_history.user.last_name %>
                      <% end %>
                    </div>
                  <%= if length(@admin_view_history) > 1 do %>
                    <svg phx-click="delete" phx-value-id={view_history.user_id} phx-target={@myself} xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 cursor-pointer hover:stroke-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                  <% end %>
                </div>
              <% end %>
            </nav>
          </div>
        <% end %>
      </div>
    """
  end
end
