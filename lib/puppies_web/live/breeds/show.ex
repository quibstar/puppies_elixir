defmodule PuppiesWeb.BreedsShowLive do
  use PuppiesWeb, :live_view

  alias Puppies.{Breeds, Accounts}

  def mount(params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(params, session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(params, session, socket) do
    user =
      if connected?(socket) && Map.has_key?(session, "user_token") do
        %{"user_token" => user_token} = session
        Accounts.get_user_by_session_token(user_token)
      end

    %{"slug" => slug} = params

    matches = Breeds.get_breed(slug)
    breed = Breeds.get_breed_and_attributes_by_slug(slug)

    socket =
      assign(
        socket,
        user: user,
        loading: false,
        matches: Map.get(matches, :matches, []),
        pagination:
          Map.get(matches, :pagination, %{pagination: %{count: 0, page: "1", limit: "12"}}),
        breed: breed,
        page_title: "Breed "
      )

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    page = Map.get(params, "page", "1")
    limit = Map.get(params, "limit", "12")
    sort = Map.get(params, "sort", "view")

    breeds =
      Breeds.get_breed(params["slug"], %{
        limit: limit,
        page: page,
        sort: sort,
        number_of_links: 7
      })

    socket =
      assign(
        socket,
        matches: breeds.matches,
        pagination: breeds.pagination
      )

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
      <div class="h-full max-w-7xl mx-auto px-4 py-6 sm:px-6 md:justify-start md:space-x-10 lg:px-8" x-data="{ open: false }">
          <%= if @loading == false do %>
              <div class='container mx-auto my-4 px-2 md:px-0 h-full'>
                  <%= if length(@matches) > 0 do %>
                    <div class="md:grid md:grid-cols-3 md:gap-4">
                      <div class="text-center space-y-4 bg-white px-6 py-9 border rounded">
                        <img class="mx-auto w-44 h-44 rounded-full overflow-hidden object-cover block ring-2 ring-primary-500 ring-offset-1" src={"/uploads/breeds/#{@breed.slug}.jpg"} alt="">
                        <h3 class="font-bold text-xl text-gray-900 sm:text-2xl"><%= @breed.name %></h3>
                      </div>
                      <div class="bg-white px-6 py-9 border rounded col-span-2">
                      	<div class="text-gray-600">
                          <div class="py-2 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                            <div class="text-sm font-medium text-gray-500">Breed Group</div>
                            <div class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2"><%= @breed.attributes.dog_breed_group %></div>
                          </div>
                          <div class="py-2 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                            <div class="text-sm font-medium text-gray-500">Size</div>
                            <div class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">Small to Medium</div>
                          </div>
                          <div class="py-2 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                            <div class="text-sm font-medium text-gray-500">Life span</div>
                            <div class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                              <%= @breed.attributes.life_span %>
                            </div>
                          </div>
                          <div class="py-2 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                            <div class="text-sm font-medium text-gray-500">Height</div>
                            <div class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                              <%= if is_nil(@breed.attributes.height), do: "N/A", else: @breed.attributes.height %>
                            </div>
                          </div>
                          <div class="py-2 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                            <div class="text-sm font-medium text-gray-500">Weight</div>
                            <div class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                              <%= if is_nil(@breed.attributes.weight), do: "N/A", else: @breed.attributes.weight %>
                            </div>
                          </div>
                          <div class="py-2 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                            <div class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                              <button class="cursor-pointer underline" @click="open = ! open">View Traits</button>
                            </div>
                          </div>
                        </div>

                        </div>
                    </div>

                      <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 my-4 p-4 bg-white rounded border"
                        x-show="open"
                        @click.outside="open = false"
                        x-transition.opacity
                        x-transition:enter.duration.500ms
                        x-transition:leave.duration.400ms
                        >
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "family-friendly", attribute: @breed.attributes.affectionate_with_family, title: "Family friendly", lower_bound: "Not so much", upper_bound: "Very loving" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "kid-friendly", attribute: @breed.attributes.kid_friendly, title: "Good with children", lower_bound: "Not recommended", upper_bound: "Yes" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "dog-friendly", attribute: @breed.attributes.dog_friendly, title: "Good with other dogs", lower_bound: "Not recommended", upper_bound: "Yes" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "friendly_toward_strangers", attribute: @breed.attributes.friendly_toward_strangers, title: "Friendly to strangers", lower_bound: "Stranger danger", upper_bound: "Hello friend!" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "all_around_friendliness", attribute: @breed.attributes.all_around_friendliness, title: "General friendliness", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "size", attribute: @breed.attributes.size, title: "Size", lower_bound: "Small", upper_bound: "Large" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "intelligence", attribute: @breed.attributes.intelligence, title: "Intelligence", lower_bound: "No so smart", upper_bound: "Smart" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "shedding", attribute: @breed.attributes.amount_of_shedding, title: "Shedding level", lower_bound: "Nope", upper_bound: "Get a new vacuum" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "amount_of_shedding", attribute: @breed.attributes.amount_of_shedding, title: "Shedding amount", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "grooming", attribute: @breed.attributes.easy_to_groom, title: "Grooming", lower_bound: "Monthly", upper_bound: "Daily" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "easy_to_groom", attribute: @breed.attributes.easy_to_groom, title: "Ease of grooming", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "drolling", attribute: @breed.attributes.drooling_potential, title: "Drooling", lower_bound: "Not so much", upper_bound: "Yuck!" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "drooling_potential", attribute: @breed.attributes.drooling_potential, title: "Drooling potential", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "potential_for_playfulness", attribute: @breed.attributes.potential_for_playfulness, title: "Playful", lower_bound: "No so much", upper_bound: "Brings you a leash" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "adaptability", attribute: @breed.attributes.adaptability, title: "Adaptability", lower_bound: "Needs routines", upper_bound: "Can adapt to anything" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "trainability", attribute: @breed.attributes.trainability, title: "Trainability", lower_bound: "Stubborn", upper_bound: "Eager to please" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "easy_to_train", attribute: @breed.attributes.easy_to_train, title: "Ease of training", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "energy_level", attribute: @breed.attributes.energy_level, title: "Energy level", lower_bound: "Low energy", upper_bound: "High energy" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "intensity", attribute: @breed.attributes.intensity, title: "Intensity", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "exercise_needs", attribute: @breed.attributes.exercise_needs, title: "Needs exercise", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "physical_needs", attribute: @breed.attributes.physical_needs, title: "Physical needs", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "health_and_grooming_needs", attribute: @breed.attributes.health_and_grooming_needs, title: "Grooming and health needs", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "general_health", attribute: @breed.attributes.general_health, title: "Overall health", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "potential_for_weight_gain", attribute: @breed.attributes.potential_for_weight_gain, title: "Potential to gain weight", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "wanderlust_potential", attribute: @breed.attributes.wanderlust_potential, title: "Potential to wander", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "potential_for_mouthiness", attribute: @breed.attributes.potential_for_mouthiness, title: "Prone to barking", lower_bound: "Never", upper_bound: "When a pin drops" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "prey_drive", attribute: @breed.attributes.prey_drive, title: "Prey Drive", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "tolerates_hot_weather", attribute: @breed.attributes.tolerates_hot_weather, title: "Tolerates hot weather", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "tolerates_cold_weather", attribute: @breed.attributes.tolerates_cold_weather, title: "Tolerates cold weather", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "tolerates_being_alone", attribute: @breed.attributes.tolerates_being_alone, title: "Tolerates being alone", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "sensitivity_level", attribute: @breed.attributes.sensitivity_level, title: "Sensitivity level", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "good_for_novice_owners", attribute: @breed.attributes.good_for_novice_owners, title: "Good beginner dog", lower_bound: "Low", upper_bound: "High" %>
                        <%= live_component PuppiesWeb.ProgressBarComponent, id: "adapts_well_to_apartment_living", attribute: @breed.attributes.adapts_well_to_apartment_living, title: "Adapts to apartments or small dwellings", lower_bound: "Low", upper_bound: "High" %>
                      </div>

                  <% end %>
                  <%= if @pagination.count > 0 do %>
                    <span class="mt-4 inline-flex items-center px-2.5 py-0.5 rounded-md text-sm font-medium bg-primary-500 text-white"> <%= @pagination.count %> available! </span>
                    <div class="grid grid-cols-2 sm:grid-cols-3 gap-4 my-4">
                        <%= for listing <- @matches do %>
                          <%= live_component  PuppiesWeb.Card, id: listing.id, listing: listing, user: @user %>
                        <% end %>
                    </div>
                    <%= if @pagination.count > 12 do %>
                        <%= live_component PuppiesWeb.PaginationComponent, id: "pagination", pagination: @pagination, socket: @socket, params: %{"page" => @pagination.page, "limit" => @pagination.limit}, end_point: PuppiesWeb.BreedsShowLive, segment_id: @breed.slug %>
                    <% end %>

                    <%= unless is_nil(@user) do %>
                      <div class="bg-primary-700 rounded">
                        <div class="max-w-2xl mx-auto text-center py-16 px-4 sm:py-20 sm:px-6 lg:px-8">
                            <h2 class="text-3xl font-extrabold text-white sm:text-4xl">
                                <span class="block capitalize"><%= @breed.name %> found!</span>
                            </h2>
                            <p class="mt-4 text-lg leading-6 text-primary-200">There is <%= @pagination.count %> <%= @breed.name %> waiting for you.</p>
                            <%= link "Sign up for free", to: Routes.user_registration_path(@socket, :new), class: "mt-8 w-full inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-primary-600 bg-white hover:bg-primary-50 sm:w-auto" %>
                        </div>
                      </div>
                    <% end %>

                  <% else %>
                    <div class="h-full flex justify-center items-center mx-auto">
                      <div class="text-center bg-white shadow p-4 rounded">
                          <svg xmlns="http://www.w3.org/2000/svg" class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                          </svg>
                          <h3 class="mt-2 text-sm font-medium text-gray-900">So Sorry!</h3>
                          <p class="mt-1 text-sm text-gray-500">
                              No <span class="capitalize"> <%= @breed.name %></span>. Maybe try <%= live_redirect "Search",  to: Routes.live_path(@socket, PuppiesWeb.SearchLive), class: "underline py-3 md:p-0 block text-base text-gray-500 hover:text-gray-900 nav-link" %>
                          </p>
                      </div>
                  </div>
                  <% end %>
              </div>
          <% else %>
              <%= live_component PuppiesWeb.LoadingComponent, id: "breeds-loading" %>
          <% end %>
      </div>
    """
  end
end
