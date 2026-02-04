# COSIF - Plano Contábil das Instituições Financeiras

<p align="center">
  <img src="docs/vitepress/public/logo.svg" alt="COSIF Logo" width="120" height="120">
</p>

<p align="center">
  <strong>Plataforma completa para consulta e documentação do COSIF</strong><br>
  Sistema de busca, API REST e documentação interativa para o Plano Contábil das Instituições do Sistema Financeiro Nacional
</p>

<p align="center">
  <a href="https://cosif-web-26932950797.us-central1.run.app/"><img src="https://img.shields.io/badge/Frontend-Live-success?style=flat-square" alt="Frontend"></a>
  <a href="https://cosif-web-26932950797.us-central1.run.app/docs/"><img src="https://img.shields.io/badge/Docs-Live-blue?style=flat-square" alt="Documentation"></a>
  <a href="https://cosif-backend-26932950797.us-central1.run.app/api/v1/accounts/search?q=caixa"><img src="https://img.shields.io/badge/API-Live-orange?style=flat-square" alt="API"></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Elixir-1.16+-4B275F?logo=elixir&logoColor=white" alt="Elixir">
  <img src="https://img.shields.io/badge/Phoenix-1.7+-FD4F00?logo=phoenixframework&logoColor=white" alt="Phoenix">
  <img src="https://img.shields.io/badge/Vue.js-3.x-4FC08D?logo=vuedotjs&logoColor=white" alt="Vue">
  <img src="https://img.shields.io/badge/PostgreSQL-15+-336791?logo=postgresql&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/GCP-Cloud%20Run-4285F4?logo=googlecloud&logoColor=white" alt="GCP">
  <img src="https://img.shields.io/badge/VitePress-1.6-646CFF?logo=vite&logoColor=white" alt="VitePress">
</p>

---

## Live Demo

