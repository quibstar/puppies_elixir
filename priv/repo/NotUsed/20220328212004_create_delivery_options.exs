defmodule Puppies.Repo.Migrations.CreateDeliveryOptions do
  use Ecto.Migration

  def change do
    create table(:delivery_options) do
      add :option, :string

      timestamps()
    end
  end
end
