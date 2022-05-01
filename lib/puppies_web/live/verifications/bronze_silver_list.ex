defmodule BronzeSilverList do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="flex-1">
      <span class="text-xl font-semibold text-bronze">Bronze</span>
      <span class="text-xl font-semibold ">/</span>
      <span class="text-xl font-semibold text-silver">Silver</span>
    </div>
    """
  end
end
