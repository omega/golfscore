use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :golf, Golf.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :golf, Golf.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "golf_dev",
  password: "golf_dev",
  database: "golf_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
