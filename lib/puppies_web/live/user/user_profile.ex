defmodule PuppiesWeb.UserProfile do
  use PuppiesWeb, :live_view

  alias Puppies.{Accounts, Photos}

  def mount(_params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(session, socket) do
    user =
      if connected?(socket) && Map.has_key?(session, "user_token") do
        %{"user_token" => user_token} = session
        Accounts.get_user_by_session_token(user_token)
      end

    socket =
      socket
      |> assign(:uploaded_files, [])
      |> allow_upload(:avatar, accept: ~w(.jpg .jpeg), max_entries: 1)

    user = Accounts.user_photo_and_location(user.id)
    changeset = Accounts.change_user_profile(user)

    {:ok,
     assign(socket,
       changeset: changeset,
       loading: false,
       user: user,
       hide_current_photo: false
     )}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      Accounts.change_user_profile(socket.assigns.user, params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(socket,
       changeset: changeset,
       params: params
     )}
  end

  def handle_event("save_user", %{"user" => params}, socket) do
    user = socket.assigns.user
    old_photo = user.photo

    case Accounts.update_user_profile(user, params) do
      {:ok, user} ->
        if old_photo && old_photo.delete do
          Photos.delete_photo(old_photo)
        else
          save_photo(socket, user)
        end

        {
          :noreply,
          socket
          |> put_flash(:info, "Profile Updated")
          |> push_redirect(to: Routes.live_path(socket, PuppiesWeb.UserDashboardLive))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("remove-avatar-image", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  def handle_event("remove-image", _, socket) do
    photo = socket.assigns.user.photo
    photo = Map.put(photo, :delete, true)
    user = Map.put(socket.assigns.user, :photo, photo)
    {:noreply, assign(socket, hide_current_photo: true, user: user)}
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

  def save_photo(socket, user) do
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
             user_id: user.id
           }) do
        {:ok, photo} ->
          Photos.resize_and_send_to_aws(photo)
      end
    end
  end

  def render(assigns) do
    ~H"""
      <div>
        <%= if @loading do %>
        <% else %>
          <div class="my-4 max-w-3xl mx-auto bg-white shadow px-4 py-5 sm:rounded-lg sm:p-6">
            <.form let={f} for={@changeset} id="user-form" phx-submit="save_user" phx_change="validate">
              <div class="space-y-8 divide-y divide-gray-200">
                <div class="pt-8">
                  <%= if !is_nil(@user.photo) && !is_nil(@user.photo.url) && !@hide_current_photo do %>
                    <div id="profile-image" class="my-4 mx-auto border-2 border-dashed rounded-full w-60 h-60 flex justify-center items-center overflow-hidden">
                      <%= img_tag( @user.photo.url) %>
                    </div>
                    <div class="flex flex-col justify-center ">
                      <button type="button" class="text-sm underline uppercase text-gray-500" phx-click="remove-image" >Remove Image</button>
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
                      <div id="profile-image" class="my-4 mx-auto border-2 border-dashed rounded-full w-60 h-60 flex justify-center items-center overflow-hidden">
                        <%= live_img_preview entry %>
                      </div>

                      <div class="flex flex-col justify-center space-y-2">
                        <progress class="h-2 rounded overflow-hidden mx-auto display-block" max="100" value={entry.progress}><%= entry.progress %>%</progress>
                        <button type="button" class="ml-4 text-sm underline uppercase text-gray-500" phx-click="remove-avatar-image" phx-value-ref={entry.ref} >Remove Image</button>
                      </div>

                    <% end %>

                    <%= for err <- upload_errors(@uploads.avatar) do %>
                      <p class="alert alert-danger"><%= error_to_string(err) %></p>
                    <% end %>
                  <% end %>

                  <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">

                    <div class="col-span-6 sm:col-span-6 lg:col-span-2">
                      <label for="first-name" class="block text-sm font-medium text-gray-700">
                        First name
                      </label>
                      <div class="mt-1">
                        <%= text_input f, :first_name, class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
                      </div>
                    </div>

                    <div class="col-span-6 sm:col-span-6 lg:col-span-2">
                      <label for="last-name" class="block text-sm font-medium text-gray-700">
                        Last name
                      </label>
                      <div class="mt-1">
                        <%= text_input f, :last_name, class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
                      </div>
                    </div>
                    <%= inputs_for f, :user_location, fn loc -> %>

                      <div class="col-span-6 sm:col-span-3">
                        <label for="country" class="block text-sm font-medium text-gray-700">Country</label>
                        <%= select loc, :country, ["United States", "Canada", "Mexico"],  class: "mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm" %>
                      </div>

                      <div class="col-span-6">
                        <label for="street-address" class="block text-sm font-medium text-gray-700">Street address</label>
                        <%= text_input loc, :street_address, class: "mt-1 focus:ring-primary-500 focus:border-primary-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md" %>
                      </div>

                      <div class="col-span-6 sm:col-span-6 lg:col-span-2">
                        <label for="city" class="block text-sm font-medium text-gray-700">City</label>
                        <%= text_input loc, :city, class: "mt-1 focus:ring-primary-500 focus:border-primary-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md" %>
                      </div>

                      <div class="col-span-6 sm:col-span-3 lg:col-span-2">
                        <label for="region" class="block text-sm font-medium text-gray-700">State / Province</label>
                        <%= text_input loc, :region, class: "mt-1 focus:ring-primary-500 focus:border-primary-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md" %>
                      </div>

                      <div class="col-span-6 sm:col-span-3 lg:col-span-2">
                        <label for="postal-code" class="block text-sm font-medium text-gray-700">ZIP / Postal code</label>
                        <%= text_input loc, :postal_code, class: "mt-1 focus:ring-primary-500 focus:border-primary-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md" %>
                      </div>
                    <% end %>
                  </div>
                </div>
                <div class="pt-5">
                  <div class="py-5">
                    <div class="flex flex-col" x-on:click.debounce="show_drawer = !show_drawer">
                      <%= submit "Submit", phx_disable_with: "Saving...",  disabled: !@changeset.valid?,  class: "inline-block px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
                    </div>
                  </div>
                </div>
              </div>
            </.form>
          </div>
        <% end %>
      </div>
    """
  end
end
