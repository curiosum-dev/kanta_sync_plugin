defmodule Kanta.Sync.Plugin.DashboardComponent do
  @moduledoc """
  Phoenix LiveComponent for Kanta dashboard
  """

  use Phoenix.LiveComponent

  alias Kanta.Sync.Adapter.ConnectionChecker
  alias Kanta.Sync.Services.FetchAndPopulateDatabaseService
  alias Kanta.Sync.Services.PushChangesToProductionService

  def pull_prompt_text,
    do: """
    Your environment will be populated with translations from the production environment. Are you sure?
    """

  def push_prompt_text,
    do: """
    Translations on production will be overwriten with changed translation from your environment. Are you sure?
    """

  def render(%{connected: connected, fetching: fetching, pushing: pushing} = assigns) do
    dot_color = if connected, do: "#4caf50", else: "#f44336"

    ~H"""
      <div class="col-span-2">
        <div class="bg-white dark:bg-stone-900 overflow-hidden shadow rounded-lg relative">
          <div class="absolute top-0 right-0 mt-2 mr-2 h-4 w-4 rounded-full" style={"background: #{dot_color}"}></div>
          <div class="flex flex-col items-center justify-center px-4 mt-2">
            <div class="text-slate-600 dark:text-content-light font-medium mb-3">KantaSync</div> 
            <%= if @connected do %> 
              <div class="text-sm mb-2">Connected to production.</div>
              <button
                phx-target={@myself} 
                phx-click="fetch" 
                data-confirm={pull_prompt_text()} 
                type="submit" 
                class="w-full flex items-center justify-center px-2 py-2 mb-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary dark:bg-accent-dark hover:bg-primary-dark hover:dark:bg-accent-light focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-slate-800 focus:ring-primary focus:dark:ring-accent-dark disabled:opacity-50"
                disabled={@fetching or @pushing}
              >
                <%= if @fetching do %> 
                  Fetching...
                <% else %> 
                  Fetch translations
                <% end %>
              </button>
              <button 
                phx-target={@myself} 
                phx-click="push"
                data-confirm={push_prompt_text()} 
                type="submit" 
                class="w-full flex items-center justify-center px-2 py-2 mb-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary dark:bg-accent-dark hover:bg-primary-dark hover:dark:bg-accent-light focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-slate-800 focus:ring-primary focus:dark:ring-accent-dark disabled:opacity-50"
                disabled={@fetching or @pushing}
              >
                <%= if @pushing do %>
                  Overwriting... 
                <% else %> 
                  Overwrite translations
                <% end %> 
              </button>
            <% else %> 
              <span class="text-sm">Can't connect to Kanta API endpoint</span>
            <% end %>
          </div>
        </div>
      </div>
    """
  end

  def update(%{id: id}, socket) do
    connected = ConnectionChecker.call()

    socket =
      assign(socket, id: id, connected: connected, fetching: false, pushing: false, task: nil)

    {:ok, socket}
  end

  def handle_event("fetch", _, %{assigns: assigns} = socket) do
    pid = self()

    Task.start(fn ->
      FetchAndPopulateDatabaseService.call()
      send_update(pid, __MODULE__, id: assigns.id, fetching: false)
    end)

    socket = assign(socket, fetching: true)

    {:noreply, socket}
  end

  def handle_event("push", _, %{assigns: assigns} = socket) do
    pid = self()

    Task.start(fn ->
      PushChangesToProductionService.call()
      send_update(pid, __MODULE__, id: assigns.id, fetching: false)
    end)

    socket = assign(socket, pushing: true)

    {:noreply, socket}
  end

  def handle_info({_ref, _data}, socket) do
    {:noreply, assign(socket, pushing: false, fetching: false)}
  end
end
