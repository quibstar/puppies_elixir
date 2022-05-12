defmodule Puppies.Repo.Migrations.CreatePhoneBlacklists do
  use Ecto.Migration

  def change do
    create table(:phone_blacklists) do
      add(:phone_number, :string)
      add(:phone_intl_format, :string)
      add(:admin_id, :integer)
      timestamps()
    end
  end
end
