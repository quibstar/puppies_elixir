defmodule PuppiesWeb.SearchPill do
  @moduledoc """
  Reusable radio
  """
  use PuppiesWeb, :live_component

  def format_string(key) do
    Atom.to_string(key) |> humanize() |> String.capitalize()
  end

  def render(assigns) do
    ~L"""
    <%= if @is_filtering == true || @is_filtering == "true" do %>
      <span class="inline-flex rounded-full items-center py-1 pl-3 pr-1 text-sm font-medium bg-primary-100 text-primary-700 ">
        <%= format_string(@label) %>
        <button type="button" class="flex-shrink-0 ml-0.5 h-4 w-4 rounded-full inline-flex items-center justify-center text-primary-400 hover:bg-primary-200 hover:text-primary-500 focus:outline-none focus:bg-primary-500 focus:text-white" phx-click="remove_filter" phx-value-key="<%= @key %>">
          <span class="sr-only">Remove large option</span>
          <svg class="h-2 w-2" stroke="currentColor" fill="none" viewBox="0 0 8 8">
            <path stroke-linecap="round" stroke-width="1.5" d="M1 1l6 6m0-6L1 7" />
          </svg>
        </button>
      </span>
    <% end %>
    """
  end
end
