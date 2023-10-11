defmodule Kanta.Sync.Informations do
  @moduledoc false

  alias Kanta.Repo
  alias Kanta.Sync.Information

  def update_last_fetched_at do
    repo = Repo.get_repo()

    case repo.get_by(Information, []) do
      nil ->
        changeset =
          Information.changeset(%{
            last_fetched_at: DateTime.utc_now()
          })

        repo.insert!(changeset)

      information ->
        information
        |> Information.changeset(%{
          last_fetched_at: DateTime.utc_now()
        })
        |> repo.update!()
    end
  end
end
