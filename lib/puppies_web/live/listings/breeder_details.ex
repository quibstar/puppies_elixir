defmodule PuppiesWeb.BreederDetails do
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <div>
        <div class="text-center space-y-4 bg-white px-6 py-9 border rounded">
          <%= img_tag @business.photo.url, class: "mx-auto w-44 h-44 rounded-full overflow-hidden object-cover block ring-2 ring-primary-500 ring-offset-1", alt: "Profile image"%>
          <div>
            <div class="inline-block text-sm text-gray-500">Presented by</div>
            <h3 class="font-bold text-xl text-gray-900 sm:text-2xl">
               <%= live_redirect @business.name, to: Routes.live_path(@socket, PuppiesWeb.BusinessPageLive, Puppies.Utilities.string_to_slug(@business.name)), class: "underline cursor-pointer"%>
            </h3>
            <div class="inline-block text-sm text-gray-500">Specializing in: </div>
            <div class="inline-block">
              <%= for breed <- @business.breeds do %>
                <%= live_redirect breed.name, to: Routes.live_path(@socket, PuppiesWeb.BreedsShowLive, breed.slug), class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-100 text-primary-800"%>
              <% end %>
            </div>
          </div>

          <div class="mx-auto">
            <%= if !is_nil(@user) && @user.id != @listing.user_id do %>
              <div class="flex place-content-center">

                  <svg @click="{ modal: (modal = !modal), showMessage: showMessage = !showMessage}" class="w-6 h-6 mr-2 cursor-pointer" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z" />
                  </svg>

                  <svg @click="{ modal: (modal = !modal), showBlock: showBlock = !showBlock}" class="w-6 h-6 mr-2 cursor-pointer" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
                  </svg>
                  <svg @click="{ modal: (modal = !modal), showFlag: showFlag = !showFlag}"  class="w-6 h-6 mr-2 cursor-pointer" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 21v-4m0 0V5a2 2 0 012-2h6.5l1 1H21l-3 6 3 6h-8.5l-1-1H5a2 2 0 00-2 2zm9-13.5V9" />
                  </svg>
              </div>
            <% else %>
                <div class="flex place-content-center">
                    <svg class="w-6 h-6 mr-2"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="#9ca3af">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z" />
                    </svg>
                    <svg class="w-6 h-6 mr-2"   xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="#9ca3af">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
                    </svg>
                    <svg class="w-6 h-6 mr-2"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="#9ca3af">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 21v-4m0 0V5a2 2 0 012-2h6.5l1 1H21l-3 6 3 6h-8.5l-1-1H5a2 2 0 00-2 2zm9-13.5V9" />
                    </svg>
                </div>
            <% end %>
          </div>
        </div>
      </div>
    """
  end
end