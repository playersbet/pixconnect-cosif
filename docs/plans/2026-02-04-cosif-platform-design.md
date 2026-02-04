# PixConnect COSIF Platform - Design Document

**Date:** 2026-02-04
**Status:** Approved
**Author:** Collaborative Design Session

---

## Overview

PixConnect COSIF is a comprehensive internal platform for searching and referencing COSIF (Plano Contábil das Instituições do Sistema Financeiro Nacional) documentation. It serves three primary purposes:

1. **Regulatory compliance** - Help financial institutions look up correct COSIF account codes
2. **Educational/reference** - Searchable documentation for accountants and analysts
3. **Integration API** - Backend service for other systems to query COSIF data programmatically

---

## Architecture

### High-Level Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        GCP Cloud Run                            │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐     ┌─────────────────┐                   │
│  │   Vue Frontend  │────▶│  Phoenix API    │                   │
│  │   (VitePress +  │◀────│  + LiveView     │                   │
│  │   Dashboard)    │ WS  │                 │                   │
│  └─────────────────┘     └────────┬────────┘                   │
│                                   │                             │
│                          ┌────────▼────────┐                   │
│                          │   PostgreSQL    │                   │
│                          │  (Cloud SQL)    │                   │
│                          └─────────────────┘                   │
└─────────────────────────────────────────────────────────────────┘
```

### Components

| Component | Technology | Purpose |
|-----------|------------|---------|
| Backend | Elixir/Phoenix | API, LiveView, WebSocket channels |
| Frontend | Vue 3 + TailwindCSS | Dashboard, explorer, admin |
| Documentation | VitePress | Converted markdown docs |
| Database | PostgreSQL 15 | Accounts, functions, full-text search |
| Infrastructure | GCP Cloud Run + Cloud SQL | Serverless, auto-scaling |
| Auth | Google IAP | Internal team SSO |

---

## Data Model

### Core Tables

```sql
-- accounts table
CREATE TABLE accounts (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    level INTEGER NOT NULL,
    parent_id BIGINT REFERENCES accounts(id),
    accepts_credit BOOLEAN DEFAULT false,
    accepts_debit BOOLEAN DEFAULT false,
    is_analytical BOOLEAN DEFAULT false,
    group_code VARCHAR(10),
    subgroup_code VARCHAR(10),
    function_id BIGINT REFERENCES functions(id),
    version_id BIGINT REFERENCES versions(id) NOT NULL,
    search_vector TSVECTOR,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- functions table
CREATE TABLE functions (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    version_id BIGINT REFERENCES versions(id) NOT NULL,
    search_vector TSVECTOR,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- versions table
CREATE TABLE versions (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    source_file VARCHAR(255),
    imported_at TIMESTAMP DEFAULT NOW(),
    is_active BOOLEAN DEFAULT false,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- users table
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    role VARCHAR(50) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- saved_searches table
CREATE TABLE saved_searches (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) NOT NULL,
    name VARCHAR(255) NOT NULL,
    query_params JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
```

### Search Strategy

- **Account code lookup**: Direct B-tree index on `code` column
- **Keyword search**: PostgreSQL `tsvector` full-text search with GIN index
- **Attribute filtering**: Composite indexes on frequently filtered columns

---

## API Design

### REST Endpoints

```
# Account Operations
GET  /api/v1/accounts/:code          # Exact account lookup
GET  /api/v1/accounts/search         # Keyword + attribute search
GET  /api/v1/accounts/:code/children # Get child accounts
GET  /api/v1/accounts/:code/ancestry # Get parent hierarchy

# Function Operations
GET  /api/v1/functions/:code         # Function lookup
GET  /api/v1/functions/search        # Search functions

# User Features
GET  /api/v1/saved_searches          # List saved searches
POST /api/v1/saved_searches          # Save a search
GET  /api/v1/export                  # Export results (CSV/JSON)

# Admin Operations
POST /api/v1/admin/import            # Trigger import
GET  /api/v1/admin/versions          # List versions
PUT  /api/v1/admin/versions/:id      # Activate version
```

### WebSocket (Live Search)

```
Channel: live_search
Events:
  - search:query → sends search query
  - search:results → receives results
```

### Search Query Parameters

```
GET /api/v1/accounts/search?
    q=depósito              # Keyword (full-text)
    &level=3                # Filter by level
    &group=1                # Filter by group
    &accepts_credit=true    # Filter by attribute
    &limit=50               # Pagination
    &offset=0
```

---

## PDF Conversion Pipeline

### Workflow

```
PDF Files → Extraction → Parsing → Markdown + JSON → QA Review → DB Import
```

### Outputs

1. **Markdown files** - For VitePress documentation, versioned in git
2. **Structured JSON** - For database import via Elixir script

### Tools

- `pdfplumber` (Python) - Text and table extraction
- `tabula-py` - Complex table extraction
- Custom parser - Structure recognition for COSIF format

---

## Frontend Design

### Views

1. **Search View** - Live suggestions, filters, results list, detail panel
2. **Explorer View** - Interactive tree visualization of account hierarchy
3. **Saved Searches** - User's saved queries with quick re-run
4. **Docs View** - Embedded VitePress documentation
5. **Admin Panel** - Import management, version control, user management

### Tech Stack

- Vue 3 + Composition API
- Pinia for state management
- Phoenix WebSocket client
- TailwindCSS for styling

---

## GCP Infrastructure

### Resources

| Resource | Configuration |
|----------|---------------|
| Cloud Run | 1 vCPU, 512MB RAM, min 1 instance |
| Cloud SQL | PostgreSQL 15, db-f1-micro |
| Cloud Storage | Frontend static assets |
| Cloud CDN | Frontend delivery |
| Secret Manager | Database credentials, API keys |
| IAP | Internal team authentication |

### CI/CD

1. Push to `main` triggers Cloud Build
2. Run tests, build Docker image
3. Deploy to Cloud Run (blue/green)
4. Build frontend, sync to Cloud Storage

---

## Project Structure

```
pixconnect-cosif/
├── CLAUDE.md                    # AI assistant context & decisions
├── README.md                    # Professional project documentation
├── docs/
│   ├── pdfs/                    # Original PDF sources
│   ├── markdown/                # Converted markdown (VitePress source)
│   ├── plans/                   # Design documents
│   └── vitepress/               # VitePress config
├── backend/
│   ├── mix.exs                  # Elixir dependencies
│   ├── lib/cosif/               # Business logic
│   ├── lib/cosif_web/           # Phoenix controllers, channels
│   ├── priv/repo/migrations/    # Database migrations
│   └── test/                    # ExUnit tests
├── frontend/
│   ├── package.json
│   ├── src/
│   │   ├── components/          # Vue components
│   │   ├── views/               # Page views
│   │   ├── stores/              # Pinia stores
│   │   └── services/            # API clients
│   └── vite.config.ts
├── scripts/
│   ├── convert_pdfs.py          # PDF extraction pipeline
│   └── import_data.exs          # Database import script
├── infrastructure/
│   ├── terraform/               # GCP infrastructure as code
│   ├── cloudbuild.yaml          # CI/CD pipeline
│   └── Dockerfile               # Backend container
└── docker-compose.yml           # Local development
```

---

## Key Decisions

1. **Phoenix LiveView for real-time** - Native WebSocket support, no separate service needed
2. **PostgreSQL full-text search** - Sufficient for internal tool, avoids Elasticsearch complexity
3. **Cloud Run** - Simplest deployment for team app, auto-scales to zero when not in use
4. **Google IAP** - Leverages existing company Google accounts, no custom auth needed
5. **Version tracking** - Supports periodic COSIF updates with rollback capability

---

## Success Criteria

- [ ] All 4 PDFs converted to searchable markdown without data loss
- [ ] Account code lookup returns results in <100ms
- [ ] Live search suggestions appear within 150ms of typing
- [ ] All three search modes (code, keyword, attribute) work correctly
- [ ] Admin can import new PDF versions without downtime
- [ ] Application deployed and accessible to internal team
