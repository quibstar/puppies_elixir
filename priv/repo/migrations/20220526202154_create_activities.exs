defmodule Puppies.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add(:action, :string)
      add(:description, :string)
      add(:data, {:array, :map})
      add(:user_id, references(:users, on_delete: :nothing))
      add(:admin_id, references(:admins, on_delete: :nothing))

      timestamps()
    end

    create(index(:activities, [:user_id]))
    create(index(:activities, [:admin_id]))
  end
end
