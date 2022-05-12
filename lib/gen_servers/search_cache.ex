defmodule Puppies.SearchCache do
  @moduledoc """
  Caching search queries.
  """
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, %{}, name: SearchCache)
  end

  def init(state) do
    :ets.new(:search_cache, [:set, :public, :named_table])
    {:ok, state}
  end

  def put(key, params) do
    GenServer.cast(SearchCache, {:insert, {key, params}})
  end

  def lookup(key) do
    GenServer.call(SearchCache, {:lookup, key})
  end

  ##  API
  def handle_cast({:insert, {key, params}}, state) do
    :ets.insert(:search_cache, {key, params})
    {:noreply, state}
  end

  def handle_call({:lookup, key}, _from, state) do
    reply =
      case :ets.lookup(:search_cache, key) do
        [] ->
          nil

        [{_key, params}] ->
          params
      end

    {:reply, reply, state}
  end
end
