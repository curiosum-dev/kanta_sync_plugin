defmodule Kanta.Sync.Translations.Domains.Finders.ListUpdatedDomains do
  @moduledoc """
  Query module aka Finder responsible for listing locales
  """

  use Kanta.Query,
    module: Kanta.Translations.Domain,
    binding: :domain

  import Kanta.Sync.Utils.QueryUtils

  def find(params \\ []) do
    base()
    |> order_by(:id)
    |> updated_since_last_fetch(:domain)
    |> paginate(params[:page], params[:per])
  end
end
