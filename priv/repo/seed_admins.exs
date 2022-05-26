alias Puppies.Admins
now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

users = [
  %{
    email: "kris@vianet.us",
    first_name: "Kris",
    last_name: "Utter",
    password: "superSecret!",
    confirmed_at: now
  },
  %{
    email: "jeff@vianet.us",
    first_name: "Jeff",
    last_name: "Steinport",
    password: "superSecret!",
    confirmed_at: now
  },
  %{
    email: "tom@vianet.us",
    first_name: "tom",
    last_name: "Englesman",
    password: "superSecret!",
    confirmed_at: now
  },
  %{
    email: "tim@vianet.us",
    first_name: "tim",
    last_name: "Hansen",
    password: "superSecret!",
    confirmed_at: now
  },
  %{
    email: "torey@vianet.us",
    first_name: "torey",
    last_name: "Heinz",
    password: "superSecret!",
    confirmed_at: now
  }
]

Enum.each(users, fn x ->
  Admins.register_admin(x)
end)
