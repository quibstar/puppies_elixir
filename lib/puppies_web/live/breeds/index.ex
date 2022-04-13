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

  def handle_event("change", %{"breeds_search" => breeds_search}, socket) do
    params =
      %{
        "name" => name,
        "size_min" => size_min,
        "size_max" => size_max,
        "kid_friendly" => kid_friendly
      } = breeds_search

    res = Puppies.ES.BreedSearch.autocomplete(%{name: name})

    breeds =
      if res == [] or res == nil do
        Breeds.breeds_list()
      else
        res
      end

    changeset = BreedsSearch.changeset(%BreedsSearch{}, params)
    IO.inspect(changeset.params)

    socket =
      assign(
        socket,
        changeset: changeset,
        breeds: breeds,
        left: (String.to_integer(size_min) - 1) * 25,
        width: (String.to_integer(size_max) - String.to_integer(size_min)) * 25
      )

    {:noreply, socket}
  end

  def handle_event("filter", _, socket) do
    changeset = BreedsSearch.changeset(%BreedsSearch{}, %{min_size: 1, max_size: 5})
    show_filter = !socket.assigns.show_filter

    socket =
      assign(
        socket,
        changeset: changeset,
        show_filter: show_filter
      )

    {:noreply, socket}
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
                    class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4 my-4 p-4 bg-white rounded shadow"
                    x-show="open"
                    x-transition.opacity
                    x-transition:enter.duration.500ms
                    x-transition:leave.duration.400ms
                    >
                    <div>
                      <%= label f, :size, class: "block"%>
                      <div class="flex justify-between text-xs text-gray-400">
                        <div>Extra small</div>
                        <div>Extra large</div>
                      </div>
                      <div class="relative mt-5">
                        <%= range_input f, :size_min, max: 5, min: 1, class: "absolute left-0 bottom-0 bg-transparent w-full h-2 appearance-none rounded" %>
                        <%= range_input f, :size_max, max: 5, min: 1, class: "absolute left-0 bottom-0 bg-primary-300 w-full h-2 appearance-none rounded" %>
                        <div class="absolute left-0 bottom-0 bg-primary-400  h-2 rounded" style={"left: #{@left}%; width: #{@width}%;"}></div>
                      </div>
                    </div>

                    <div>
                      <%= label f, :kid_friendly, class: "block"%>
                      <div class="flex justify-between text-xs text-primary-400">
                        <div>No</div>
                        <div>Yes</div>
                      </div>
                      <%= range_input f, :kid_friendly, max: 5, min: 1, class: "w-full h-2 bg-primary-300 appearance-none rounded" %>
                    </div>

                    <div>
                      <%= label f, :dog_friendly, class: "block"%>
                      <div class="flex justify-between text-xs text-primary-400">
                        <div>No</div>
                        <div>Yes</div>
                      </div>
                      <%= range_input f, :dog_friendly, max: 5, min: 1, class: "w-full h-2 bg-primary-300 appearance-none rounded" %>
                    </div>

                    <div>
                      <%= label f, :stranger_friendly, class: "block"%>
                      <div class="flex justify-between text-xs text-primary-400">
                        <div>No</div>
                        <div>Yes</div>
                      </div>
                      <%= range_input f, :stranger_friendly, max: 5, min: 1, class: "w-full h-2 bg-primary-300 appearance-none rounded" %>
                    </div>

                    <div>
                      <%= label f, :adaptable, class: "block"%>
                      <div class="flex justify-between text-xs text-primary-400">
                        <div>No</div>
                        <div>Yes</div>
                      </div>
                      <%= range_input f, :adaptable, max: 5, min: 1, class: "w-full h-2 bg-primary-300 appearance-none rounded" %>
                    </div>


                    <div>
                      <%= label f, :trainable, class: "block"%>
                      <div class="flex justify-between text-xs text-primary-400">
                        <div>No</div>
                        <div>Yes</div>
                      </div>
                      <%= range_input f, :trainability, max: 5, min: 1, class: "w-full h-2 bg-primary-300 appearance-none rounded" %>
                    </div>

                    <div>
                      <%= label f, :intelligence, class: "block"%>
                      <div class="flex justify-between text-xs text-primary-400">
                        <div>No</div>
                        <div>Yes</div>
                      </div>
                      <%= range_input f, :intelligence, max: 5, min: 1, class: "w-full h-2 bg-primary-300 appearance-none rounded" %>
                    </div>

                     <div>
                      <%= label f, :tendency_to_bark_or_howl, class: "block"%>
                      <div class="flex justify-between text-xs text-primary-400">
                        <div>No</div>
                        <div>Yes</div>
                      </div>
                      <%= range_input f, :tendency_to_bark_or_howl, max: 5, min: 1, class: "w-full h-2 bg-primary-300 appearance-none rounded" %>
                    </div>
                  </div>
                </.form>
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
