defmodule PuppiesWeb.ProductComponent do
  use Phoenix.Component

  def free(assigns) do
    ~H"""
      <div class="flex-1">
        <h3 class="text-xl font-semibold text-bronze">Free</h3>
        <p class="mt-4 flex items-baseline text-gray-900">
          <span class="text-5xl font-extrabold tracking-tight">$0</span>
          <span class="ml-1 text-xl font-semibold">/365</span>
          <div class="ml-1 text-xl font-semibold"></div>
        </p>
        <p class="mt-6 text-gray-500"></p>
        <ul role="list" class="mt-6 space-y-6">
          <li class="flex">
            <svg class="flex-shrink-0 w-6 h-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
            <span class="ml-3 text-gray-500">Unlimited access to all Bronze members.</span>
          </li>
          <li class="flex">
            <svg class="flex-shrink-0 w-6 h-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
            <span class="ml-3 text-gray-500">Two Free listings.</span>
          </li>
        </ul>
      </div>
    """
  end

  def standard(assigns) do
    ~H"""
      <div class="flex-1">
        <h3 class="text-xl font-semibold text-silver">Standard</h3>
        <p class="mt-4 flex items-baseline text-gray-900">
          <span class="text-5xl font-extrabold tracking-tight">$15.00</span>
          <span class="ml-1 text-xl font-semibold">/30 Days</span>
        </p>
        <ul role="list" class="mt-6 space-y-6">
          <li class="flex">
            <svg class="flex-shrink-0 w-6 h-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
            <span class="ml-3 text-gray-500">Unlimited access to all Bronze and Silver profiles.</span>
          </li>

          <li class="flex">
            <svg class="flex-shrink-0 w-6 h-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
            <span class="ml-3 text-gray-500">We pay for phone verification</span>
          </li>

          <li class="flex">
            <svg class="flex-shrink-0 w-6 h-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
            <span class="ml-3 text-gray-500">Up to 25 listings.</span>
          </li>
        </ul>
      </div>
    """
  end

  def premium(assigns) do
    ~H"""
      <div class="flex-1">
        <h3 class="text-xl font-semibold text-gold">Premium</h3>
        <p class="mt-4 flex items-baseline text-gray-900">
          <span class="text-5xl font-extrabold tracking-tight">$40.50</span>
          <span class="ml-1 text-xl font-semibold">/90 Days</span>
          <div class="ml-1 text-xl font-semibold">Save 10%</div>
        </p>
        <ul role="list" class="mt-6 space-y-6">
          <li class="flex">
            <svg class="flex-shrink-0 w-6 h-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
            <span class="ml-3 text-gray-500">Unlimited access to all profiles.</span>
          </li>

          <li class="flex">
            <svg class="flex-shrink-0 w-6 h-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
            <span class="ml-3 text-gray-500">We pay for phone verification</span>
          </li>

          <li class="flex">
            <svg class="flex-shrink-0 w-6 h-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
            <span class="ml-3 text-gray-500">We pay for ID verification</span>
          </li>

          <li class="flex">
            <svg class="flex-shrink-0 w-6 h-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
            <span class="ml-3 text-gray-500">Up to 50 listings.</span>
          </li>

        </ul>
      </div>
    """
  end

  def id_verification(assigns) do
    ~H"""
      <div class="flex-1">
        <h3 class="text-xl font-semibold text-bronze">ID Verification</h3>
        <p class="mt-4 flex items-baseline text-gray-900">
          <span class="text-5xl font-extrabold tracking-tight">$1.99</span>
        </p>
        <p class="mt-6 text-gray-500"></p>
        <ul role="list" class="mt-6 space-y-6">
          <li class="flex">
            <svg class="flex-shrink-0 w-6 h-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
            <span class="ml-3 text-gray-500">One credit to obtain Gold reputation.</span>
          </li>
        </ul>
      </div>
    """
  end
end
