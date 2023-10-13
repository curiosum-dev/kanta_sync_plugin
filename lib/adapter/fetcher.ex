defmodule Kanta.Sync.Adapter.Fetcher do
  @moduledoc """
  Fetches entries from the production environment.
  """

  import Kanta.Sync.Adapter

  @spec call(String.t()) :: Enumerable.t()
  def call(resource) do
    Stream.resource(
      fn -> %{"page_number" => 1, "total_pages" => :infinity} end,
      fn config ->
        case fetch_resource(resource, config) do
          nil ->
            {:halt, nil}

          %{"entries" => entries, "metadata" => metadata} ->
            {[entries], Map.update!(metadata, "page_number", &(&1 + 1))}
        end
      end,
      fn _ -> nil end
    )
  end

  defp fetch_resource(_resource, %{"page_number" => page_number, "total_pages" => total_pages})
       when page_number > total_pages do
    nil
  end

  defp fetch_resource(resource, config) do
    query = [page: config["page_number"]]

    with {:ok, %Tesla.Env{status: 200, body: body}} <- get("/#{resource}", query: query),
         %{"entries" => _entries, "metadata" => _metadata} <- body do
      body
    else
      _ -> nil
    end
  end
end
