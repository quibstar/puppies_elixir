defmodule Puppies.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      add(:first_name, :string)
      add(:last_name, :string)
      add(:customer_id, :string)
      add(:status, :string, default: "active")
      add(:membership_end_date, :utc_datetime)
      add(:phone_number, :string)
      add(:phone_intl_format, :string)
      add(:visitor_id, :string)
      add(:terms_of_service, :boolean)
      add(:is_seller, :boolean)
      timestamps()
    end

    create unique_index(:users, [:email, :status])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end
end
