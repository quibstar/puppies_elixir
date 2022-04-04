defmodule Puppies.Repo.Migrations.CreateListingStatuses do
  use Ecto.Migration

  def change do
    create table(:listing_statuses) do
      add :status, :string

      timestamps()
    end
  end
end
