defmodule Puppies.Repo.Migrations.CreateUserNotes do
  use Ecto.Migration

  def change do
    create table(:user_notes) do
      add(:note, :string)
      add(:created_by, :string)
      add(:user_id, references(:users, on_delete: :delete_all))
      timestamps()
    end
  end
end
