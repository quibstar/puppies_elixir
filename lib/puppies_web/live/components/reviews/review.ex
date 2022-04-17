defmodule PuppiesWeb.Review do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="space-y-4 ">
      <div class="space-y-2 border rounded bg-white p-4">
        <div class="flex text-gray-500">
          <img class="h-10 w-10 rounded-full" src="https://images.unsplash.com/photo-1550525811-e5869dd03032?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
          <div class="ml-3 flex-grow">
            <p class="font-medium text-gray-900">Calvin Hawkins</p>
            <div class="flex">
              <p><%= @rating %></p>
              <%= live_component PuppiesWeb.Stars, rating: @rating %>
            </div>
          </div>
          <div>
            04/10/2022
          </div>
        </div>
        <div class="text-sm text-gray-500">
          Tempore odit atque voluptatibus! Ducimus quidem itaque optio delectus porro voluptatibus autem qui! Et officia omnis rerum consequatur nulla similique aperiam distinctio. Qui quia repellendus sed omnis velit quis vel consequatur omnis? Sed optio veritatis illum rerum perferendis
        </div>
      </div>
    </div>
    """
  end
end
