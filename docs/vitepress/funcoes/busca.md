# Buscar Função

Utilize os métodos abaixo para encontrar a função de uma conta específica.

## Aplicação Web

A forma mais fácil é utilizar a [aplicação de busca](/) com interface visual:

1. Digite o código ou nome da conta
2. Clique no resultado desejado
3. Visualize a função completa no modal

## API REST

### Buscar por Código Exato

```bash
curl "https://api.example.com/api/v1/accounts/1.1.1.10.00.00-8"
```

### Buscar por Termo

```bash
curl "https://api.example.com/api/v1/accounts/search?q=caixa"
```

### Parâmetros de Busca

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `q` | string | Termo de busca (código ou nome) |
| `level` | number | Filtrar por nível (1-7) |
| `group` | string | Filtrar por grupo (1-9) |
| `limit` | number | Limite de resultados (padrão: 50) |
| `offset` | number | Paginação |

### Exemplo Completo

```bash
curl "https://api.example.com/api/v1/accounts/search?q=deposito&level=4&group=2&limit=10"
```

**Resposta:**

```json
{
  "data": [
    {
      "id": 1234,
      "code": "2.1.1.10.00.00-5",
      "name": "Depósitos de Ligadas",
      "description": "Registrar os depósitos à vista...",
      "level": 4,
      "group_code": "2",
      "accepts_credit": true,
      "accepts_debit": true
    }
  ]
}
```

## WebSocket (Tempo Real)

Para busca com sugestões em tempo real:

```javascript
import { Socket } from 'phoenix';

const socket = new Socket('wss://api.example.com/socket');
socket.connect();

const channel = socket.channel('live_search:lobby');
channel.join();

// Enviar busca
channel.push('search', { query: 'caixa' })
  .receive('ok', (response) => {
    console.log('Sugestões:', response.suggestions);
  });
```

## Exemplos de Funções

### Disponibilidades

| Código | Nome | Função |
|--------|------|--------|
| 1.1.1.10.00.00-8 | CAIXA | Registrar o numerário existente em moeda corrente nacional |
| 1.1.2.30.00.00-3 | DEPÓSITOS BANCÁRIOS | Registrar o valor dos depósitos de livre movimentação |

### Operações de Crédito

| Código | Nome | Função |
|--------|------|--------|
| 1.6.1.10.00.00-1 | EMPRÉSTIMOS | Registrar os empréstimos concedidos a pessoas físicas e jurídicas |
| 1.6.9.80.00.00-5 | PROVISÃO NÍVEL H | Registrar a provisão para créditos classificados no nível H |

### Receitas

| Código | Nome | Função |
|--------|------|--------|
| 7.1.1.10.00.00-5 | RENDAS DE EMPRÉSTIMOS | Registrar as receitas de empréstimos concedidos |
| 7.7.5.10.00.00-5 | RENDAS DE TRANSFERÊNCIAS | Registrar as receitas com serviços de transferência de fundos |

## Dicas de Busca

1. **Por código parcial**: Digite `1.1.1` para ver todas as contas de Caixa
2. **Por nome**: Digite `deposito` para encontrar contas relacionadas
3. **Por grupo**: Use `group=7` para ver apenas receitas
4. **Por nível**: Use `level=4` para ver títulos (4º grau)
