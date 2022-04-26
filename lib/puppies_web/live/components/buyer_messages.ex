defmodule PuppiesWeb.BuyerMessages do
  use PuppiesWeb, :live_component

  def un_read_messages(messages, user_id) do
    Enum.reduce(messages, 0, fn m, num ->
      if m.sent_by != user_id do
        num + 1
      else
        num
      end
    end)
  end

  def render(assigns) do
    ~H"""
      <div class="bg-white px-4 py-5 shadow sm:rounded-lg sm:px-6">
        <h2 id="timeline-title" class="text-xlg font-medium text-gray-900 mb-2">Messages</h2>
        <div class="divide-y divide-gray-200">
          <%= for thread <- @thread_businesses do %>
            <div class="md:grid grid-cols-6 gap-2 py-4">
              <div class="flex col-span-2">
                <div>
                  <div class="text-gray-600">Contact:</div>
                  <div class="flex items-center space-x-2">
                    <%= PuppiesWeb.Avatar.show(%{business: thread.business, user: thread.business.user, square: 16 , extra_classes: "text-2xl"}) %>
                    <div>
                      <div>
                        <%= thread.business.name %>
                      </div>
                      <%= live_redirect "Profile", to: Routes.live_path(@socket, PuppiesWeb.BusinessPageLive, Puppies.Utilities.string_to_slug(thread.business.name)), class: "underline cursor-pointer text-xs text-gray-500"%>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-span-3">
                <div class="text-gray-600">Regarding:</div>
                <div class="flex flex-wrap items-center">
                  <%= for listing_thread <- @thread_listings do %>
                    <%= if listing_thread.business_id == thread.business.id do %>
                      <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.MessagesLive, listing_id: listing_thread.listing.id, thread: listing_thread.uuid), class: "cursor-pointer" do %>
                        <div class="flex items-center space-x-2 m-2">
                          <%= PuppiesWeb.PuppyAvatar.show(%{listing: listing_thread.listing, square: 10, extra_classes: "text8_5xl"}) %>
                          <div>
                            <div class="underline"><%= listing_thread.listing.name %></div>
                            <div class="text-xs text-gray-500">Unread: <%= un_read_messages(listing_thread.messages, @user.id) %></div>
                          </div>
                        </div>
                      <% end %>
                    <% end %>
                  <% end %>
                </div>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    """
  end
end
