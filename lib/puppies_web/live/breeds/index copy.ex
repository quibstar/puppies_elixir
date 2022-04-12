defmodule PuppiesWeb.BreedsIndexLiveAlt do
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

  def color_base_on_percent(number) do
    res = 100 / 5 * number

    cond do
      res <= 30 ->
        "primary"

      res <= 60 ->
        "primary"

      true ->
        "primary"
    end
  end

  def render(assigns) do
    ~H"""
      <div class="h-full max-w-7xl mx-auto px-4 py-6 sm:px-6 md:justify-start md:space-x-10 lg:px-8">
          <%= if @loading == false do %>
              <div class='container mx-auto my-4 px-2 md:px-0 h-full'>
                <div class='md:flex justify-between'>
                    <div class='flex'>
                        <div class="text-xl md:text-3xl">
                            <span class="capitalize">Breeds</span>.
                        </div>
                    </div>
                    <div class="my-2">
                      Autocomplete
                    </div>
                </div>
                <div>
                  Filter
                </div>
                <span class="inline-flex items-center text-sm font-medium text-gray-900"> <%= length(@breeds) %> beautiful types of dogs.</span>
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 my-4">
                  <%= for breed <- @breeds do %>

                    <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.BreedsShowLive, breed.slug) do %>
                      <div class="overflow-hidden relative rounded-lg bg-white shadow-sm  hover:shadow-lg focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-primary-500">
                        <div class="h-52 overflow-hidden">
                          <img class="w-full z-0 object-cover" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
                        </div>
                        <div class="p-4">

                          <p class="text-base font-medium text-gray-900"><%= breed.name %></p>

                          <div class="text-xs text-gray-900 grid grid-cols-2 flex-grow">
                            <div >Adaptable: </div>
                            <div class="bg-gray-200 h-1 mt-1">
                              <div class={"bg-primary-500 h-1"} style={"width: #{100/5 * breed.adaptable}%"}></div>
                            </div>

                            <div>Friendly:</div>
                            <div class="bg-gray-200 h-1 mt-1">
                              <div class={"bg-primary-500 h-1"} style={"width: #{100/5 * breed.friendly}%"}></div>
                            </div>

                            <div>Grooming & Health:</div>
                            <div class="bg-gray-200 h-1 mt-1">
                              <div class={"bg-primary-500 h-1"} style={"width: #{100/5 * breed.grooming_and_health}%"}></div>
                            </div>


                            <div>Trainable:</div>
                            <div class="bg-gray-200 h-1 mt-1">
                              <div class={"bg-primary-500 h-1"} style={"width: #{100/5 * breed.trainable}%"}></div>
                            </div>


                            <div>Training & Exercise:</div>
                            <div class="bg-gray-200 h-1 mt-1">
                              <div class={"bg-primary-500 h-1"} style={"width: #{100/5 * breed.attention_and_exercise}%"}></div>
                            </div>
                          </div>

                        </div>
                      </div>
                    <% end %>
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
