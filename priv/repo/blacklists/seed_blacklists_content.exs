"#{__DIR__}/bad_words.csv"
|> File.read!()
|> String.split(",")
|> String.trim()
|> Enum.map(fn content ->
  Puppies.Blacklists.create_content_blacklist(%{content: String.trim(content)})
end)
