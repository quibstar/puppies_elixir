defmodule NeedsSilverUpgrade do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
      <div class='max-w-5xl container mx-auto my-4'>
        <div class="md:w-1/2 mx-auto p-8 bg-white border border-gray-200 rounded-2xl shadow-s relative">
            <div class="flex-1">
                <.live_component module={BronzeSilverList} id="bronze-silver-list"/>
                <p class="mt-4 flex items-baseline text-primary-500">
                    <span class="text-5xl font-extrabold tracking-tight">Phone Verification</span>
                </p>
                <p class="mt-4 text-gray-500">
                  Verify your phone number to level up to Silver.
                </p>


                  <div class="mt-4">

                    <div class="rounded-md bg-green-50 p-4">
                      <div class="flex">
                        <div class="flex-shrink-0">
                          <!-- Heroicon name: solid/information-circle -->
                          <svg class="h-5 w-5 text-green-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                            <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
                          </svg>
                        </div>
                        <div class="ml-3 flex-1 md:flex md:justify-between">
                          <p class="text-sm text-green-700">You'll be eligible to upgrade your ID after you've verified your phone</p>
                        </div>
                      </div>
                    </div>
                  </div>


                <div class="mt-4">
                  <%= live_component PuppiesWeb.SilverComponent, id: "silver_upgrade", user: @user %>
                </div>

            </div>
        </div>
      </div>
    """
  end
end
