defmodule PuppiesWeb.Verifications do
  use Phoenix.Component
  use Phoenix.HTML

  def verifications(assigns) do
    ~H"""
      <div class="bg-white px-4 py-5 shadow sm:rounded-lg sm:px-6">

          <span class='text-lg leading-6 font-medium text-gray-900'>Reputation Level: </span>
          <%= cond do %>
              <% @user.reputation_level == 3 -> %>
                  <div class="inline-block px-4 text-sm rounded-full bg-gold mb-1 text-white">Gold</div>
                  <div class="text-sm">You have unlimited access.</div>

              <% @user.reputation_level == 2 -> %>
                  <div class="inline-block  px-2 text-sm rounded-full bg-silver mb-1 text-white">Silver</div>
                  <p class="text-sm text-gray-600">Purchase
                  <%= live_redirect "ID Credit", to: PuppiesWeb.Router.Helpers.live_path(@socket, PuppiesWeb.CheckoutLive,  "ID Verification"), class: "underline cursor-pointer"%>
                   to use to upgrade to Gold</p>


              <% @user.reputation_level == 1 -> %>
                  <div class="leading-6 inline px-2 text-sm rounded-full bg-bronze mb-1 text-white">Bronze</div>
                  <div class="my-3">
                    <%= live_component PuppiesWeb.SilverComponent, id: "silver-component", user: @user %>
                  </div>

              <% @user.reputation_level == 0 -> %>
                  <div class="text-sm text-gray-600">You need to verify your email establish Bronze reputation and be visible to the community.</div>
          <% end %>

          <p class="text-xs text-gray-500 mt-2">Learn more about our <%= link "reputation system", to: PuppiesWeb.Router.Helpers.faq_path(@socket, :index), class: "underline" %>.</p>
      </div>
    """
  end
end
