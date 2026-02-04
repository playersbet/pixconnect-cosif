defmodule CosifWeb.LiveSearchChannel do
  use CosifWeb, :channel

  alias Cosif.Accounts

  @impl true
  def join("live_search:lobby", _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("search", %{"query" => query}, socket) do
    # Debounce is handled client-side, but we limit results here
    results = Accounts.search_accounts(query, limit: 10)

    suggestions = Enum.map(results, fn account ->
      %{
        code: account.code,
        name: account.name,
        level: account.level
      }
    end)

    {:reply, {:ok, %{suggestions: suggestions}}, socket}
  end
end
