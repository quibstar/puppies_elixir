defmodule PuppiesWeb.VerificationsLive do
  @moduledoc """
  Matches live view index
  """
  use PuppiesWeb, :live_view

  alias Puppies.{
    Accounts,
    Verification.Credits,
    Transactions
  }

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

    if !is_nil(user.customer_id) do
      Transactions.verify_charges_has_been_saved(user.customer_id)
    end

    id_credit = Credits.has_credit?(user.id, "ID Verification")

    if Map.has_key?(params, "gv") || user.reputation_level == 3 do
      Credits.delete_credit(user.id, "ID Verification")
    end

    {:ok,
     socket
     |> assign(:loading, false)
     |> assign(:id_credit, id_credit)
     |> assign(:user, user)}
  end

  def render(assigns) do
    ~H"""
      <div class="mx-4 h-full">
        <%= if @loading == false && !is_nil(@user)do %>
          <%= cond do %>
            <% @user.reputation_level == 0 -> %>
              <div class="h-full flex justify-center items-center mx-auto">
                <div class="text-center">
                    <svg class="mx-auto h-12 w-12 text-gray-400" xmlns="http://www.w3.org/2000/svg"  fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                    </svg>
                    <h3 class="mt-2 text-sm font-medium text-gray-900">We need to communicate.</h3>
                    <p class="mt-1 text-sm text-gray-500">
                      You need to verify your email before you can upgrade you verifications.
                    </p>
                </div>
              </div>
              <% @user.reputation_level == 1 -> %>
                <.live_component module={NeedsSilverUpgrade} id="needs-silver-upgrade" user={@user} />
              <% @user.reputation_level == 2 -> %>
                <%= if @id_credit do %>
                  <.live_component module={NeedsGoldUpgrade} id="needs-gold-upgrade" user={@user} />
                <% else %>
                  <.live_component module={SilverVerified} id="silver-verified" />
                <% end %>
              <% @user.reputation_level == 3 -> %>
                <.live_component module={GoldVerified} id="gold-verified" />
            <% true -> %>
              Contact customer support.
          <% end %>
        <% else %>
          <%= live_component PuppiesWeb.LoadingComponent,  id: :loading %>
        <% end %>
      </div>
    """
  end
end
