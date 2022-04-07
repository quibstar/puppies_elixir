defmodule FilterComponent do
  use PuppiesWeb, :live_component

  """
  :coat_color_pattern,

  :dob,


  :purebred,
  """

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
                  <%= for k <- [:male, :female] do %>
                      <div class="relative flex items-star">
                          <div class="flex items-center h-5">
                          <%= checkbox :search, :sex, name: "search[sex][]", checked: Enum.member?(Map.get(@params, "sex", []), "#{k}"), checked_value: k, hidden_input: false, value: k, id: "sex-#{k}", class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded" %>
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
                          <%= checkbox :search, :bloodline, name: "search[bloodline][]", checked: Enum.member?(Map.get(@params, "delivery", []), "#{k}"), checked_value: k, hidden_input: false, value: k, id: "delivery-#{k}", class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded" %>
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
                              <%= checkbox :search, :champion, name: "search[champion][]", checked_value: k, hidden_input: false, checked: Enum.member?(Map.get(@params, "champion", []), "#{k}"), value: k, id: "champion-#{k}", class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded" %>
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
                              <%= checkbox :search, :papers, name: "search[papers][]", checked_value: k, hidden_input: false, checked: Enum.member?(Map.get(@params, "papers", []), "#{k}"), value: k, id: "papers-#{k}", class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded" %>
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
                  <%= for k <-  [ :current_vaccinations, :veterinary_exam, :health_certificate, :health_guarantee] do %>
                      <div class="relative flex items-start">
                          <div class="flex items-center h-5">
                              <%= checkbox :search, :health, name: "search[health][]", checked_value: k, hidden_input: false, checked: Enum.member?(Map.get(@params, "health", []), "#{k}"), value: k, id: "health-#{k}", class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded" %>
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
                  <%= select :search, :min_price, [ {"Not born yet", 0}, {"Week", 7}, {"Two weeks", 14}, {"Month", 30}, {"Two months", 60}, {"Three months", 90}, {"Six months", 180}, {"Year+", 365}], class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md", selected: Map.get(@params, "age", "0") %>
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
                <%= select :search, :min_price, [ {"$100", 100}, {"$200", 200}, {"$300", 300}, {"$400", 400}, {"$500", 500}, {"$600", 600}, {"$700", 700}, {"$800", 800}, {"$900", 900}, {"$1000", 1000}, {"$1200", 1200}, {"$1300", 1300}, {"$1400", 1400}, {"$1500", 1500}, {"$1600", 1600}, {"$1700", 1700}, {"$1800", 1800}, {"$1900", 1900}], class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md", selected: Map.get(@params, "min_price", "100") %>
                <div class="my-2"></div>
                Max:
                <%= select :search, :max_price, [ {"$200", 200}, {"$300", 300}, {"$400", 400}, {"$500", 500}, {"$600", 600}, {"$700", 700}, {"$800", 800}, {"$900", 900}, {"$1000", 1000}, {"$1200", 1200}, {"$1300", 1300}, {"$1400", 1400}, {"$1500", 1500}, {"$1600", 1600}, {"$1700", 1700}, {"$1800", 1800}, {"$1900", 1900}, {"$2000+", 2000}], class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md", selected:  Map.get(@params, "max_price", "2000") %>
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
                              <%= checkbox :search, :extras, name: "search[extras][]", checked_value: k, hidden_input: false, checked: Enum.member?(Map.get(@params, "extras", []), "#{k}"), value: k, id: "extras-#{k}", class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded" %>
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
