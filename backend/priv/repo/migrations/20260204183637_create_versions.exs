defmodule Cosif.Repo.Migrations.CreateVersions do
  use Ecto.Migration

  def change do
    create table(:versions) do
      add :name, :string, null: false
      add :source_file, :string
      add :imported_at, :utc_datetime
      add :is_active, :boolean, default: false
      add :notes, :text

      timestamps()
    end

    create index(:versions, [:is_active])
  end
end
