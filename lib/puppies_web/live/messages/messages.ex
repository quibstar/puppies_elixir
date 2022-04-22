defmodule PuppiesWeb.MessagesLive do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_view

  def render(assigns) do
    ~H"""
      <div class='flex h-full' x-data="{ open: false }">
        <ul class="flex-none w-45 border-r-[1px] bg-white">
           <li x-on:click="open = !open" class="p-4 flex rounded-lg shadow-md border border-primary-500 m-2 space-x-4">
              <img class="mx-auto w-10 h-10 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
              <div class="ml-3 flex-grow">
                <p class="text-sm text-gray-900">
                  Sadie!
                </p>
                <div class="text-xs text-gray-400">
                  04/10/2022
                </div>
              </div>
          </li>
           <li x-on:click="open = !open" class="p-4 flex rounded-lg hover:shadow-md border border-white hover:border-primary-500 m-2 space-x-4">
              <img class="mx-auto w-10 h-10 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
              <div class="ml-3 flex-grow">
                <p class="text-sm  text-gray-900">
                  Some dog name
                </p>
                <div class="text-xs text-gray-400 ">
                  04/10/2022
                </div>
              </div>
          </li>
        </ul>
        <div class="grow">
          <div class="flex h-full overflow-hidden" >
            <div class="flex-none w-45 border-r-[1px] bg-white"
              x-show="open"
              x-transition:enter="transform transition ease-in-out duration-500 sm:duration-700"
              x-transition:enter-start="-translate-x-full"
              x-transition:enter-end="translate-x-0"
              x-transition:leave="transform transition ease-in-out duration-500 sm:duration-700"
              x-transition:leave-start="translate-x-0"
              x-transition:leave-end="-translate-x-full"
            >
              <svg x-on:click="open = !open" xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 m-2 stroke-primary-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
              </svg>
              <ul >
                <li class="p-4 flex rounded-lg  hover:shadow-md border border-transparent hover:border-primary-500 m-2 space-x-4">
                    <img class="mx-auto w-10 h-10 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
                    <div class="flex-grow">
                      <p class="text-sm text-gray-900">
                        Some dog name
                      </p>
                      <p class="text-xs  text-gray-500">
                        what is up....
                      </p>
                    </div>
                    <div class="text-xs text-gray-400 mt-1">
                      04/10/2022
                    </div>
                </li>
                <li class="p-4 flex rounded-lg shadow-md border border-primary-500 m-2 space-x-4">
                    <img class="mx-auto w-10 h-10 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
                    <div class="ml-3 flex-grow">
                      <p class="text-sm  text-gray-900">
                        Some dog name
                      </p>
                      <p class="text-xs  text-gray-500">
                        I'd like to
                      </p>

                    </div>
                </li>
                <li class="p-4 flex rounded-lg hover:shadow-md border border-white hover:border-primary-500 m-2 space-x-4">
                    <img class="mx-auto w-10 h-10 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
                    <div class="ml-3 flex-grow">
                      <p class="text-sm  text-gray-900">
                        Some dog name
                      </p>
                      <p class="text-xs  text-gray-500">
                        Hey....
                      </p>
                    </div>
                </li>
              </ul>
            </div>
            <div class="relative h-full">
              <ul class="p-4 space-y-4  h-[calc(100vh-400px)] overflow-scroll">
                <li class="flex items-end">
                    <img class="mx-4 flex-none mx-auto w-10 h-10 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
                    <div class="p-4 shadow rounded text-sm bg-white">
                    1 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eget nulla ut eros pulvinar porta. Proin at arcu fringilla, imperdiet elit id, tempor erat. Curabitur feugiat id nisl vitae accumsan. Nulla pharetra magna arcu. Nam vel erat quis urna pharetra feugiat a ac nisi. Etiam pellentesque lacus non magna aliquet consequat. Duis porttitor rutrum risus, ut tincidunt ex porttitor ut. Ut id hendrerit enim. Nunc odio felis, varius et tincidunt in, finibus at augue. Sed pulvinar lorem vel sodales dignissim. Nullam sed maximus neque.
                    </div>
                </li>
                <li class="flex items-end  flex-row-reverse">
                    <img class="mx-4 flex-none mx-auto w-10 h-10 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
                    <div class="p-4 shadow rounded text-sm bg-white">
                    2 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eget nulla ut eros pulvinar porta. Proin at arcu fringilla, imperdiet elit id, tempor erat. Curabitur feugiat id nisl vitae accumsan. Nulla pharetra magna arcu. Nam vel erat quis urna pharetra feugiat a ac nisi. Etiam pellentesque lacus non magna aliquet consequat. Duis porttitor rutrum risus, ut tincidunt ex porttitor ut. Ut id hendrerit enim. Nunc odio felis, varius et tincidunt in, finibus at augue. Sed pulvinar lorem vel sodales dignissim. Nullam sed maximus neque.
                    </div>
                </li>
                <li class="flex items-end ">
                    <img class="mx-4 flex-none mx-auto w-10 h-10 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
                    <div class="p-4 shadow rounded text-sm bg-white">
                      3 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eget nulla ut eros pulvinar porta. Proin at arcu fringilla, imperdiet elit id, tempor erat. Curabitur feugiat id nisl vitae accumsan. Nulla pharetra magna arcu. Nam vel erat quis urna pharetra feugiat a ac nisi. Etiam pellentesque lacus non magna aliquet consequat. Duis porttitor rutrum risus, ut tincidunt ex porttitor ut. Ut id hendrerit enim. Nunc odio felis, varius et tincidunt in, finibus at augue. Sed pulvinar lorem vel sodales dignissim. Nullam sed maximus neque.
                    </div>
                </li>
                <li class="flex items-end ">
                    <img class="mx-4 flex-none mx-auto w-10 h-10 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
                    <div class="p-4 shadow rounded text-sm bg-white">
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eget nulla ut eros pulvinar porta. Proin at arcu fringilla, imperdiet elit id, tempor erat. Curabitur feugiat id nisl vitae accumsan. Nulla pharetra magna arcu. Nam vel erat quis urna pharetra feugiat a ac nisi. Etiam pellentesque lacus non magna aliquet consequat. Duis porttitor rutrum risus, ut tincidunt ex porttitor ut. Ut id hendrerit enim. Nunc odio felis, varius et tincidunt in, finibus at augue. Sed pulvinar lorem vel sodales dignissim. Nullam sed maximus neque.
                    </div>
                </li>
                <li class="flex items-end ">
                    <img class="mx-4 flex-none mx-auto w-10 h-10 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
                    <div class="p-4 shadow rounded text-sm bg-white">
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eget nulla ut eros pulvinar porta. Proin at arcu fringilla, imperdiet elit id, tempor erat. Curabitur feugiat id nisl vitae accumsan. Nulla pharetra magna arcu. Nam vel erat quis urna pharetra feugiat a ac nisi. Etiam pellentesque lacus non magna aliquet consequat. Duis porttitor rutrum risus, ut tincidunt ex porttitor ut. Ut id hendrerit enim. Nunc odio felis, varius et tincidunt in, finibus at augue. Sed pulvinar lorem vel sodales dignissim. Nullam sed maximus neque.
                    </div>
                </li>
                <li class="flex items-end ">
                    <img class="mx-4 flex-none mx-auto w-10 h-10 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
                    <div class="p-4 shadow rounded text-sm bg-white">
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eget nulla ut eros pulvinar porta. Proin at arcu fringilla, imperdiet elit id, tempor erat. Curabitur feugiat id nisl vitae accumsan. Nulla pharetra magna arcu. Nam vel erat quis urna pharetra feugiat a ac nisi. Etiam pellentesque lacus non magna aliquet consequat. Duis porttitor rutrum risus, ut tincidunt ex porttitor ut. Ut id hendrerit enim. Nunc odio felis, varius et tincidunt in, finibus at augue. Sed pulvinar lorem vel sodales dignissim. Nullam sed maximus neque.
                    </div>
                </li>
                <li class="flex items-end ">
                    <img class="mx-4 flex-none mx-auto w-10 h-10 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
                    <div class="p-4 shadow rounded text-sm bg-white">
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eget nulla ut eros pulvinar porta. Proin at arcu fringilla, imperdiet elit id, tempor erat. Curabitur feugiat id nisl vitae accumsan. Nulla pharetra magna arcu. Nam vel erat quis urna pharetra feugiat a ac nisi. Etiam pellentesque lacus non magna aliquet consequat. Duis porttitor rutrum risus, ut tincidunt ex porttitor ut. Ut id hendrerit enim. Nunc odio felis, varius et tincidunt in, finibus at augue. Sed pulvinar lorem vel sodales dignissim. Nullam sed maximus neque.
                    </div>
                </li>
                <li class="flex items-end ">
                    <img class="mx-4 flex-none mx-auto w-10 h-10 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
                    <div class="p-4 shadow rounded text-sm bg-white">
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eget nulla ut eros pulvinar porta. Proin at arcu fringilla, imperdiet elit id, tempor erat. Curabitur feugiat id nisl vitae accumsan. Nulla pharetra magna arcu. Nam vel erat quis urna pharetra feugiat a ac nisi. Etiam pellentesque lacus non magna aliquet consequat. Duis porttitor rutrum risus, ut tincidunt ex porttitor ut. Ut id hendrerit enim. Nunc odio felis, varius et tincidunt in, finibus at augue. Sed pulvinar lorem vel sodales dignissim. Nullam sed maximus neque.
                    </div>
                </li>
                <li class="flex items-end ">
                    <img class="mx-4 flex-none mx-auto w-10 h-10 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
                    <div class="p-4 shadow rounded text-sm bg-white">
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eget nulla ut eros pulvinar porta. Proin at arcu fringilla, imperdiet elit id, tempor erat. Curabitur feugiat id nisl vitae accumsan. Nulla pharetra magna arcu. Nam vel erat quis urna pharetra feugiat a ac nisi. Etiam pellentesque lacus non magna aliquet consequat. Duis porttitor rutrum risus, ut tincidunt ex porttitor ut. Ut id hendrerit enim. Nunc odio felis, varius et tincidunt in, finibus at augue. Sed pulvinar lorem vel sodales dignissim. Nullam sed maximus neque.
                    </div>
                </li>
                <li class="flex items-end ">
                    <img class="mx-4 flex-none mx-auto w-10 h-10 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1" src={"/uploads/dogs/#{Enum.random(1..16)}.jpg"} alt="random dog image">
                    <div class="p-4 shadow rounded text-sm bg-white">
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eget nulla ut eros pulvinar porta. Proin at arcu fringilla, imperdiet elit id, tempor erat. Curabitur feugiat id nisl vitae accumsan. Nulla pharetra magna arcu. Nam vel erat quis urna pharetra feugiat a ac nisi. Etiam pellentesque lacus non magna aliquet consequat. Duis porttitor rutrum risus, ut tincidunt ex porttitor ut. Ut id hendrerit enim. Nunc odio felis, varius et tincidunt in, finibus at augue. Sed pulvinar lorem vel sodales dignissim. Nullam sed maximus neque.
                    </div>
                </li>
              </ul>
              <div class="bg-white absolute bottom-0 w-full border-t-[1px]">

                <div class="p-4">
                  <div class="mt-1">
                    <textarea rows="4" name="comment" id="comment" class="focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"></textarea>
                    <div class="mt-4 flex justify-end">
                      <%= submit "Submit", phx_disable_with: "Saving...",  disabled: false,  class: "inline-block px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    """
  end
end
