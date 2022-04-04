defmodule PuppiesWeb.BusinessPageLive do
  use PuppiesWeb, :live_view

  alias Puppies.Accounts

  alias Puppies.Businesses

  def mount(params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(params, session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(params, session, socket) do
    user =
      if connected?(socket) && Map.has_key?(session, "user_token") do
        %{"user_token" => user_token} = session
        Accounts.get_user_by_session_token(user_token)
      end

    IO.inspect(params)
    business = Businesses.get_business_by_slug(params["slug"])
    {:ok, assign(socket, user: user, loading: false, business: business)}
  end

  def render(assigns) do
    ~H"""
      <div class="max-w-3xl mx-auto">
        <%= if @loading do %>
        <% else %>
          <%= @business.name %>
        <% end %>
      </div>
    """
  end
end
