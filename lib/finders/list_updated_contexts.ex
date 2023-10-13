defmodule Kanta.Sync.Translations.Contexts.Finders.ListUpdatedContexts do
  @moduledoc """
  Query module aka Finder responsible for listing contexts 
  """

  use Kanta.Query,
    module: Kanta.Translations.Context,
    binding: :context

  import Kanta.Sync.Utils.QueryUtils

  def find(params \\ []) do
    base()
    |> order_by(:id)
    |> updated_since_last_fetch(:context)
    |> paginate(params[:page], params[:per])
  end
end
