# "#{__DIR__}/blacklist_domains.csv"
# |> File.read!()
# |> String.split("\n")
# |> Enum.filter(fn line -> String.trim(line) != "" end)
# |> Enum.map(fn csv_line ->
#   [_, domain, _, _] =
#     csv_line
#     |> String.replace("\"", "")
#     |> String.replace("\n", "")
#     |> String.split(",")

#   Puppies.Blacklists.create_domain_blacklist(%{domain: domain})
# end)

# "#{__DIR__}/countries.csv"
# |> File.read!()
# |> String.split("\n")
# |> Enum.map(fn csv_line ->
#   [name, code] =
#     csv_line
#     |> String.split(",")

#   Puppies.Blacklists.create_country_blacklist(%{name: name, code: code})
# end)

# "#{__DIR__}/bad_words.csv"
# |> File.read!()
# |> String.split(",")
# |> Enum.map(fn content ->
#   Puppies.Blacklists.create_content_blacklist(%{content: content})
# end)

# "#{__DIR__}/blocked_ip_addresses.csv"
# |> File.read!()
# |> String.split("\n")
# |> Enum.map(fn ip ->
#   Puppies.Blacklists.create_ip_address_blacklist(%{ip_address: ip})
# end)

"#{__DIR__}/blocked_phone_numbers.csv"
|> File.read!()
|> String.split("\n")
|> Enum.map(fn phone ->
  Puppies.Blacklists.create_phone_blacklist(%{phone_number: phone})
end)
