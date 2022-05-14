defmodule PuppiesWeb.NoteFormComponent do
  @moduledoc """
  Profile component
  """
  use PuppiesWeb, :live_component

  alias Puppies.Admin.{Notes}
  alias Puppies.User.Note

  def update(%{note: note} = assigns, socket) do
    changeset =
      if is_nil(note) do
        %Note{}
      else
        note
      end

    changeset = Notes.change_note(changeset)

    action =
      if is_nil(note) do
        :new
      else
        :edit
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:action, action)
     |> assign(:note, note)}
  end

  def handle_event("validate", %{"note" => note_params}, socket) do
    changeset =
      Notes.change_note(%Note{}, note_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"note" => note_params}, socket) do
    save_note(socket, socket.assigns.action, note_params)
  end

  defp save_note(socket, :edit, note_params) do
    case Notes.update(socket.assigns.note, note_params) do
      {:ok, _note} ->
        {:noreply,
         socket
         |> put_flash(:info, "Note updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_note(socket, :new, note_params) do
    case Notes.create(note_params) do
      {:ok, _note} ->
        {:noreply,
         socket
         |> put_flash(:info, "Note created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def render(assigns) do
    ~H"""
      <div>
        <.form let={f} for={@changeset} id="note-form" phx_target={@myself} phx_change="validate" phx_submit="save" %>
          <div>
            <div>
              <%= unless is_nil(@note) do %>
                <%= hidden_input f, :id, value: @note.id %>
              <% end %>
              <%= hidden_input f, :user_id, value: @user.id %>
              <%= hidden_input f, :created_by, value: "#{@admin.first_name} #{@admin.last_name}" %>
            </div>
            <div>
              <%= textarea f, :note, class: "p-2 shadow-sm focus:ring-primary-500 focus:border-primary-500 mt-1 block w-full sm:text-sm border border-gray-300 rounded-md", rows: 5 %>
              <%= error_tag f, :note %>
            </div>
          </div>
          <div class="sm:flex sm:flex-row-reverse mt-4">
            <%= submit "Save", phx_disable_with: "Saving...", disabled: !@changeset.valid?, class: "inline-block px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
          </div>
        </.form>
      </div>
    """
  end
end
