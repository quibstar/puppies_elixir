defmodule Puppies.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :place_id, :string
      add :place_name, :string
      add :place, :string
      add :place_slug, :string
      add :region, :string
      add :region_slug, :string
      add :region_short_code, :string
      add :country, :string
      add :address, :string
      add :text, :string
      add :delete, :boolean, default: false, null: false
      add :lat, :float
      add :lng, :float
      add :business_id, references(:businesses, on_delete: :nothing)

      timestamps()
    end

    create index(:locations, [:business_id])
  end
end
