defmodule Puppies.Repo.Migrations.PhoneVerifications do
  use Ecto.Migration

  def change do
    create table(:phone_verifications) do
      add(:sid, :string)
      add(:user_id, references(:users, on_delete: :delete_all))

      timestamps()
    end
  end
end
