defmodule Puppies.Flag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "flags" do
    field(:reason, :string)
    field(:is_open, :boolean, default: true)
    field(:system_reported, :boolean, default: false)
    field(:offender_id, :id)
    field(:reporter_id, :id)
    field(:type, :string)

    timestamps()
  end

  @doc false
  def changeset(flag, attrs) do
    flag
    |> cast(attrs, [
      :reason,
      :is_open,
      :system_reported,
      :offender_id,
      :reporter_id,
      :type
    ])
    |> validate_required([:reason, :offender_id, :reporter_id])
  end
end
