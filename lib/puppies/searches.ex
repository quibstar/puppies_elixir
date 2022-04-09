defmodule Puppies.Searches do
  @moduledoc """
  The Dogs context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.{Search}

  def create_search(attrs \\ %{}) do
    %Search{}
    |> Search.changeset(attrs)
    |> Repo.insert()
  end

  def update_search(%Search{} = search, attrs) do
    search
    |> Search.changeset(attrs)
    |> Repo.update()
  end

  def delete_search(%Search{} = search) do
    Repo.delete(search)
  end

  def change_search(%Search{} = search, attrs \\ %{}) do
    Search.changeset(search, attrs)
  end
end
