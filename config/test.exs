import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :puppies, Puppies.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "puppies_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :puppies, PuppiesWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "p0mgadRC3LK1rM/o/togTqyxsPLCZdYsun6iWd+ocmVyLWLiXkZR4mD3Z5ecIf0y",
  server: false

# In test we don't send emails.
config :puppies, Puppies.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :puppies,
  elasticsearch_base_url: "http://localhost:9200"

# config/test.exs
config :puppies, Oban, testing: true
