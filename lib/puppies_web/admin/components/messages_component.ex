defmodule PuppiesWeb.Admin.MessagesComponent do
  @moduledoc """
  Profile component
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <div>
        <%= unless is_nil(@user) do %>
          <ul  class="h-[calc(100vh-144px)] overflow-scroll bg-gray-50 p-2 rounded-lg border"  id="chat-messages" phx-hook="chatMessages">
            <%= PuppiesWeb.MessagesList.render_list(%{user: @user, messages: @messages,  current_thread: @thread}) %>
          </ul>
        <% end %>
      </div>
    """
  end
end
