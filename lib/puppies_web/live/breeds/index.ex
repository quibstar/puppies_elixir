defmodule PuppiesWeb.BreedsIndexLive do
  use PuppiesWeb, :live_view

  alias Puppies.{Breeds, BreedsSearch}

  def mount(_params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(_params, session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(_params, _session, socket) do
    breeds = Breeds.breeds_list()

    changeset = BreedsSearch.changeset(%BreedsSearch{}, %{min_size: 1, max_size: 5})

    socket =
      assign(
        socket,
        changeset: changeset,
        loading: false,
        breeds: breeds,
        page_title: "Breeds",
        width: 100,
        left: 0,
        show_filter: false
      )

    {:ok, socket}
  end

  def handle_event("change", %{"breeds_search" => breeds_search}, socket) do
    res = Puppies.ES.BreedSearch.autocomplete(breeds_search)

    breeds =
      if res == [] or res == nil do
        Breeds.breeds_list()
      else
        res
      end

    changeset = BreedsSearch.changeset(%BreedsSearch{}, breeds_search)

    socket =
      assign(
        socket,
        changeset: changeset,
        breeds: breeds,
        left: (String.to_integer(breeds_search["size_min"]) - 1) * 25,
        width:
          (String.to_integer(breeds_search["size_max"]) -
             String.to_integer(breeds_search["size_min"])) * 25
      )

    {:noreply, socket}
  end

  def handle_event("filter", _, socket) do
    changeset = BreedsSearch.changeset(%BreedsSearch{}, %{min_size: 1, max_size: 5})
    show_filter = !socket.assigns.show_filter
    breeds = Breeds.breeds_list()

    socket =
      assign(
        socket,
        breeds: breeds,
        changeset: changeset,
        show_filter: show_filter
      )

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
      <div class="h-full max-w-7xl mx-auto px-4 py-6 sm:px-6 md:justify-start md:space-x-10 lg:px-8">
          <%= if @loading == false do %>
              <div class='container mx-auto my-4 px-2 md:px-0 h-full' x-data="{ open: false }">
                <.form let={f} for={@changeset} phx-change="change" >
                  <div class='md:flex justify-between'>
                      <div class='flex'>
                          <div class="text-xl md:text-3xl">
                              <span class="capitalize">Breeds</span>.
                          </div>
                      </div>
                      <div class="my-2 flex items-center">
                          <div>
                            <div class="relative flex items-center">
                              <%= text_input f, :name, class: "w-full shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md focus:outline-none disabled:opacity-50",  autocomplete: "off", placeholder: "Type a breed", disabled: @show_filter %>
                            </div>
                          </div>
                          <div class="text-sm text-gray-400 mx-2"> OR </div>
                          <button type="button" class="ml-2 inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500" @click.debounce="open = ! open" phx-click="filter">Filter</button>
                      </div>
                  </div>
                  <div class="">
                    <div class="text-sm font-medium text-gray-900"> <%= length(@breeds) %> beautiful types of dogs.</div>
                  </div>
                  <div
                    x-show="open"
                    x-transition.opacity
                    x-transition:enter.duration.500ms
                    x-transition:leave.duration.400ms
                    >
                    <%= live_component PuppiesWeb.FilterFormComponent, id: "filter", f: f, changeset: @changeset, left: @left, width: @width %>
                  </div>
                </.form>
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 my-4">
                  <%= for breed <- @breeds do %>
                    <div class="relative rounded-lg  bg-white shadow-sm flex items-center space-x-3 hover:shadow-lg focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-primary-500">
                      <div class="flex-shrink-0 rounded-tl-lg rounded-bl-lg overflow-hidden">
                        <%= if Puppies.Utilities.check_for_image?("/uploads/breeds/#{breed.slug}.jpg") do %>
                          <img class="h-16 w-16 object-cover" src={"/uploads/breeds/#{breed.slug}.jpg"} alt="">
                        <% else %>
                          <img class="h-16 w-16" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="">
                        <% end %>
                      </div>
                      <div class="flex-1 min-w-0">
                        <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.BreedsShowLive, breed.slug) do %>
                          <span class="absolute inset-0" aria-hidden="true"></span>
                          <p class="text-sm font-medium text-gray-900"><%= breed.name %></p>
                        <% end %>
                      </div>
                    </div>
                  <% end %>
                </div>
              </div>
          <% else %>
              <%= live_component PuppiesWeb.LoadingComponent, id: "breeds-loading" %>
          <% end %>
      </div>
    """
  end
end
