defmodule Puppies.Repo.Migrations.CreatePhotos do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :url, :string
      add :name, :string
      add :business_id, references(:businesses, on_delete: :nothing)
      add :listing_id, references(:listings, on_delete: :nothing)

      timestamps()
    end

    create index(:photos, [:business_id, :listing_id])
  end
end
