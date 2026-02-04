# Autenticação

## Status Atual

::: info
A API COSIF é atualmente **pública** e não requer autenticação.
:::

## Futuro: API Keys

Em versões futuras, a autenticação via API Key será implementada para:
- Controle de rate limiting
- Analytics de uso
- Acesso a recursos premium

### Como será

```bash
curl -H "Authorization: Bearer YOUR_API_KEY" \
  "https://cosif.playersbet.com/api/v1/accounts/search?q=caixa"
```

### Headers

| Header | Valor |
|--------|-------|
| `Authorization` | `Bearer YOUR_API_KEY` |
| `Content-Type` | `application/json` |

## Rate Limiting

### Limites Atuais

| Tipo | Limite |
|------|--------|
| Por IP | 60 req/min |
| Burst | 10 req/s |

### Respostas de Rate Limit

Quando o limite é excedido:

```http
HTTP/1.1 429 Too Many Requests
Retry-After: 60
```

```json
{
  "error": {
    "code": "rate_limit_exceeded",
    "message": "Too many requests. Please retry after 60 seconds."
  }
}
```

### Headers de Rate Limit

```http
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1612345678
```

## CORS

A API suporta CORS para os seguintes origins:

- `http://localhost:3000`
- `http://localhost:5173`
- `http://localhost:5174`
- `https://cosif.playersbet.com`

### Preflight Request

```http
OPTIONS /api/v1/accounts/search
Access-Control-Request-Method: GET
Access-Control-Request-Headers: Authorization
```

### Response

```http
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Allow-Headers: Authorization, Content-Type
Access-Control-Max-Age: 86400
```

## Segurança

### Recomendações

1. **HTTPS**: Sempre use HTTPS em produção
2. **API Key**: Não exponha sua API key no frontend
3. **Rate Limiting**: Implemente retry com backoff exponencial
4. **Caching**: Cache respostas quando possível

### Exemplo com Retry

```javascript
async function fetchWithRetry(url, options = {}, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      const response = await fetch(url, options);

      if (response.status === 429) {
        const retryAfter = response.headers.get('Retry-After') || 60;
        await new Promise(r => setTimeout(r, retryAfter * 1000));
        continue;
      }

      return response;
    } catch (error) {
      if (i === retries - 1) throw error;
      await new Promise(r => setTimeout(r, Math.pow(2, i) * 1000));
    }
  }
}
```
