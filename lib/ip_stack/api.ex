defmodule Puppies.IPStack.Api do
  @moduledoc """
  Api for ipstack.com
  http://api.ipstack.com/24.204.172.199?access_key=401360927b2f5772c481befa9bc793f5&format=1
  """
  def ip_stack_endpoint(ip_address) do
    key = Application.get_env(:puppies, :ip_stack_api_key)
    "http://api.ipstack.com/#{ip_address}?access_key=#{key}&format=1"
  end

  def get(ip_address) do
    ip_stack_endpoint(ip_address)
    |> HTTPoison.get(headers())
    |> response()
  end

  def response(res) do
    case res do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "404"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp headers() do
    [
      {"Content-Type", "application/json"}
    ]
  end
end
