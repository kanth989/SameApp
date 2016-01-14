use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :frdapp, Frdapp.Endpoint,
  secret_key_base: "f1UgTzOMgL0vVdx303XKTVhoCPMYRZDVhrtQLvf8eR2GDBUvWKFMXNwWVeFZTWHq"

# Configure your database
config :frdapp, Frdapp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "frdapp_prod",
  pool_size: 20
