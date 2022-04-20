defmodule PuppiesWeb.PaginationComponent do
  @moduledoc """
  Module for show links for pagination
  """
  use PuppiesWeb, :live_component

  defp url_builder(socket, end_point, segment_id, page, params) do
    params = Map.put(params, "page", page)

    params =
      if Map.has_key?(params, "prefix") do
        prefix = Map.get(params, "prefix")

        Map.delete(params, "page")
        |> Map.delete("limit")
        |> Map.put("#{prefix}page", page)
        |> Map.put("#{prefix}limit", params["limit"])
      else
        params
      end

    if is_nil(segment_id) do
      Routes.live_path(socket, end_point, params)
    else
      Routes.live_path(socket, end_point, segment_id, params)
    end
  end

  def render(assigns) do
    ~H"""
    <div id='pagination' class="mx-auto my-4">
      <div id='pagination-links' class="flex justify-center">
        <%= if @pagination.previous > 0 do %>

          <%= live_redirect  to: url_builder(@socket, @end_point, @segment_id, "1" , @params), class: "hover:underline mx-2 cursor-pointer" do %>
            <svg class="h-5 w-5 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7" />
            </svg>
          <% end %>

          <%= live_redirect  to:  url_builder(@socket, @end_point, @segment_id, @pagination.previous, @params), class: "hover:underline mx-2 cursor-pointer" do %>
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
            <%= live_redirect  to:  url_builder(@socket, @end_point, @segment_id, i, @params), class: "hover:underline mx-2 cursor-pointer" do %>
              <%= i %>
            <% end %>
          <% end %>
        <% end %>

        <%= if @pagination.next <= @pagination.last_page do %>
          <%= live_redirect  to:  url_builder(@socket, @end_point, @segment_id, @pagination.next, @params), class: "hover:underline mx-2 cursor-pointer" do %>
            <svg class="h-5 w-5 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          <% end %>

          <%= live_redirect  to:  url_builder(@socket, @end_point, @segment_id, @pagination.last_page, @params), class: "hover:underline mx-2 cursor-pointer" do %>
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
