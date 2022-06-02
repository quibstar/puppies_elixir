defmodule Puppies.Repo.Migrations.AddUniqueToProductsAndPlans do
  use Ecto.Migration

  def change do
    create(unique_index(:products, [:product_id]))
  end
end
