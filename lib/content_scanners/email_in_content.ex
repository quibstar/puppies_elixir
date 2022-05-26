defmodule Puppies.EmailInContent do
  @moduledoc """
  Documentation for `Scanner`.
  """

  alias Puppies.Flags

  def profile_has_unknown_email_in_content(content, user) do
    if content_contains_email_not_associated_to_user(content, user.email) do
      check_for_flag("unknown_email_in_content", user)
    end
  end

  defp check_for_flag(type, user) do
    exists =
      Flags.check_for_flag(%{
        "offender_id" => user.id,
        "reason" => "Email in content is not the same as #{user.email}"
      })

    if !exists do
      create_flag(type, user)
    end
  end

  defp create_flag(type, user) do
    Flags.create(%{
      system_reported: true,
      offender_id: user.id,
      reason: "Email in content is not the same as #{user.email}",
      type: type
    })
  end

  # scan content for email not belonging to user
  def get_emails_in_content(string) do
    String.split(string)
    |> Enum.reduce([], fn x, acc ->
      if x =~ "@" do
        [x | acc]
      else
        acc
      end
    end)
  end

  def content_contains_email_not_associated_to_user(content, email) do
    res =
      get_emails_in_content(content)
      |> Enum.reduce(0, fn string, acc ->
        if string != email do
          acc + 1
        else
          acc
        end
      end)

    if res == 0 do
      false
    else
      true
    end
  end
end
