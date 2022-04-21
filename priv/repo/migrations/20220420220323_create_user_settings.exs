defmodule Puppies.Repo.Migrations.CreateUserSettings do
  use Ecto.Migration

  def change do
    create table(:user_settings) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:email_new_matches, :boolean, default: true, null: false)
      add(:email_new_favorites, :boolean, default: true, null: false)
      add(:email_offers, :boolean, default: false, true: false)
      add(:push_new_matches, :boolean, default: true, null: false)
      add(:push_new_favorites, :boolean, default: true, null: false)
      add(:push_offers, :boolean, default: false, true: false)

      timestamps()
    end
  end
end
