defmodule Kanta.Sync.Translations.Messages.Finders.ListUpdatedMessages do
  @moduledoc """
  Query module aka Finder responsible for listing locales
  """

  use Kanta.Query,
    module: Kanta.Translations.Message,
    binding: :message

  import Kanta.Sync.Utils.QueryUtils

  def find(params \\ []) do
    base()
    |> order_by(:id)
    |> updated_since_last_fetch(:message)
    |> paginate(params[:page], params[:per])
  end
end
