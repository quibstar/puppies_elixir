defmodule Puppies.Repo.Migrations.CreateSearches do
  use Ecto.Migration

  def change do
    create table(:searches) do
      add(:search_by, :string)
      add(:breeds, {:array, :string})
      add(:state, :string)
      add(:is_filtering, :boolean, default: false, null: false)
      add(:place_id, :string)
      add(:lat, :float)
      add(:lng, :float)
      add(:place_name, :string)
      add(:distance, :integer)
      add(:order, :string)
      add(:male, :boolean, default: false, null: false)
      add(:female, :boolean, default: false, null: false)
      add(:coat_color_pattern, :string)
      add(:dob, :integer)
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
      add(:purebred, :boolean, default: false, null: false)
      add(:min_price, :integer)
      add(:max_price, :integer)
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end
  end
end
