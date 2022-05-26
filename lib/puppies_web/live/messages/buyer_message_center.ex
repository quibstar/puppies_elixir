defmodule PuppiesWeb.BuyerMessageCenter do
  use PuppiesWeb, :live_component

  alias PuppiesWeb.MessageUtilities

  def render(assigns) do
    ~H"""
      <div class="flex relative" id="chat-container">
        <div id='chat-list' class="flex-none md:w-[300px] border-r-[1px] bg-white absolute top-0 bottom-0 z-10 -left-full md:left-auto md:relative">
          <ul class="h-[calc(100vh-144px)] overflow-scroll">
            <%= for thread <- @listing_threads do %>
              <li>
                <%= live_patch to: Routes.live_path(@socket, PuppiesWeb.MessagesLive, thread: thread.uuid), class: "p-2 flex rounded-lg hover:shadow-md border hover:border-primary-500 m-2 space-x-4 #{MessageUtilities.current_thread_class(@current_thread.id, thread.id)}" do %>
                  <div class="flex-none relative">
                    <%= PuppiesWeb.PuppyAvatar.show(%{listing: thread.listing, square: 10, extra_classes: "text8_5xl"}) %>
                    <span id={"#{@user.id}-listing-#{thread.listing.id}"} class="absolute top-6 left-6 hidden inline-flex items-center px-1.5 py-0.0 rounded-full text-xs font-medium bg-red-500 text-white">  <%= MessageUtilities.unread_message_count(@user, thread.messages) %> </span>
                  </div>
                  <div class="flex-grow">
                    <p class="text-sm text-gray-900">
                      <%= thread.listing.name %> <%= thread.listing.id %>
                    </p>
                    <p class="text-xs  text-gray-500 truncate w-28">
                      <%= thread.last_message %>
                    </p>
                  </div>
                  <div>
                    <div data-date={thread.updated_at} class="text-xs text-gray-400 mt-1 messages-date"></div>
                    <div data-time={thread.updated_at} class="text-xs text-gray-400 mt-1 messages-time"><%=thread.updated_at%></div>
                  </div>
                <% end %>
              </li>
            <% end %>
          </ul>
        </div>
        <div class="w-full">
            <div class="p-2 bg-white shadow z-1 flex">
              <div id="message-drawer-opener" class="flex md:hidden">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 stroke-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
                </svg>
                <span class="text-xs text-gray-500 mt-1 underline">MailBox</span>
              </div>

              <div class="text-sm mt-0.5 text-center flex-grow text-gray-500 ">
                Conversation with: <%= @current_thread.receiver.first_name %> <%= @current_thread.receiver.last_name %>
              </div>

              <.live_component module={PuppiesWeb.FlagSellerIcon} id="flag_icon" business={@current_thread.receiver.business} user={@current_thread.sender} listing={@current_thread.listing} return_to={ Routes.live_path(@socket, PuppiesWeb.MessagesLive, thread: @current_thread.uuid)}/>
            </div>

          <ul class="pb-4 h-[calc(100vh-295px)] overflow-scroll flex flex-col" id="chat-messages" phx-hook="chatMessages" phx-update="replace">
            <%= if  @messages != [] do %>
              <%= PuppiesWeb.MessagesList.render_list(%{user: @user, messages: @messages,  current_thread: @current_thread}) %>
            <% end %>
          </ul>
          <.live_component module={PuppiesWeb.MessageForm} id="message-form" user={@user} current_thread={@current_thread} changeset={@changeset} />
        </div>
      </div>
    """
  end
end
