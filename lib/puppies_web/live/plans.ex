defmodule PuppiesWeb.ProductsLive do
  @moduledoc """
  Plans live view index
  """
  use PuppiesWeb, :live_view

  def render(assigns) do
    ~H"""
      <div class="max-w-7xl mx-auto py-24 px-4  sm:px-6 lg:px-8">
        <h2 class="text-3xl font-extrabold text-gray-900 sm:text-5xl sm:leading-none sm:tracking-tight lg:text-6xl">Listing has never been easier.</h2>
        <p class="mt-6 max-w-3xl text-xl text-gray-500">Choose the plan that's right for you.</p>

        <!-- Tiers -->
        <div class="mt-24 space-y-12 lg:space-y-0 lg:grid lg:grid-cols-3 lg:gap-x-8">
          <div class="relative p-8 bg-white border border-gray-200 rounded-2xl shadow-sm flex flex-col">
              <%= PuppiesWeb.ProductComponent.free(@socket) %>
          </div>

          <div class="relative p-8 bg-white border border-gray-200 rounded-2xl shadow-sm flex flex-col">
            <%= PuppiesWeb.ProductComponent.standard(@socket) %>
            <%= live_redirect "Silver", to: Routes.live_path(@socket, PuppiesWeb.CheckoutLive, "Standard"), class: "bg-primary-500 text-white hover:bg-primary-600 mt-8 block w-full py-3 px-6 border border-transparent rounded-md text-center font-medium"%>
          </div>

          <div class="relative p-8 bg-white border border-gray-200 rounded-2xl shadow-sm flex flex-col">
            <%= PuppiesWeb.ProductComponent.premium(@socket) %>
            <%= live_redirect "Gold", to: Routes.live_path(@socket, PuppiesWeb.CheckoutLive,  "Premium"), class: "bg-primary-500 text-white hover:bg-primary-600 hover:text-white mt-8 block w-full py-3 px-6 border border-transparent rounded-md text-center font-medium"%>
          </div>
        </div>
      </div>
    """
  end
end
