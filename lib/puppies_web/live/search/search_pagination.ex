defmodule PuppiesWeb.SearchPaginationComponent do
  @moduledoc """
  Module for show links for pagination
  """
  use PuppiesWeb, :live_component

  defp url_builder(socket, end_point, page, limit, params) do
    params = Map.put(params, "page", page) |> Map.put("limit", limit)

    Routes.live_path(
      socket,
      end_point,
      %{"search" => params}
    )
  end

  def render(assigns) do
    ~H"""
    <div id='pagination' class="mx-auto my-4">
      <div id='pagination-links' class="flex justify-center">
        <%= if @pagination.previous > 0 do %>

          <%= live_patch to: url_builder(@socket, @end_point, "1" , @limit, @params), class: "hover:underline mx-2 cursor-pointer" do %>
            <svg class="h-5 w-5 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7" />
            </svg>
          <% end %>

          <%= live_patch to: url_builder(@socket, @end_point, @pagination.previous , @limit, @params), class: "hover:underline mx-2 cursor-pointer" do %>
            <svg class="h-5 w-5 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          <% end %>

        <% else %>

        <div class="text-gray-400">
            <svg class="h-5 w-5 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7" />
            </svg>
          </div>

        <div class="text-gray-400">
          <svg class="h-5 w-5 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
          </svg>
        </div>


        <% end %>

        <%= for i <- @pagination.first_link..@pagination.last_link do %>
          <%= if @pagination.page == i do %>
            <div class="text-gray-400 mx-2"><%= i %></div>
          <% else %>
            <%= live_patch to: url_builder(@socket, @end_point, i, @limit, @params), class: "hover:underline mx-2 cursor-pointer" do %>
              <%= i %>
            <% end %>
          <% end %>
        <% end %>

        <%= if @pagination.next <= @pagination.last_page do %>
          <%= live_patch to: url_builder(@socket, @end_point, @pagination.next , @limit, @params), class: "hover:underline mx-2 cursor-pointer" do %>
            <svg class="h-5 w-5 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          <% end %>

          <%= live_patch to: url_builder(@socket, @end_point, @pagination.last_page , @limit, @params), class: "hover:underline mx-2 cursor-pointer" do %>
            <svg class="h-5 w-5 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5l7 7-7 7M5 5l7 7-7 7" />
            </svg>
         <% end %>

        <% else %>
          <div class="text-gray-400">
            <svg class="h-5 w-5 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </div>

          <div class="text-gray-400 ">
            <svg class="h-5 w-5 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5l7 7-7 7M5 5l7 7-7 7" />
            </svg>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
