defmodule PuppiesWeb.BreederDetails do
  use PuppiesWeb, :live_component

  alias PuppiesWeb.{FlagIcon, ChatIcon}

  def render(assigns) do
    ~H"""
      <div >
        <div class="text-center space-y-4 bg-white px-6 py-9 border rounded">
          <%= PuppiesWeb.Avatar.show(%{business: @business, user: @business.user, square: 44, extra_classes: "text8_5xl"}) %>
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
                <%= if is_nil(@conversation_started) do %>
                  <.live_component module={ChatIcon} id="chat_icon" business={@business} user={@user} listing={@listing} return_to={ Routes.live_path(@socket, PuppiesWeb.ListingShow, @listing.id)}/>
                <% else %>
                  <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.MessagesLive, uuid: @conversation_started.uuid  ) do %>
                      <svg class="w-6 h-6 mr-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
                      </svg>
                  <% end %>
                <% end %>
                <.live_component module={FlagIcon} id="flag_icon" business={@business} user={@user} listing={@listing} return_to={ Routes.live_path(@socket, PuppiesWeb.ListingShow, @listing.id)}/>
              </div>
            <% else %>
                <div class="flex place-content-center">
                    <svg class="w-6 h-6 mr-2"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="#9ca3af">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z" />
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
