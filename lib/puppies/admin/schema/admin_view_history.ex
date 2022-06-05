defmodule Puppies.Admin.ViewHistory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "view_histories" do
    field(:admin_id, :id)
    # field(:user_id, :id)
    belongs_to(:user, Puppies.Accounts.User)
    timestamps()
  end

  @doc false
  def changeset(admin_view_history, attrs) do
    admin_view_history
    |> cast(attrs, [:user_id, :admin_id])
    |> validate_required([])
  end
end
