defmodule PuppiesWeb.Avatar do
  @moduledoc """
  list view component
  """
  use Phoenix.Component
  use Phoenix.HTML

  defp user_initials(user) do
    first_initial = user.first_name |> String.first()
    last_initial = user.last_name |> String.first()
    first_initial <> last_initial
  end

  def show(assigns) do
    ~H"""
      <div class="relative">
        <%= cond do %>
          <% !is_nil(@business) && !is_nil(@business.photo)  && Map.has_key?(@business.photo, :url) -> %>
            <%= img_tag( @business.photo.url, class: "#{@extra_classes} h-#{@square} w-#{@square} rounded-full border border-2 border-primary-500 object-cover") %>

          <% !is_nil(@business) -> %>
            <div class={"#{@extra_classes} mx-auto w-#{@square} h-#{@square} rounded-full overflow-hidden ring-2 ring-yellow-500 ring-offset-1 bg-primary-500 text-white font-bold text-center leading-relaxed"}>
              <%= @business.name |> String.first() %>
            </div>

          <% Map.has_key?(@user.photo, :url) -> %>
            <%= img_tag( @user.photo.url, class: "#{@extra_classes} h-#{@square} w-#{@square} rounded-full border border-2 border-primary-500 object-cover") %>

          <% true -> %>
            <div class={"#{@extra_classes} mx-auto w-#{@square} h-#{@square} rounded-full overflow-hidden ring-2 ring-yellow-500 ring-offset-1 bg-primary-500 text-white font-bold text-center leading-relaxed"}>
              <%= user_initials(@user) %>
            </div>
        <% end %>
      </div>
    """
  end
end
