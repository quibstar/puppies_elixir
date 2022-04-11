defmodule Puppies.Repo.Migrations.CreateFavorites do
  use Ecto.Migration

  def change do
    create table(:favorites) do
      add(:user_id, references(:users, on_delete: :nothing))
      add(:listing_id, references(:listings, on_delete: :nothing))

      timestamps()
    end

    create(index(:favorites, [:user_id, :listing_id]))
  end
end
