defmodule Puppies.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :price_id, :string
    field :product_id, :string
    field :unit_amount, :integer

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :product_id, :price_id, :unit_amount])
    |> validate_required([:name, :product_id, :price_id, :unit_amount])
  end
end
