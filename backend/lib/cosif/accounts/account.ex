defmodule Cosif.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :code, :string
    field :name, :string
    field :description, :string
    field :level, :integer
    field :accepts_credit, :boolean, default: false
    field :accepts_debit, :boolean, default: false
    field :is_analytical, :boolean, default: false
    field :group_code, :string
    field :subgroup_code, :string

    belongs_to :parent, __MODULE__
    belongs_to :function, Cosif.Accounts.Function
    belongs_to :version, Cosif.Accounts.Version

    has_many :children, __MODULE__, foreign_key: :parent_id

    timestamps()
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [
      :code, :name, :description, :level, :parent_id,
      :accepts_credit, :accepts_debit, :is_analytical,
      :group_code, :subgroup_code, :function_id, :version_id
    ])
    |> validate_required([:code, :name, :level, :version_id])
    |> unique_constraint([:code, :version_id])
  end
end
