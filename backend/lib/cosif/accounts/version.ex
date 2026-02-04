defmodule Cosif.Accounts.Version do
  use Ecto.Schema
  import Ecto.Changeset

  schema "versions" do
    field :name, :string
    field :source_file, :string
    field :imported_at, :utc_datetime
    field :is_active, :boolean, default: false
    field :notes, :string

    has_many :accounts, Cosif.Accounts.Account
    has_many :functions, Cosif.Accounts.Function

    timestamps()
  end

  def changeset(version, attrs) do
    version
    |> cast(attrs, [:name, :source_file, :imported_at, :is_active, :notes])
    |> validate_required([:name])
  end
end
