defmodule PuppiesWeb.SellerMessageCenter do
  use PuppiesWeb, :live_component
  alias PuppiesWeb.MessageUtilities

  def render(assigns) do
    ~H"""
      <div class="flex">
        <div class="flex-none w-[300px]  border-r-[1px] bg-white">
          <%= if is_nil(@listing_threads) do %>
            <ul class="h-[calc(100vh-144px)] overflow-scroll">
              <%= for thread <- @threads do %>
                <li>
                  <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.MessagesLive, listing_id: thread.listing_id), class: "p-4 flex rounded-lg hover:shadow-md border hover:border-primary-500 m-2 space-x-4" do %>
                    <div class="relative">
                      <%= PuppiesWeb.PuppyAvatar.show(%{listing: thread.listing, square: 10, extra_classes: "text8_5xl"}) %>
                      <span id={"#{@user.id}-listing-#{thread.listing.id}"} class={"absolute top-6 left-6 hidden inline-flex items-center px-1.5 py-0.0 rounded-full text-xs font-medium bg-red-500 text-white"}>  <%= length(thread.messages) %> </span>
                    </div>
                    <div class="ml-3 flex-grow">
                      <p class="text-sm text-gray-900">
                        <%= thread.listing.name %>
                      </p>
                      <div data-time={thread.listing.inserted_at} class="text-xs text-gray-400 messages-date"></div>
                    </div>
                  <% end %>
                </li>
              <% end %>
            </ul>
          <% else %>
            <div>
              <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.MessagesLive), class: "block flex items-center" do %>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 m-2 stroke-primary-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
                </svg>
                <div class="text-sm text-primary-500 flex space-x-2 p-2 items-center">
                  <%= PuppiesWeb.PuppyAvatar.show(%{listing: @current_thread.listing, square: 10, extra_classes: "text8_5xl"}) %> <div><%= @current_thread.listing.name %></div>
                </div>
              <% end %>
              <ul>
                <%= for thread <- @listing_threads do %>
                  <li>
                    <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.MessagesLive, listing_id: thread.listing_id, thread: thread.uuid), class: "p-2 flex rounded-lg hover:shadow-md border hover:border-primary-500 m-2 space-x-4 #{MessageUtilities.current_thread_class(@current_thread.id, thread.id)}" do %>
                      <div class="flex-none relative">
                        <%= PuppiesWeb.Avatar.show(%{business: thread.receiver.business, user: thread.receiver, square: 10, extra_classes: "text-2xl"}) %>
                        <span id={"#{@user.id}-listing-#{thread.listing.id}"} class="absolute hidden top-6 left-6 inline-flex items-center px-1.5 py-0.0 rounded-full text-xs font-medium bg-red-500 text-white">  <%= MessageUtilities.unread_message_count(@user, thread.messages) %> </span>
                      </div>
                      <div class="flex-grow">
                        <p class="text-sm text-gray-900">
                          <%= MessageUtilities.business_or_user_name(thread.receiver) %>
                        </p>
                        <%= unless thread.messages == [] do %>
                          <p class="text-xs  text-gray-500 truncate w-28">
                            <%= MessageUtilities.last_message(thread.messages) %>
                          </p>
                        <% end %>
                      </div>
                      <%= unless thread.messages == [] do %>
                        <div data-time={MessageUtilities.last_message_date(thread.messages)} class="text-xs text-gray-400 mt-1 messages-date"></div>
                      <% end %>
                    <% end %>
                  </li>
                <% end %>
              </ul>
            </div>
          <% end %>
        </div>
        <div class="w-full">
          <ul class="h-[calc(100vh-295px)] overflow-scroll flex flex-col" id="chat-messages" phx-hook="chatMessages" phx-update="append">
            <%= if  @messages != [] do %>
              <%= for {message, index} <- Enum.with_index(@messages) do  %>

                <%= if MessageUtilities.check_date(@messages, index, message.inserted_at) do %>
                  <div id={"m-#{message.id}"} class="relative" phx-update="ignore">
                    <div class="absolute inset-0 flex items-center" aria-hidden="true">
                      <div class="w-full border-t border-gray-300"></div>
                    </div>
                    <div class="relative flex justify-center">
                      <span  data-time={message.inserted_at} class="messages-date px-2 bg-gray-50 text-sm text-gray-500"> </span>
                    </div>
                  </div>
                <% end %>

                <%= if message.sent_by != @user.id do %>
                  <li class="flex items-end my-2" id={"#{message.id}"}>
                    <%= PuppiesWeb.Avatar.show(%{business: @current_thread.receiver.business, user: @current_thread.receiver, square: 10, extra_classes: "text-2xl mx-4"}) %>
                    <div class="p-2 mb-4 shadow rounded-br-lg rounded-tr-lg rounded-tl-lg text-sm bg-white">
                      <%= message.message %>
                    </div>
                  </li>
                <% else %>
                  <li class="flex items-end flex-row-reverse my-2" id={"#{message.id}"}>
                      <%= PuppiesWeb.Avatar.show(%{business: @current_thread.sender.business, user: @current_thread.sender, square: 10, extra_classes: "text-2xl mx-4"}) %>
                    <div>
                      <div class="p-2 mb-4 shadow rounded-bl-lg rounded-tr-lg rounded-tl-lg text-sm bg-white">
                        <%= message.message %>
                        <!-- <div class="flex text-xs">
                          <div class="grow"></div>
                          <svg xmlns="http://www.w3.org/2000/svg" class={"inline-block h-4 w-4 #{is_read(message.read)}"} fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
                          </svg>
                        </div> -->
                      </div>
                    </div>
                  </li>
                <% end %>


              <% end %>
            <% end %>
          </ul>
          <.live_component module={PuppiesWeb.MessageForm} id="message-form" user={@user} current_thread={@current_thread} changeset={@changeset} />
        </div>
      </div>
    """
  end
end
