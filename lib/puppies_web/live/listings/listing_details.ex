defmodule PuppiesWeb.ListingDetails do
  use PuppiesWeb, :live_component

  alias Puppies.{Utilities, Favorites}

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  def sex(sex) do
    case sex do
      "male" ->
        "he"

      "female" ->
        "she"
    end
  end

  def available?(delivery) do
    case delivery do
      true ->
        "Available"

      false ->
        "Unavailable"
    end
  end

  def yes_or_no?(delivery) do
    case delivery do
      true ->
        "Yes"

      false ->
        "No"
    end
  end

  def status(status) do
    case status do
      "available" ->
        "I'm currently available"

      "on hold" ->
        "I'm currently on hold"

      "sold" ->
        "Sorry, I'm sold. I have a new home!"
    end
  end

  def is_favorite?(is_favorite) do
    if is_favorite do
      "fill-red-500 stroke-red-500"
    else
      "fill-white stroke-primary-500"
    end
  end

  def handle_event("favorite", _, socket) do
    fav = socket.assigns.is_favorite
    user_id = socket.assigns.user_id
    listing = socket.assigns.listing

    if socket.assigns.is_favorite do
      Favorites.delete_favorite(user_id, listing.id)
    else
      Favorites.create_favorite(%{user_id: user_id, listing_id: listing.id})
    end

    socket = assign(socket, is_favorite: !fav)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
      <div class="col-span-2 mb-4">
        <div class="bg-white px-6  border rounded">
          <div class="py-5">
            <div class="grid grid-cols-1 sm:grid-cols-3">
              <div>
                <div class="text-lg leading-6 font-medium text-gray-900 flex space-x-2">
                  <h3>Hi, I'm <span class="text-primary-600"><%=@listing.name %></span></h3>
                  <svg class={"w-6 h-6 mr-2 cursor-pointer #{is_favorite?(@is_favorite)}"} phx-click="favorite" phx-target={@myself} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                  </svg>
                </div>

                <p class="mt-1 max-w-2xl text-sm text-gray-500">
                  I'm a <%= if @listing.purebred do %>
                    purebred
                  <% else %>
                    mixed
                  <% end %>
                  <%= Puppies.Utilities.breed_names(@listing.breeds) %>
                </p>
                <p class="mt-1 max-w-2xl text-sm text-gray-500">
                  <%= status(@listing.status) %>
                </p>

              </div>
              <div class="col-span-2 text-center flex justify-between">
                <div>
                  <dt class="text-sm font-medium text-gray-500 truncate">Total Views</dt>
                  <dd class="mt-1 font-semibold text-gray-900"><%= length(@views) %></dd>
                </div>

                <div>
                  <dt class="text-sm font-medium text-gray-500 truncate">Member Views</dt>
                  <dd class="mt-1 font-semibold text-gray-900"><%= Utilities.members(@views) %></dd>
                </div>

                <div>
                  <dt class="text-sm font-medium text-gray-500 truncate">Non Registered Views</dt>
                  <dd class="mt-1 font-semibold text-gray-900"><%= Utilities.organic(@views) %></dd>
                </div>
              </div>
            </div>

          </div>
          <div class="border-t border-gray-200 py-5">
            <dl class="grid grid-cols-1 gap-x-4 gap-y-8 sm:grid-cols-2">
              <div class="sm:col-span-1">
                <dt class="text-sm font-medium text-gray-500">Age</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= Puppies.Utilities.date_format_from_ecto(@listing.dob) %></dd>
              </div>
              <div class="sm:col-span-1">
                <dt class="text-sm font-medium text-gray-500">Gender</dt>
                <dd class="mt-1 text-sm text-gray-900 capitalize"><%= @listing.sex %></dd>
              </div>
              <div class="sm:col-span-1">
                <dt class="text-sm font-medium text-gray-500">Coat Color Pattern</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= if is_nil(@listing.coat_color_pattern), do: "N/A", else: @listing.coat_color_pattern %></dd>
              </div>
              <div class="sm:col-span-1">
                <dt class="text-sm font-medium text-gray-500">Price</dt>
                <dd class="mt-1 text-sm text-gray-900">$<%= @listing.price %>.00</dd>
              </div>
              <div class="sm:col-span-2">
                <dt class="text-sm font-medium text-gray-500">About</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= @listing.description %></dd>
              </div>
            </dl>
          </div>

          <div class="relative mt-4">
            <div class="absolute inset-0 flex items-center" aria-hidden="true">
              <div class="w-full border-t border-gray-300"></div>
            </div>
            <div class="relative flex justify-center">
              <span class="px-2 bg-white text-sm text-gray-500"> Health </span>
            </div>
          </div>

          <div class="py-5">
            <dl class="grid grid-cols-1 gap-x-4 gap-y-8 sm:grid-cols-3">
              <div>
                <dt class="text-sm font-medium text-gray-500">Current Vaccinations</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= yes_or_no? @listing.current_vaccinations %></dd>
              </div>

              <div>
                <dt class="text-sm font-medium text-gray-500">Veterinary Exam</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= yes_or_no? @listing.veterinary_exam %></dd>
              </div>

              <div>
                <dt class="text-sm font-medium text-gray-500">Health Certificate</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= yes_or_no? @listing.health_certificate %></dd>
              </div>

              <div>
                <dt class="text-sm font-medium text-gray-500">Health Guarantee</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= yes_or_no? @listing.health_guarantee %></dd>
              </div>
            </dl>
          </div>

          <div class="relative mt-4">
            <div class="absolute inset-0 flex items-center" aria-hidden="true">
              <div class="w-full border-t border-gray-300"></div>
            </div>
            <div class="relative flex justify-center">
              <span class="px-2 bg-white text-sm text-gray-500"> Bloodline </span>
            </div>
          </div>

          <div class="py-5">
            <dl class="grid grid-cols-1 gap-x-4 gap-y-8 sm:grid-cols-3">
              <div>
                <dt class="text-sm font-medium text-gray-500">Pedigree</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= yes_or_no? @listing.pedigree %></dd>
              </div>

              <div>
                <dt class="text-sm font-medium text-gray-500">Champion Sired</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= yes_or_no? @listing.champion_sired %></dd>
              </div>

              <div>
                <dt class="text-sm font-medium text-gray-500">Champion Bloodline</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= yes_or_no? @listing.champion_bloodline %></dd>
              </div>

              <div>
                <dt class="text-sm font-medium text-gray-500">Show Quality</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= yes_or_no? @listing.show_quality %></dd>
              </div>

              <div>
                <dt class="text-sm font-medium text-gray-500">Registered</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= yes_or_no? @listing.registered %></dd>
              </div>

              <div>
                <dt class="text-sm font-medium text-gray-500">Registrable</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= yes_or_no? @listing.registrable %></dd>
              </div>
            </dl>
          </div>

          <div class="relative mt-4">
            <div class="absolute inset-0 flex items-center" aria-hidden="true">
              <div class="w-full border-t border-gray-300"></div>
            </div>
            <div class="relative flex justify-center">
              <span class="px-2 bg-white text-sm text-gray-500"> Extras </span>
            </div>
          </div>

          <div class="py-5">
            <dl class="grid grid-cols-1 gap-x-4 gap-y-8 sm:grid-cols-3">
              <div>
                <dt class="text-sm font-medium text-gray-500">Hypoallergenic</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= yes_or_no? @listing.hypoallergenic %></dd>
              </div>

              <div>
                <dt class="text-sm font-medium text-gray-500">Microchip</dt>
                <dd class="mt-1 text-sm text-gray-900"><%=yes_or_no?  @listing.microchip %></dd>
              </div>

            </dl>
          </div>

          <div class="relative mt-4">
            <div class="absolute inset-0 flex items-center" aria-hidden="true">
              <div class="w-full border-t border-gray-300"></div>
            </div>
            <div class="relative flex justify-center">
              <span class="px-2 bg-white text-sm text-gray-500"> Delivery </span>
            </div>
          </div>

          <div class="py-5">
            <dl class="grid grid-cols-1 gap-x-4 gap-y-8 sm:grid-cols-3">
              <div>
                <dt class="text-sm font-medium text-gray-500">On Site</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= available? @listing.deliver_on_site %></dd>
              </div>

              <div>
                <dt class="text-sm font-medium text-gray-500">Pickup</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= available?  @listing.deliver_pick_up %></dd>
              </div>

              <div>
                <dt class="text-sm font-medium text-gray-500">Shipped</dt>
                <dd class="mt-1 text-sm text-gray-900"><%= available? @listing.delivery_shipped %></dd>
              </div>
            </dl>
          </div>

        </div>
      </div>
    """
  end
end
