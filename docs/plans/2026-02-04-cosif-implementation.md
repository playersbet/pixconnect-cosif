# COSIF Platform Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a comprehensive COSIF search platform with Elixir/Phoenix backend, Vue frontend, and GCP deployment.

**Architecture:** Phoenix API with LiveView for real-time search, Vue 3 dashboard for interactive features, PostgreSQL for data storage with full-text search, VitePress for documentation, deployed on GCP Cloud Run.

**Tech Stack:** Elixir 1.16+, Phoenix 1.7+, PostgreSQL 15, Vue 3, Vite, VitePress, TailwindCSS, Docker, Terraform, Python (PDF conversion)

---

## Phase 0: Project Setup (Parallelizable)

### Task 0.1: Initialize Git and Create CLAUDE.md

**Files:**
- Create: `CLAUDE.md`
- Create: `.gitignore`

**Step 1: Create CLAUDE.md**

```markdown
# COSIF Platform - Claude Context

## Project Overview
Internal COSIF (Plano Contábil das Instituições do Sistema Financeiro Nacional) search platform for Brazilian financial accounting standards.

## Tech Stack
- **Backend**: Elixir 1.16+, Phoenix 1.7+
- **Frontend**: Vue 3, Vite, TailwindCSS
- **Documentation**: VitePress
- **Database**: PostgreSQL 15
- **Deployment**: GCP Cloud Run, Cloud SQL

## Key Commands
```bash
# Backend
cd backend && mix deps.get && mix ecto.setup
mix phx.server

# Frontend
cd frontend && npm install && npm run dev

# Documentation
cd docs/vitepress && npm install && npm run dev

# PDF Conversion
cd scripts && python convert_pdfs.py
```

## Account Code Format
COSIF accounts follow the pattern: `X.X.X.XX.XX.XX-X`
- Grau 1: `X.0.0.00.00.00-X` (e.g., ATIVO, PASSIVO)
- Grau 2-7: Increasingly specific subcategories
- Last digit after hyphen is check digit

## Current Status
- [ ] Phase 0: Project Setup
- [ ] Phase 1: PDF Conversion
- [ ] Phase 2: Backend Development
- [ ] Phase 3: Frontend Development
- [ ] Phase 4: Documentation
- [ ] Phase 5: Deployment
```

**Step 2: Create .gitignore**

```gitignore
# Elixir
_build/
deps/
*.ez
*.beam
erl_crash.dump
*.plt
*.plt.hash

# Phoenix
/backend/priv/static/assets/
/backend/.elixir_ls/

# Node
node_modules/
dist/
.vitepress/dist/
.vitepress/cache/

# Python
__pycache__/
*.pyc
.venv/
venv/

# Environment
.env
.env.local
.env.*.local

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Terraform
.terraform/
*.tfstate
*.tfstate.*
*.tfvars

# Logs
*.log
npm-debug.log*

# Test
/coverage/
```

**Step 3: Commit**

```bash
git add CLAUDE.md .gitignore
git commit -m "chore: add CLAUDE.md and .gitignore"
```

---

### Task 0.2: Create README.md

**Files:**
- Create: `README.md`

**Step 1: Create professional README**

```markdown
# PixConnect COSIF

<p align="center">
  <strong>Plataforma de Consulta COSIF</strong><br>
  Sistema interno de busca e referência para o Plano Contábil das Instituições do Sistema Financeiro Nacional
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Elixir-1.16+-4B275F?logo=elixir" alt="Elixir">
  <img src="https://img.shields.io/badge/Phoenix-1.7+-FD4F00?logo=phoenixframework" alt="Phoenix">
  <img src="https://img.shields.io/badge/Vue-3-4FC08D?logo=vuedotjs" alt="Vue">
  <img src="https://img.shields.io/badge/PostgreSQL-15-336791?logo=postgresql" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/GCP-Cloud%20Run-4285F4?logo=googlecloud" alt="GCP">
</p>

---

## Features

- **🔍 Live Search** - Real-time suggestions as you type
- **📊 Account Explorer** - Interactive hierarchy visualization
- **🔢 Code Lookup** - Instant account details by code
- **📝 Keyword Search** - Full-text search across descriptions
- **🎯 Attribute Filtering** - Filter by level, group, and attributes
- **💾 Saved Searches** - Save and reuse frequent queries
- **📤 Export** - Download results as CSV or JSON
- **📚 Documentation** - Searchable COSIF manual

## Quick Start

### Prerequisites

- Elixir 1.16+
- Node.js 20+
- PostgreSQL 15+
- Python 3.10+ (for PDF conversion)

### Development Setup

```bash
# Clone the repository
git clone <repository-url>
cd pixconnect-cosif

# Backend setup
cd backend
mix deps.get
mix ecto.setup
mix phx.server

# Frontend setup (new terminal)
cd frontend
npm install
npm run dev

# Documentation (new terminal)
cd docs/vitepress
npm install
npm run dev
```

### Environment Variables

```bash
# Backend (.env)
DATABASE_URL=postgres://user:pass@localhost/cosif_dev
SECRET_KEY_BASE=<generate-with-mix-phx.gen.secret>

