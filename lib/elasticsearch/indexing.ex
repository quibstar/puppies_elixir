defmodule Puppies.ES.Indexing do
  @moduledoc """
  Elaticsearch: Health check, creating indexing and deleting indexing
  """
  alias Puppies.ES.Api

  def health() do
    Api.get("/_cluster/health")
  end

  def create_index(type) do
    settings = %{
      settings: %{
        number_of_shards: 1,
        number_of_replicas: 1
      }
    }

    Api.put("/#{type}", settings)
  end

  def get_index(index) do
    Api.get("/#{index}")
  end

  def create_mappings(index, mappings) do
    Api.put("/#{index}", mappings)
  end

  def delete_index(idx) do
    Api.delete("/#{idx}")
  end

  def alias(idx, alias_name) do
    action = %{
      actions: [
        %{
          add: %{
            index: idx,
            alias: alias_name
          }
        }
      ]
    }

    Api.post("/_aliases", action)
  end
end
