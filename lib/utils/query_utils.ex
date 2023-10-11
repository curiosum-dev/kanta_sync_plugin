defmodule Kanta.Sync.Utils.QueryUtils do
  @moduledoc false

  import Ecto.Query

  alias Kanta.Repo
  alias Kanta.Sync.Information

  def updated_since_last_fetch(query, binding) do
    repo = Repo.get_repo()

    last_fetched_at =
      case repo.get_by(Information, []) do
        nil ->
          DateTime.from_unix(0)

        information ->
          Map.get(information, :last_fetched_at)
      end

    where(
      query,
      [{^binding, resource}],
      field(resource, :updated_at) > ^last_fetched_at
    )
  end
end