# Frontend (.env)
VITE_API_URL=http://localhost:4000/api
VITE_WS_URL=ws://localhost:4000/socket
```

## Project Structure

```
pixconnect-cosif/
├── backend/          # Elixir/Phoenix API
├── frontend/         # Vue 3 dashboard
├── docs/
│   ├── pdfs/         # Original COSIF PDFs
│   ├── markdown/     # Converted documentation
│   ├── vitepress/    # Documentation site
│   └── plans/        # Design documents
├── scripts/          # PDF conversion tools
└── infrastructure/   # Terraform & Docker
```

## API Reference

| Endpoint | Description |
|----------|-------------|
| `GET /api/v1/accounts/:code` | Get account by code |
| `GET /api/v1/accounts/search` | Search accounts |
| `GET /api/v1/functions/:code` | Get function by code |
| `WS /socket/live_search` | Real-time search suggestions |

See [API Documentation](docs/vitepress/api.md) for full reference.

## Deployment

```bash
# Build and deploy to GCP
cd infrastructure
terraform init
terraform apply

# Or use Cloud Build
gcloud builds submit
```

## License

Internal use only. COSIF documentation © Banco Central do Brasil.
```

**Step 2: Commit**

```bash
git add README.md
git commit -m "docs: add professional README"
```

---

## Phase 1: PDF Conversion (Parallelizable)

### Task 1.1: Create PDF Conversion Script

**Files:**
- Create: `scripts/requirements.txt`
- Create: `scripts/convert_pdfs.py`
- Create: `scripts/parse_cosif.py`

**Step 1: Create requirements.txt**

```text
pdfplumber==0.10.3
tabula-py==2.9.0
pandas==2.1.4
```

**Step 2: Create convert_pdfs.py**

```python
#!/usr/bin/env python3
"""
COSIF PDF to Markdown/JSON Converter
Extracts tables and text from COSIF documentation PDFs.
"""

import os
import json
import re
from pathlib import Path
from typing import List, Dict, Any

import pdfplumber


def extract_text_from_pdf(pdf_path: str) -> str:
    """Extract all text from a PDF file."""
    text_content = []
    with pdfplumber.open(pdf_path) as pdf:
        for page in pdf.pages:
            text = page.extract_text()
            if text:
                text_content.append(text)
    return "\n\n".join(text_content)


def extract_tables_from_pdf(pdf_path: str) -> List[List[List[str]]]:
    """Extract all tables from a PDF file."""
    all_tables = []
    with pdfplumber.open(pdf_path) as pdf:
        for page in pdf.pages:
            tables = page.extract_tables()
            if tables:
                all_tables.extend(tables)
    return all_tables


def parse_account_code(code: str) -> Dict[str, Any]:
    """Parse a COSIF account code into its components."""
    # Pattern: X.X.X.XX.XX.XX-X or variations
    pattern = r'^(\d)\.(\d)\.(\d)\.(\d{2})\.(\d{2})\.(\d{2})-?(\d)?$'
    match = re.match(pattern, code.replace(' ', ''))

    if match:
        groups = match.groups()
        return {
            "code": code,
            "group": groups[0],
            "subgroup1": groups[1],
            "subgroup2": groups[2],
            "subgroup3": groups[3],
            "subgroup4": groups[4],
            "subgroup5": groups[5],
            "check_digit": groups[6] if groups[6] else None,
            "level": calculate_level(groups)
        }
    return None


def calculate_level(groups: tuple) -> int:
    """Calculate the hierarchy level based on non-zero groups."""
    level = 1
    for i, g in enumerate(groups[:6]):
        if g and g != '0' and g != '00':
            level = i + 1
    return min(level, 7)


def convert_to_markdown(pdf_name: str, text: str, tables: List) -> str:
    """Convert extracted content to Markdown format."""
    md_content = [f"# {pdf_name.replace('.pdf', '').replace('_', ' ').title()}\n"]

    # Add text content
    if text:
        md_content.append("## Conteúdo\n")
        md_content.append(text)

    # Add tables
    if tables:
        md_content.append("\n## Tabelas\n")
        for i, table in enumerate(tables):
            if table and len(table) > 1:
                md_content.append(f"\n### Tabela {i + 1}\n")
                # Header row
                header = table[0]
                md_content.append("| " + " | ".join(str(h or '') for h in header) + " |")
                md_content.append("|" + "|".join(["---"] * len(header)) + "|")
                # Data rows
                for row in table[1:]:
                    md_content.append("| " + " | ".join(str(c or '') for c in row) + " |")

    return "\n".join(md_content)


def main():
    """Main conversion function."""
    docs_dir = Path(__file__).parent.parent / "docs"
    pdfs_dir = docs_dir / "pdfs"
    markdown_dir = docs_dir / "markdown"
    json_dir = docs_dir / "json"

    # Create output directories
    markdown_dir.mkdir(exist_ok=True)
    json_dir.mkdir(exist_ok=True)

    # Move existing PDFs to pdfs subdirectory
    pdfs_dir.mkdir(exist_ok=True)
    for pdf in docs_dir.glob("*.pdf"):
        pdf.rename(pdfs_dir / pdf.name)

    # Process each PDF
    for pdf_file in pdfs_dir.glob("*.pdf"):
        print(f"Processing: {pdf_file.name}")

        # Extract content
        text = extract_text_from_pdf(str(pdf_file))
        tables = extract_tables_from_pdf(str(pdf_file))

        # Save as Markdown
        md_content = convert_to_markdown(pdf_file.name, text, tables)
        md_path = markdown_dir / f"{pdf_file.stem}.md"
        md_path.write_text(md_content, encoding='utf-8')
        print(f"  Created: {md_path}")

        # Save raw data as JSON
        json_data = {
            "source": pdf_file.name,
            "text": text,
            "tables": tables
        }
        json_path = json_dir / f"{pdf_file.stem}.json"
        json_path.write_text(json.dumps(json_data, ensure_ascii=False, indent=2), encoding='utf-8')
        print(f"  Created: {json_path}")

    print("\nConversion complete!")


if __name__ == "__main__":
    main()
```

