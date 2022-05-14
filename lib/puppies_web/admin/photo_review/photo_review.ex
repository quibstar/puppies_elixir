defmodule PuppiesWeb.Admin.PhotoReview do
  use PuppiesWeb, :live_view

  alias Puppies.Admins
  alias Puppies.Admin.Photos
  alias PuppiesWeb.{UI.Drawer}

  def mount(_params, session, socket) do
    admin =
      if connected?(socket) && Map.has_key?(session, "admin_token") do
        %{"admin_token" => admin_token} = session
        Admins.get_admin_by_session_token(admin_token)
      end

    socket = socket |> assign(:admin, admin)
    {:ok, set_assigns(socket, "1", "100", nil, nil, "photos")}
  end

  def handle_event("page-to", %{"page_id" => page_id}, socket) do
    {:noreply,
     socket
     |> push_redirect(
       to: Routes.live_path(socket, PuppiesWeb.Admin.PhotoReviewLive, page: page_id)
     )}
  end

  def handle_event("approve_all_photos", %{}, socket) do
    # if photo was approved or mark_for_deletion they
    # will already be remove from the current list of photos
    Enum.each(socket.assigns.photos, fn photo ->
      Photos.update(photo, %{approved: true})
    end)

    {:noreply,
     socket
     |> push_redirect(
       to: Routes.live_path(socket, PuppiesWeb.Admin.PhotoReviewLive, page: default_page(socket))
     )}
  end

  def handle_event("approve_photo", %{"id" => id}, socket) do
    photo = Photos.get_photo!(id)
    Photos.update(photo, %{approved: true, mark_for_deletion: false})

    {:noreply,
     socket
     |> assign(:photo_id, id)
     |> put_flash(:info, "Photo approved")}

    #  |> push_redirect(
    #    to: Routes.live_path(socket, PuppiesWeb.Admin.PhotoReviewLive, page: default_page(socket))
    #  )}
  end

  def handle_event("delete_photo", %{"id" => id}, socket) do
    photo = Photos.get_photo!(id)
    Photos.update(photo, %{approved: false, mark_for_deletion: true})

    {:noreply,
     socket
     |> push_redirect(
       to: Routes.live_path(socket, PuppiesWeb.Admin.PhotoReviewLive, page: default_page(socket))
     )}
  end

  def handle_event("photos_tab", %{"photos_tab" => tab}, socket) do
    {:noreply, assign(socket, photos_tab: tab, photo_id: nil)}
  end

  def handle_event("choose-image", %{"ref" => id}, socket) do
    {:noreply, assign(socket, photo_id: id)}
  end

  def handle_event("update-photo", %{"photo" => photo_params}, socket) do
    photo = Photos.get_photo!(photo_params["id"])

    case Photos.update(photo, photo_params) do
      {:ok, _} ->
        {:noreply,
         set_assigns(
           socket,
           socket.assigns.page,
           socket.assigns.limit,
           nil,
           nil,
           socket.assigns.photos_tab
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_params(params, _uri, socket) do
    page = Map.get(params, "page", "1")
    limit = Map.get(params, "limit", "100")
    photo_id = Map.get(params, "photo_id", nil)
    profile_id = Map.get(params, "profile_id", nil)
    photos_tab = Map.get(params, "photos_tab", "photos")

    socket = set_assigns(socket, page, limit, photo_id, profile_id, photos_tab)

    {:noreply, socket}
  end

  defp set_assigns(socket, page, limit, photo_id, profile_id, photos_tab) do
    photo_count = Photos.photos_that_need_approval_count()
    photos_marked_for_deletion = Photos.photos_marked_for_deletion()
    res = Photos.photos_that_need_approval(page, limit)

    assign(
      socket,
      photo_count: photo_count,
      photos: res.photos,
      pagination: res.pagination,
      page: page,
      limit: limit,
      photo_id: photo_id,
      profile_id: profile_id,
      photos_tab: photos_tab,
      photos_marked_for_deletion: photos_marked_for_deletion
    )
  end

  def default_page(socket) do
    Map.get(socket.assigns, :page, "1")
  end

  def render(assigns) do
    ~H"""
    <div class="flex-1 flex items-stretch overflow-hidden" x-data="{ show_drawer: false}">

      <Drawer.drawer key="show_drawer">
        <:drawer_title>
          Photo Details
        </:drawer_title>
        <:drawer_body>
          <.live_component module={PuppiesWeb.PhotoDetailsComponent} id="photo-drawer" photo_id={@photo_id}/>
        </:drawer_body>
      </Drawer.drawer>

      <div class="pt-8 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 md:w-full">
        <div class="flex">
          <h1 class="flex-1 text-2xl font-bold text-gray-900">Photos</h1>
          <div class="ml-6 bg-gray-100 p-0.5 rounded-lg flex items-center sm:hidden">
            <button type="button" class="p-1.5 rounded-md text-gray-400 hover:bg-white hover:shadow-sm focus:outline-none focus:ring-2 focus:ring-inset focus:ring-primary-500" >
                Approve All
            </button>
          </div>
        </div>
        <!-- Tabs -->
        <div class="mt-3 sm:mt-2">
          <div class="sm:hidden">
            <label for="tabs">Select a tab</label>
            <!-- Use an "onChange" listener to redirect the user to the selected tab URL. -->
            <select id="tabs" name="tabs" class="block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm rounded-md">
                <option selected>Recently Added</option>
                <option>Marked for Deletion</option>
                <option>Favorited</option>
            </select>
          </div>
          <div class="hidden sm:block">
            <div class="flex items-center border-b border-gray-200">
                <nav class="flex-1 -mb-px flex space-x-6 xl:space-x-8" aria-label="Tabs">
                  <button phx-click="photos_tab" phx-value-photos_tab="photos" class={"#{if @photos_tab == "photos", do: "active-tab", else: ""} whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm"} >
                    Recently Added
                    <%= if @photo_count != [] do %>
                      (<%= @photo_count %>)
                    <% end %>
                  </button>
                  <button phx-click="photos_tab" phx-value-photos_tab="mark_for_deletion"class={"#{if @photos_tab == "mark_for_deletion", do: "active-tab", else: ""} border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm"} >
                    Marked for Deletion
                    <%= if @photos_marked_for_deletion != [] do %>
                      (<%= length(@photos_marked_for_deletion) %>)
                    <% end %>
                  </button>
                </nav>
                <div>
                  <button phx-click="approve_all_photos" class="bg-transparent hover:bg-primary-500 text-primary-500 text-xs hover:text-white py-1 px-2 border border-primary-500 hover:border-transparent rounded">Approve all photos</button>
                </div>
            </div>
          </div>
        </div>
        <!-- Gallery -->
        <section class="mt-8 pb-16" aria-labelledby="gallery-heading">
          <ul role="list" class="grid grid-cols-2 gap-x-4 gap-y-8 sm:grid-cols-3 sm:gap-x-6 md:grid-cols-4 lg:grid-cols-3 xl:grid-cols-4 xl:gap-x-8">
            <%= if @photos_tab == "photos" do %>
              <%= for photo <- @photos do %>
                <li class="relative">
                    <div phx-click="choose-image" phx-value-ref={photo.id} x-on:click.debounce="show_drawer = !show_drawer"  class="hover:opacity-75 cursor-pointer group block w-full aspect-w-10 aspect-h-7 rounded-lg bg-gray-100 overflow-hidden">
                      <img src={photo.url} alt="" class="object-cover pointer-events-none"/>
                    </div>
                    <p class="text-sm text-gray-500">Approved: <%= if photo.approved, do: "Yes", else: "No"%></p>
                    <p class="text-sm text-gray-500">Marked for Deletion: <%= if photo.mark_for_deletion, do: "Yes", else: "No"%></p>
                    <button class="text-sm text-primary-500 underline hover:text-primary-700" phx-click="delete_photo" phx-value-id={photo.id}>
                      Delete Photo
                    </button>
                </li>
              <% end %>
            <% else %>
              <%= for photo <- @photos_marked_for_deletion do %>
                <li class="relative">
                  <div phx-click="choose-image" phx-value-ref={photo.id}  class="hover:opacity-75  group block w-full aspect-w-10 aspect-h-7 rounded-lg bg-gray-100 overflow-hidden">
                    <img src={photo.url} alt="" class="object-cover pointer-events-none"/>
                  </div>
                  <button class="text-sm text-primary-500 underline hover:text-primary-700" phx-click="approve_photo" phx-value-id={photo.id}>
                    Approve Photo
                  </button>
                </li>
              <% end %>
            <% end %>
          </ul>
          <%= if @photos_tab == "photos" do %>
            <%= if @photo_count > String.to_integer(@limit) do %>
              <%= live_component PuppiesWeb.PaginationComponent, id: "pagination", pagination: @pagination, socket: @socket, params: %{"page" => @pagination.page, "limit" => @pagination.limit}, end_point: PuppiesWeb.Admin.PhotoReview, segment_id: nil %>
            <% end %>
          <% end %>
        </section>
      </div>
    </div>
    """
  end
end
