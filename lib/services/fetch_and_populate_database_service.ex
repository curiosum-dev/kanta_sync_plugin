defmodule Kanta.Sync.Services.FetchAndPopulateDatabaseService do
  @moduledoc """
  Populates the database with data from the production environment.
  """

  import Kanta.Repo

  alias Kanta.Sync.Adapter.Fetcher
  alias Kanta.Sync.Informations
  alias Kanta.Utils.{DatabasePopulator, GetSchemata}

  def call do
    repo = get_repo()

    repo.transaction(fn ->
      GetSchemata.call()
      |> Enum.each(fn {resource_name, _opts} ->
        Fetcher.call(resource_name)
        |> Stream.each(&DatabasePopulator.call(repo, resource_name, &1))
        |> Stream.run()
      end)

      Informations.update_last_fetched_at()
    end)
  end
end
