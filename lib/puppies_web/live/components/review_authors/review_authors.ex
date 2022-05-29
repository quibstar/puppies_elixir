defmodule PuppiesWeb.ReviewAuthors do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component
  alias PuppiesWeb.{UI.Modal}
  alias Puppies.Reviews

  def handle_event("edit-review", %{"id" => note_id}, socket) do
    {:noreply,
     socket
     |> assign(:review, Reviews.get_review!(note_id))}
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
        <div class="bg-white px-4 py-5 shadow sm:rounded-lg sm:px-6">
          <h2 id="timeline-title" class="text-xlg font-medium text-gray-900">Reviews</h2>
          <p class="text-gray-600 text-sm">Authored by you</p>
          <ul>
            <%= for review <- @reviews do %>
              <li class="py-4 flex">
                <%= PuppiesWeb.Avatar.show(%{business: review.business, user: review.business.user, square: "10", extra_classes: "text-4xl pt-0.5"}) %>
                <div class="ml-3">
                  <p class="text-sm font-medium text-gray-900 underline">
                    <%= live_patch review.business.name, to: Routes.live_path(@socket, PuppiesWeb.BusinessPageLive, review.business.slug) %>
                  </p>
                  <p class="text-sm font-medium text-gray-900">
                    Rating: <%=review.rating %>
                    <button phx-target={@myself} phx-click="edit-review" phx-value-id={review.id} class="underline text-gray-600" x-on:click="show_modal = !show_modal">
                      Edit
                    </button>
                  </p>
                </div>
              </li>
            <% end %>
          </ul>
        </div>
      </div>
    """
  end
end
