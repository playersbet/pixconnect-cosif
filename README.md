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
