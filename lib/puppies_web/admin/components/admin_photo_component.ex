defmodule PuppiesWeb.PhotoDetailsComponent do
  @moduledoc """
  Profile component
  """
  use PuppiesWeb, :live_component
  alias Puppies.Photos

  def update(assigns, socket) do
    photo =
      if is_nil(assigns.photo_id) do
        nil
      else
        Photos.get_photo!(assigns.photo_id)
      end

    changeset =
      if is_nil(assigns.photo_id) do
        Photos.change_photo(%Puppies.Photos.Photo{})
      else
        Photos.change_photo(photo)
      end

    {:ok,
     assign(
       socket,
       photo: photo,
       changeset: changeset
     )}
  end

  def render(assigns) do
    ~H"""
      <div>
        <%= unless is_nil(@photo) do %>
          <div>
            <div class="block w-full aspect-w-10 aspect-h-7 rounded-lg overflow-hidden">
              <img class="object-cover w-full m-auto" src={@photo.url}>
            </div>

            <dl class="mt-2 border-t border-b border-gray-200 divide-y divide-gray-200">
              <div class="py-3 flex justify-between text-sm font-medium">
                <dt class="text-gray-500">Resized</dt>
                <dd class="text-gray-900"><%= @photo.resized %></dd>
              </div>

              <div class="py-3 flex justify-between text-sm font-medium">
                <dt class="text-gray-500">Marked for deletion</dt>
                <dd class="text-gray-900"><%= @photo.mark_for_deletion %></dd>
              </div>

              <div class="py-3 flex justify-between text-sm font-medium">
                <dt class="text-gray-500">Approved</dt>
                <dd class="text-gray-900"><%= @photo.approved %></dd>
              </div>
            </dl>
            <.form let={f} for={@changeset} id="image-form" phx_submit="update-photo" class="mt-4">
              <div>
                <%= hidden_input f, :id, value: @photo.id %>
                <label>
                  <%= checkbox f, :mark_for_deletion %>
                  Mark for deletion
                </label>
              </div>
              <div>
                <label>
                  <%= checkbox f, :approved %>
                  Approve
                </label>
              </div>

              <div class="sm:flex sm:flex-row-reverse"  x-on:click="show_drawer = !show_drawer",>
                <%= submit "Submit", phx_disable_with: "Submitting...", class: "w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm" %>
              </div>
            </.form>
          </div>
        <% end %>
    </div>
    """
  end
end
