import Config

config :kanta_sync_plugin,
  kanta_endpoint:
    System.get_env("KANTA_API_ENDPOINT") ||
      raise("Environment variable KANTA_API_ENDPOINT missing."),
  kanta_secret_token:
    System.get_env("KANTA_SECRET_TOKEN") ||
      raise("""
      Environment variable KANTA_SECRET_TOKEN missing.
      You can generate it with `mix phx.gen.auth 266`.
      Make sure to set the same environment variable in the production Kanta environment.
      """)
