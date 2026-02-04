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
