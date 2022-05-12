defmodule Puppies.Repo.Migrations.CreateEmailBlacklists do
  use Ecto.Migration

  def change do
    create table(:email_blacklists) do
      add(:domain, :string)
      add(:admin_id, :integer)
      timestamps()
    end
  end
end
