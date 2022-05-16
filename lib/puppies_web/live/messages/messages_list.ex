defmodule PuppiesWeb.MessagesList do
  use Phoenix.Component
  alias PuppiesWeb.MessageUtilities

  def render_list(assigns) do
    ~H"""
      <%= for {message, index} <- Enum.with_index(@messages) do  %>
        <%= if MessageUtilities.check_date(@messages, index, message.inserted_at) do %>
          <li>
            <div id={"m-#{message.id}"} class="relative" phx-update="ignore">
              <div class="absolute inset-0 flex items-center" aria-hidden="true">
                <div class="w-full border-t border-gray-300"></div>
              </div>
              <div class="relative flex justify-center">
                <span  data-date={message.inserted_at} class="messages-date px-2 bg-gray-50 text-xs text-gray-500"> </span>
              </div>
            </div>
          </li>
        <% end %>
        <%= if message.sent_by != @user.id do %>
          <li class="flex items-end" id={"#{message.id}"}>
            <%= if MessageUtilities.get_next_item(@messages, index, message.sent_by) == true do %>
              <%= PuppiesWeb.Avatar.show(%{business: @current_thread.receiver.business, user: @current_thread.receiver, square: 10, extra_classes: "text-2xl mx-4"}) %>
            <% else %>
              <div class="w-10 h-10 mx-4 flex flex-col"></div>
            <% end %>
            <div class="p-2 shadow rounded-br-lg rounded-tr-lg rounded-tl-lg text-sm bg-white">
              <%= message.message %>
            </div>
          </li>
        <% else %>
          <li class="flex items-end flex-row-reverse" id={"#{message.id}"}>
            <%= if MessageUtilities.get_next_item(@messages, index, message.sent_by) == true do %>
              <%= PuppiesWeb.Avatar.show(%{business: @current_thread.sender.business, user: @current_thread.sender, square: 10, extra_classes: "text-2xl mx-4"}) %>
            <% else %>
              <div class="w-10 h-10 mx-4 flex flex-col"></div>
            <% end %>
            <div>
              <div class="p-2 shadow rounded-bl-lg rounded-tr-lg rounded-tl-lg text-sm bg-white">
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
    """
  end
end
