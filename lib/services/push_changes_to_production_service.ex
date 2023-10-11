defmodule Kanta.Sync.Services.PushChangesToProductionService do
  @moduledoc """
  Pushes changed data to the production environment.
  """

  alias Kanta.Sync.Adapter.Pusher
  alias Kanta.Sync.Utils.DatabasePuller
  alias Kanta.Utils.GetSchemata

  def call do
    GetSchemata.call()
    |> Enum.map(&elem(&1, 0))
    |> Enum.each(fn resource_name ->
      DatabasePuller.call(resource_name)
      |> Stream.map(&Pusher.call(resource_name, &1))
      |> Stream.run()
    end)
  end
end
