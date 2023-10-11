# KantaSyncPlugin

This plugin allows easily synchronizing translations from your dev/staging environment, directly into the production.

## Installation

Add KantaSync to your deps list:
```elixir
def deps do
  [
    {:kanta_sync_plugin, "~> 0.1.0"}
  ]
end
```

Create a new migration file and add the KantaSync migrations setup:

```elixir 
defmodule KantaTest.Repo.Migrations.AddKantaSyncTables do
  use Ecto.Migration

  def up do
    Kanta.Sync.Migration.up(version: 1)
  end

  def down do
    Kanta.Sync.Migration.down(version: 1)
  end
end
```

KantaSync creates table `kanta_sync_information` where information about the last fetch from the production is stored, to send only necessary changes instead of a full translations list when synchronizing. 

Make sure that you have the Kanta API endpoint configured:

```elixir
scope "/" do 
  kanta_api("/kanta-api")
end 
```

## Environment variables

- `KANTA_API_ENDPOINT`
  Full path to Kanta API endpoint. 
  Example: `KANTA_API_ENDPOINT=https://kanta.curiosum.com/kanta-api`
- `KANTA_SECRET_TOKEN`
  Secret token allowing communication between production and staging/dev environments. Should be generated with `mix phx.gen.secret 256`.
  **Both environments must have the same `KANTA_SECRET_TOKEN` environment variables.**

