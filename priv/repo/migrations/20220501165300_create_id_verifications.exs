defmodule Puppies.Repo.Migrations.CreateIdVerifications do
  use Ecto.Migration

  def change do
    create table(:id_verifications) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:status, :string)
      add(:verification_session_id, :string)
      add(:error_code, :string)
      add(:error_reason, :string)
      timestamps()
    end
  end
end
