defmodule SilverVerified do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
      <div class='max-w-7xl mx-auto'>
        <div class="mt-24 space-y-12 lg:space-y-0 lg:grid lg:grid-cols-2 lg:gap-x-4">
            <div class="mx-auto p-8 bg-white border border-gray-200 rounded-2xl shadow-s relative">
                <div class="flex-1">
                  <.live_component module={BronzeSilverList} id="bronze-silver-list"/>
                  <p class="my-4 flex items-baseline text-primary-500">
                      <span class="text-5xl font-extrabold tracking-tight">Silver Verification</span>
                  </p>
                  <p class="mt-6 text-gray-500">
                    You have obtained all the requirements associate with Bronze and Silver members. If you want maximum exposure consider upgrading. You'll find the most reputable individuals are Gold level members.
                  </p>
                </div>
            </div>

            <div class="relative p-8 bg-white border border-gray-200 rounded-2xl shadow-sm flex flex-col">
              <%= PuppiesWeb.ProductComponent.id_verification(assigns.socket) %>
              <%= live_redirect "ID Verification", to: PuppiesWeb.Router.Helpers.live_path(@socket, PuppiesWeb.CheckoutLive,  "ID Verification"), class: "bg-primary-500 text-white hover:bg-primary-600 hover:text-white mt-8 block w-full py-3 px-6 border border-transparent rounded-md text-center font-medium"%>
            </div>
        </div>
        <div class="my-4 text-gray-400">&#42; Phone and ID verifications are limited to one attempt. If you have previously purchased them they'll be reinstated.</div>
      </div>
    """
  end
end
