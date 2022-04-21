defmodule Puppies.Repo.Migrations.AddUserIdToPhotos do
  use Ecto.Migration

  def change do
    alter table("photos") do
      add(:user_id, :integer)
    end
  end
end
