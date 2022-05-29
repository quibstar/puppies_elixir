"#{__DIR__}/blacklist_domains.csv"
|> File.read!()
|> String.split("\n")
|> Enum.filter(fn line -> String.trim(line) != "" end)
|> Enum.map(fn csv_line ->
  [_, domain, _, _] =
    csv_line
    |> String.replace("\"", "")
    |> String.replace("\n", "")
    |> String.split(",")
    |> String.trim()

  Puppies.Blacklists.create_domain_blacklist(%{domain: domain})
end)
