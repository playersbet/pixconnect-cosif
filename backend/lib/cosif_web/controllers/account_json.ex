defmodule CosifWeb.AccountJSON do
  alias Cosif.Accounts.Account

  def index(%{accounts: accounts}) do
    %{data: for(account <- accounts, do: data(account))}
  end

  def show(%{account: account}) do
    %{data: data(account)}
  end

  defp data(%Account{} = account) do
    %{
      id: account.id,
      code: account.code,
      name: account.name,
      description: account.description,
      level: account.level,
      accepts_credit: account.accepts_credit,
      accepts_debit: account.accepts_debit,
      is_analytical: account.is_analytical,
      group_code: account.group_code,
      parent: parent_data(account.parent),
      children_count: length(account.children || [])
    }
  end

  defp parent_data(nil), do: nil
  defp parent_data(parent), do: %{code: parent.code, name: parent.name}
end
