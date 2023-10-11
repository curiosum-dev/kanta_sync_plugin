defmodule Kanta.Sync.Utils.DatabasePuller do
  @moduledoc false

  alias Kanta.Sync.Translations.Contexts.Finders.ListUpdatedContexts
  alias Kanta.Sync.Translations.Domains.Finders.ListUpdatedDomains
  alias Kanta.Sync.Translations.Locale.Finders.ListUpdatedLocales
  alias Kanta.Sync.Translations.Messages.Finders.ListUpdatedMessages
  alias Kanta.Sync.Translations.PluralTranslations.Finders.ListUpdatedPluralTranslations
  alias Kanta.Sync.Translations.SingularTranslations.Finders.ListUpdatedSingularTranslations

  @resource_to_finder %{
    "contexts" => ListUpdatedContexts,
    "domains" => ListUpdatedDomains,
    "locales" => ListUpdatedLocales,
    "messages" => ListUpdatedMessages,
    "singular_translations" => ListUpdatedSingularTranslations,
    "plural_translations" => ListUpdatedPluralTranslations
  }

  @spec call(String.t()) :: Enumerable.t()
  def call(resource) do
    finder = Map.fetch!(@resource_to_finder, resource)

    Stream.resource(
      fn -> %{page: 1} end,
      fn config ->
        case fetch_resource(finder, config) do
          nil ->
            {:halt, nil}

          %{entries: entries, metadata: %{page_number: page} = metadata} ->
            {[entries], Map.put(metadata, :page, page + 1)}
        end
      end,
      fn _ -> nil end
    )
  end

  defp fetch_resource(_finder, %{page: page, total_pages: total_pages})
       when page > total_pages do
    nil
  end

  defp fetch_resource(finder, config) do
    case finder.find(config) do
      %{entries: _entries, metadata: _metadata} = data -> data
      _ -> nil
    end
  end
end
