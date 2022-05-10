defmodule PuppiesWeb.SellerMessageCenter do
  use PuppiesWeb, :live_component
  alias PuppiesWeb.MessageUtilities

  def render(assigns) do
    ~H"""
      <div class="flex relative" id="chat-container">
        <div id='chat-list' class="flex-none w-[300px]  border-r-[1px] absolute top-0 bottom-0 bg-white z-10 -left-full md:left-auto md:relative">
          <%= if is_nil(@listing_threads) do %>
            <ul class="h-[calc(100vh-144px)] overflow-scroll">
              <%= for thread <- @threads do %>
                <li>
                  <%= live_patch to: Routes.live_path(@socket, PuppiesWeb.MessagesLive, listing_id: thread.listing_id), class: "p-4 flex rounded-lg hover:shadow-md border hover:border-primary-500 m-2 space-x-4" do %>
                    <div class="relative">
                      <%= PuppiesWeb.PuppyAvatar.show(%{listing: thread.listing, square: 10, extra_classes: "text8_5xl"}) %>
                      <span id={"#{@user.id}-listing-#{thread.listing.id}"} class={"absolute top-6 left-6 hidden inline-flex items-center px-1.5 py-0.0 rounded-full text-xs font-medium bg-red-500 text-white"}>  <%= length(thread.messages) %> </span>
                    </div>
                    <div class="ml-3 flex justify-between flex-grow">
                      <p class="text-sm text-gray-900">
                        <%= thread.listing.name %>  <%= thread.listing.id %>
                      </p>
                      <span data-date={thread.updated_at} class="text-xs text-gray-400 messages-date"></span>
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
                    <%= live_patch to: Routes.live_path(@socket, PuppiesWeb.MessagesLive, listing_id: thread.listing_id, thread: thread.uuid), class: "p-2 flex rounded-lg hover:shadow-md border hover:border-primary-500 m-2 space-x-4 #{MessageUtilities.current_thread_class(@current_thread.id, thread.id)}" do %>
                      <div class="flex-none relative">
                        <%= PuppiesWeb.Avatar.show(%{business: thread.receiver.business, user: thread.receiver, square: 10, extra_classes: "text-2xl"}) %>
                        <span id={"#{@user.id}-listing-#{thread.uuid}"} class="absolute hidden top-6 left-6 inline-flex items-center px-1.5 py-0.0 rounded-full text-xs font-medium bg-red-500 text-white">  <%= MessageUtilities.unread_message_count(@user, thread.messages) %> </span>
                      </div>
                      <div class="flex-grow">
                        <p class="text-sm text-gray-900">
                          <%= MessageUtilities.business_or_user_name(thread.receiver) %>
                           <%= @user.id %> <%= thread.listing.id %>
                        </p>
                        <p class="text-xs  text-gray-500 truncate w-28">
                          <%= thread.last_message%>
                        </p>
                      </div>
                      <div data-date={thread.updated_at} class="text-xs text-gray-400 mt-1 messages-date"></div>
                    <% end %>
                  </li>
                <% end %>
              </ul>
            </div>
          <% end %>
        </div>
        <div class="w-full">
            <div class="p-2 bg-white shadow z-1 flex">
              <div id="message-drawer-opener" class="flex md:hidden">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 stroke-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
                </svg>
                <span class="text-xs text-gray-500 mt-1 underline">MailBox</span>
              </div>

              <%= unless @messages == [] do %>
                <div class="text-sm mt-0.5 text-center flex-grow text-gray-500 ">
                  Conversation with: <%= @current_thread.receiver.first_name %> <%= @current_thread.receiver.last_name %>
                </div>

                <svg @click="{ modal: (modal = !modal), showFlag: showFlag = !showFlag}" xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mr-2 cursor-pointer text-gray-500 " fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 21v-4m0 0V5a2 2 0 012-2h6.5l1 1H21l-3 6 3 6h-8.5l-1-1H5a2 2 0 00-2 2zm9-13.5V9" />
                </svg>

                <svg  @click="{ modal: (modal = !modal), showBlock: showBlock = !showBlock}" xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 cursor-pointer text-gray-500 " fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
                </svg>
              <% end %>
            </div>
          <ul class="h-[calc(100vh-295px)] overflow-scroll flex flex-col" id="chat-messages" phx-hook="chatMessages" phx-update="replace">
            <%= if  @messages != [] do %>
              <%= PuppiesWeb.MessagesList.render_list(%{user: @user, messages: @messages,  current_thread: @current_thread}) %>
            <% else %>
            <li class="h-full">
              <div class="h-full flex justify-center items-center mx-auto">
                <div class="text-center">
                    <svg class="mx-auto h-12 w-12 text-gray-400" xmlns="http://www.w3.org/2000/svg"  fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                    </svg>
                    <h3 class="mt-2 text-sm font-medium text-gray-500">Choose a listing to respond to.</h3>
                </div>
              </div>
            </li>
            <% end %>
          </ul>
          <.live_component module={PuppiesWeb.MessageForm} id="message-form" user={@user} current_thread={@current_thread} changeset={@changeset} />
        </div>
      </div>
    """
  end
end
