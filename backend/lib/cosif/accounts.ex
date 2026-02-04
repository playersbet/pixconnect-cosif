defmodule Cosif.Accounts do
  @moduledoc """
  The Accounts context for COSIF data.
  """

  import Ecto.Query, warn: false
  alias Cosif.Repo
  alias Cosif.Accounts.{Account, Version, Function}

  # Versions

  def list_versions do
    Repo.all(from v in Version, order_by: [desc: v.inserted_at])
  end

  def get_active_version do
    Repo.one(from v in Version, where: v.is_active == true)
  end

  def get_version!(id), do: Repo.get!(Version, id)

  def create_version(attrs \\ %{}) do
    %Version{}
    |> Version.changeset(attrs)
    |> Repo.insert()
  end

  def activate_version(%Version{} = version) do
    Repo.transaction(fn ->
      # Deactivate all versions
      Repo.update_all(Version, set: [is_active: false])

      # Activate the specified version
      version
      |> Version.changeset(%{is_active: true})
      |> Repo.update!()
    end)
  end

  # Accounts

  def get_account_by_code(code, version_id \\ nil) do
    version_id = version_id || get_active_version_id()

    from(a in Account,
      where: a.code == ^code and a.version_id == ^version_id,
      preload: [:parent, :function, :children]
    )
    |> Repo.one()
  end

  def search_accounts(query, opts \\ []) do
    version_id = opts[:version_id] || get_active_version_id()
    limit = opts[:limit] || 50
    offset = opts[:offset] || 0

    base_query =
      from(a in Account,
        where: a.version_id == ^version_id,
        limit: ^limit,
        offset: ^offset
      )

    base_query
    |> apply_search_filter(query)
    |> apply_level_filter(opts[:level])
    |> apply_group_filter(opts[:group])
    |> apply_attribute_filters(opts)
    |> order_by([a], a.code)
    |> Repo.all()
  end

  def get_account_children(code, version_id \\ nil) do
    version_id = version_id || get_active_version_id()

    case get_account_by_code(code, version_id) do
      nil -> []
      account ->
        from(a in Account,
          where: a.parent_id == ^account.id,
          order_by: a.code
        )
        |> Repo.all()
    end
  end

  def get_account_ancestry(code, version_id \\ nil) do
    version_id = version_id || get_active_version_id()

    case get_account_by_code(code, version_id) do
      nil -> []
      account -> build_ancestry(account, [], MapSet.new())
    end
  end

  defp build_ancestry(%Account{parent: nil} = account, acc, _seen), do: [account | acc]
  defp build_ancestry(%Account{id: id, parent: parent} = account, acc, seen) do
    # Prevent infinite loops from circular references
    if MapSet.member?(seen, id) do
      [account | acc]
    else
      parent = Repo.preload(parent, :parent)
      # Check if parent is the same as current (self-reference)
      if parent.id == id do
        [account | acc]
      else
        build_ancestry(parent, [account | acc], MapSet.put(seen, id))
      end
    end
  end

  # Full-text search
  defp apply_search_filter(query, nil), do: query
  defp apply_search_filter(query, ""), do: query
  defp apply_search_filter(query, search_term) do
    search_query = "%#{search_term}%"

    from(a in query,
      where:
        ilike(a.name, ^search_query) or
        ilike(a.description, ^search_query) or
        ilike(a.code, ^search_query)
    )
  end

  defp apply_level_filter(query, nil), do: query
  defp apply_level_filter(query, level) do
    from(a in query, where: a.level == ^level)
  end

  defp apply_group_filter(query, nil), do: query
  defp apply_group_filter(query, group) do
    from(a in query, where: a.group_code == ^group)
  end

  defp apply_attribute_filters(query, opts) do
    query
    |> maybe_filter(:accepts_credit, opts[:accepts_credit])
    |> maybe_filter(:accepts_debit, opts[:accepts_debit])
    |> maybe_filter(:is_analytical, opts[:is_analytical])
  end

  defp maybe_filter(query, _field, nil), do: query
  defp maybe_filter(query, field, value) do
    from(a in query, where: field(a, ^field) == ^value)
  end

  defp get_active_version_id do
    case get_active_version() do
      nil -> raise "No active version found"
      version -> version.id
    end
  end

  # Functions

  def get_function_by_code(code, version_id \\ nil) do
    version_id = version_id || get_active_version_id()

    from(f in Function,
      where: f.code == ^code and f.version_id == ^version_id
    )
    |> Repo.one()
  end

  def search_functions(query, opts \\ []) do
    version_id = opts[:version_id] || get_active_version_id()
    limit = opts[:limit] || 50

    from(f in Function,
      where: f.version_id == ^version_id,
      where: ilike(f.name, ^"%#{query}%") or ilike(f.description, ^"%#{query}%"),
      limit: ^limit,
      order_by: f.code
    )
    |> Repo.all()
  end

  # Import

  def import_accounts(accounts, version_id) do
    Repo.transaction(fn ->
      Enum.each(accounts, fn account_data ->
        %Account{}
        |> Account.changeset(Map.put(account_data, :version_id, version_id))
        |> Repo.insert!()
      end)
    end)
  end
end
