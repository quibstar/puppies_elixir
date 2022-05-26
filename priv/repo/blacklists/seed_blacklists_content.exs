"#{__DIR__}/bad_words.csv"
|> File.read!()
|> String.split(",")
|> Enum.map(fn content ->
  Puppies.Blacklists.create_content_blacklist(%{content: String.trim(content)})
end)
