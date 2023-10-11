defmodule Kanta.Sync.Migrations.Postgresql.V01 do
  @moduledoc """
  Kanta Sync V1 Migrations
  """

  use Ecto.Migration

  alias Kanta.Repo
  alias Kanta.Sync.Information

  @default_prefix "public"
  @kanta_sync_information "kanta_sync_information"

  def up(opts) do
    up_kanta_sync_information(opts)
  end

  def down(opts) do
    down_kanta_sync_information(opts)
  end

  defp up_kanta_sync_information(_opts) do
    create_if_not_exists table(@kanta_sync_information) do
      add(:last_fetched_at, :utc_datetime, default: fragment("CURRENT_TIMESTAMP"))
    end
  end

  defp down_kanta_sync_information(_opts) do
    drop(table(@kanta_sync_information))
  end
end
