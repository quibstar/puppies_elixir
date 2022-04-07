defmodule PuppiesWeb.FindPuppyLive.State do
  use PuppiesWeb, :live_view
  alias Puppies.{ES.StateCitySearch}

  @size "40"
  def mount(params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(session, params, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(_, params, socket) do
    %{"state" => state} = params

    matches = StateCitySearch.state(state, "1", @size)
    count = Map.get(matches, :count, 0)

    socket =
      assign(
        socket,
        loading: false,
        matches: Map.get(matches, :matches, []),
        pagination: Puppies.Pagination.pagination(count, "1", @size),
        match: %{
          limit: "40",
          page: "1",
          sort: :newest
        },
        state: state,
        page_title: "Puppies in #{state} "
      )

    {:ok, socket}
  end

  def state_to_human_readable(state) do
    if String.length(state) == 2 do
      String.upcase(state) |> String.to_atom() |> PuppiesWeb.StateUtilities.abbrev_to_state()
    else
      state
    end
  end

  def handle_event("show_profile", %{"profile_id" => profile_id}, socket) do
    {:noreply, socket |> push_redirect(to: Routes.profile_show_path(socket, :show, profile_id))}
  end

  def handle_event("page-to", %{"page_id" => page_id}, socket) do
    match =
      socket.assigns.match
      |> Map.put(:page, page_id)
      |> Map.put(:sort, socket.assigns.match.sort)

    {:noreply,
     socket
     |> push_redirect(
       to: Routes.find_puppy_state_path(socket, :state, socket.assigns.state, match: match)
     )}
  end

  def handle_event("changed", %{"match" => match}, socket) do
    limit = socket.assigns.match.limit
    page = socket.assigns.match.page

    match =
      socket.assigns.match
      |> Map.put(:page, page)
      |> Map.put(:limit, limit)
      |> Map.put(:sort, match["sort"])

    {:noreply,
     socket
     |> push_redirect(
       to: Routes.find_puppy_state_path(socket, :state, socket.assigns.state, match: match)
     )}
  end

  def handle_params(params, _uri, socket) do
    if params["match"] do
      match = params["match"]
      page = match["page"]
      limit = match["limit"]
      sort = match["sort"]
      state = params["state"]

      matches = StateCitySearch.state(state, page, limit)
      count = Map.get(matches, :count, 0)

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
          pagination: Puppies.Pagination.pagination(count, page, @size),
          match: updated_match,
          state: state
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
              <div class='container mx-auto my-4 px-2 md:px-0 h-full'>
                  <%= if length(@matches) > 0 do %>
                      <div class='md:flex justify-between'>
                          <div class='flex'>
                              <div class="text-xl md:text-3xl">
                                Puppies in <span class="capitalize"><%= state_to_human_readable(@state) %></span>.
                              </div>
                          </div>
                          <div class="my-2">
                            <%= PuppiesWeb.FilterComponent.render(%{user: nil, selected: @match.sort}) %>
                          </div>
                      </div>
                      <span class="inline-flex items-center px-2.5 py-0.5 rounded-md text-sm font-medium bg-primary-500 text-white"> <%= @pagination.count %> available! </span>
                  <% end %>


                  <%= if length(@matches) > 0 do %>
                      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4 my-4">
                          <%= for listing <- @matches do %>
                              <%= live_component  PuppiesWeb.FlatCard, id: listing["_id"], listing: listing["_source"] %>
                          <% end %>
                      </div>
                      <%= if @pagination.count > String.to_integer(@match.limit) do %>
                          <%= PuppiesWeb.PaginationComponent.render(%{pagination: @pagination, socket: @socket, page: @match.page, limit: @match.limit}) %>
                      <% end %>

                       <div class="bg-primary-700 rounded">
                          <div class="max-w-2xl mx-auto text-center py-16 px-4 sm:py-20 sm:px-6 lg:px-8">
                              <h2 class="text-3xl font-extrabold text-white sm:text-4xl">
                                  <span class="block capitalize"><%= state_to_human_readable(@state) %></span>
                                  <span class="block">is waiting for you.</span>
                              </h2>
                              <p class="mt-4 text-lg leading-6 text-primary-200">There are <%= @pagination.count %> new opportunities.</p>
                              <%= link "Sign up for free", to: Routes.user_registration_path(@socket, :new), class: "mt-8 w-full inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-primary-600 bg-white hover:bg-primary-50 sm:w-auto" %>
                          </div>
                      </div>

                  <% else %>
                    <div class="h-full flex justify-center items-center mx-auto">
                      <div class="text-center bg-white shadow p-4 rounded">
                          <svg xmlns="http://www.w3.org/2000/svg" class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                          </svg>
                          <h3 class="mt-2 text-sm font-medium text-gray-900">So Sorry!</h3>
                          <p class="mt-1 text-sm text-gray-500">
                              No rooms available in <span class="capitalize"> <%= state_to_human_readable(@state) %></span>. Maybe try <%= live_redirect "searching", to: Routes.live_path(@socket, PuppiesWeb.SearchLive), class: "underline py-3 md:p-0 block text-base text-gray-500 hover:text-gray-900 nav-link" %>
                          </p>
                      </div>
                  </div>
                  <% end %>
              </div>
          <% else %>
              <%= live_component PuppiesWeb.LoadingComponent, id: "matches-loading" %>
          <% end %>
      </div>
    """
  end
end
