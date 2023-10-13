defmodule Kanta.Sync.Plugin do
  @moduledoc """
  Documentation for `KantaSyncPlugin`.
  """

  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name])
  end

  def init(_opts) do
    {:ok, %{}}
  end
end
