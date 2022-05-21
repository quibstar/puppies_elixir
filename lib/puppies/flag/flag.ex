defmodule Puppies.Flag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "flags" do
    field(:reason, :string)
    field(:resolved, :boolean, default: false)
    field(:system_reported, :boolean, default: false)
    field(:offender_id, :id)
    field(:reporter_id, :id)
    field(:type, :string)
    field(:custom_reason, :string)
    field(:admin_id, :integer)

    has_one(:reporter, Puppies.Accounts.User,
      references: :reporter_id,
      foreign_key: :id
    )

    has_one(:admin, Puppies.Admins.Admin,
      references: :admin_id,
      foreign_key: :id
    )

    timestamps()
  end

  @doc false
  def changeset(flag, attrs) do
    flag
    |> cast(attrs, [
      :reason,
      :resolved,
      :system_reported,
      :offender_id,
      :reporter_id,
      :type,
      :custom_reason,
      :admin_id
    ])
    |> validate_required([:reason, :offender_id, :reporter_id])
    |> validate_length(:custom_reason, max: 180)
  end
end
