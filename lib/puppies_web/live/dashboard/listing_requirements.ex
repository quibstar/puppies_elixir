defmodule PuppiesWeb.ListingRequirements do
  use Phoenix.Component
  use Phoenix.HTML

  def html(assigns) do
    ~H"""
        <div class="text-gray-500">
          <%= if @user.is_seller do %>

            <p class="mt-1 max-w-2xl">Hello <%= @user.first_name %> <%= @user.last_name %>, to get started listing you must first:</p>
            <ol class="my-2 list-decimal ml-4">

              <li class={if is_nil(@business), do: "",else: "line-through"}>Fill out
                <span x-on:click="show_drawer = !show_drawer" class="cursor-pointer underline">Business/Personal Details.</span>
              </li>

              <li class={if @subscription_count == 0, do: "",else: "line-through"}>
                Choose your <%= live_redirect "plan", to: PuppiesWeb.Router.Helpers.live_path(@socket,  PuppiesWeb.ProductsLive), class: "underline cursor-pointer" %>.
              </li>

              <li class={if @listings == [], do: "",else: "line-through"}>Create some listing!</li>
            </ol>

          <% else %>
            <%= unless @user.confirmed_at do %>
              <p class="text-red-500 text-sm mt-2">Please confirm your email.</p>
            <% end %>
          <% end %>
        </div>
    """
  end
end
