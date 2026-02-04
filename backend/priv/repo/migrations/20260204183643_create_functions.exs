defmodule Cosif.Repo.Migrations.CreateFunctions do
  use Ecto.Migration

  def change do
    create table(:functions) do
      add :code, :string, null: false
      add :name, :string, null: false
      add :description, :text
      add :version_id, references(:versions, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:functions, [:code, :version_id])
    create index(:functions, [:version_id])

    # Full-text search index
    execute """
    CREATE INDEX functions_search_idx ON functions
    USING GIN (to_tsvector('portuguese', coalesce(name, '') || ' ' || coalesce(description, '')))
    """
  end
end
