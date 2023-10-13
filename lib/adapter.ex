defmodule Kanta.Sync.Adapter do
  @moduledoc """
  Kanta Sync Adapter
  """

  use Tesla

  plug(Tesla.Middleware.BaseUrl, System.fetch_env!("KANTA_API_ENDPOINT"))

  plug(Tesla.Middleware.Headers, get_headers())

  plug(Tesla.Middleware.JSON)

  defp get_headers do
    if api_authorization_disabled?() do
      []
    else
      [{"Authorization", "Bearer #{get_bearer_token()}"}]
    end
  end

  defp get_bearer_token do
    System.fetch_env!("KANTA_SECRET_TOKEN")
    |> then(&:crypto.hash(:sha256, &1))
    |> Base.encode64()
  end

  defp api_authorization_disabled? do
    Kanta.config().disable_api_authorization
  end
end
