defmodule CosifWeb.UserSocket do
  use Phoenix.Socket

  channel "live_search:*", CosifWeb.LiveSearchChannel

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end
