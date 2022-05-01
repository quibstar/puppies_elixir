defmodule Puppies.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :product_id, :string
      add :price_id, :string
      add :unit_amount, :integer

      timestamps()
    end
  end
end
