defmodule Kanta.Sync.Adapter do
  @moduledoc """
  Kanta Sync Adapter
  """

  use Tesla

  plug(Tesla.Middleware.BaseUrl, System.fetch_env!("KANTA_API_ENDPOINT"))

  plug(Tesla.Middleware.Headers, [
    {"Authorization", "Bearer #{get_bearer_token()}"}
  ])

  plug(Tesla.Middleware.JSON)

  defp get_bearer_token do
    System.fetch_env!("KANTA_SECRET_TOKEN")
    |> then(&:crypto.hash(:sha256, &1))
    |> Base.encode64()
  end
end
