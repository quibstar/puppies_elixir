defmodule Puppies.Admin.NotesComponent do
  @moduledoc """
  Profile component
  """
  use PuppiesWeb, :live_component
  alias PuppiesWeb.{UI.Modal}
  alias Puppies.Admin.Notes

  def handle_event("delete-note", %{"id" => id}, socket) do
    note = Notes.get_note!(id)
    {:ok, _} = Notes.delete_note(note)
    notes = Notes.user_notes(socket.assigns.user.id)
    {:noreply, assign(socket, :notes, notes)}
  end

  def handle_event("edit-note", %{"id" => note_id}, socket) do
    {:noreply,
     socket
     |> assign(:note, Notes.get_note!(note_id))}
  end

  def render(assigns) do
    ~H"""
    <div x-data="{ show_modal: false}">
    <Modal.modal>
      <:modal_title>
        Note
      </:modal_title>
      <:modal_body>
        <.live_component module={PuppiesWeb.NoteFormComponent} id="note_form" note={@note} user={@user} admin={@admin} return_to={Routes.live_path(@socket, PuppiesWeb.Admin.User, @user.id) }/>
      </:modal_body>
    </Modal.modal>


      <div class="text-gray-500 grid justify-items-end">
        <button class="flex hover:text-primary-500" x-on:click="show_modal = !show_modal">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 inline-block" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
          </svg>
          Note
        </button>
      </div>
      <%= if @notes == [] do %>
          <%= live_component(PuppiesWeb.Admin.Empty, id: "no-notes", title: "No Notes", message: "") %>
      <% else %>
        <div class="divide-y">
          <%= for note <- @notes do %>
            <div class="my-2 py-2">
                <div class="flex">
                    <div class="flex-grow">
                        <%= note.note %>
                    </div>
                    <div>
                      <div phx-target={@myself} phx-click="edit-note" phx-value-id={note.id} class="inline-block" x-on:click.debounce="show_modal = !show_modal">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                        </svg>
                      </div>

                      <div phx-target={@myself} phx-click="delete-note" phx-value-id={note.id} class="inline-block">
                          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                          </svg>
                      </div>
                    </div>
                </div>
                <div class="flex">
                    <div class="text-xs text-gray-500">Created By: <%= note.created_by %> <%= Puppies.Utilities.format_short_date_time(note.inserted_at) %></div>
                </div>
            </div>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end
end
