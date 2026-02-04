# Funções das Contas COSIF

As funções definem o propósito e a utilização correta de cada conta do plano contábil.

## O que são Funções?

A função de uma conta descreve:
- **O que registrar**: Quais operações devem ser escrituradas
- **Como registrar**: Natureza dos lançamentos (débito/crédito)
- **Quando registrar**: Momento do reconhecimento
- **Base normativa**: Fundamentação legal

## Estrutura de uma Função

Cada função contém os seguintes elementos:

```
Código: X.X.X.XX.XX.XX-D
Título: NOME DA CONTA

Função:
Registrar [descrição detalhada da finalidade da conta
e das operações que devem ser nela escrituradas].

Base normativa: [Circular/Resolução que regulamenta]
```

## Exemplo

### 1.1.1.10.00.00-8 - CAIXA

**Função:**
Registrar o numerário existente em moeda corrente nacional.

**Base normativa:** INBCB493

**Lançamentos típicos:**

| Operação | Débito | Crédito |
|----------|--------|---------|
| Recebimento em espécie | CAIXA | Conta de origem |
| Pagamento em espécie | Conta de destino | CAIXA |

## Consulta de Funções

### Via Aplicação Web

Acesse a [aplicação de busca](/) e clique em qualquer conta para ver sua função completa.

### Via API

```bash
# Buscar conta com função
curl "https://api.example.com/api/v1/accounts/1.1.1.10.00.00-8"
```

**Resposta:**
```json
{
  "data": {
    "code": "1.1.1.10.00.00-8",
    "name": "CAIXA",
    "description": "Registrar o numerário existente em moeda corrente nacional.",
    "level": 6,
    "group_code": "1"
  }
}
```

## Estatísticas

| Métrica | Valor |
|---------|-------|
| Total de contas | 4.026 |
| Contas com função documentada | 1.370 |
| Cobertura | 34% |

## Bases Normativas Comuns

| Código | Descrição |
|--------|-----------|
| INBCB493 | Instrução Normativa BCB 493 |
| CMN4966 | Resolução CMN 4.966 |
| RES2682 | Resolução 2.682/99 (Provisão) |
| CPC48 | Pronunciamento Contábil 48 |

## Navegação

- [Buscar Função](/funcoes/busca) - Pesquise funções por código ou descrição
