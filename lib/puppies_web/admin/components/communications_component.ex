defmodule PuppiesWeb.Admin.Communications do
  @moduledoc """
  empty data component
  """
  use PuppiesWeb, :live_component
  alias Puppies.Utilities

  def render(assigns) do
    ~H"""
    <div>
      <div>
        <div class="border-b border-gray-200">
          <nav class="-mb-px flex space-x-2" aria-label="Tabs">
            <%= live_patch to: Routes.live_path(@socket, PuppiesWeb.Admin.User, @user.id, %{tab: @tab, sub_tab: "conversations"}), class: "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm #{Utilities.active_tab(@sub_tab, "conversations")}" do %>
              Conversations
            <% end %>

            <%= live_patch to: Routes.live_path(@socket, PuppiesWeb.Admin.User, @user.id, %{tab: @tab, sub_tab: "reviews"}), class: "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm #{Utilities.active_tab(@sub_tab, "reviews")}" do %>
              Reviews
            <% end %>

            <%= live_patch to: Routes.live_path(@socket, PuppiesWeb.Admin.User, @user.id, %{tab: @tab, sub_tab: "sys-emails"}), class: "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm #{Utilities.active_tab(@sub_tab, "sys-emails")}" do %>
              System Emails
            <% end %>

            <%= live_patch to: Routes.live_path(@socket, PuppiesWeb.Admin.User, @user.id, %{tab: @tab, sub_tab: "sys-messages"}), class: "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm #{Utilities.active_tab(@sub_tab, "sys-messages")}" do %>
              System Messages
            <% end %>

          </nav>
        </div>
        <%= cond do %>
          <% @sub_tab == "conversations" -> %>
            <.live_component module={PuppiesWeb.Admin.ThreadComponent} id="threads" threads={@threads} thread={nil} messages={[]} user={@user}/>

          <% @sub_tab == "reviews" -> %>
            <div class="my-4 text-xs text-gray-500">
              Reviews written by this user.
            </div>
            <div class="space-y-2">
              <%= for review <- @reviews do %>
                <%= live_component  PuppiesWeb.Admin.Review, id: review.id, review: review, business: review.business %>
              <% end %>
            </div>

          <% @sub_tab == "sys-emails" -> %>
            Sys email

          <% @sub_tab == "sys-messages" -> %>
            Sys messages

        <% end %>
      </div>
    </div>
    """
  end
end
