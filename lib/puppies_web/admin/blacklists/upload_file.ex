defmodule PuppiesWeb.Admin.UploadBlackListFile do
  @moduledoc """
  ContentBlacklist component modal
  """
  use PuppiesWeb, :live_component

  def update(assigns, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      Upload
    </div>
    """
  end
end
