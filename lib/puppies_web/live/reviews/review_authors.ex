defmodule PuppiesWeb.ReviewAuthors do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component
  alias PuppiesWeb.{UI.Modal}
  alias Puppies.Reviews

  def handle_event("edit-review", %{"id" => id}, socket) do
    {:noreply,
     socket
     |> assign(:review, Reviews.get_review!(id))}
  end

  def render(assigns) do
    ~H"""
      <div x-data="{ show_modal: false}">
        <Modal.modal>
          <:modal_title>
            Edit Review
          </:modal_title>
          <:modal_body>
            <.live_component module={PuppiesWeb.ReviewForm} id="rev_form" review={@review}/>
          </:modal_body>
        </Modal.modal>

        <h2 id="timeline-title" class="text-xlg font-medium text-gray-900">Reviews</h2>
        <p class="text-gray-600 text-sm">Authored by you</p>

        <ul class="divide-y">
          <%= for review <- @reviews do %>
            <li class="py-4 flex">
              <%= PuppiesWeb.Avatar.show(%{business: review.business, user: review.business.user, square: "10", extra_classes: "text-4xl pt-0.5"}) %>
              <div class="ml-3">
                <div class="flex justify-between">
                  <p class="text-sm font-medium text-gray-900 underline">
                    <%= live_patch review.business.name, to: Routes.live_path(@socket, PuppiesWeb.BusinessPageLive, review.business.slug) %>
                  </p>
                    <button phx-target={@myself} phx-click="edit-review" phx-value-id={review.id} class="underline text-primary-500 hover:text-primary-700" x-on:click="show_modal = !show_modal">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                  </button>
                </div>
                <p class="text-sm font-medium text-gray-900">
                  <PuppiesWeb.Stars.rating rating={review.rating} />
                </p>
                <p class="text-sm">
                  <%=review.review %>
                </p>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    """
  end
end
