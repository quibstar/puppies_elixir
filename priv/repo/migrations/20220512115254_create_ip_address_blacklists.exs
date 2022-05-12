defmodule Puppies.Repo.Migrations.CreateIpAddressBlacklists do
  use Ecto.Migration

  def change do
    create table(:ip_address_blacklists) do
      add(:ip_address, :string)
      add(:admin_id, :integer)
      timestamps()
    end
  end
end
