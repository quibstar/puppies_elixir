"#{__DIR__}/blocked_ip_addresses.csv"
|> File.read!()
|> String.split("\n")
|> Enum.map(fn ip ->
  Puppies.Blacklists.create_ip_address_blacklist(%{ip_address: ip})
end)
