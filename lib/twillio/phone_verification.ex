defmodule Puppies.Verifications.Twilio do
  @moduledoc """
  Module for verifying users phone number
  """

  defp account_sid do
    Application.get_env(:puppies, :twilio_account_sid)
  end

  defp auth_token do
    Application.get_env(:puppies, :twilio_auth_token)
  end

  defp service do
    Application.get_env(:puppies, :twilio_service)
  end

  defp authorization do
    {"Authorization", "Basic " <> Base.encode64("#{account_sid()}:#{auth_token()}")}
  end

  def post_phone_number(phone_number) do
    # example "+16165555555"
    res =
      HTTPoison.post(
        "https://verify.twilio.com/v2/Services/#{service()}/Verifications",
        {:form, [To: phone_number, Channel: "sms"]},
        [
          authorization(),
          {"Content-type", "application/x-www-form-urlencoded"}
        ]
      )

    case res do
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:failure, "Not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      {:ok, %HTTPoison.Response{status_code: 201}} ->
        {:ok, "Pending"}
    end
  end

  def verify_phone_number(phone_number, code) do
    case HTTPoison.post(
           "https://verify.twilio.com/v2/Services/#{service()}/VerificationCheck",
           {:form, [To: phone_number, Code: code]},
           [
             authorization(),
             {"Content-type", "application/x-www-form-urlencoded"}
           ]
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body_string}} ->
        body = Jason.decode!(body_string)
        {:ok, "Congratulation you're now silver", body["sid"]}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:failure, "Expired please try again"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
