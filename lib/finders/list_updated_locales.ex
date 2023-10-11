defmodule Kanta.Sync.Translations.Locale.Finders.ListUpdatedLocales do
  @moduledoc """
  Query module aka Finder responsible for listing locales
  """

  use Kanta.Query,
    module: Kanta.Translations.Locale,
    binding: :locale

  import Kanta.Sync.Utils.QueryUtils

  def find(params \\ []) do
    base()
    |> order_by(:id)
    |> updated_since_last_fetch(:locale)
    |> paginate(params[:page], params[:per])
  end
end
