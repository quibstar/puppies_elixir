defmodule PuppiesWeb.VerificationsLive do
  @moduledoc """
  Matches live view index
  """
  use PuppiesWeb, :live_view

  alias Puppies.{
    Accounts,
    Profiles,
    Verifications.ID,
    Verifications.Phone,
    Verification.Credits,
    Utilities,
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
      <div class="mx-4">
      <%= if @loading == false && !is_nil(@user)do %>
          <%= cond do %>
            <% @user.reputation_level == 0 -> %>
                Need to confirm email
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
