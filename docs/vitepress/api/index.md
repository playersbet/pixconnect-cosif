# API Reference

A API COSIF permite consultar o plano de contas programaticamente através de uma interface REST moderna.

## Base URL

```
Production: https://cosif.playersbet.com/api/v1
Development: http://localhost:4000/api/v1
```

## Autenticação

Atualmente a API é pública e não requer autenticação.

::: tip Futuro
Autenticação via API Key será implementada em versões futuras para controle de rate limiting.
:::

## Formato de Resposta

Todas as respostas são em JSON com a seguinte estrutura:

```json
{
  "data": { ... }  // ou array para listagens
}
```

### Erros

```json
{
  "error": {
    "code": "not_found",
    "message": "Account not found"
  }
}
```

## Endpoints

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/accounts/search` | [Buscar contas](/api/search) |
| GET | `/accounts/:code` | [Obter conta por código](/api/accounts) |
| GET | `/accounts/:code/children` | Obter subcontas |
| GET | `/accounts/:code/ancestry` | Obter hierarquia |

## Exemplo Rápido

```bash
# Buscar conta CAIXA
curl "http://localhost:4000/api/v1/accounts/1.1.1.10.00.00-8"
```

```json
{
  "data": {
    "id": 123,
    "code": "1.1.1.10.00.00-8",
    "name": "CAIXA",
    "description": "Registrar o numerário existente em moeda corrente nacional.",
    "level": 6,
    "group_code": "1",
    "accepts_credit": true,
    "accepts_debit": true,
    "is_analytical": true,
    "parent": {
      "code": "1.1.1.00.00.00-9",
      "name": "Caixa"
    },
    "children_count": 0
  }
}
```

## SDKs e Bibliotecas

### JavaScript/TypeScript

```typescript
const API_BASE = 'http://localhost:4000/api/v1';

async function getAccount(code: string) {
  const response = await fetch(`${API_BASE}/accounts/${code}`);
  return response.json();
}

async function searchAccounts(query: string) {
  const response = await fetch(`${API_BASE}/accounts/search?q=${query}`);
  return response.json();
}
```

### Python

```python
import requests

API_BASE = 'http://localhost:4000/api/v1'

def get_account(code: str):
    response = requests.get(f'{API_BASE}/accounts/{code}')
    return response.json()

def search_accounts(query: str):
    response = requests.get(f'{API_BASE}/accounts/search', params={'q': query})
    return response.json()
```

### Elixir

```elixir
defmodule CosifClient do
  @base_url "http://localhost:4000/api/v1"

  def get_account(code) do
    {:ok, response} = HTTPoison.get("#{@base_url}/accounts/#{code}")
    Jason.decode!(response.body)
  end

  def search(query) do
    {:ok, response} = HTTPoison.get("#{@base_url}/accounts/search", [], params: [q: query])
    Jason.decode!(response.body)
  end
end
```

## Rate Limiting

| Plano | Requisições/minuto |
|-------|-------------------|
| Público | 60 |
| Autenticado | 600 |

## Navegação

- [Autenticação](/api/auth) - Configuração de autenticação
- [Contas](/api/accounts) - Endpoint de contas
- [Busca](/api/search) - Endpoint de busca
- [WebSocket](/api/websocket) - Busca em tempo real
