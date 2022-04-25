defmodule PuppiesWeb.FlagComponent do
  @moduledoc """
  Flag component modal
  """
  use PuppiesWeb, :live_component
  alias Puppies.Flag
  alias Puppies.Flags

  def update(assigns, socket) do
    changeset = Flag.changeset(%Flag{}, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  def handle_event("validate", %{"flag" => params}, socket) do
    changeset = Flag.changeset(%Flag{}, params)

    {:noreply,
     assign(socket,
       changeset: changeset
     )}
  end

  def handle_event("flag_profile", %{"flag" => flag_params}, socket) do
    exists = Flags.check_for_flag(flag_params)

    if exists do
      {:noreply,
       socket
       |> put_flash(:error, "You've already reported this person for #{flag_params["reason"]}")
       |> push_redirect(to: socket.assigns.return_to)}
    else
      case Flags.create(flag_params) do
        {:ok, _flag} ->
          {:noreply,
           socket
           |> put_flash(:info, "Profile has been reported")
           |> push_redirect(to: socket.assigns.return_to)}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
      end
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <.form let={form} for={@changeset}  phx_target={@myself} phx_change="validate" phx_submit="flag_profile">
        <%= PuppiesWeb.Avatar.show(%{business: @business, user: @business.user, square: 44, extra_classes: "text8_5xl"}) %>
          <div class='my-4'>
              Please let us know why your are reporting <%= @business.name %>
              <label class="block"><%= radio_button form, :reason, "Inappropriate content" %> Inappropriate content</label>
              <label class="block"><%= radio_button form, :reason, "Violence"%> Violence</label>
              <label class="block"><%= radio_button form, :reason, "Harassment"%> Harassment</label>
              <label class="block"><%= radio_button form, :reason, "Spam" %> Spam</label>
              <label class="block"><%= radio_button form, :reason, "Hate Speech"%> Hate Speech</label>
              <%= hidden_input form, :offender_id, value: @business.user_id %>
              <%= hidden_input form, :reporter_id, value: @user.id %>
               <%= hidden_input form, :type, value: "reported_by_user" %>
          </div>

          <%= submit "Submit", phx_disable_with: "Saving...",  disabled: !@changeset.valid?,  class: "w-full px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
      </.form>
    </div>
    """
  end
end
