defmodule Kanta.Sync.Translations.SingularTranslations.Finders.ListUpdatedSingularTranslations do
  @moduledoc """
  Query module aka Finder responsible for listing locales
  """

  use Kanta.Query,
    module: Kanta.Translations.SingularTranslation,
    binding: :singular_translation

  import Kanta.Sync.Utils.QueryUtils

  def find(params \\ []) do
    base()
    |> order_by(:id)
    |> updated_since_last_fetch(:singular_translation)
    |> paginate(params[:page], params[:per])
  end
end