**Step 3: Create parse_cosif.py for structured account extraction**

```python
#!/usr/bin/env python3
"""
Parse COSIF accounts from converted JSON files into database-ready format.
"""

import json
import re
from pathlib import Path
from typing import List, Dict, Optional


def parse_account_line(line: str) -> Optional[Dict]:
    """Parse a single account line from COSIF documents."""
    # Pattern for account codes like "1.0.0.00.00.00-9" or "1.1.1.10.01.10-001"
    pattern = r'^(\d+(?:\.\d+)*(?:-\d+)?)\s+(.+)$'
    match = re.match(pattern, line.strip())

    if match:
        code = match.group(1)
        name = match.group(2).strip()
        return {
            "code": code,
            "name": name,
            "level": calculate_account_level(code)
        }
    return None


def calculate_account_level(code: str) -> int:
    """Calculate hierarchy level from account code."""
    # Remove check digit suffix
    base_code = code.split('-')[0] if '-' in code else code
    parts = base_code.split('.')

    level = 1
    for i, part in enumerate(parts):
        if part != '0' and part != '00':
            level = i + 1

    return min(level, 7)


def extract_accounts_from_json(json_path: Path) -> List[Dict]:
    """Extract account information from a converted JSON file."""
    accounts = []

    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # Parse text content for account patterns
    if data.get('text'):
        for line in data['text'].split('\n'):
            account = parse_account_line(line)
            if account:
                accounts.append(account)

    # Parse tables for structured account data
    if data.get('tables'):
        for table in data['tables']:
            for row in table:
                if row and len(row) >= 2:
                    # Try to parse first column as code, second as name
                    code_cell = str(row[0] or '').strip()
                    name_cell = str(row[1] or '').strip()

                    if re.match(r'^\d+\.\d+', code_cell):
                        accounts.append({
                            "code": code_cell,
                            "name": name_cell,
                            "level": calculate_account_level(code_cell)
                        })

    return accounts


def build_hierarchy(accounts: List[Dict]) -> List[Dict]:
    """Build parent-child relationships for accounts."""
    # Sort by code to ensure parents come before children
    accounts = sorted(accounts, key=lambda x: x['code'])

    # Create lookup by code
    code_to_account = {a['code']: a for a in accounts}

    for account in accounts:
        code = account['code']
        # Find parent by looking for shorter matching prefix
        parts = code.split('.')
        for i in range(len(parts) - 1, 0, -1):
            parent_code = '.'.join(parts[:i])
            if parent_code in code_to_account:
                account['parent_code'] = parent_code
                break

    return accounts


def main():
    """Process all JSON files and output structured accounts."""
    docs_dir = Path(__file__).parent.parent / "docs"
    json_dir = docs_dir / "json"
    output_path = json_dir / "accounts_structured.json"

    all_accounts = []

    for json_file in json_dir.glob("*.json"):
        if json_file.name == "accounts_structured.json":
            continue

        print(f"Parsing: {json_file.name}")
        accounts = extract_accounts_from_json(json_file)
        all_accounts.extend(accounts)
        print(f"  Found {len(accounts)} accounts")

    # Remove duplicates by code
    unique_accounts = {}
    for account in all_accounts:
        code = account['code']
        if code not in unique_accounts:
            unique_accounts[code] = account

    accounts_list = list(unique_accounts.values())
    accounts_list = build_hierarchy(accounts_list)

    # Save structured output
    output_path.write_text(
        json.dumps(accounts_list, ensure_ascii=False, indent=2),
        encoding='utf-8'
    )
    print(f"\nSaved {len(accounts_list)} unique accounts to {output_path}")


if __name__ == "__main__":
    main()
```

**Step 4: Commit**

```bash
git add scripts/
git commit -m "feat: add PDF conversion scripts"
```

---

## Phase 2: Backend Development

### Task 2.1: Initialize Phoenix Project

**Files:**
- Create: `backend/` (Phoenix project)

**Step 1: Create Phoenix project**

```bash
cd /Users/felipesantiago/Documents/pixconnect-cosif
mix phx.new backend --app cosif --database postgres --no-html --no-assets --no-mailer
```

**Step 2: Configure database in config/dev.exs**

Update `backend/config/dev.exs`:

