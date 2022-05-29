defmodule Puppies.Repo.Migrations.CreateBlacklists do
  use Ecto.Migration

  def change do
    create table(:blacklisted_countries) do
      add(:name, :string)
      add(:code, :string)
      add(:selected, :boolean, default: false)
      add(:admin_id, :integer)
      timestamps()
    end

    create(unique_index(:blacklisted_countries, [:code]))

    create table(:blacklisted_ip_addresses) do
      add(:ip_address, :string)
      add(:admin_id, :integer)
      timestamps()
    end

    create(unique_index(:blacklisted_ip_addresses, [:ip_address]))

    create table(:blacklisted_contents) do
      add(:content, :string)
      add(:admin_id, :integer)
      timestamps()
    end

    create(unique_index(:blacklisted_contents, [:content]))

    create table(:blacklisted_domains) do
      add(:domain, :string)
      add(:admin_id, :integer)
      timestamps()
    end

    create(unique_index(:blacklisted_domains, [:domain]))

    create table(:blacklisted_phones) do
      add(:phone_number, :string)
      add(:admin_id, :integer)
      timestamps()
    end

    create(unique_index(:blacklisted_phones, [:phone_number]))
  end
end
