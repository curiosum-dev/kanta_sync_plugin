defmodule Kanta.Sync.Information do
  @moduledoc """
  Schema containing private Kanta Sync information, including last fetch timestamp.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Kanta.Translations.Message

  @optional_fields []
  @required_fields ~w(last_fetched_at)a

  schema "kanta_sync_information" do
    field(:last_fetched_at, :utc_datetime)
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
