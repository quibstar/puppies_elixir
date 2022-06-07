defmodule PuppiesWeb.ReviewForm do
  use PuppiesWeb, :live_component

  alias Puppies.{Reviews, Reviews.Review}

  def update(assigns, socket) do
    changeset =
      if is_nil(assigns.review) do
        Reviews.change_review(%Review{})
      else
        Reviews.change_review(assigns.review)
      end

    {:ok,
     assign(socket,
       changeset: changeset
     )}
  end

  def handle_event("validate", %{"review" => review}, socket) do
    current_review = Reviews.get_review!(review["id"])
    changeset = Reviews.change_review(current_review, review)

    {:noreply,
     assign(socket,
       changeset: changeset
     )}
  end

  def handle_event("save", %{"review" => params}, socket) do
    review = Reviews.get_review!(params["id"])

    case Reviews.update_review(review, params) do
      {:ok, new_review} ->
        Puppies.BackgroundJobCoordinator.record_updated_review_activity(
          review.user_id,
          review,
          new_review
        )

        Puppies.BackgroundJobCoordinator.check_for_blacklisted_content(
          review.user_id,
          review.review,
          "review content"
        )

        {
          :noreply,
          socket
          |> put_flash(:info, "Review updated")
          |> push_redirect(to: Routes.live_path(socket, PuppiesWeb.Reviews))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def render(assigns) do
    ~H"""
      <div>
        <.form let={f} for={@changeset} id="review-form" phx-submit="save" phx_change="validate" phx-target={@myself}>
            <%= hidden_input f, :id %>
            <div class="mt-4">
              <%= label f, :rating, class: "inline-block text-sm font-medium text-gray-700" %>
              <%= select f, :rating, [1, 2, 3, 4, 5], class: "block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm rounded-md" %>
            </div>

            <div class="mt-4 col-span-2">
              <%= label f, :review, class: "inline-block text-sm font-medium text-gray-700" %> <small class="text-xs text-red-500">*</small>
              <%= textarea f, :review, rows: 12, class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
              <%= error_tag f, :review %>
            </div>
            <div class="py-5">
              <div class="flex flex-col">
                <%= submit "Submit", phx_disable_with: "Saving...",  disabled: !@changeset.valid?,  class: "inline-block px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
              </div>
            </div>
        </.form>
      </div>
    """
  end
end