```elixir
config :cosif, Cosif.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "cosif_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

**Step 3: Commit**

```bash
git add backend/
git commit -m "feat: initialize Phoenix backend"
```

---

### Task 2.2: Create Database Schema

**Files:**
- Create: `backend/priv/repo/migrations/TIMESTAMP_create_versions.exs`
- Create: `backend/priv/repo/migrations/TIMESTAMP_create_accounts.exs`
- Create: `backend/priv/repo/migrations/TIMESTAMP_create_functions.exs`
- Create: `backend/lib/cosif/accounts/account.ex`
- Create: `backend/lib/cosif/accounts/version.ex`
- Create: `backend/lib/cosif/accounts/function.ex`

**Step 1: Generate migrations**

```bash
cd backend
mix ecto.gen.migration create_versions
mix ecto.gen.migration create_accounts
mix ecto.gen.migration create_functions
```

**Step 2: Create versions migration**

```elixir
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
```

**Step 3: Create accounts migration**

```elixir
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
```

**Step 4: Create functions migration**

```elixir
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
```

**Step 5: Create Ecto schemas**

Create `backend/lib/cosif/accounts/version.ex`:

```elixir
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
```

Create `backend/lib/cosif/accounts/account.ex`:

```elixir
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
```

Create `backend/lib/cosif/accounts/function.ex`:

```elixir
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
```

**Step 6: Run migrations**

```bash
mix ecto.create
mix ecto.migrate
```

**Step 7: Commit**

```bash
git add backend/priv/repo/migrations/ backend/lib/cosif/accounts/
git commit -m "feat: add database schema for accounts, functions, and versions"
```

---

### Task 2.3: Create Accounts Context

**Files:**
- Create: `backend/lib/cosif/accounts.ex`

**Step 1: Create accounts context**

```elixir
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
      account -> build_ancestry(account, [])
    end
  end

  defp build_ancestry(%Account{parent: nil} = account, acc), do: [account | acc]
  defp build_ancestry(%Account{parent: parent} = account, acc) do
    parent = Repo.preload(parent, :parent)
    build_ancestry(parent, [account | acc])
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
```

**Step 2: Commit**

```bash
git add backend/lib/cosif/accounts.ex
git commit -m "feat: add Accounts context with search functionality"
```

---

### Task 2.4: Create API Controllers

**Files:**
- Create: `backend/lib/cosif_web/controllers/account_controller.ex`
- Create: `backend/lib/cosif_web/controllers/account_json.ex`
- Create: `backend/lib/cosif_web/controllers/function_controller.ex`
- Create: `backend/lib/cosif_web/controllers/function_json.ex`
- Modify: `backend/lib/cosif_web/router.ex`

**Step 1: Create AccountController**

```elixir
defmodule CosifWeb.AccountController do
  use CosifWeb, :controller

  alias Cosif.Accounts

  action_fallback CosifWeb.FallbackController

  def show(conn, %{"code" => code}) do
    case Accounts.get_account_by_code(code) do
      nil -> {:error, :not_found}
      account -> render(conn, :show, account: account)
    end
  end

  def search(conn, params) do
    accounts = Accounts.search_accounts(
      params["q"],
      level: parse_int(params["level"]),
      group: params["group"],
      accepts_credit: parse_bool(params["accepts_credit"]),
      accepts_debit: parse_bool(params["accepts_debit"]),
      limit: parse_int(params["limit"]) || 50,
      offset: parse_int(params["offset"]) || 0
    )

    render(conn, :index, accounts: accounts)
  end

  def children(conn, %{"code" => code}) do
    children = Accounts.get_account_children(code)
    render(conn, :index, accounts: children)
  end

  def ancestry(conn, %{"code" => code}) do
    ancestry = Accounts.get_account_ancestry(code)
    render(conn, :index, accounts: ancestry)
  end

  defp parse_int(nil), do: nil
  defp parse_int(val) when is_integer(val), do: val
  defp parse_int(val) when is_binary(val) do
    case Integer.parse(val) do
      {int, _} -> int
      :error -> nil
    end
  end

  defp parse_bool(nil), do: nil
  defp parse_bool("true"), do: true
  defp parse_bool("false"), do: false
  defp parse_bool(_), do: nil
end
```

**Step 2: Create AccountJSON view**

```elixir
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
```

**Step 3: Update router**

```elixir
defmodule CosifWeb.Router do
  use CosifWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", CosifWeb do
    pipe_through :api

    get "/accounts/search", AccountController, :search
    get "/accounts/:code", AccountController, :show
    get "/accounts/:code/children", AccountController, :children
    get "/accounts/:code/ancestry", AccountController, :ancestry

    get "/functions/search", FunctionController, :search
    get "/functions/:code", FunctionController, :show
  end
