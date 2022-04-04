defmodule PuppiesWeb.ListingsEdit do
  use PuppiesWeb, :live_view

  alias Puppies.Accounts

  alias PuppiesWeb.{ListingsForm}

  def mount(%{"listing_id" => listing_id}, session, socket) do
    case connected?(socket) do
      true -> connected_mount(listing_id, session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(listing_id, session, socket) do
    user =
      if connected?(socket) && Map.has_key?(session, "user_token") do
        %{"user_token" => user_token} = session
        Accounts.get_user_by_session_token(user_token)
      end

    {:ok, assign(socket, user: user, loading: false, listing_id: listing_id)}
  end

  def render(assigns) do
    ~H"""
      <div class="max-w-3xl mx-auto">
        <%= if @loading do %>
        <% else %>
          <.live_component module={ListingsForm} id={@user.id}  user={@user} listing_id={@listing_id}/>
        <% end %>
      </div>
    """
  end
end
