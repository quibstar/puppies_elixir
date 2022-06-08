defmodule PuppiesWeb.ReviewDispute do
  @moduledoc """
  Reviews and authored reviews
  """
  use PuppiesWeb, :live_component

  alias PuppiesWeb.{UI.Modal}
  alias Puppies.{Reviews, Review.Dispute}

  def handle_event("validate", %{"dispute" => dispute}, socket) do
    changeset = Reviews.change_review_dispute(%Dispute{}, dispute)
    {:noreply, socket |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"dispute" => dispute}, socket) do
    case Reviews.create_dispute(dispute) do
      {:ok, review} ->
        Reviews.update_review(review, %{approved: false})

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
          Dispute review
        </:modal_title>
        <:modal_body>
          <.form let={f} for={@changeset} id="review-dispute-form" phx-submit="save" phx_change="validate" phx-target={@myself}>
            <%= hidden_input f, :review_id %>
            <%= hidden_input f, :disputed, value: true %>
            <%= label f, "In a few word please state the reason for dispute", class: "inline-block text-sm text-gray-700" %>
            <div class="mt-4 col-span-2">
              <%= textarea f, :reason, rows: 12, class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
            </div>
            <div class="py-5">
              <div class="flex flex-col">
                <%= submit "Submit", phx_disable_with: "Saving...",  disabled: !@changeset.valid?,  class: "inline-block px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
              </div>
            </div>
          </.form>
        </:modal_body>
      </Modal.modal>

      <svg x-on:click.debounce="show_modal = !show_modal" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 stroke-primary-500 hover:stroke-primary-700" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round" d="M3 21v-4m0 0V5a2 2 0 012-2h6.5l1 1H21l-3 6 3 6h-8.5l-1-1H5a2 2 0 00-2 2zm9-13.5V9" />
      </svg>
    </div>
    """
  end
end
