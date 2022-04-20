defmodule Puppies.Repo.Migrations.CreateListings do
  use Ecto.Migration

  def change do
    create table(:listings) do
      add(:name, :string)
      add(:dob, :date)
      add(:price, :integer)
      add(:sex, :string)
      add(:coat_color_pattern, :string)
      add(:description, :text)
      add(:status, :string)
      add(:deliver_on_site, :boolean, default: false, null: false)
      add(:deliver_pick_up, :boolean, default: false, null: false)
      add(:delivery_shipped, :boolean, default: false, null: false)
      add(:champion_sired, :boolean, default: false, null: false)
      add(:show_quality, :boolean, default: false, null: false)
      add(:champion_bloodline, :boolean, default: false, null: false)
      add(:registered, :boolean, default: false, null: false)
      add(:registrable, :boolean, default: false, null: false)
      add(:current_vaccinations, :boolean, default: false, null: false)
      add(:veterinary_exam, :boolean, default: false, null: false)
      add(:health_certificate, :boolean, default: false, null: false)
      add(:health_guarantee, :boolean, default: false, null: false)
      add(:pedigree, :boolean, default: false, null: false)
      add(:hypoallergenic, :boolean, default: false, null: false)
      add(:microchip, :boolean, default: false, null: false)
      add(:purebred, :boolean, default: true, null: false)
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:listings, [:user_id]))
  end
end
