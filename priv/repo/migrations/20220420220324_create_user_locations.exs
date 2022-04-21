defmodule Puppies.Repo.Migrations.CreateUserLocations do
  use Ecto.Migration

  def change do
    create table(:user_locations) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:country, :string)
      add(:street_address, :string)
      add(:city, :string)
      add(:region, :string)
      add(:postal_code, :string)

      timestamps()
    end
  end
end
