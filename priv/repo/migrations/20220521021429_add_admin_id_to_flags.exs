defmodule Puppies.Repo.Migrations.AddAdminIdToFlags do
  use Ecto.Migration

  def change do
    alter table("flags") do
      add(:admin_id, :integer)
    end
  end
end
