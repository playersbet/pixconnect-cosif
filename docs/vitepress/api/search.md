# Busca

Endpoint para busca de contas por texto ou filtros.

## Buscar Contas

```http
GET /api/v1/accounts/search
```

### Query Parameters

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| `q` | string | Não | Termo de busca (código ou nome) |
| `level` | number | Não | Filtrar por nível (1-7) |
| `group` | string | Não | Filtrar por grupo (1-9) |
| `accepts_credit` | boolean | Não | Filtrar por aceita crédito |
| `accepts_debit` | boolean | Não | Filtrar por aceita débito |
| `limit` | number | Não | Limite de resultados (padrão: 50, máx: 100) |
| `offset` | number | Não | Offset para paginação |

### Exemplos

#### Busca por texto

```bash
curl "http://localhost:4000/api/v1/accounts/search?q=caixa"
```

#### Busca com filtros

```bash
curl "http://localhost:4000/api/v1/accounts/search?q=deposito&level=4&group=2"
```

#### Paginação

```bash
curl "http://localhost:4000/api/v1/accounts/search?q=emprestimo&limit=10&offset=20"
```

### Resposta

```json
{
  "data": [
    {
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
  ]
}
```

## Comportamento da Busca

### Busca por Código

Se o termo se parece com um código COSIF, a busca prioriza correspondência de código:

```bash
# Busca pelo início do código
curl "http://localhost:4000/api/v1/accounts/search?q=1.1.1"

# Retorna todas as contas que começam com 1.1.1
```

### Busca por Nome/Descrição

Para termos textuais, a busca é feita no nome e descrição:

```bash
curl "http://localhost:4000/api/v1/accounts/search?q=numerario"

# Busca "numerário" em nome e descrição
```

### Busca Case-Insensitive

A busca ignora maiúsculas/minúsculas e acentos:

```bash
# Ambos retornam o mesmo resultado
curl "http://localhost:4000/api/v1/accounts/search?q=CAIXA"
curl "http://localhost:4000/api/v1/accounts/search?q=caixa"
```

## Filtros

### Por Nível

```bash
# Apenas grupos (nível 1)
curl "http://localhost:4000/api/v1/accounts/search?level=1"

# Apenas títulos (nível 4)
curl "http://localhost:4000/api/v1/accounts/search?level=4"
```

### Por Grupo

```bash
# Apenas Ativo (grupo 1)
curl "http://localhost:4000/api/v1/accounts/search?group=1"

# Apenas Receitas (grupo 7)
curl "http://localhost:4000/api/v1/accounts/search?group=7"
```

### Por Atributos

```bash
# Contas que aceitam crédito
curl "http://localhost:4000/api/v1/accounts/search?accepts_credit=true"

# Contas que aceitam débito
curl "http://localhost:4000/api/v1/accounts/search?accepts_debit=true"
```

## Combinando Filtros

Todos os filtros podem ser combinados:

```bash
# Contas de despesa (grupo 8) de nível 4 que contêm "pessoal"
curl "http://localhost:4000/api/v1/accounts/search?q=pessoal&group=8&level=4"
```

## Paginação

Use `limit` e `offset` para paginar resultados:

```javascript
async function getAllAccounts(query) {
  const results = [];
  let offset = 0;
  const limit = 50;

  while (true) {
    const response = await fetch(
      `/api/v1/accounts/search?q=${query}&limit=${limit}&offset=${offset}`
    );
    const { data } = await response.json();

    if (data.length === 0) break;

    results.push(...data);
    offset += limit;
  }

  return results;
}
```

## Performance

- Resultados são limitados a 100 por requisição
- Use filtros específicos para melhor performance
- Cache resultados quando possível

## Códigos de Resposta

| Código | Descrição |
|--------|-----------|
| 200 | Sucesso |
| 400 | Parâmetros inválidos |
| 500 | Erro interno |
