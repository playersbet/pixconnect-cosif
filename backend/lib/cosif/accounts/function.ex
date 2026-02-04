defmodule Cosif.Accounts.Function do
  use Ecto.Schema
  import Ecto.Changeset

  schema "functions" do
    field :code, :string
    field :name, :string
    field :description, :string

    belongs_to :version, Cosif.Accounts.Version
    has_many :accounts, Cosif.Accounts.Account

    timestamps()
  end

  def changeset(function, attrs) do
    function
    |> cast(attrs, [:code, :name, :description, :version_id])
    |> validate_required([:code, :name, :version_id])
    |> unique_constraint([:code, :version_id])
  end
end
