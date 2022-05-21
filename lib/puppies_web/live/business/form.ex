defmodule PuppiesWeb.BusinessForm do
  use PuppiesWeb, :live_component

  alias Puppies.{Businesses, Businesses.Business, Breeds, Location, Photos}

  def update(assigns, socket) do
    breeds = Breeds.list_breeds()

    bus = Businesses.get_business_by_user_id(assigns.user.id)

    changeset =
      if is_nil(bus) do
        Businesses.change_business(%Business{location: %Location{}, breeds: []})
      else
        Businesses.change_business(bus, %{location_autocomplete: bus.location.place_name})
      end

    breeds_options =
      Enum.reduce(breeds, [], fn breed, acc ->
        acc ++ ["#{breed.name}": breed.slug]
      end)

    socket =
      socket
      |> assign(:uploaded_files, [])
      |> allow_upload(:avatar, accept: ~w(.jpg .jpeg), max_entries: 1)

    {:ok,
     assign(socket,
       business: bus,
       changeset: changeset,
       user: assigns.user,
       breeds: breeds,
       breeds_options: breeds_options,
       values: [],
       breed_queried: [],
       selected_breeds: Map.get(changeset.data, :breeds, []),
       breed: "",
       locations: [],
       params: %{},
       hide_current_photo: false
     )}
  end

  def handle_event("validate", %{"_target" => target, "business" => params}, socket) do
    breed_queried =
      if target == ["business", "breed"] && String.length(params["breed"]) > 2 do
        Enum.reduce(socket.assigns.breeds, [], fn breed, acc ->
          breed_downcase = String.downcase(breed.name)
          params_downcase = String.downcase(params["breed"])

          if String.starts_with?(breed_downcase, params_downcase) do
            [breed | acc]
          else
            acc
          end
        end)
      else
        []
      end

    slug =
      if target == ["business", "name"] do
        Puppies.Utilities.string_to_slug(params["name"])
      else
        Puppies.Utilities.string_to_slug(socket.assigns.business.name)
      end

    params = Map.put(params, "slug", slug)

    locations =
      if target == ["business", "location_autocomplete"] &&
           String.length(params["location_autocomplete"]) > 3 do
        MapBox.mapbox_address(params["location_autocomplete"])
      else
        []
      end

    changeset =
      Businesses.change_business(%Business{breeds: []}, params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(socket,
       changeset: changeset,
       breed_queried: breed_queried,
       locations: locations,
       params: params
     )}
  end

  def handle_event("save_business", %{"business" => params}, socket) do
    %{"id" => id} = params
    old_photo = socket.assigns.business.photo

    business_breeds =
      Enum.reduce(socket.assigns.selected_breeds, [], fn breed, acc ->
        [%{breed_id: breed.id} | acc]
      end)

    params = Map.put(params, "business_breeds", business_breeds)

    business =
      if id == "" do
        Businesses.create_business(params)
      else
        Businesses.update_business(socket.assigns.business, params)
      end

    message =
      if id == "" do
        "business created."
      else
        "business updated."
      end

    case business do
      {:ok, business} ->
        if old_photo && old_photo.delete do
          Photos.delete_photo(old_photo)
        else
          save_photo(socket, business)
        end

        changeset = Businesses.change_business(%Business{})

        {
          :noreply,
          socket
          |> put_flash(:info, message)
          |> assign(:changeset, changeset)
          |> push_redirect(to: Routes.live_path(socket, PuppiesWeb.UserDashboardLive))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("choose-breed", %{"id" => id}, socket) do
    dog = Breeds.get_breed!(id)
    selected_breeds = socket.assigns.selected_breeds ++ [dog]

    socket =
      assign(
        socket,
        selected_breeds: selected_breeds,
        breed_queried: [],
        breed: ""
      )

    {:noreply, socket}
  end

  def handle_event("remove-breed", %{"id" => id}, socket) do
    selected_breeds =
      Enum.reduce(socket.assigns.selected_breeds, [], fn breed, acc ->
        if("#{breed.id}" != id) do
          acc ++ [breed]
        else
          acc
        end
      end)

    socket =
      assign(
        socket,
        selected_breeds: selected_breeds
      )

    {:noreply, socket}
  end

  def handle_event("choose-location", %{"place_id" => id}, socket) do
    loc = Enum.find(socket.assigns.locations, fn x -> x.place_id == id end)

    changeset =
      Businesses.change_business(
        %Business{},
        Map.merge(socket.assigns.changeset.params, %{
          "location" => loc,
          "location_autocomplete" => Map.get(loc, :place_name)
        })
      )

    {:noreply,
     assign(socket,
       changeset: changeset,
       locations: []
     )}
  end

  def handle_event("remove-avatar-image", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  def handle_event("remove-business-image", _, socket) do
    photo = socket.assigns.business.photo
    photo = Map.put(photo, :delete, true)
    business = Map.put(socket.assigns.business, :photo, photo)
    {:noreply, assign(socket, hide_current_photo: true, business: business)}
  end

  # file upload
  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

  def hide_container(items) do
    if items == [] do
      ""
    else
      "hidden "
    end
  end

  def save_photo(socket, business) do
    profile_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, entry ->
        photo_name = Photos.rename_photo(entry)
        dest = Path.join("priv/static/uploads", photo_name)
        File.cp!(path, dest)

        %{
          url: Routes.static_path(socket, "/uploads/#{Path.basename(dest)}"),
          name: photo_name
        }
      end)

    photo = List.last(profile_files)

    if !is_nil(photo) do
      case Photos.create_photo(%{
             url: photo.url,
             name: photo.name,
             business_id: business.id
           }) do
        {:ok, photo} ->
          Photos.resize_and_send_to_aws(photo)
      end
    end
  end

  def render(assigns) do
    ~H"""
      <div>
        <.form let={f} for={@changeset} id="business-form" phx-submit="save_business" phx_change="validate" phx-target={@myself}>
            <%= hidden_input f, :id %>
            <%= hidden_input f, :user_id, value: @user.id %>
            <div>

              <%= if !is_nil(@business) && @business.photo && !@hide_current_photo do %>
                <div class="my-4 mx-auto border-2 border-dashed rounded-full w-60 h-60  flex justify-center items-center overflow-hidden">
                  <%= img_tag( @business.photo.url, class: " w-60 h-60 object-cover") %>
                </div>
                <div class="flex flex-col justify-center ">
                  <button type="button" class="text-sm underline uppercase text-gray-500" phx-click="remove-business-image" phx-target={@myself} >Remove Image</button>
                </div>
              <% else %>

                <div class={"#{hide_container(@uploads.avatar.entries)} my-4 mx-auto p-4 border-2 border-dashed rounded-full w-60 h-60 flex justify-center items-center"}>
                  <div class="space-y-1 text-center">
                    <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
                      <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                    </svg>

                    <div class="text-sm text-gray-600">
                      <label  class="relative cursor-pointer bg-white rounded-md font-medium text-primary-600 hover:text-primary-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-primary-500">
                        <span>Upload a file</span>
                          <%= live_file_input @uploads.avatar, class: "h-0 absolute overflow-hidden"%>
                      </label>
                    </div>
                  </div>
                </div>

                <%= for entry <- @uploads.avatar.entries do %>
                  <div class="my-4 mx-auto border-2 border-dashed rounded-full w-60 h-60 flex justify-center items-center overflow-hidden">
                    <%= live_img_preview entry %>
                  </div>

                  <div class="flex flex-col justify-center space-y-2">
                    <progress class="h-2 rounded overflow-hidden mx-auto display-block" max="100" value={entry.progress}><%= entry.progress %>%</progress>
                    <button type="button" class="ml-4 text-sm underline uppercase text-gray-500" phx-click="remove-avatar-image" phx-value-ref={entry.ref} phx-target={@myself} >Remove Image</button>
                  </div>

                <% end %>

                <%= for err <- upload_errors(@uploads.avatar) do %>
                  <p class="alert alert-danger"><%= error_to_string(err) %></p>
                <% end %>
              <% end %>


              <div class="relative mt-4">
                <div class="absolute inset-0 flex items-center" aria-hidden="true">
                  <div class="w-full border-t border-gray-300"></div>
                </div>
                <div class="relative flex justify-center">
                  <span class="px-2 bg-white text-sm text-gray-500"> Businesses </span>
                </div>
              </div>

              <div class="mt-4 flex-grow">
                <%= label f, "Name or business name", class: "inline-block text-sm font-medium text-gray-700" %> <small class="text-xs text-red-500">*</small>
                <%= text_input f, :name, class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
                <%= error_tag f, :name %>
                <div class="text-xs text-gray-500 mt-2">
                  Filling in you name or business name gives you a unique marketing page on our site. This is required to advertise/list on our site.
                </div>
              </div>

              <%= hidden_input f, :slug %>

              <div class="mt-4 flex-grow">
                <%= label f, :website, class: "block text-sm font-medium text-gray-700" %>
                <%= text_input f, :website, class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
                <%= error_tag f, :website %>
              </div>

              <div class="mt-4 flex">
                <div class="relative flex items-start">
                  <div class="flex items-center h-5">
                    <%= checkbox f, :federal_license, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded"  %>
                  </div>
                  <div class="ml-3 text-sm">
                    <%= label f, :federal_license, class: "font-medium text-gray-700" %>
                  </div>
                </div>

                <div class="ml-8 relative flex items-start">
                  <div class="flex items-center h-5">
                    <%= checkbox f, :state_license, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded"  %>
                  </div>
                  <div class="ml-3 text-sm">
                    <%= label f, :state_license, class: "font-medium text-gray-700" %>
                  </div>
                </div>
              </div>

              <div class="mt-4">
                <div class="relative">
                  <div class='container mx-auto my-4 px-2 md:px-0 h-full'>
                    <%= label f, :breeds, class: "block"%>
                    <%= text_input f, :breed, autocomplete: "off", value: @breed, class: "w-full shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md" %>

                    <%= multiple_select f, :breeds, @breeds_options, value: @values, class: "hidden"%>

                    <%= if @breed_queried != [] do %>
                      <ul class="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm" id="options" role="listbox">
                        <%= for breed <- @breed_queried do %>
                          <li phx-click="choose-breed" phx-value-id={breed.id} phx-target={@myself} class="cursor-pointer relative py-2 pl-3 pr-9 text-gray-900 hover:text-white hover:bg-primary-500"  role="option">
                              <%= breed.name %>
                          </li>
                        <% end %>
                      </ul>
                    <% end %>
                  </div>
                </div>
                <div class="">
                  <%= for breed <- @selected_breeds do %>
                    <span class="inline-flex rounded-full items-center py-1 pl-3 pr-1 mb-2 text-sm font-medium bg-primary-100 text-primary-700 ">
                      <%= breed.name %>
                      <button type="button" phx-click="remove-breed" phx-value-id={breed.id} phx-target={@myself} class="flex-shrink-0 ml-0.5 h-4 w-4 rounded-full inline-flex items-center justify-center text-primary-400 hover:bg-primary-200 hover:text-primary-500 focus:outline-none focus:bg-primary-500 focus:text-white">
                        <span class="sr-only">Remove large option</span>
                        <svg class="h-2 w-2" stroke="currentColor" fill="none" viewBox="0 0 8 8">
                          <path stroke-linecap="round" stroke-width="1.5" d="M1 1l6 6m0-6L1 7" />
                        </svg>
                      </button>
                    </span>
                  <% end %>
                </div>
              </div>

              <div class="relative mt-4">
                <div class="absolute inset-0 flex items-center" aria-hidden="true">
                  <div class="w-full border-t border-gray-300"></div>
                </div>
                <div class="relative flex justify-center">
                  <span class="px-2 bg-white text-sm text-gray-500"> Personal </span>
                </div>
              </div>

              <div class="mt-4 flex-grow">
                <%= label f, :phone, class: "inline-block text-sm font-medium text-gray-700" %> <small class="text-xs text-red-500">*</small>
                <%= text_input f, :phone, class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
                <%= error_tag f, :phone %>
              </div>

              <div class="mt-4 flex-grow relative">
                <%= label f, :location, class: "inline-block text-sm font-medium text-gray-700" %> <small class="text-xs text-red-500">*</small>
                <%= text_input f, :location_autocomplete, autocomplete: "off", class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
                <%= if @locations != [] do %>
                  <ul class="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm" id="options" role="listbox">
                    <%= for location <- @locations do %>
                      <li phx-click="choose-location" phx-value-place_id={location.place_id} phx-target={@myself} class="cursor-pointer relative py-2 pl-3 pr-9 text-gray-900 hover:text-white hover:bg-primary-500"  role="option">
                          <%= location.place_name %>
                      </li>
                    <% end %>
                  </ul>
                <% end %>
              </div>


              <%= inputs_for f, :location, fn l -> %>
                <%= hidden_input l, :place_id %>
                <%= hidden_input l, :place_name %>
                <%= hidden_input l, :place %>
                <%= hidden_input l, :place_slug %>
                <%= hidden_input l, :region %>
                <%= hidden_input l, :region_slug %>
                <%= hidden_input l, :region_short_code %>
                <%= hidden_input l, :country %>
                <%= hidden_input l, :address %>
                <%= hidden_input l, :text %>
                <%= hidden_input l, :delete %>
                <%= hidden_input l, :lat %>
                <%= hidden_input l, :lng %>
              <% end %>

              <div class="mt-4 flex-grow">
                <%= label f, :description, class: "block text-sm font-medium text-gray-700" %>
                <%= textarea f, :description, class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
                <%= error_tag f, :description %>
              </div>

            </div>
            <div class="py-5">
              <div class="flex flex-col" x-on:click.debounce="show_drawer = !show_drawer">
                <%= submit "Submit", phx_disable_with: "Saving...",  disabled: !@changeset.valid?,  class: "inline-block px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
              </div>
            </div>
        </.form>
      </div>
    """
  end
end
