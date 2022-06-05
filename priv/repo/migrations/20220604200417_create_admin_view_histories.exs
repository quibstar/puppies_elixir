defmodule Puppies.Repo.Migrations.CreateAdminViewHistories do
  use Ecto.Migration

  def change do
    create table(:view_histories) do
      add(:admin_id, references(:admins, on_delete: :nothing))
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:view_histories, [:admin_id]))
    create(index(:view_histories, [:user_id]))
  end
end
