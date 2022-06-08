defmodule PuppiesWeb.BusinessReviews do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component
  alias Puppies.{Reviews, Review.Reply, Review.Dispute}

  def render(assigns) do
    ~H"""
    <div>
      <h2 id="timeline-title" class="text-xlg font-medium text-gray-900">Reviews</h2>
      <p class="text-gray-600 text-sm">of <%= @business.name %></p>
      <ul class="divide-y">
        <%= for review <- @business.reviews do %>
          <li class="py-4 flex">
            <%= PuppiesWeb.Avatar.show(%{business: review.business, user: review.user, square: "10", extra_classes: "text-2xl pt-0.5"}) %>
            <div class="ml-3">

              <div class="flex justify-between">
                <div>
                  <p class="font-medium text-gray-900"><%= review.user.first_name %> <%= review.user.last_name %></p>
                  <PuppiesWeb.Stars.rating rating={review.rating} />
                </div>
                <div class="flex space-x-2">
                  <%= if is_nil(review.reply) do %>
                    <.live_component module={PuppiesWeb.ReviewReply} id={"reply-#{review.id}"}  changeset={Reviews.change_review_reply(%Reply{}, %{review_id: review.id})} reply={nil}/>
                  <% else %>
                    <.live_component module={PuppiesWeb.ReviewReply} id={"edit-reply-#{review.reply.id}"} changeset={Reviews.change_review_reply(review.reply, %{})} reply={review.reply}/>
                  <% end %>
                  <%= if is_nil(review.dispute) do %>
                    <.live_component module={PuppiesWeb.ReviewDispute} id={"dispute-reply-#{review.id}"} changeset={Reviews.change_review_dispute(%Dispute{}, %{review_id: review.id })}  offender_id={review.user.id} reporter_id={@user_id} reason={"Review left by #{review.user.first_name} #{review.user.last_name} is being disputed."}/>
                  <% end %>
                </div>
              </div>

              <div class="text-sm">
                <%=review.review %>
              </div>

              <%= unless is_nil(review.reply) do %>
                <div class="text-sm my-4">
                  Your reply: <%= review.reply.reply %>
                </div>
              <% end %>

              <%= unless is_nil(review.dispute) do %>
                <div class="inline-block bg-red-50 border-l-4 border-red-400 p-4 mt-2">
                  <div class="flex">
                    <div class="flex-shrink-0">
                      <!-- Heroicon name: solid/exclamation -->
                      <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                        <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
                      </svg>
                    </div>
                    <div class="ml-3">
                      <p class="text-sm text-red-700">
                        Review left by <%= review.user.first_name %> <%= review.user.last_name %> is being disputed and is under review.
                      </p>
                    </div>
                  </div>
                </div>
              <% end %>
            </div>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end
end
