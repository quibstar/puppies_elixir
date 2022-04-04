defmodule Puppies.Repo.Migrations.CreateListingBreeds do
  use Ecto.Migration

  def change do
    create table(:listing_breeds) do
      add :breed_id, references(:breeds, on_delete: :nothing)
      add :listing_id, references(:listings, on_delete: :nothing)

      timestamps()
    end

    create index(:listing_breeds, [:breed_id])
    create index(:listing_breeds, [:listing_id])
  end
end
