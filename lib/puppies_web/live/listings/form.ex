defmodule PuppiesWeb.ListingsForm do
  use PuppiesWeb, :live_component

  alias Puppies.{Listings, Listings.Listing, Breeds, Photos, ES}

  def update(assigns, socket) do
    results =
      if is_nil(assigns.listing_id) do
        changeset = Listings.change_listing(%Listing{sex: "male", breeds: []})
        %{changeset: changeset, selected_breeds: [], max_uploads: 6, photos: []}
      else
        lst = Listings.get_listing!(assigns.listing_id)
        changeset = Listings.change_listing(lst)

        %{
          changeset: changeset,
          selected_breeds: Map.get(lst, :breeds, []),
          photos: lst.photos
        }
      end

    socket =
      socket
      |> assign(:current_photos, results.photos)
      |> assign(:changeset, results.changeset)
      |> assign(:user, assigns.user)
      |> assign(:breed_queried, [])
      |> assign(:selected_breeds, results.selected_breeds)
      |> assign(:breed, "")
      |> assign(:uploaded_files, [])
      |> allow_upload(:images, accept: ~w(.jpg .jpeg .png), max_entries: 6)
      |> assign(:remove_photos, [])

    {:ok, socket}
  end

  def handle_event("validate", %{"_target" => target, "listing" => params}, socket) do
    breed =
      if target == ["listing", "breed"] && String.length(params["breed"]) > 2 do
        params["breed"]
      else
        ""
      end

    changeset =
      Listings.change_listing(%Listing{breeds: []}, params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(socket,
       changeset: changeset,
       breed: breed
     )}
  end

  def handle_event("save_listing", %{"listing" => params}, socket) do
    %{"id" => id} = params

    listing_breeds =
      Enum.reduce(socket.assigns.selected_breeds, [], fn breed, acc ->
        [%{breed_id: breed.id} | acc]
      end)

    params = Map.put(params, "listing_breeds", listing_breeds)

    listing =
      if id == "" do
        Listings.create_listing(params)
      else
        listing = Listings.get_listing!(params["id"])
        Listings.update_listing(listing, params)
      end

    Enum.each(socket.assigns.remove_photos, fn photo ->
      if photo.delete do
        Photos.delete_photo(photo)
      end
    end)

    message =
      if id == "" do
        "Listing created."
      else
        "Listing updated."
      end

    case listing do
      {:ok, listing} ->
        save_photo(socket, listing)
        ES.Listings.re_index_listing(listing.id)
        changeset = Listings.change_listing(%Listing{sex: "male", breeds: []})

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

  def handle_event("remove-images-image", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :images, ref)}
  end

  def handle_event("remove-saved-image", %{"photo_id" => photo_id}, socket) do
    photos =
      Enum.reduce(socket.assigns.current_photos, %{keep: [], remove: []}, fn photo, acc ->
        if "#{photo.id}" == photo_id do
          list = Map.get(acc, :remove)
          Map.put(acc, :remove, [%{photo | delete: true} | list])
        else
          list = Map.get(acc, :keep)
          Map.put(acc, :keep, [photo | list])
        end
      end)

    {:noreply,
     assign(socket,
       current_photos: Map.get(photos, :keep),
       remove_photos: Map.get(photos, :remove)
     )}
  end

  # file upload
  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

  def save_photo(socket, listing) do
    files =
      consume_uploaded_entries(socket, :images, fn %{path: path}, entry ->
        photo_name = Photos.rename_photo(entry)
        dest = Path.join("priv/static/uploads", photo_name)
        File.cp!(path, dest)

        %{
          url: Routes.static_path(socket, "/uploads/#{Path.basename(dest)}"),
          name: photo_name
        }
      end)

    Enum.each(files, fn photo ->
      case Photos.create_photo(%{
             url: photo.url,
             name: photo.name,
             listing_id: listing.id
           }) do
        {:ok, photo} ->
          Photos.resize_and_send_to_aws(photo)
      end
    end)
  end

  def current_photos_and_uploaded_photos(current, uploaded) do
    length(current) + length(uploaded)
  end

  def render(assigns) do
    ~H"""
      <section aria-labelledby="listing-form">
        <div class="bg-white shadow sm:rounded-lg my-4">
          <div class="px-4 py-5 sm:px-6">
            <h1>Listing</h1>
            <.form let={f} for={@changeset} id="listing-form" phx-submit="save_listing" phx_change="validate" phx-target={@myself}>
              <%= hidden_input f, :id %>
              <%= hidden_input f, :user_id, value: @user.id %>

              <div class="md:grid grid-cols-2 gap-4">
                <div class="mt-4">
                  <%= label f, :name, class: "inline-block text-sm font-medium text-gray-700" %> <small class="text-xs text-red-500">*</small>
                  <%= text_input f, :name, class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
                  <%= error_tag f, :name %>
                </div>

                <div class="mt-4">
                  <%= label f, "DOB/Expected Date", class: "inline-block text-sm font-medium text-gray-700" %> <small class="text-xs text-red-500">*</small>
                  <%= date_input f, :dob, class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
                  <%= error_tag f, :name %>
                </div>
              </div>

              <div class="md:grid grid-cols-3 gap-4">
                <div class="mt-4">
                  <%= label f, :purebred, class: "block text-sm font-medium text-gray-700" %>
                  <div class="space-y-4 sm:flex sm:items-center sm:space-y-0 sm:space-x-10">
                    <div class="flex items-center">
                      <%= radio_button f, :purebred, :true, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300" %>
                      <%= label f, :yes, class: "ml-3 block text-sm font-medium text-gray-700" %>
                    </div>

                    <div class="flex items-center">
                      <%= radio_button f, :purebred, :false, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300" %>
                      <%= label f, :no, class: "ml-3 block text-sm font-medium text-gray-700" %>
                    </div>
                  </div>
                </div>

                <.live_component module={PuppiesWeb.BreedsAutoSelectComponent} id="listing_form" form={f}  selected_breeds={@selected_breeds} breed={@breed} target="#listing-form" />

                <div class="mt-4">
                  <%= label f, :coat_color_pattern, class: "block text-sm font-medium text-gray-700" %>
                  <%= select f, :coat_color_pattern, ["","Black & Tan", "Bicolor", "Tricolor", "Merle", "Tuxedo", "Harlequin", "Spotted", "Flecked", "Brindle", "Saddle", "Sable", "Solid"], class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
                  <%= error_tag f, :coat %>
                </div>
              </div>

              <Divider.divider title="Gender - Attributes - Delivery Options" />

              <div class="mt-4">
                <%= label f, :gender, class: "block text-sm font-medium text-gray-700" %>
                <div class="space-y-4 sm:flex sm:items-center sm:space-y-0 sm:space-x-10">
                  <div class="flex items-center">
                    <%= radio_button f, :sex, :male, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300" %>
                    <%= label f, :male, class: "ml-3 block text-sm font-medium text-gray-700" %>
                  </div>

                  <div class="flex items-center">
                    <%= radio_button f, :sex, :female, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300" %>
                    <%= label f, :female, class: "ml-3 block text-sm font-medium text-gray-700" %>
                  </div>
                </div>
              </div>

              <div class="mt-4">
                <%= label f, :attributes, class: "block text-sm font-medium text-gray-700" %>
                <div class="col-span-4 grid grid-cols-3">
                  <%= for attribute <- ["champion_sired", "show_quality", "champion_bloodline", "registered", "registrable", "current_vaccinations", "veterinary_exam", "health_certificate", "health_guarantee", "pedigree", "hypoallergenic", "microchip"] do %>
                    <div class="relative flex items-start">
                      <div class="flex items-center h-5">
                        <%= checkbox f, String.to_atom(attribute), class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded" %>
                      </div>
                      <div class="ml-3 text-sm">
                        <label for={attribute} class="font-medium text-gray-700 capitalize"><%= humanize(attribute) %></label>
                      </div>
                    </div>
                  <% end %>
                </div>
              </div>

              <div class="mt-4">
                <%= label f, :delivery_options, class: "block text-sm font-medium text-gray-700" %>
                <div class="grid grid-cols-3 mt-2">
                  <%= for delivery <- ["deliver_on_site", "deliver_pick_up", "delivery_shipped"] do %>
                    <div class="relative flex items-start">
                      <div class="flex items-center h-5">
                        <%= checkbox f, String.to_atom(delivery), class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded" %>
                      </div>
                      <div class="ml-3 text-sm">
                        <label for={delivery} class="font-medium text-gray-700 capitalize"><%= humanize(delivery) %></label>
                      </div>
                    </div>
                  <% end %>
                </div>
              </div>

              <Divider.divider title="Price - Description" />

              <div class="mt-4 md:w-1/4">
                <%= label f, :price, class: "inline-block text-sm font-medium text-gray-700" %> <small class="text-xs text-red-500">*</small>
                <div class="flex relative">
                  <div class="top-1.5 left-2 absolute text-base text-gray-700">$</div>
                  <%= number_input f, :price, min: 0, class: "pl-5 shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
                </div>
                <%= error_tag f, :price %>
              </div>

              <div class="mt-4">
                <%= label f, "Description and good to know information", class: "block text-sm font-medium text-gray-700" %>
                <%= textarea f, :description, rows: 5, class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
              </div>
              <div class="mt-6 text-primary-600 text-sm">
                Never include your phone or email, unless you want to get unsolicited emails and phone calls. Scammer routinely scan websites for these details
              </div>

              <div class="col-span-4">

                <Divider.divider title="Photos" />

                <%= unless length(@current_photos) + length(@uploads.images.entries) >= 6 do %>
                  <div class="text-primary-600 text-base overflow-hidden">
                    Drag and drop up to 6 photos.
                  </div>

                  <%= for err <- upload_errors(@uploads.images) do %>
                    <AlertError.error>
                      <%= error_to_string(err) %>
                    </AlertError.error>
                  <% end %>

                  <div class="my-4 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md" phx-drop-target={@uploads.images.ref}>
                    <div class="space-y-1 text-center">
                      <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
                        <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                      </svg>
                      <div class="flex text-sm text-gray-600">
                        <label  class="relative overflow-hidden underline bold cursor-pointer">
                          <span>Upload a file</span>
                            <div  class="h-0 overflow-hidden absolute">
                              <%= live_file_input @uploads.images %>
                            </div>
                        </label>
                        <p class="pl-1">or drag and drop</p>
                      </div>
                      <p class="text-xs text-gray-500">PNG, JPG, GIF up to 10MB</p>
                    </div>
                  </div>
                <% end %>

                <div class="mt-4">
                  <div class="grid grid-cols-2 md:grid-cols-6 gap-4">

                      <%= for photo <- @current_photos do %>
                        <%= if  photo.delete == false do %>
                          <div>
                            <div class="my-4 mx-auto border-2 border-dashed rounded w-24 h-24 flex justify-center items-center overflow-hidden">
                              <%= img_tag( photo.url, class: "object-cover w-full h-full") %>
                            </div>
                            <div class="flex flex-col justify-center ">
                              <button type="button" class="text-sm underline uppercase text-gray-500" phx-click="remove-saved-image" phx-value-photo_id={photo.id} phx-target={@myself} >Remove Image</button>
                            </div>
                          </div>
                        <% end %>
                      <% end %>

                    <%= for entry <- @uploads.images.entries do  %>
                      <div>
                        <div class="my-4 mx-auto border-2 border-dashed rounded w-24 h-24 flex justify-center items-center overflow-hidden">
                          <%= live_img_preview entry %>
                        </div>
                        <div class="flex flex-col justify-center space-y-2 mt-2">
                          <progress class="w-3/4 md:w-full h-2 rounded overflow-hidden mx-auto display-block" max="100" value={entry.progress}><%= entry.progress %>%</progress>
                          <button type="button" class="text-sm underline uppercase text-gray-500" phx-click="remove-images-image" phx-value-ref={entry.ref} phx-target={@myself} >Remove Image</button>
                        </div>
                      </div>
                    <% end %>
                  </div>
                </div>
              </div>

              <div class=" mt-4">
                <div class="flex flex-col" x-on:click.debounce="show_drawer = !show_drawer">
                  <%= submit "Submit", phx_disable_with: "Saving...",  disabled: !@changeset.valid?,  class: "inline-block px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
                </div>
              </div>
            </.form>
          </div>
        </div>
      </section>
    """
  end
end
