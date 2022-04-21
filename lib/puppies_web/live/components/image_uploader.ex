defmodule PuppiesWeb.ImageUploader do
  use PuppiesWeb, :live_component

  def handle_event("remove-image", _, socket) do
    {:noreply, assign(socket, hide_current_photo: true)}
  end

  def hide_container(items) do
    if items == [] do
      ""
    else
      "hidden "
    end
  end

  # file upload
  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

  def render(assigns) do
    ~H"""
      <%= if !is_nil(@entity) && @entity.photo && !@hide_current_photo do %>
        <div class="my-4 mx-auto border-2 border-dashed rounded-full w-60 h-60 flex justify-center items-center overflow-hidden">
          <%= img_tag( @entity.photo.url) %>
        </div>
        <div class="flex flex-col justify-center ">
          <button type="button" class="text-sm underline uppercase text-gray-500" phx-click="remove-image" phx-target={@myself} >Remove Image</button>
        </div>
      <% else %>
        <div class={"#{hide_container(@uploads.image.entries)} my-4 mx-auto p-4 border-2 border-dashed rounded-full w-60 h-60 flex justify-center items-center"}>
          <div class="space-y-1 text-center">
            <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
              <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
            </svg>

            <div class="text-sm text-gray-600">
              <label  class="relative cursor-pointer bg-white rounded-md font-medium text-primary-600 hover:text-primary-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-primary-500">
                <span>Upload a file</span>
                  <%= live_file_input @uploads.image, class: "h-0 absolute overflow-hidden"%>
              </label>
            </div>
          </div>
        </div>

        <%= for entry <- @uploads.image.entries do %>
          <div class="my-4 mx-auto border-2 border-dashed rounded-full w-60 h-60 flex justify-center items-center overflow-hidden">
            <%= live_img_preview entry %>
          </div>

          <div class="flex flex-col justify-center space-y-2">
            <progress class="h-2 rounded overflow-hidden mx-auto display-block" max="100" value={entry.progress}><%= entry.progress %>%</progress>
            <button type="button" class="ml-4 text-sm underline uppercase text-gray-500" phx-click="remove-image-image" phx-value-ref={entry.ref} phx-target={@myself} >Remove Image</button>
          </div>

        <% end %>

        <%= for err <- upload_errors(@uploads.image) do %>
          <p class="alert alert-danger"><%= error_to_string(err) %></p>
        <% end %>
      <% end %>
    """
  end
end
