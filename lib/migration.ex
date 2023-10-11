defmodule Kanta.Sync.Migrations do
  @moduledoc false

  defdelegate up(opts \\ []), to: Kanta.Sync.Migration
  defdelegate down(opts \\ []), to: Kanta.Sync.Migration
end

defmodule Kanta.Sync.Migration do
  @moduledoc false

  use Ecto.Migration

  @doc """
  Migrates storage up to the latest version.
  """
  @callback up(Keyword.t()) :: :ok

  @doc """
  Migrates storage down to the previous version.
  """
  @callback down(Keyword.t()) :: :ok

  @doc """
  Identifies the last migrated version.
  """
  @callback migrated_version(Keyword.t()) :: non_neg_integer()

  @doc """
  Run the `up` changes for all migrations between the initial version and the current version.

  ## Example

  Run all migrations up to the current version:

      Kanta.Sync.Migration.up()

  Run migrations up to a specified version:

      Kanta.Sync.Migration.up(version: 2)

  Run migrations in an alternate prefix:

      Kanta.Sync.Migration.up(prefix: "payments")

  Run migrations in an alternate prefix but don't try to create the schema:

      Kanta.Sync.Migration.up(prefix: "payments", create_schema: false)
  """
  def up(opts \\ []) when is_list(opts) do
    migrator().up(opts)
  end

  @doc """
  Run the `down` changes for all migrations between the current version and the initial version.

  ## Example

  Run all migrations from current version down to the first:

      Kanta.Sync.Migration.down()

  Run migrations down to and including a specified version:

      Kanta.Sync.Migration.down(version: 5)

  Run migrations in an alternate prefix:

      Kanta.Sync.Migration.down(prefix: "payments")
  """
  def down(opts \\ []) when is_list(opts) do
    migrator().down(opts)
  end

  @doc """
  Check the latest version the database is migrated to.

  ## Example

      Kanta.Sync.Migration.migrated_version()
  """
  def migrated_version(opts \\ []) when is_list(opts) do
    migrator().migrated_version(opts)
  end

  defp migrator do
    case repo().__adapter__() do
      Ecto.Adapters.Postgres -> Kanta.Sync.Migrations.Postgresql
    end
  end
end
