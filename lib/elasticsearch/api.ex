defmodule Puppies.ES.Api do
  @moduledoc """
  Api for connecting to elastic search
  """
  def elasticsearch_endpoint(url) do
    Application.get_env(:puppies, :elasticsearch_base_url) <> url
  end

  def get(url) do
    elasticsearch_endpoint(url)
    |> HTTPoison.get(headers())
    |> response()
  end

  def put(url, body) do
    elasticsearch_endpoint(url)
    |> HTTPoison.put(Jason.encode!(body), headers())
    |> response()
  end

  def post(url, body) do
    elasticsearch_endpoint(url)
    |> HTTPoison.post(Jason.encode!(body), headers())
    |> response()
  end

  def delete(url) do
    elasticsearch_endpoint(url)
    |> HTTPoison.delete(headers())
    |> response()
  end

  def response(res) do
    case res do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 201, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 405, body: body}} ->
        {:ok, body}

      # {:ok, %HTTPoison.Response{status_code: 400}} ->
      #   {:error, "400"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp headers() do
    [{"Content-Type", "application/json"}]
  end
end
