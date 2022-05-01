defmodule Puppies.Verifications.Phone do
  @moduledoc """
  Verification module
  """
  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.PhoneVerification

  def verified?(user_id) do
    Repo.exists?(from(v in PhoneVerification, where: v.user_id == ^user_id))
  end

  def get_phone_verification(user_id) do
    from(v in PhoneVerification, where: v.user_id == ^user_id) |> Repo.one()
  end

  def insert_verification(attrs) do
    PhoneVerification.changeset(%PhoneVerification{}, attrs)
    |> Repo.insert()
  end
end
