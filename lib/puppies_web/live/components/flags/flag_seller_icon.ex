defmodule PuppiesWeb.FlagSellerIcon do
  @moduledoc """
  Flag component modal
  """
  use PuppiesWeb, :live_component

  alias PuppiesWeb.{UI.Modal, FlagSellerForm}

  def render(assigns) do
    ~H"""
    <div x-data="{ show_modal: false}" >
      <Modal.modal>
        <:modal_title>
          Report <%= @business.name %>
        </:modal_title>

        <:modal_body>
         <.live_component module={FlagSellerForm} id={@business.id} business={@business} user={@user} return_to={@return_to}/>
        </:modal_body>
      </Modal.modal>

      <svg  x-on:click.debounce="show_modal = !show_modal" class="w-6 h-6 mr-2 cursor-pointer" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 21v-4m0 0V5a2 2 0 012-2h6.5l1 1H21l-3 6 3 6h-8.5l-1-1H5a2 2 0 00-2 2zm9-13.5V9" />
      </svg>
    </div>
    """
  end
end
