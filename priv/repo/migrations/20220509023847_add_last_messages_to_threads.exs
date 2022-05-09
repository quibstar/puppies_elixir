defmodule Puppies.Repo.Migrations.AddLastMessagesToThreads do
  use Ecto.Migration

  def change do
    alter table("threads") do
      add(:last_message, :string)
    end
  end
end