end
```

**Step 4: Commit**

```bash
git add backend/lib/cosif_web/
git commit -m "feat: add API controllers for accounts and functions"
```

---

### Task 2.5: Create LiveView Channel for Live Search

**Files:**
- Create: `backend/lib/cosif_web/channels/live_search_channel.ex`
- Modify: `backend/lib/cosif_web/channels/user_socket.ex`

**Step 1: Create LiveSearchChannel**

```elixir
defmodule CosifWeb.LiveSearchChannel do
  use CosifWeb, :channel

  alias Cosif.Accounts

  @impl true
  def join("live_search:lobby", _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("search", %{"query" => query}, socket) do
    # Debounce is handled client-side, but we limit results here
    results = Accounts.search_accounts(query, limit: 10)

    suggestions = Enum.map(results, fn account ->
      %{
        code: account.code,
        name: account.name,
        level: account.level
      }
    end)

    {:reply, {:ok, %{suggestions: suggestions}}, socket}
  end
end
```

**Step 2: Update UserSocket**

```elixir
defmodule CosifWeb.UserSocket do
  use Phoenix.Socket

  channel "live_search:*", CosifWeb.LiveSearchChannel

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end
```

**Step 3: Commit**

```bash
git add backend/lib/cosif_web/channels/
git commit -m "feat: add LiveSearch WebSocket channel"
```

---

## Phase 3: Frontend Development

### Task 3.1: Initialize Vue Project

**Files:**
- Create: `frontend/` (Vue project)

**Step 1: Create Vue project with Vite**

```bash
cd /Users/felipesantiago/Documents/pixconnect-cosif
npm create vite@latest frontend -- --template vue-ts
cd frontend
npm install
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
npm install pinia @vueuse/core phoenix
```

**Step 2: Configure Tailwind**

Update `frontend/tailwind.config.js`:

```javascript
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

**Step 3: Add Tailwind to CSS**

Update `frontend/src/style.css`:

```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

**Step 4: Commit**

```bash
git add frontend/
git commit -m "feat: initialize Vue frontend with Vite and Tailwind"
```

---

### Task 3.2: Create API Service and Phoenix Socket Client

**Files:**
- Create: `frontend/src/services/api.ts`
- Create: `frontend/src/services/socket.ts`

**Step 1: Create API service**

```typescript
// frontend/src/services/api.ts
const API_BASE = import.meta.env.VITE_API_URL || 'http://localhost:4000/api/v1';

export interface Account {
  id: number;
  code: string;
  name: string;
  description?: string;
  level: number;
  accepts_credit: boolean;
  accepts_debit: boolean;
  is_analytical: boolean;
  group_code?: string;
  parent?: { code: string; name: string };
  children_count: number;
}

export interface SearchParams {
  q?: string;
  level?: number;
  group?: string;
  accepts_credit?: boolean;
  accepts_debit?: boolean;
  limit?: number;
  offset?: number;
}

async function fetchJson<T>(url: string): Promise<T> {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  return response.json();
}

export const accountsApi = {
  async getByCode(code: string): Promise<{ data: Account }> {
    return fetchJson(`${API_BASE}/accounts/${encodeURIComponent(code)}`);
  },

  async search(params: SearchParams): Promise<{ data: Account[] }> {
    const query = new URLSearchParams();
    Object.entries(params).forEach(([key, value]) => {
      if (value !== undefined && value !== null) {
        query.set(key, String(value));
      }
    });
    return fetchJson(`${API_BASE}/accounts/search?${query}`);
  },

  async getChildren(code: string): Promise<{ data: Account[] }> {
    return fetchJson(`${API_BASE}/accounts/${encodeURIComponent(code)}/children`);
  },

  async getAncestry(code: string): Promise<{ data: Account[] }> {
    return fetchJson(`${API_BASE}/accounts/${encodeURIComponent(code)}/ancestry`);
  },
};
```

**Step 2: Create Phoenix Socket client**

```typescript
// frontend/src/services/socket.ts
import { Socket, Channel } from 'phoenix';

const WS_URL = import.meta.env.VITE_WS_URL || 'ws://localhost:4000/socket';

let socket: Socket | null = null;
let searchChannel: Channel | null = null;

export function connectSocket(): Socket {
  if (socket) return socket;

  socket = new Socket(WS_URL, {});
  socket.connect();

  return socket;
}

export function joinSearchChannel(): Channel {
  if (searchChannel) return searchChannel;

  const sock = connectSocket();
  searchChannel = sock.channel('live_search:lobby', {});

  searchChannel
    .join()
    .receive('ok', () => console.log('Joined live_search channel'))
    .receive('error', (resp) => console.error('Unable to join', resp));

  return searchChannel;
}

export interface SearchSuggestion {
  code: string;
  name: string;
  level: number;
}

export function liveSearch(
  query: string,
  callback: (suggestions: SearchSuggestion[]) => void
): void {
  const channel = joinSearchChannel();

  channel
    .push('search', { query })
    .receive('ok', (response) => {
      callback(response.suggestions);
    })
    .receive('error', (err) => {
      console.error('Search error:', err);
      callback([]);
    });
}
```

**Step 3: Commit**

```bash
git add frontend/src/services/
git commit -m "feat: add API service and Phoenix socket client"
```

---

### Task 3.3: Create Pinia Store

**Files:**
- Create: `frontend/src/stores/accounts.ts`
- Create: `frontend/src/stores/index.ts`

**Step 1: Create accounts store**

```typescript
// frontend/src/stores/accounts.ts
import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import { accountsApi, type Account, type SearchParams } from '@/services/api';
import { liveSearch, type SearchSuggestion } from '@/services/socket';

export const useAccountsStore = defineStore('accounts', () => {
  // State
  const accounts = ref<Account[]>([]);
  const currentAccount = ref<Account | null>(null);
  const suggestions = ref<SearchSuggestion[]>([]);
  const loading = ref(false);
  const error = ref<string | null>(null);
  const searchQuery = ref('');
  const filters = ref<SearchParams>({});

  // Actions
  async function search(params: SearchParams) {
    loading.value = true;
    error.value = null;

    try {
      const response = await accountsApi.search(params);
      accounts.value = response.data;
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Search failed';
    } finally {
      loading.value = false;
    }
  }

  async function getAccount(code: string) {
    loading.value = true;
    error.value = null;

    try {
      const response = await accountsApi.getByCode(code);
      currentAccount.value = response.data;
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to load account';
    } finally {
      loading.value = false;
    }
  }

  function updateSuggestions(query: string) {
    searchQuery.value = query;
    if (query.length < 2) {
      suggestions.value = [];
      return;
    }

    liveSearch(query, (results) => {
      suggestions.value = results;
    });
  }

  function clearSuggestions() {
    suggestions.value = [];
  }

  function setFilters(newFilters: SearchParams) {
    filters.value = { ...filters.value, ...newFilters };
  }

  function clearFilters() {
    filters.value = {};
  }

  return {
    // State
    accounts,
    currentAccount,
    suggestions,
    loading,
    error,
    searchQuery,
    filters,

    // Actions
    search,
    getAccount,
    updateSuggestions,
    clearSuggestions,
    setFilters,
    clearFilters,
  };
});
```

**Step 2: Create store index**

```typescript
// frontend/src/stores/index.ts
import { createPinia } from 'pinia';

export const pinia = createPinia();

export * from './accounts';
```

**Step 3: Commit**

```bash
git add frontend/src/stores/
git commit -m "feat: add Pinia store for accounts"
```

---

### Task 3.4: Create Vue Components

**Files:**
- Create: `frontend/src/components/SearchBar.vue`
- Create: `frontend/src/components/AccountCard.vue`
- Create: `frontend/src/components/FilterPanel.vue`
- Create: `frontend/src/components/AccountTree.vue`

**Step 1: Create SearchBar component**

```vue
<!-- frontend/src/components/SearchBar.vue -->
<script setup lang="ts">
import { ref, watch } from 'vue';
import { useDebounceFn } from '@vueuse/core';
import { useAccountsStore } from '@/stores/accounts';

const store = useAccountsStore();
const inputRef = ref<HTMLInputElement | null>(null);
const showSuggestions = ref(false);

const debouncedSearch = useDebounceFn((query: string) => {
  store.updateSuggestions(query);
}, 150);

function onInput(event: Event) {
  const value = (event.target as HTMLInputElement).value;
  debouncedSearch(value);
  showSuggestions.value = true;
}

function selectSuggestion(code: string) {
  store.getAccount(code);
  showSuggestions.value = false;
  if (inputRef.value) {
    inputRef.value.value = code;
  }
}

function onSubmit() {
  showSuggestions.value = false;
  store.search({ q: store.searchQuery, ...store.filters });
}
</script>

<template>
  <div class="relative w-full max-w-2xl">
    <form @submit.prevent="onSubmit" class="flex gap-2">
      <input
        ref="inputRef"
        type="text"
        placeholder="Buscar conta, código ou descrição..."
        class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
        @input="onInput"
        @focus="showSuggestions = true"
        @blur="() => setTimeout(() => showSuggestions = false, 200)"
      />
      <button
        type="submit"
        class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
      >
        Buscar
      </button>
    </form>

    <!-- Suggestions dropdown -->
    <div
      v-if="showSuggestions && store.suggestions.length > 0"
      class="absolute z-10 w-full mt-1 bg-white border border-gray-200 rounded-lg shadow-lg max-h-64 overflow-y-auto"
    >
      <button
        v-for="suggestion in store.suggestions"
        :key="suggestion.code"
        class="w-full px-4 py-2 text-left hover:bg-gray-100 flex justify-between items-center"
        @click="selectSuggestion(suggestion.code)"
      >
        <span class="font-mono text-sm text-gray-600">{{ suggestion.code }}</span>
        <span class="text-gray-800 truncate ml-2">{{ suggestion.name }}</span>
      </button>
    </div>
  </div>
</template>
```

**Step 2: Create AccountCard component**

```vue
<!-- frontend/src/components/AccountCard.vue -->
<script setup lang="ts">
import type { Account } from '@/services/api';

defineProps<{
  account: Account;
}>();

defineEmits<{
  (e: 'select', code: string): void;
}>();
</script>

<template>
  <div
    class="p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition cursor-pointer"
    @click="$emit('select', account.code)"
  >
    <div class="flex justify-between items-start mb-2">
      <span class="font-mono text-sm text-blue-600 font-semibold">
        {{ account.code }}
      </span>
      <span class="text-xs px-2 py-1 bg-gray-100 rounded">
        Nível {{ account.level }}
      </span>
    </div>

    <h3 class="text-lg font-medium text-gray-900 mb-1">
      {{ account.name }}
    </h3>

    <p v-if="account.description" class="text-sm text-gray-600 line-clamp-2">
      {{ account.description }}
    </p>

    <div class="mt-3 flex gap-2">
      <span
        v-if="account.accepts_credit"
        class="text-xs px-2 py-1 bg-green-100 text-green-800 rounded"
      >
        Crédito
      </span>
      <span
        v-if="account.accepts_debit"
        class="text-xs px-2 py-1 bg-red-100 text-red-800 rounded"
      >
        Débito
      </span>
      <span
        v-if="account.is_analytical"
        class="text-xs px-2 py-1 bg-purple-100 text-purple-800 rounded"
      >
        Analítica
      </span>
    </div>
  </div>
</template>
```

**Step 3: Commit**

```bash
git add frontend/src/components/
git commit -m "feat: add Vue components for search and account display"
```

---

### Task 3.5: Create Main App Layout

**Files:**
- Modify: `frontend/src/App.vue`
- Create: `frontend/src/views/SearchView.vue`

**Step 1: Update App.vue**

```vue
<!-- frontend/src/App.vue -->
<script setup lang="ts">
import { RouterView } from 'vue-router';
</script>

<template>
  <div class="min-h-screen bg-gray-50">
    <header class="bg-white shadow-sm border-b">
      <div class="max-w-7xl mx-auto px-4 py-4">
        <div class="flex justify-between items-center">
          <h1 class="text-2xl font-bold text-gray-900">
            COSIF
          </h1>
          <nav class="flex gap-4">
            <router-link
              to="/"
              class="text-gray-600 hover:text-gray-900"
            >
              Busca
            </router-link>
            <router-link
              to="/explorer"
              class="text-gray-600 hover:text-gray-900"
            >
              Explorador
            </router-link>
            <router-link
              to="/docs"
              class="text-gray-600 hover:text-gray-900"
            >
              Documentação
            </router-link>
          </nav>
        </div>
      </div>
    </header>

    <main class="max-w-7xl mx-auto px-4 py-8">
      <RouterView />
    </main>
  </div>
</template>
```

**Step 2: Create SearchView**

```vue
<!-- frontend/src/views/SearchView.vue -->
<script setup lang="ts">
import { useAccountsStore } from '@/stores/accounts';
import SearchBar from '@/components/SearchBar.vue';
import AccountCard from '@/components/AccountCard.vue';

const store = useAccountsStore();

function handleAccountSelect(code: string) {
  store.getAccount(code);
}
</script>

<template>
  <div class="space-y-8">
    <!-- Search Section -->
    <section class="flex flex-col items-center py-8">
      <h2 class="text-3xl font-bold text-gray-900 mb-6">
        Busca de Contas COSIF
      </h2>
      <SearchBar />
    </section>

    <!-- Results Section -->
    <section v-if="store.loading" class="text-center py-8">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
      <p class="mt-4 text-gray-600">Carregando...</p>
    </section>

    <section v-else-if="store.error" class="text-center py-8">
      <p class="text-red-600">{{ store.error }}</p>
    </section>

    <section v-else-if="store.accounts.length > 0" class="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
      <AccountCard
        v-for="account in store.accounts"
        :key="account.id"
        :account="account"
        @select="handleAccountSelect"
      />
    </section>

    <!-- Current Account Detail -->
    <section
      v-if="store.currentAccount"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4"
      @click.self="store.currentAccount = null"
    >
      <div class="bg-white rounded-lg shadow-xl max-w-2xl w-full max-h-[80vh] overflow-y-auto p-6">
        <div class="flex justify-between items-start mb-4">
          <span class="font-mono text-xl text-blue-600">
            {{ store.currentAccount.code }}
          </span>
          <button
            class="text-gray-400 hover:text-gray-600"
            @click="store.currentAccount = null"
          >
            ✕
          </button>
        </div>

        <h3 class="text-2xl font-bold text-gray-900 mb-4">
          {{ store.currentAccount.name }}
        </h3>

        <p v-if="store.currentAccount.description" class="text-gray-600 mb-4">
          {{ store.currentAccount.description }}
        </p>

        <dl class="grid grid-cols-2 gap-4 text-sm">
          <div>
            <dt class="text-gray-500">Nível</dt>
            <dd class="font-medium">{{ store.currentAccount.level }}</dd>
          </div>
          <div>
            <dt class="text-gray-500">Grupo</dt>
            <dd class="font-medium">{{ store.currentAccount.group_code || '-' }}</dd>
          </div>
          <div>
            <dt class="text-gray-500">Aceita Crédito</dt>
            <dd class="font-medium">{{ store.currentAccount.accepts_credit ? 'Sim' : 'Não' }}</dd>
          </div>
          <div>
            <dt class="text-gray-500">Aceita Débito</dt>
            <dd class="font-medium">{{ store.currentAccount.accepts_debit ? 'Sim' : 'Não' }}</dd>
          </div>
        </dl>

        <div v-if="store.currentAccount.parent" class="mt-4 pt-4 border-t">
          <p class="text-sm text-gray-500">Conta Pai:</p>
          <p class="font-mono text-sm">
            {{ store.currentAccount.parent.code }} - {{ store.currentAccount.parent.name }}
          </p>
        </div>
      </div>
    </section>
  </div>
</template>
```

**Step 3: Commit**

```bash
git add frontend/src/App.vue frontend/src/views/
git commit -m "feat: add main app layout and search view"
```

---

## Phase 4: VitePress Documentation

### Task 4.1: Initialize VitePress

**Files:**
- Create: `docs/vitepress/` (VitePress project)

**Step 1: Create VitePress project**

```bash
cd /Users/felipesantiago/Documents/pixconnect-cosif/docs
mkdir vitepress && cd vitepress
npm init -y
npm install -D vitepress
```

**Step 2: Create VitePress config**

Create `docs/vitepress/.vitepress/config.ts`:

```typescript
import { defineConfig } from 'vitepress';

export default defineConfig({
  title: 'COSIF Documentation',
  description: 'Plano Contábil das Instituições do Sistema Financeiro Nacional',
  lang: 'pt-BR',

  themeConfig: {
    nav: [
      { text: 'Manual', link: '/manual/' },
      { text: 'Contas', link: '/contas/' },
      { text: 'Funções', link: '/funcoes/' },
      { text: 'API', link: '/api/' },
    ],

    sidebar: {
      '/manual/': [
        {
          text: 'Manual COSIF',
          items: [
            { text: 'Introdução', link: '/manual/' },
            { text: 'Estrutura', link: '/manual/estrutura' },
          ],
        },
      ],
      '/contas/': [
        {
          text: 'Plano de Contas',
          items: [
            { text: 'Visão Geral', link: '/contas/' },
            { text: 'Ativo', link: '/contas/ativo' },
            { text: 'Passivo', link: '/contas/passivo' },
          ],
        },
      ],
    },

    search: {
      provider: 'local',
    },
  },
});
```

**Step 3: Create index page**

Create `docs/vitepress/index.md`:

```markdown
---
layout: home
hero:
  name: COSIF
  text: Plano Contábil das Instituições do Sistema Financeiro Nacional
  tagline: Documentação completa e pesquisável
  actions:
    - theme: brand
      text: Manual COSIF
      link: /manual/
    - theme: alt
      text: Plano de Contas
      link: /contas/

features:
  - title: Busca Rápida
    details: Encontre contas e funções instantaneamente com nossa busca em tempo real.
  - title: Hierarquia Visual
    details: Explore a estrutura de contas através de uma interface interativa.
  - title: API Documentada
    details: Integre o COSIF aos seus sistemas através da nossa API RESTful.
---
```

**Step 4: Commit**

```bash
git add docs/vitepress/
git commit -m "feat: initialize VitePress documentation"
```

---

## Phase 5: Infrastructure & Deployment

### Task 5.1: Create Docker Configuration

**Files:**
- Create: `infrastructure/Dockerfile`
- Create: `docker-compose.yml`

**Step 1: Create backend Dockerfile**

```dockerfile
# infrastructure/Dockerfile
FROM elixir:1.16-alpine AS builder

RUN apk add --no-cache build-base git

WORKDIR /app

ENV MIX_ENV=prod

COPY backend/mix.exs backend/mix.lock ./
RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get --only prod
RUN mix deps.compile

COPY backend/config config/
COPY backend/lib lib/
COPY backend/priv priv/

RUN mix compile
RUN mix release

# Runtime
FROM alpine:3.18

RUN apk add --no-cache libstdc++ openssl ncurses-libs

WORKDIR /app

COPY --from=builder /app/_build/prod/rel/cosif ./

ENV HOME=/app
ENV PORT=4000

EXPOSE 4000

CMD ["bin/cosif", "start"]
```

**Step 2: Create docker-compose.yml**

```yaml
version: '3.8'

services:
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: cosif_dev
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  backend:
    build:
      context: .
      dockerfile: infrastructure/Dockerfile
    environment:
      DATABASE_URL: postgres://postgres:postgres@db/cosif_dev
      SECRET_KEY_BASE: ${SECRET_KEY_BASE}
      PHX_HOST: localhost
    ports:
      - "4000:4000"
    depends_on:
      - db

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:80"
    depends_on:
      - backend

volumes:
  postgres_data:
```

**Step 3: Commit**

```bash
git add infrastructure/ docker-compose.yml
git commit -m "feat: add Docker configuration"
```

---

### Task 5.2: Create Terraform Configuration

**Files:**
- Create: `infrastructure/terraform/main.tf`
- Create: `infrastructure/terraform/variables.tf`

**Step 1: Create main.tf**

```hcl
# infrastructure/terraform/main.tf
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Cloud SQL
resource "google_sql_database_instance" "cosif" {
  name             = "cosif-postgres"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = true
    }

    backup_configuration {
      enabled = true
    }
  }

  deletion_protection = false
}