| Component | URL | Description |
|-----------|-----|-------------|
| **Frontend** | [cosif-web.run.app](https://cosif-web-26932950797.us-central1.run.app/) | Vue 3 dashboard with live search |
| **Documentation** | [cosif-web.run.app/docs](https://cosif-web-26932950797.us-central1.run.app/docs/) | Complete COSIF documentation |
| **API** | [cosif-backend.run.app](https://cosif-backend-26932950797.us-central1.run.app/api/v1/accounts/search?q=caixa) | REST API for account queries |

---

## Features

### Search & Discovery
- **Live Search** - Real-time suggestions with WebSocket support
- **Full-Text Search** - Search across account names and descriptions
- **Code Lookup** - Instant account details by COSIF code
- **Hierarchy Navigation** - Browse parent/child account relationships

### Data & Export
- **4,026 Accounts** - Complete COSIF account database
- **1,370 Descriptions** - Detailed account functions imported from official PDFs
- **JSON/CSV Export** - Download search results in multiple formats
- **Ancestry Tracking** - View complete account lineage

### Documentation
- **Interactive Manual** - Searchable COSIF documentation
- **API Reference** - Complete REST API documentation
- **Code Examples** - Integration examples and snippets

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Cloud Run (GCP)                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────┐    ┌──────────────────┐                  │
│  │   cosif-web      │    │  cosif-backend   │                  │
│  │   (nginx)        │    │  (Phoenix)       │                  │
│  │                  │    │                  │                  │
│  │  ┌────────────┐  │    │  ┌────────────┐  │    ┌──────────┐  │
│  │  │  Vue SPA   │  │───▶│  │  REST API  │  │───▶│ Cloud SQL│  │
│  │  └────────────┘  │    │  └────────────┘  │    │ Postgres │  │
│  │  ┌────────────┐  │    │  ┌────────────┐  │    └──────────┘  │
│  │  │ VitePress  │  │    │  │ WebSocket  │  │                  │
│  │  │   Docs     │  │    │  │  Channel   │  │                  │
│  │  └────────────┘  │    │  └────────────┘  │                  │
│  └──────────────────┘    └──────────────────┘                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Project Structure

```
pixconnect-cosif/
├── backend/                 # Elixir/Phoenix API server
│   ├── lib/
│   │   ├── cosif/          # Business logic & contexts
│   │   └── cosif_web/      # Controllers, channels, router
│   ├── priv/repo/          # Database migrations
│   └── Dockerfile          # Production container
│
├── frontend/               # Vue 3 SPA
│   ├── src/
│   │   ├── components/     # Vue components
│   │   ├── services/       # API client
│   │   └── stores/         # Pinia state management
│   └── vite.config.ts      # Build configuration
│
├── docs/
│   ├── vitepress/          # Documentation site
│   │   ├── .vitepress/     # VitePress config
│   │   ├── api/            # API documentation
│   │   ├── contas/         # Account documentation
│   │   ├── funcoes/        # Function documentation
│   │   └── manual/         # User manual
│   ├── pdfs/               # Original COSIF PDFs
│   └── markdown/           # Converted documentation
│
├── hosting/                # Static site hosting
│   ├── Dockerfile          # nginx container
│   ├── nginx.conf          # Server configuration
│   └── public_combined/    # Built static files
│
├── scripts/                # Utility scripts
│   └── parse_cosif.py      # PDF to database converter
│
└── infrastructure/         # IaC configuration
    └── terraform/          # GCP infrastructure
```

---

## API Reference

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/v1/accounts/search` | Search accounts by query |
| `GET` | `/api/v1/accounts/:code` | Get account by COSIF code |
| `GET` | `/api/v1/accounts/:code/children` | Get child accounts |
| `GET` | `/api/v1/accounts/:code/ancestry` | Get account ancestry |
| `GET` | `/api/v1/functions/search` | Search account functions |
| `GET` | `/api/v1/functions/:code` | Get function by code |
| `WS` | `/socket/websocket` | Real-time search channel |

### Example Request

```bash
# Search for accounts containing "caixa"
curl "https://cosif-backend-26932950797.us-central1.run.app/api/v1/accounts/search?q=caixa&limit=5"
```

### Example Response

```json
{
  "data": [
    {
      "id": 2,
      "code": "1.1.1.00.00.00-9",
      "name": "Caixa",
      "level": 3,
      "group_code": "1",
      "is_analytical": false,
      "children_count": 2,
      "parent": {
        "code": "1.1.0.00.00.00-2",
        "name": "DISPONIBILIDADES"
      }
    }
  ]
}
```

---

## Development Setup

### Prerequisites

- **Elixir** 1.16+ with OTP 26+
- **Node.js** 20+ with npm
- **PostgreSQL** 15+
- **Python** 3.10+ (for PDF conversion)

### Backend Setup

```bash
cd backend

# Install dependencies
mix deps.get

# Setup database
mix ecto.setup

# Start server
mix phx.server
```

The API will be available at `http://localhost:4000`.

### Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

The frontend will be available at `http://localhost:5173`.

### Documentation Setup

```bash
cd docs/vitepress

# Install dependencies
npm install

# Start development server
npx vitepress dev
```

The documentation will be available at `http://localhost:5174`.

---

## Environment Variables

### Backend

| Variable | Description | Example |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | `ecto://user:pass@host/cosif` |
| `SECRET_KEY_BASE` | Phoenix secret key | Generate with `mix phx.gen.secret` |
| `PHX_HOST` | Production hostname | `cosif-backend.run.app` |
| `PORT` | Server port | `4000` |

### Frontend

| Variable | Description | Example |
|----------|-------------|---------|
| `VITE_API_URL` | Backend API URL | `https://cosif-backend.run.app/api/v1` |
| `VITE_WS_URL` | WebSocket URL | `wss://cosif-backend.run.app/socket` |

---

## Deployment

### Cloud Run (Production)

```bash
# Deploy backend
cd backend
gcloud run deploy cosif-backend \
  --source . \
  --region us-central1 \
  --allow-unauthenticated

# Build and deploy frontend + docs
cd ..
npm run build --prefix frontend
npx vitepress build docs/vitepress

# Combine outputs
mkdir -p hosting/public_combined/docs
cp -r frontend/dist/* hosting/public_combined/
cp -r docs/vitepress/.vitepress/dist/* hosting/public_combined/docs/

# Deploy static site
cd hosting
gcloud run deploy cosif-web \
  --source . \
  --region us-central1 \
  --allow-unauthenticated
```

### Docker (Local)

```bash
# Backend
cd backend
docker build -t cosif-backend .
docker run -p 4000:4000 -e DATABASE_URL=... cosif-backend

# Frontend + Docs
cd hosting
docker build -t cosif-web .
docker run -p 8080:8080 cosif-web
```

---

## COSIF Code Structure

COSIF account codes follow the format: `X.X.X.XX.XX.XX-D`

| Position | Description | Example |
|----------|-------------|---------|
| 1st digit | Group | `1` = Ativo |
| 2nd digit | Subgroup | `1.1` = Disponibilidades |
| 3rd digit | Breakdown | `1.1.1` = Caixa |
| 4th-5th | Title | `1.1.1.10` = Caixa Moeda Nacional |
| 6th-7th | Subtitle | `1.1.1.10.00` |
| 8th-9th | Item | `1.1.1.10.00.00` |
| Last | Check digit | `1.1.1.10.00.00-8` |

### Account Groups

| Group | Description |
|-------|-------------|
| **1** | Ativo Circulante e Realizável a Longo Prazo |
| **2** | Passivo Circulante e Exigível a Longo Prazo |
| **3** | Patrimônio Líquido |
| **6** | Compensação |
| **7** | Contas de Resultado Credoras |
| **8** | Contas de Resultado Devedoras |
| **9** | Contas Transitórias |

---

## Tech Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| **Backend** | Elixir + Phoenix | REST API & WebSocket |
| **Database** | PostgreSQL | Data storage with full-text search |
| **Frontend** | Vue 3 + Vite | Single-page application |
| **State** | Pinia | Frontend state management |
| **Docs** | VitePress | Static documentation site |
| **Hosting** | Cloud Run | Containerized deployment |
| **Database** | Cloud SQL | Managed PostgreSQL |
| **Static** | nginx | Static file serving |

---

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Create a Pull Request

---

## License

This project is for internal use. COSIF documentation is based on official materials from Banco Central do Brasil.

---

<p align="center">
  <sub>Built with Elixir, Vue, and VitePress</sub>
</p>
