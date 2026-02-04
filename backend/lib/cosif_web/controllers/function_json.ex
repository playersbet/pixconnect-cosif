defmodule CosifWeb.FunctionJSON do
  alias Cosif.Accounts.Function

  def index(%{functions: functions}) do
    %{data: for(function <- functions, do: data(function))}
  end

  def show(%{function: function}) do
    %{data: data(function)}
  end

  defp data(%Function{} = function) do
    %{
      id: function.id,
      code: function.code,
      name: function.name,
      description: function.description
    }
  end
end
