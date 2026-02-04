defmodule CosifWeb.FunctionController do
  use CosifWeb, :controller

  alias Cosif.Accounts

  action_fallback CosifWeb.FallbackController

  def show(conn, %{"code" => code}) do
    case Accounts.get_function_by_code(code) do
      nil -> {:error, :not_found}
      function -> render(conn, :show, function: function)
    end
  end

  def search(conn, params) do
    functions = Accounts.search_functions(
      params["q"] || "",
      limit: parse_int(params["limit"]) || 50
    )

    render(conn, :index, functions: functions)
  end

  defp parse_int(nil), do: nil
  defp parse_int(val) when is_integer(val), do: val
  defp parse_int(val) when is_binary(val) do
    case Integer.parse(val) do
      {int, _} -> int
      :error -> nil
    end
  end
end
