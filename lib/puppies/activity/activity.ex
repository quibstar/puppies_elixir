defmodule Puppies.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activities" do
    field(:action, :string)
    field(:data, {:array, :map})
    field(:user_id, :id)
    field(:admin_id, :id)
    field(:description, :string)

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:user_id, :admin_id, :action, :data, :description])
    |> validate_required([:action])
  end
end
