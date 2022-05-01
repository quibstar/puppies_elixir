defmodule Puppies.Verifications.ID do
  @moduledoc """
  IdVerification module
  """
  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.IdVerification

  def create_or_update_verification(attrs) do
    if verified?(attrs.user_id) do
      update_verification(attrs)
    else
      insert_verification(attrs)
    end
  end

  def verified?(user_id) do
    Repo.exists?(from(v in IdVerification, where: v.user_id == ^user_id))
  end

  def get_id_verification(user_id) do
    from(v in IdVerification, where: v.user_id == ^user_id) |> Repo.one(user_id)
  end

  def update_verification(attrs) do
    from(v in IdVerification,
      where: v.user_id == ^attrs.user_id,
      preload: [:user]
    )
    |> Repo.one()
    |> IdVerification.changeset(attrs)
    |> Repo.update()
  end

  def insert_verification(attrs) do
    IdVerification.changeset(%IdVerification{}, attrs)
    |> Repo.insert()
  end

  def process_stripe_event(stripe_event) do
    ver = %{}

    ver =
      Map.put(ver, :verification_session_id, stripe_event.data.object.id)
      |> Map.put(:status, stripe_event.data.object.status)
      |> Map.put(:user_id, stripe_event.data.object.metadata.user_id)

    if is_nil(stripe_event.data.object.last_error) do
      # clear out any previous errors
      Map.put(ver, :error_code, nil)
      |> Map.put(:error_reason, nil)
    else
      Map.put(ver, :error_code, stripe_event.data.object.last_error.code)
      |> Map.put(:error_reason, stripe_event.data.object.last_error.reason)
    end
  end

  def verification_status(user_id) do
    q =
      from(v in "id_verifications",
        where: v.user_id == ^user_id,
        select: [:status]
      )

    Repo.one(q)
  end
end
