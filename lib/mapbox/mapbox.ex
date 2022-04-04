defmodule MapBox do
  @moduledoc """
  Mapbox for getting address and places
  """
  def mapbox_address(place) do
    {:ok, place_encoded} = Jason.encode(place)
    key = Application.get_env(:puppies, :mapbox_key)

    url =
      "https://api.mapbox.com/geocoding/v5/mapbox.places/#{place_encoded}.json?country=us&types=address&autocomplete=true&access_token=#{key}"

    response(HTTPoison.get(url))
  end

  def mapbox_place(place) do
    {:ok, place_encoded} = Jason.encode(place)
    key = Application.get_env(:puppies, :mapbox_key)

    url =
      "https://api.mapbox.com/geocoding/v5/mapbox.places/#{place_encoded}.json?country=us&types=place&autocomplete=true&access_token=#{key}"

    response(HTTPoison.get(url))
  end

  def response(res) do
    case res do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, res} = Jason.decode(body)

        Enum.reduce(res["features"], [], fn x, acc ->
          coord = x["geometry"]["coordinates"]
          meta = meta_data(x)

          address = %{
            place_id: x["id"],
            place_name: x["place_name"],
            lng: List.first(coord),
            lat: List.last(coord),
            text: x["text"],
            address: x["address"]
          }

          address =
            if x["place_type"] == ["place"] do
              Map.put(
                address,
                :place_slug,
                String.replace(x["text"], " ", "-") |> String.downcase()
              )
            else
              address
            end

          addy = Map.merge(address, meta)
          acc ++ [addy]
        end)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        []

      {:error, %HTTPoison.Error{reason: _}} ->
        []
    end
  end

  def meta_data(x) do
    Enum.reduce(x["context"], %{}, fn
      x, acc ->
        cond do
          String.contains?(x["id"], "place") == true ->
            Map.put(acc, :place, x["text"])
            |> Map.put(:place_slug, String.replace(x["text"], " ", "-") |> String.downcase())

          String.contains?(x["id"], "region") == true ->
            short = String.split(x["short_code"], "-") |> List.last() |> String.downcase()
            state_slug = String.replace(x["text"], " ", "-") |> String.downcase()

            Map.put(acc, :region, x["text"])
            |> Map.put(:region_slug, state_slug)
            |> Map.put(:region_short_code, short)

          String.contains?(x["id"], "country") == true ->
            Map.put(acc, :country, x["text"])

          true ->
            acc
        end
    end)
  end

  # defp get_state_abbreviation(state) do
  #   map = %{
  #     Alabama: "AL",
  #     Alaska: "AK",
  #     Arizona: "AZ",
  #     Arkansas: "AR",
  #     California: "CA",
  #     Colorado: "CO",
  #     Connecticut: "CT",
  #     Delaware: "DE",
  #     Florida: "FL",
  #     Georgia: "GA",
  #     Hawaii: "HI",
  #     Idaho: "ID",
  #     Illinois: "IL",
  #     Indiana: "IN",
  #     Iowa: "IA",
  #     Kansas: "KS",
  #     Kentucky: "KY",
  #     Louisiana: "LA",
  #     Maine: "ME",
  #     Maryland: "MD",
  #     Massachusetts: "MA",
  #     Michigan: "MI",
  #     Minnesota: "MN",
  #     Mississippi: "MS",
  #     Missouri: "MO",
  #     Montana: "MT",
  #     Nebraska: "NE",
  #     Nevada: "NV",
  #     "New Hampshire": "NH",
  #     "New Jersey": "NJ",
  #     "New Mexico": "NM",
  #     "New York": "NY",
  #     "North Carolina": "NC",
  #     "North Dakota": "ND",
  #     Ohio: "OH",
  #     Oklahoma: "OK",
  #     Oregon: "OR",
  #     Pennsylvania: "PA",
  #     "Rhode Island": "RI",
  #     "South Carolina": "SC",
  #     "South Dakota": "SD",
  #     Tennessee: "TN",
  #     Texas: "TX",
  #     Utah: "UT",
  #     Vermont: "VT",
  #     Virginia: "VA",
  #     Washington: "WA",
  #     "West Virginia": "WV",
  #     Wisconsin: "WI",
  #     Wyoming: "WY"
  #   }

  #   Map.get(map, String.to_existing_atom(state)) |> String.downcase()
  # end
end
