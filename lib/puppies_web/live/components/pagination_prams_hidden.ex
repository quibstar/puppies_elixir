defmodule PuppiesWeb.PaginationParamsHiddenComponent do
  @moduledoc """
  Module for show links for pagination
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id='pagination' class="mx-auto my-4">
      <div id='pagination-links' class="flex justify-center">
        <%= if @pagination.previous > 0 do %>

          <div class="hover:underline mx-2 cursor-pointer" phx-click="page-to" phx-value-page_id="1" >
            <svg class="h-5 w-5 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7" />
            </svg>
          </div>

          <div class="hover:underline mx-2 cursor-pointer" phx-click="page-to" phx-value-page_id="<%= @pagination.previous %>">
            <svg class="h-5 w-5 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </div>

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
          <%= if @page == to_string(i) do %>
            <div class="text-gray-400 mx-2"><%= i %></div>
          <% else %>
            <div class="hover:underline mx-2 cursor-pointer" phx-click="page-to" phx-value-page_id="<%= i %>"><%= i %></div>
          <% end %>
        <% end %>

        <%= if @pagination.next <= @pagination.last_page do %>

          <div class="hover:underline mx-2 cursor-pointer" phx-click="page-to" phx-value-page_id="<%= @pagination.next %>" >
            <svg class="h-5 w-5 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </div>

          <div class="hover:underline mx-2 cursor-pointer" phx-click="page-to" phx-value-page_id="<%= @pagination.last_page %>" >
            <svg class="h-5 w-5 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5l7 7-7 7M5 5l7 7-7 7" />
            </svg>
         </div>

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
