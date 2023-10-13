defmodule Kanta.Sync.Translations.PluralTranslations.Finders.ListUpdatedPluralTranslations do
  @moduledoc """
  Query module aka Finder responsible for listing plural translations 
  """

  use Kanta.Query,
    module: Kanta.Translations.PluralTranslation,
    binding: :plural_translation

  import Kanta.Sync.Utils.QueryUtils

  def find(params \\ []) do
    base()
    |> order_by(:id)
    |> updated_since_last_fetch(:plural_translation)
    |> paginate(params[:page], params[:per])
  end
end
