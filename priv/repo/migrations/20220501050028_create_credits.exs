defmodule Puppies.Repo.Migrations.CreateCredits do
  use Ecto.Migration

  def change do
    create table(:verification_credits) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:type, :string)
      add(:attempts, :integer)

      timestamps()
    end
  end
end
