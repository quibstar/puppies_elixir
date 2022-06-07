defmodule Puppies.Repo.Migrations.CreateReviewReplies do
  use Ecto.Migration

  def change do
    create table(:review_replies) do
      add(:reply, :string)
      add(:review_id, references(:reviews, on_delete: :nothing))
      timestamps()
    end

    create(index(:review_replies, [:review_id]))
  end
end
