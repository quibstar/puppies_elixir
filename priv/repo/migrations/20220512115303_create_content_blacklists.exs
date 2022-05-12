defmodule Puppies.Repo.Migrations.CreateContentBlacklists do
  use Ecto.Migration

  def change do
    create table(:content_blacklists) do
      add(:content, :string)
      add(:admin_id, :integer)
      timestamps()
    end
  end
end
