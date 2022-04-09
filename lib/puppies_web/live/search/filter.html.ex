defmodule FilterComponent do
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <div class="text-primary-700 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-2 my-2">
          <div x-data="{ open: false }" class='relative'>
              <button @click="open = ! open" type="button" class="sm:text-sm flex justify-between w-full py-1 px-2 border border-transparent shadow rounded text-primary-700 bg-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                  Sex
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 block" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                  </svg>
              </button>
              <div class="top-0 absolute p-4 bg-white z-50 rounded border w-full" x-show="open"  @click.outside="open = false">
                  <%= for k <- [:male, :female, :both ] do %>
                      <div class="relative flex items-star">
                          <div class="flex items-center h-5">
                          <%= radio_button @f, :sex, k, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded" %>
                          </div>
                          <div class="ml-3 text-sm">
                              <label for={k} class="font-medium"><%= humanize(k) %></label>
                          </div>
                      </div>
                  <% end %>
              </div>
          </div>

          <div x-data="{ open: false }" class='relative'>
              <button @click="open = ! open" type="button" class="sm:text-sm flex justify-between w-full py-1 px-2 border border-transparent shadow rounded text-primary-700 bg-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                  Bloodline
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 block" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                  </svg>
              </button>
              <div class="top-0 absolute p-4 bg-white z-50 rounded border w-full" x-show="open"  @click.outside="open = false">
                  <%= for k <- [:purebred, :designer, :purebred_and_designer] do %>
                      <div class="relative flex items-star">
                          <div class="flex items-center h-5">
                          <%= radio_button @f, :bloodline, k, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded" %>
                          </div>
                          <div class="ml-3 text-sm">
                              <label for={k} class="font-medium"><%= humanize(k) %></label>
                          </div>
                      </div>
                  <% end %>
              </div>
          </div>

          <div x-data="{ open: false }" class='relative'>
              <button x-on:click="open = ! open" type="button" class="sm:text-sm flex justify-between w-full py-1 px-2 border border-transparent shadow rounded text-primary-700 bg-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                  Champion
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 block" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                  </svg>
              </button>
              <div class="top-0 absolute p-4 bg-white z-50 rounded border w-full" x-show="open"  @click.outside="open = false">
                  <%= for k <-  [:champion_sired, :show_quality, :champion_bloodline] do %>
                      <div class="relative flex items-start">
                          <div class="flex items-center h-5">
                              <%= checkbox @f, k, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded" %>
                          </div>
                          <div class="ml-3 text-sm">
                              <label for={k} class="font-medium"><%= humanize(k) %></label>
                          </div>
                      </div>
                  <% end %>
              </div>
          </div>

          <div x-data="{ open: false }" class='relative'>
              <button x-on:click="open = ! open" type="button" class="sm:text-sm flex justify-between w-full py-1 px-2 border border-transparent shadow rounded text-primary-700 bg-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                  Papers
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 block" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                  </svg>
              </button>
              <div class="top-0 absolute p-4 bg-white z-50 rounded border w-full" x-show="open"  @click.outside="open = false">
                  <%= for k <-  [:registered, :registrable, :pedigree] do %>
                      <div class="relative flex items-start">
                          <div class="flex items-center h-5">
                              <%= checkbox @f, k, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded" %>
                          </div>
                          <div class="ml-3 text-sm">
                              <label for={k} class="font-medium"><%= humanize(k) %></label>
                          </div>
                      </div>
                  <% end %>
              </div>
          </div>

          <div x-data="{ open: false }" class='relative'>
              <button x-on:click="open = ! open" type="button" class="sm:text-sm flex justify-between w-full py-1 px-2 border border-transparent shadow rounded text-primary-700 bg-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                  Health
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 block" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                  </svg>
              </button>
              <div class="top-0 absolute p-4 bg-white z-50 rounded border w-full" x-show="open"  @click.outside="open = false">
                  <%= for k <-  [:current_vaccinations, :veterinary_exam, :health_certificate, :health_guarantee] do %>
                      <div class="relative flex items-start">
                          <div class="flex items-center h-5">
                              <%= checkbox @f, k, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded" %>
                          </div>
                          <div class="ml-3 text-sm">
                              <label for={k} class="font-medium"><%= humanize(k) %></label>
                          </div>
                      </div>
                  <% end %>
              </div>
          </div>

          <div x-data="{ open: false }" class='relative'>
              <button x-on:click="open = ! open" type="button" class="sm:text-sm flex justify-between w-full py-1 px-2 border border-transparent shadow rounded text-primary-700 bg-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                  Age
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 block" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                  </svg>
              </button>
              <div class="top-0 absolute p-4 bg-white z-50 rounded border w-full" x-show="open"  @click.outside="open = false">
                  <%= select @f, :dob, [ {"", -1}, {"Not born yet", 0}, {"One week", 7}, {"Two weeks", 14},{"Three weeks", 21}, {"Month", 30}, {"Two months", 60}, {"Three months", 90}, {"Six months", 180}, {"Year+", 365}], value: Map.get(@params, "dob", -1), class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md" %>
              </div>
          </div>

          <div x-data="{ open: false }" class='relative'>
            <button x-on:click="open = ! open" type="button" class="sm:text-sm flex justify-between w-full py-1 px-2 border border-transparent shadow rounded text-primary-700 bg-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                Price Range
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 block" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                </svg>
            </button>
            <div class="top-0 absolute p-4 bg-white z-50 rounded border w-full" x-show="open"  @click.outside="open = false">
                Min:
                <%= select @f, :min_price, [ {"Any", -1}, {"$100", 100}, {"$200", 200}, {"$300", 300}, {"$400", 400}, {"$500", 500}, {"$600", 600}, {"$700", 700}, {"$800", 800}, {"$900", 900}, {"$1000", 1000}, {"$1200", 1200}, {"$1300", 1300}, {"$1400", 1400}, {"$1500", 1500}, {"$1600", 1600}, {"$1700", 1700}, {"$1800", 1800}, {"$1900", 1900}], class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md"%>
                <div class="my-2"></div>
                Max:
                <%= select @f, :max_price, [ {"$200", 200}, {"$300", 300}, {"$400", 400}, {"$500", 500}, {"$600", 600}, {"$700", 700}, {"$800", 800}, {"$900", 900}, {"$1000", 1000}, {"$1200", 1200}, {"$1300", 1300}, {"$1400", 1400}, {"$1500", 1500}, {"$1600", 1600}, {"$1700", 1700}, {"$1800", 1800}, {"$1900", 1900}, {"$2000", 2000}, {"$3000", 3000},  {"$4000", 4000},  {"$5000", 5000}, {"Any", -1}], value: Map.get(@params, "max_price", -1), class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md"%>
            </div>
          </div>
            <div x-data="{ open: false }" class='relative'>
              <button x-on:click="open = ! open" type="button" class="sm:text-sm flex justify-between w-full py-1 px-2 border border-transparent shadow rounded text-primary-700 bg-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                  Extras
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 block" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                  </svg>
              </button>
              <div class="top-0 absolute p-4 bg-white z-50 rounded border w-full" x-show="open"  @click.outside="open = false">
                  <%= for k <-  [:hypoallergenic, :microchip] do %>
                      <div class="relative flex items-start">
                          <div class="flex items-center h-5">
                              <%= checkbox @f, k, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded" %>
                          </div>
                          <div class="ml-3 text-sm">
                              <label for={k} class="font-medium"><%= humanize(k) %></label>
                          </div>
                      </div>
                  <% end %>
              </div>
          </div>
      </div>
    """
  end
end
