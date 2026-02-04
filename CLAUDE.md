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
- [x] Phase 0: Project Setup (CLAUDE.md, README.md, .gitignore)
- [x] Phase 1: PDF Conversion (scripts/convert_pdfs.py, parse_cosif.py)
- [x] Phase 2: Backend Development (Phoenix API, Ecto schemas, WebSocket)
- [x] Phase 3: Frontend Development (Vue 3, Pinia, components)
- [x] Phase 4: Documentation (VitePress initialized)
- [x] Phase 5: Deployment (Docker, Terraform for GCP)

## API Endpoints
```
GET /api/v1/accounts/:code          # Get account by code
GET /api/v1/accounts/search         # Search accounts (q, level, group, accepts_credit, accepts_debit)
GET /api/v1/accounts/:code/children # Get child accounts
GET /api/v1/accounts/:code/ancestry # Get parent hierarchy
GET /api/v1/functions/:code         # Get function by code
GET /api/v1/functions/search        # Search functions
WS  /socket/websocket               # Live search channel (live_search:lobby)
```
