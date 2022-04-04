defmodule PuppiesWeb.BusinessEdit do
  use PuppiesWeb, :live_view

  alias Puppies.Accounts

  alias PuppiesWeb.{BusinessForm}

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

    {:ok, assign(socket, user: user, loading: false)}
  end

  def render(assigns) do
    ~H"""
      <div class="max-w-3xl mx-auto">
        <%= if @loading do %>
        <% else %>
          <.live_component module={BusinessForm} id={@user.id}  user={@user} />
        <% end %>
      </div>
    """
  end
end