resource "google_sql_database" "cosif" {
  name     = "cosif"
  instance = google_sql_database_instance.cosif.name
}

resource "google_sql_user" "cosif" {
  name     = "cosif"
  instance = google_sql_database_instance.cosif.name
  password = var.db_password
}

# Cloud Run
resource "google_cloud_run_service" "backend" {
  name     = "cosif-backend"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/cosif-backend:latest"

        env {
          name  = "DATABASE_URL"
          value = "postgres://cosif:${var.db_password}@/${google_sql_database.cosif.name}?host=/cloudsql/${google_sql_database_instance.cosif.connection_name}"
        }

        env {
          name  = "SECRET_KEY_BASE"
          value = var.secret_key_base
        }

        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
        }
      }

      service_account_name = google_service_account.backend.email
    }

    metadata {
      annotations = {
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.cosif.connection_name
        "autoscaling.knative.dev/minScale"      = "1"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Service Account
resource "google_service_account" "backend" {
  account_id   = "cosif-backend"
  display_name = "COSIF Backend Service Account"
}

# IAM
resource "google_cloud_run_service_iam_member" "invoker" {
  service  = google_cloud_run_service.backend.name
  location = google_cloud_run_service.backend.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Cloud Storage for frontend
resource "google_storage_bucket" "frontend" {
  name     = "${var.project_id}-cosif-frontend"
  location = var.region

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }

  cors {
    origin          = ["*"]
    method          = ["GET"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

resource "google_storage_bucket_iam_member" "frontend_public" {
  bucket = google_storage_bucket.frontend.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

output "backend_url" {
  value = google_cloud_run_service.backend.status[0].url
}

output "frontend_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.frontend.name}/index.html"
}
```

**Step 2: Create variables.tf**

```hcl
# infrastructure/terraform/variables.tf
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "secret_key_base" {
  description = "Phoenix secret key base"
  type        = string
  sensitive   = true
}
```

**Step 3: Commit**

```bash
git add infrastructure/terraform/
git commit -m "feat: add Terraform configuration for GCP"
```

---

## Summary

This plan is designed for **maximum parallelization**:

**Phase 0** (Project Setup): Tasks 0.1, 0.2 can run in parallel
**Phase 1** (PDF Conversion): Task 1.1 runs independently
**Phase 2** (Backend): Tasks 2.1-2.5 are sequential (dependencies)
**Phase 3** (Frontend): Tasks 3.1-3.5 can start after backend APIs exist
**Phase 4** (Documentation): Task 4.1 runs independently
**Phase 5** (Infrastructure): Tasks 5.1-5.2 run independently

**Parallel Execution Groups:**
1. Group A: Tasks 0.1, 0.2, 1.1, 4.1, 5.1, 5.2 (all independent)
2. Group B: Tasks 2.1 → 2.2 → 2.3 → 2.4 → 2.5 (sequential)
3. Group C: Tasks 3.1 → 3.2 → 3.3 → 3.4 → 3.5 (after 2.4 completes)

Total: 15 tasks, estimated parallel execution time significantly reduced by running independent tasks simultaneously.
