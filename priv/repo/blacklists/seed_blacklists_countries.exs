"#{__DIR__}/countries.csv"
|> File.read!()
|> String.split("\n")
|> Enum.map(fn csv_line ->
  [name, code] =
    csv_line
    |> String.split(",")

  Puppies.Blacklists.create_country_blacklist(%{name: name, code: code})
end)
