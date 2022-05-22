defmodule Puppies.Repo.Migrations.CreateIpData do
  use Ecto.Migration

  def change do
    create table(:ip_data) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:ip, :string)
      add(:type, :string)
      add(:continent_code, :string)
      add(:continent_name, :string)
      add(:country_code, :string)
      add(:country_name, :string)
      add(:region_code, :string)
      add(:region_name, :string)
      add(:city, :string)
      add(:zip, :string)
      add(:latitude, :float)
      add(:longitude, :float)
      add(:country_flag, :string)
      add(:time_zone, :string)
      add(:isp, :string)

      timestamps()
    end

    create(index(:ip_data, [:ip]))
  end
end
