defmodule PuppiesWeb.ReviewReply do
  @moduledoc """
  Reviews and authored reviews
  """
  use PuppiesWeb, :live_component

  alias PuppiesWeb.{UI.Modal}
  alias Puppies.{Reviews, Review.Reply}

  def handle_event("validate", %{"reply" => reply}, socket) do
    changeset = Reviews.change_review_reply(%Reply{}, reply)
    {:noreply, socket |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"reply" => reply}, socket) do
    res =
      if is_nil(reply["id"]) do
        Reviews.create_reply(reply)
      else
        Reviews.update_reply(socket.assigns.reply, reply)
      end

    case res do
      {:ok, _} ->
        {:noreply,
         socket
         |> push_redirect(to: Routes.live_path(socket, PuppiesWeb.Reviews))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def render(assigns) do
    ~H"""
    <div  x-data="{ show_modal: false}" >
      <Modal.modal>
        <:modal_title>
          Reply to review
        </:modal_title>
        <:modal_body>
          <.form let={f} for={@changeset} id="review-dispute-form" phx-submit="save" phx_change="validate" phx-target={@myself}>
            <%= hidden_input f, :id %>
            <%= hidden_input f, :review_id %>
            <div class="mt-4 col-span-2">
              <%= textarea f, :reply, rows: 12, class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
            </div>
            <div class="py-5">
              <div class="flex flex-col">
                <%= submit "Submit", phx_disable_with: "Saving...",  disabled: !@changeset.valid?,  class: "inline-block px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
              </div>
            </div>
          </.form>
        </:modal_body>
      </Modal.modal>

      <%= if is_nil(@reply) do %>
        <svg x-on:click.debounce="show_modal = !show_modal" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 stroke-primary-500 hover:stroke-primary-700" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M3 10h10a8 8 0 018 8v2M3 10l6 6m-6-6l6-6" />
        </svg>
      <% else %>
       <svg x-on:click.debounce="show_modal = !show_modal" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 stroke-primary-500 hover:stroke-primary-700" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
        </svg>
      <% end %>
    </div>
    """
  end
end
