defmodule Puppies.Repo.Migrations.CreateBusinesses do
  use Ecto.Migration

  def change do
    create table(:businesses) do
      add(:name, :string)
      add(:slug, :string)
      add(:website, :string)
      add(:phone_number, :string)
      add(:description, :text)
      add(:state_license, :boolean, default: false, null: false)
      add(:federal_license, :boolean, default: false, null: false)
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:businesses, [:user_id]))
    create(index(:businesses, [:slug]))
  end
end
