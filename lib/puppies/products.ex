defmodule Puppies.Products do
  @moduledoc """
  Subscriptions module
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.Product

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def get_product_by_name(name) do
    from(p in Product,
      where: p.name == ^name
    )
    |> Repo.one()
  end
end
