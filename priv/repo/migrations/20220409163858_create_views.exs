defmodule Puppies.Repo.Migrations.CreateViews do
  use Ecto.Migration

  def change do
    create table(:views) do
      add(:user_id, references(:users, on_delete: :nothing))
      add(:listing_id, references(:listings, on_delete: :nothing))
      add(:unique, :boolean, default: false)
      timestamps()
    end

    create(index(:views, [:user_id, :listing_id]))
  end
end
