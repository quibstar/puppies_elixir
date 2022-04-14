defmodule PuppiesWeb.BreedsMatchMakerLive do
  use PuppiesWeb, :live_view

  alias Puppies.{BreedsSearch}

  def mount(_params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(_params, session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(_params, _session, socket) do
    changeset = BreedsSearch.changeset(%BreedsSearch{}, %{min_size: 1, max_size: 5})

    socket =
      assign(
        socket,
        changeset: changeset,
        loading: false,
        breeds: [],
        page_title: "Breeds",
        width: 100,
        left: 0
      )

    {:ok, socket}
  end

  def handle_event("change", %{"breeds_search" => breeds_search}, socket) do
    res = Puppies.ES.BreedSearch.autocomplete(breeds_search)

    breeds =
      if res == [] or res == nil do
        []
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

  def render(assigns) do
    ~H"""
      <div class="h-full max-w-7xl mx-auto px-4 py-6 sm:px-6 md:justify-start md:space-x-10 lg:px-8">
          <%= if @loading == false do %>
              <div class='container mx-auto my-4 px-2 md:px-0 h-full' x-data="{ open: false }">
                <div class='md:flex justify-between'>
                    <div class='flex'>
                        <div class="text-xl md:text-3xl">
                            <span class="capitalize">Puppy matcher</span>.
                        </div>
                    </div>
                </div>
                <div>
                  <div class="text-gray-900">
                  Better results will show up at the top of the page.
                  </div>
                </div>
                <.form let={f} for={@changeset} phx-change="change" >
                  <%= live_component PuppiesWeb.FilterFormComponent, id: "filter", f: f, changeset: @changeset, left: @left, width: @width %>
                </.form>
                <%= unless @breeds == [] do %>
                  <span class="text-sm border border-primary-600 rounded-full bg-primary-500 text-white px-1"> <%= length(@breeds) %></span> results
                <% end %>

                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 my-4">
                  <%= for breed <- @breeds do %>
                    <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.BreedsShowLive, breed.slug) do %>
                      <div class="overflow-hidden relative rounded-lg bg-white shadow-sm hover:shadow-lg focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-primary-500">
                        <div class="">
                          <img class="h-auto w-full" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="">
                        </div>
                        <div class="p-4">

                          <p class="text-sm font-medium text-gray-900"><%= breed.name %> <%= breed.score %></p>
                            <div class="text-xs text-gray-500 mt-2">
                              <div>Size:</div>
                              <div class="bg-gray-200 h-1 w-full mt-3 ml--8 rounded">
                                <div class={"bg-primary-500 h-1 rounded"} style={"width: #{100/5 *  breed.size}%"}></div>
                              </div>
                            </div>

                            <div class="text-xs text-gray-500 mt-2">
                              <div>Kid Friendly:</div>
                              <div class="bg-gray-200 h-1 w-full mt-3 ml--8 rounded">
                                <div class={"bg-primary-500 h-1 rounded"} style={"width: #{100/5 *  breed.kid_friendly}%"}></div>
                              </div>
                            </div>

                            <div class="text-xs text-gray-500 mt-2">
                              <div>Dog Friendly:</div>
                              <div class="bg-gray-200 h-1 w-full mt-3 ml--8 rounded">
                                <div class={"bg-primary-500 h-1 rounded"} style={"width: #{100/5 *  breed.dog_friendly}%"}></div>
                              </div>
                            </div>

                            <div class="text-xs text-gray-500 mt-2">
                              <div>Intensity:</div>
                              <div class="bg-gray-200 h-1 w-full mt-3 ml--8 rounded">
                                <div class={"bg-primary-500 h-1 rounded"} style={"width: #{100/5 *  breed.intensity}%"}></div>
                              </div>
                            </div>

                            <div class="text-xs text-gray-500 mt-2">
                              <div>Shedding:</div>
                              <div class="bg-gray-200 h-1 w-full mt-3 ml--8 rounded">
                                <div class={"bg-primary-500 h-1 rounded"} style={"width: #{100/5 *  breed.amount_of_shedding}%"}></div>
                              </div>
                            </div>

                            <div class="text-xs text-gray-500 mt-2">
                              <div>Trainable:</div>
                              <div class="bg-gray-200 h-1 w-full mt-3 ml--8 rounded">
                                <div class={"bg-primary-500 h-1 rounded"} style={"width: #{100/5 *  breed.trainability}%"}></div>
                              </div>
                            </div>

                            <div class="text-xs text-gray-500 mt-2">
                              <div>Intelligence:</div>
                              <div class="bg-gray-200 h-1 w-full mt-3 ml--8 rounded">
                                <div class={"bg-primary-500 h-1 rounded"} style={"width: #{100/5 *  breed.intelligence}%"}></div>
                              </div>
                            </div>

                            <div class="text-xs text-gray-500 mt-2">
                              <div>Barking/Howling:</div>
                              <div class="bg-gray-200 h-1 w-full mt-3 ml--8 rounded">
                                <div class={"bg-primary-500 h-1 rounded"} style={"width: #{100/5 *  breed.tendency_to_bark_or_howl}%"}></div>
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
