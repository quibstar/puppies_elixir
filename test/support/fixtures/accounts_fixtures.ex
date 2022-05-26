defmodule Puppies.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puppies.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "superSecret!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      first_name: "Joe",
      last_name: "Smith",
      terms_of_service: true,
      is_seller: Map.get(attrs, :is_seller, false),
      email: Map.get(attrs, :email, unique_user_email()),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Puppies.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
