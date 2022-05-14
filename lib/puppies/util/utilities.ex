defmodule Puppies.Utilities do
  @moduledoc """
  The utilites context
  """
  def meters_to_miles(distance) when is_integer(distance) do
    distance * 1609.34
  end

  def meters_to_miles(distance) when is_binary(distance) do
    convert_string_to_integer(distance) * 1609.34
  end

  def convert_string_to_integer(item) do
    if is_binary(item) == true do
      String.to_integer(item)
    else
      item
    end
  end

  def set_offset(page, limit) do
    convert_string_to_integer(page) *
      convert_string_to_integer(limit) -
      convert_string_to_integer(limit)
  end

  def ip_to_string(ip) do
    ip |> Tuple.to_list() |> Enum.join(".")
  end

  def x_forward_or_remote_ip(conn) do
    res =
      conn.req_headers
      |> Enum.reduce(%{"x-forwarded-for": nil}, fn x, acc ->
        if elem(x, 0) == "x-forwarded-for" do
          Map.put(acc, "x-forwarded-for", elem(x, 1))
        else
          acc
        end
      end)

    if is_nil(res["x-forwarded-for"]) do
      conn.remote_ip |> ip_to_string()
    else
      res["x-forwarded-for"]
    end
  end

  def date_from_int(integer) do
    {:ok, date} = DateTime.from_unix(integer)
    date
  end

  def membership_status(user) do
    cond do
      user.membership_end_date == nil ->
        nil

      Date.compare(user.membership_end_date, DateTime.utc_now()) == :lt ->
        :expired

      Date.compare(user.membership_end_date, DateTime.utc_now()) == :gt ->
        :active
    end
  end

  def states do
    [
      %{name: "Alabama", abbreviation: "AL"},
      %{name: "Alaska", abbreviation: "AK"},
      %{name: "Arizona", abbreviation: "AZ"},
      %{name: "Arkansas", abbreviation: "AR"},
      %{name: "California", abbreviation: "CA"},
      %{name: "Colorado", abbreviation: "CO"},
      %{name: "Connecticut", abbreviation: "CT"},
      %{name: "Delaware", abbreviation: "DE"},
      %{name: "Florida", abbreviation: "FL"},
      %{name: "Georgia", abbreviation: "GA"},
      %{name: "Hawaii", abbreviation: "HI"},
      %{name: "Idaho", abbreviation: "ID"},
      %{name: "Illinois", abbreviation: "IL"},
      %{name: "Indiana", abbreviation: "IN"},
      %{name: "Iowa", abbreviation: "IA"},
      %{name: "Kansas", abbreviation: "KS"},
      %{name: "Kentucky", abbreviation: "KY"},
      %{name: "Louisiana", abbreviation: "LA"},
      %{name: "Maine", abbreviation: "ME"},
      %{name: "Maryland", abbreviation: "MD"},
      %{name: "Massachusetts", abbreviation: "MA"},
      %{name: "Michigan", abbreviation: "MI"},
      %{name: "Minnesota", abbreviation: "MN"},
      %{name: "Mississippi", abbreviation: "MS"},
      %{name: "Missouri", abbreviation: "MO"},
      %{name: "Montana", abbreviation: "MT"},
      %{name: "Nebraska", abbreviation: "NE"},
      %{name: "Nevada", abbreviation: "NV"},
      %{name: "New Hampshire", abbreviation: "NH"},
      %{name: "New Jersey", abbreviation: "NJ"},
      %{name: "New Mexico", abbreviation: "NM"},
      %{name: "New York", abbreviation: "NY"},
      %{name: "North Carolina", abbreviation: "NC"},
      %{name: "North Dakota", abbreviation: "ND"},
      %{name: "Ohio", abbreviation: "OH"},
      %{name: "Oklahoma", abbreviation: "OK"},
      %{name: "Oregon", abbreviation: "OR"},
      %{name: "Pennsylvania", abbreviation: "PA"},
      %{name: "Rhode Island", abbreviation: "RI"},
      %{name: "South Carolina", abbreviation: "SC"},
      %{name: "South Dakota", abbreviation: "SD"},
      %{name: "Tennessee", abbreviation: "TN"},
      %{name: "Texas", abbreviation: "TX"},
      %{name: "Utah", abbreviation: "UT"},
      %{name: "Vermont", abbreviation: "VT"},
      %{name: "Virginia", abbreviation: "VA"},
      %{name: "Washington", abbreviation: "WA"},
      %{name: "West Virginia", abbreviation: "WV"},
      %{name: "Wisconsin", abbreviation: "WI"},
      %{name: "Wyoming", abbreviation: "WY"}
    ]
  end

  def string_to_slug(str) do
    String.downcase(str)
    # |> String.replace(~r/[\p{P}\p{S}]/, "")
    |> String.replace(" ", "-")
  end

  def slug_to_string(str) do
    String.downcase(str) |> String.replace("-", " ")
  end

  def breed_names(breeds) do
    if length(breeds) == 1 do
      List.first(breeds).name
    else
      Enum.reduce(breeds, [], fn x, acc ->
        [x.name, acc]
      end)
      |> Enum.join(", ")
    end
  end

  def state_to_human_readable(state) do
    if String.length(state) == 2 do
      String.upcase(state) |> String.to_atom() |> PuppiesWeb.StateUtilities.abbrev_to_state()
    else
      state
    end
  end

  def integer_to_date(utc) do
    {:ok, date} = DateTime.from_unix(utc)
    date
  end

  def date_format(date) do
    {:ok, d} = NaiveDateTime.from_iso8601(date <> " 00:00:00Z")
    [year, month, day] = String.split(date, "-")

    if Date.compare(d, Date.utc_today()) == :gt do
      "Expected on: #{month}/#{day}/#{year}"
    else
      Puppies.DistanceOfTimeHelpers.time_ago_in_words(d) <> " old"
    end
  end

  def date_format_from_ecto(date) do
    if Date.compare(date, Date.utc_today()) == :gt do
      "Expected on: #{date.month}/#{date.day}/#{date.year}"
    else
      {:ok, d} = NaiveDateTime.from_iso8601(Date.to_iso8601(date) <> " 00:00:00Z")
      Puppies.DistanceOfTimeHelpers.time_ago_in_words(d) <> " old"
    end
  end

  def first_image(photos) do
    if photos != [] do
      List.first(photos).url
    else
      nil
    end
  end

  def check_for_image?(slug) do
    url = File.cwd!() <> "/priv/static/" <> slug
    File.exists?(url)
  end

  # Stats

  def members(views) do
    Enum.reduce(views, 0, fn view, acc ->
      if !is_nil(view.user_id) do
        acc + 1
      else
        acc
      end
    end)
  end

  def organic(views) do
    Enum.reduce(views, 0, fn view, acc ->
      if is_nil(view.user_id) do
        acc + 1
      else
        acc
      end
    end)
  end

  def unique(views) do
    Enum.reduce(views, 0, fn view, acc ->
      if view.unique do
        acc + 1
      else
        acc
      end
    end)
  end

  def format_short_date_time(date) do
    Calendar.strftime(date, "%m/%d/%y %I:%M:%S %p")
  end
end
