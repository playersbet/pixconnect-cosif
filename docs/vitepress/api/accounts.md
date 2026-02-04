# Contas

Endpoint para consulta de contas individuais do plano COSIF.

## Obter Conta por Código

```http
GET /api/v1/accounts/:code
```

### Parâmetros de URL

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `code` | string | Código COSIF completo (ex: `1.1.1.10.00.00-8`) |

### Exemplo

```bash
curl "http://localhost:4000/api/v1/accounts/1.1.1.10.00.00-8"
```

### Resposta

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

### Campos da Resposta

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | number | ID interno |
| `code` | string | Código COSIF |
| `name` | string | Nome da conta |
| `description` | string | Função da conta |
| `level` | number | Nível hierárquico (1-7) |
| `group_code` | string | Grupo (1º dígito) |
| `accepts_credit` | boolean | Aceita lançamentos a crédito |
| `accepts_debit` | boolean | Aceita lançamentos a débito |
| `is_analytical` | boolean | É conta analítica |
| `parent` | object | Conta pai (código e nome) |
| `children_count` | number | Quantidade de subcontas |

### Erros

| Código | Descrição |
|--------|-----------|
| 404 | Conta não encontrada |

```json
{
  "error": {
    "code": "not_found",
    "message": "Account not found"
  }
}
```

## Obter Subcontas

```http
GET /api/v1/accounts/:code/children
```

Retorna todas as contas filhas imediatas.

### Exemplo

```bash
curl "http://localhost:4000/api/v1/accounts/1.1.0.00.00.00-2/children"
```

### Resposta

```json
{
  "data": [
    {
      "id": 1,
      "code": "1.1.1.00.00.00-9",
      "name": "Caixa",
      "level": 3,
      "children_count": 2
    },
    {
      "id": 2,
      "code": "1.1.2.00.00.00-6",
      "name": "Depósitos Bancários",
      "level": 3,
      "children_count": 5
    }
  ]
}
```

## Obter Hierarquia (Ancestry)

```http
GET /api/v1/accounts/:code/ancestry
```

Retorna a cadeia hierárquica da raiz até a conta.

### Exemplo

```bash
curl "http://localhost:4000/api/v1/accounts/1.1.1.10.00.00-8/ancestry"
```

### Resposta

```json
{
  "data": [
    {
      "code": "1.0.0.00.00.00-5",
      "name": "ATIVO",
      "level": 1
    },
    {
      "code": "1.1.0.00.00.00-2",
      "name": "DISPONIBILIDADES",
      "level": 2
    },
    {
      "code": "1.1.1.00.00.00-9",
      "name": "Caixa",
      "level": 3
    },
    {
      "code": "1.1.1.10.00.00-8",
      "name": "CAIXA",
      "level": 4
    }
  ]
}
```

## Exemplos de Uso

### JavaScript

```javascript
async function getAccountWithHierarchy(code) {
  const [account, children, ancestry] = await Promise.all([
    fetch(`/api/v1/accounts/${code}`).then(r => r.json()),
    fetch(`/api/v1/accounts/${code}/children`).then(r => r.json()),
    fetch(`/api/v1/accounts/${code}/ancestry`).then(r => r.json()),
  ]);

  return {
    ...account.data,
    children: children.data,
    ancestry: ancestry.data,
  };
}
```

### Python

```python
import requests

def get_account_details(code):
    base = 'http://localhost:4000/api/v1/accounts'

    account = requests.get(f'{base}/{code}').json()
    children = requests.get(f'{base}/{code}/children').json()
    ancestry = requests.get(f'{base}/{code}/ancestry').json()

    return {
        **account['data'],
        'children': children['data'],
        'ancestry': ancestry['data'],
    }
```
