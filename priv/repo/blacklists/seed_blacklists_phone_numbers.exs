"#{__DIR__}/blocked_phone_numbers.csv"
|> File.read!()
|> String.split("\n")
|> String.trim()
|> Enum.map(fn phone ->
  Puppies.Blacklists.create_phone_blacklist(%{phone_number: phone})
end)
