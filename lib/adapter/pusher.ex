defmodule Kanta.Sync.Adapter.Pusher do
  @moduledoc """
  Pushes entries to the production environment.
  """

  import Kanta.Sync.Adapter

  @spec call(String.t(), [map()]) :: Enumerable.t()
  def call(resource, entries) when is_list(entries) do
    data = %{entries: entries}

    {:ok, %Tesla.Env{status: 200}} = patch("/#{resource}/0", data)
  end
end
