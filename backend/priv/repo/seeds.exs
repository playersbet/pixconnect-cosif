# Script for populating the database with COSIF data
# Run with: mix run priv/repo/seeds.exs

alias Cosif.Repo
alias Cosif.Accounts.{Account, Version, Function}

# Read the structured accounts JSON
json_path = Path.join([__DIR__, "..", "..", "..", "docs", "json", "accounts_structured.json"])

IO.puts("Reading accounts from: #{json_path}")

accounts_data =
  json_path
  |> File.read!()
  |> Jason.decode!()

IO.puts("Loaded #{length(accounts_data)} accounts")

# Delete existing data for clean re-import
IO.puts("Clearing existing data...")
Repo.delete_all(Account)
Repo.delete_all(Version)

# Create a version for this import
{:ok, version} =
  %Version{}
  |> Version.changeset(%{
    name: "COSIF 2026-02",
    source_file: "accounts_structured.json",
    imported_at: DateTime.utc_now(),
    is_active: true,
    notes: "Import from PDF conversion with descriptions"
  })
  |> Repo.insert()

IO.puts("Created version: #{version.name} (ID: #{version.id})")

# First pass: Insert all accounts without parent relationships
IO.puts("Importing accounts (first pass - no parents)...")

code_to_id =
  accounts_data
  |> Enum.with_index()
  |> Enum.reduce(%{}, fn {account_data, idx}, acc ->
    if rem(idx, 500) == 0, do: IO.puts("  Processing account #{idx + 1}...")

    {:ok, account} =
      %Account{}
      |> Account.changeset(%{
        code: account_data["code"],
        name: account_data["name"] || "Unknown",
        level: account_data["level"] || 1,
        version_id: version.id,
        description: account_data["description"],
        accepts_credit: false,
        accepts_debit: false,
        is_analytical: false,
        group_code: String.first(account_data["code"] || "0"),
        subgroup_code: account_data["base_normativa"]
      })
      |> Repo.insert()

    Map.put(acc, account_data["code"], account.id)
  end)

IO.puts("Imported #{map_size(code_to_id)} accounts")

# Second pass: Update parent relationships
IO.puts("Setting up parent relationships...")

accounts_data
|> Enum.filter(fn a -> Map.has_key?(a, "parent_code") end)
|> Enum.with_index()
|> Enum.each(fn {account_data, idx} ->
  if rem(idx, 500) == 0, do: IO.puts("  Processing relationship #{idx + 1}...")

  account_id = Map.get(code_to_id, account_data["code"])
  parent_id = Map.get(code_to_id, account_data["parent_code"])

  if account_id && parent_id do
    Repo.get!(Account, account_id)
    |> Ecto.Changeset.change(%{parent_id: parent_id})
    |> Repo.update!()
  end
end)

IO.puts("\nImport complete!")
IO.puts("Total accounts: #{Repo.aggregate(Account, :count)}")
IO.puts("Active version: #{version.name}")
