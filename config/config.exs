import Config

# Check if is loaded inside IEx instead of as a Kanta plugin. 
loaded_in_iex? = fn ->
  function_exported?(Kanta, :__info__, 1)
end

api_authorization_disabled? = fn ->
  not loaded_in_iex?.() and Kanta.config().disable_api_authorization
end

config :kanta_sync_plugin,
  kanta_endpoint:
    System.get_env("KANTA_API_ENDPOINT") || loaded_in_iex? ||
      raise("Environment variable KANTA_API_ENDPOINT missing."),
  kanta_secret_token:
    System.get_env("KANTA_SECRET_TOKEN") || loaded_in_iex? || api_authorization_disabled?.() ||
      raise("""
      Environment variable KANTA_SECRET_TOKEN missing.
      You can generate it with `mix phx.gen.auth 266`.
      Make sure to set the same environment variable in the production Kanta environment.
      """)
