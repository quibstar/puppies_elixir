defmodule BronzeVerification do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
      <div class='max-w-7xl container mx-auto my-4'>
        <div class="mt-24 space-y-12 lg:space-y-0 lg:grid lg:grid-cols-3 lg:gap-x-4">
          <div class="mx-auto p-8 bg-white border border-gray-200 rounded-2xl shadow-s relative">
                <div class="flex-1">
                    <span class="text-xl font-semibold text-bronze">Bronze</span>
                    <p class="mt-4 flex items-baseline text-primary-500">
                        <span class="text-5xl font-extrabold tracking-tight">We see you</span>
                        <div class="ml-1 text-xl font-semibold"></div>
                    </p>
                    <p class="mt-6 text-gray-500">
                      You have obtained the minimum level to be visible to other community members.
                      If you want maximum exposure consider upgrading. You'll find premium members at silver and gold levels. For truly reputable individuals we suggest going for the gold.
                    </p>
                </div>
            </div>

            <div class="relative p-8 bg-white border border-gray-200 rounded-2xl shadow-sm flex flex-col">
              <%= PuppiesWeb.ProductComponent.standard(assigns.socket) %>
              <%= live_redirect "Silver", to: PuppiesWeb.Router.Helpers.live_path(@socket, PuppiesWeb.CheckoutLive, "Standard"), class: "bg-primary-500 text-white hover:bg-primary-600 mt-8 block w-full py-3 px-6 border border-transparent rounded-md text-center font-medium"%>
            </div>

            <div class="relative p-8 bg-white border border-gray-200 rounded-2xl shadow-sm flex flex-col">
              <%= PuppiesWeb.ProductComponent.premium(assigns.socket) %>
              <%= live_redirect "Gold", to: PuppiesWeb.Router.Helpers.live_path(@socket, PuppiesWeb.CheckoutLive,  "Premium"), class: "bg-primary-500 text-white hover:bg-primary-600 hover:text-white mt-8 block w-full py-3 px-6 border border-transparent rounded-md text-center font-medium"%>
            </div>
        </div>
        <div class="my-4 text-gray-400">&#42; Phone and ID verifications are limited to one attempt. If you have previously purchased them they'll be reinstated.</div>
      </div>
    """
  end
end
