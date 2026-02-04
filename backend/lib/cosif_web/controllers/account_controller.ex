defmodule CosifWeb.AccountController do
  use CosifWeb, :controller

  alias Cosif.Accounts

  action_fallback CosifWeb.FallbackController

  def show(conn, %{"code" => code}) do
    case Accounts.get_account_by_code(code) do
      nil -> {:error, :not_found}
      account -> render(conn, :show, account: account)
    end
  end

  def search(conn, params) do
    accounts = Accounts.search_accounts(
      params["q"],
      level: parse_int(params["level"]),
      group: params["group"],
      accepts_credit: parse_bool(params["accepts_credit"]),
      accepts_debit: parse_bool(params["accepts_debit"]),
      limit: parse_int(params["limit"]) || 50,
      offset: parse_int(params["offset"]) || 0
    )

    render(conn, :index, accounts: accounts)
  end

  def children(conn, %{"code" => code}) do
    children = Accounts.get_account_children(code)
    render(conn, :index, accounts: children)
  end

  def ancestry(conn, %{"code" => code}) do
    ancestry = Accounts.get_account_ancestry(code)
    render(conn, :index, accounts: ancestry)
  end

  defp parse_int(nil), do: nil
  defp parse_int(val) when is_integer(val), do: val
  defp parse_int(val) when is_binary(val) do
    case Integer.parse(val) do
      {int, _} -> int
      :error -> nil
    end
  end

  defp parse_bool(nil), do: nil
  defp parse_bool("true"), do: true
  defp parse_bool("false"), do: false
  defp parse_bool(_), do: nil
end
