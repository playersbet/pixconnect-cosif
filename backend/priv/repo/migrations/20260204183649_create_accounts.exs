defmodule Cosif.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :code, :string, null: false
      add :name, :string, null: false
      add :description, :text
      add :level, :integer, null: false
      add :parent_id, references(:accounts, on_delete: :nilify_all)
      add :accepts_credit, :boolean, default: false
      add :accepts_debit, :boolean, default: false
      add :is_analytical, :boolean, default: false
      add :group_code, :string
      add :subgroup_code, :string
      add :function_id, references(:functions, on_delete: :nilify_all)
      add :version_id, references(:versions, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:accounts, [:code, :version_id])
    create index(:accounts, [:level])
    create index(:accounts, [:parent_id])
    create index(:accounts, [:version_id])
    create index(:accounts, [:group_code])

    # Full-text search index
    execute """
    CREATE INDEX accounts_search_idx ON accounts
    USING GIN (to_tsvector('portuguese', coalesce(name, '') || ' ' || coalesce(description, '')))
    """
  end
end
