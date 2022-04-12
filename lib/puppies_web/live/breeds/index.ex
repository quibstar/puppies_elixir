defmodule PuppiesWeb.BreedsIndexLive do
  use PuppiesWeb, :live_view

  alias Puppies.{Breeds}

  def mount(_params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(_params, session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(_params, _session, socket) do
    breeds = Breeds.breeds_list()

    socket =
      assign(
        socket,
        loading: false,
        breeds: breeds,
        page_title: "Breeds"
      )

    {:ok, socket}
  end

  def handle_event("page-to", %{"page_id" => page_id}, socket) do
    match =
      socket.assigns.match
      |> Map.put(:page, page_id)
      |> Map.put(:sort, socket.assigns.match.sort)

    {:noreply,
     socket
     |> push_redirect(
       to: Routes.live_path(socket, PuppiesWeb.BreedsShowLive, socket.assigns.breed, match: match)
     )}
  end

  def handle_params(params, _uri, socket) do
    if params["match"] do
      match = params["match"]
      page = match["page"]
      limit = match["limit"]
      sort = match["sort"]

      matches =
        Breeds.get_breed(params["slug"], %{
          limit: limit,
          page: page,
          sort: sort,
          number_of_links: 7
        })

      updated_match =
        if Map.has_key?(socket.assigns, "match") do
          socket.assigns.match
          |> Map.put(:page, page)
          |> Map.put(:limit, limit)
          |> Map.put(:sort, sort)
        else
          %{}
          |> Map.put(:page, page)
          |> Map.put(:limit, limit)
          |> Map.put(:sort, sort)
        end

      socket =
        assign(
          socket,
          matches: Map.get(matches, :matches, []),
          pagination: Map.get(matches, :pagination, %{count: 0}),
          match: updated_match
        )

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
      <div class="h-full max-w-7xl mx-auto px-4 py-6 sm:px-6 md:justify-start md:space-x-10 lg:px-8">
          <%= if @loading == false do %>
              <div class='container mx-auto my-4 px-2 md:px-0 h-full' x-data="{ open: false }">
                <div class='md:flex justify-between'>
                    <div class='flex'>
                        <div class="text-xl md:text-3xl">
                            <span class="capitalize">Breeds</span>.
                        </div>
                    </div>
                    <div class="my-2 flex">
                        <div>
                          <div class="relative flex items-center">
                            <input type="text" name="search" id="search" class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full pr-12 sm:text-sm border-gray-300 rounded" autocomplete="off">
                          </div>
                        </div>
                        <button class="ml-2 inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500" @click="open = ! open">Filter</button>
                    </div>
                </div>
                <div class="">
                  <div class="text-sm font-medium text-gray-900"> <%= length(@breeds) %> beautiful types of dogs.</div>
                </div>
                <div
                  class="p-2 my-2 border rounded bg-white"
                  x-show="open"
                  @click.outside="open = false"
                  x-transition.opacity
                  x-transition:enter.duration.500ms
                  x-transition:leave.duration.400ms
                  >

                  Filter
                </div>
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 my-4">
                  <%= for breed <- @breeds do %>
                    <div class="relative rounded-lg  bg-white shadow-sm flex items-center space-x-3 hover:shadow-lg focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-primary-500">
                      <div class="flex-shrink-0 rounded-tl-lg rounded-bl-lg overflow-hidden">
                        <img class="h-16 w-16" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="">
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
