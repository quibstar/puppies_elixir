defmodule PuppiesWeb.Reviews do
  @moduledoc """
  Reviews and authored reviews
  """
  use PuppiesWeb, :live_view

  alias Puppies.{Accounts, Reviews}

  def mount(_params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(session, socket) do
    user =
      if connected?(socket) && Map.has_key?(session, "user_token") do
        %{"user_token" => user_token} = session
        Accounts.get_user_by_session_token(user_token)
      end

    # TODO: BELOW IS WRONG, MUST GET BUSINESS ID?
    business = Reviews.business_reviews(user.id)
    reviews = Reviews.get_reviews_by_user_id(user.id)

    {:ok, assign(socket, business: business, user: user, reviews: reviews, loading: false)}
  end

  def render(assigns) do
    ~H"""
    <div class="mt-4 mx-auto px-4 sm:px-6 lg:max-w-7xl lg:px-8"  x-data="{ show_modal: false}" >
      <%= unless @loading do %>
        <div class="grid grid-cols-2 gap-8 mt-4">
          <.live_component module={PuppiesWeb.BusinessReviews} id="business-review" business={@business} />
          <.live_component module={PuppiesWeb.ReviewAuthors} id="reviews" reviews={@reviews} review={nil} />
        </div>
      <% end %>
    </div>
    """
  end
end
