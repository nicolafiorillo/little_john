
import Config

config :little_john,
  port: (System.get_env("PORT") || "8080") |> String.to_integer()
