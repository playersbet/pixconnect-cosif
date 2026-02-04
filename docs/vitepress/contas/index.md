# Plano de Contas COSIF

O plano de contas COSIF contém mais de 4.000 contas organizadas hierarquicamente em 7 níveis de desdobramento.

## Visão Geral

O plano está dividido nos seguintes grupos principais:

| Grupo | Nome | Natureza | Descrição |
|-------|------|----------|-----------|
| **1** | Ativo | Devedora | Bens e direitos da instituição |
| **2** | Passivo | Credora | Obrigações com terceiros |
| **3** | Patrimônio Líquido | Credora | Recursos próprios |
| **6** | Compensação | Mista | Contas de controle |
| **7** | Resultado Credor | Credora | Receitas |
| **8** | Resultado Devedor | Devedora | Despesas |
| **9** | Transitórias | Mista | Contas temporárias |

## Estrutura Hierárquica

```
Grupo (1º dígito)
└── Subgrupo (2º dígito)
    └── Desdobramento (3º dígito)
        └── Título (4º-5º dígitos)
            └── Subtítulo (6º-7º dígitos)
                └── Item (8º-9º dígitos)
                    └── Subitem (dígito verificador)
```

## Grupos Detalhados

### [1 - Ativo](/contas/ativo)

Compreende os bens e direitos da instituição:
- 1.1 - Disponibilidades
- 1.2 - Aplicações Interfinanceiras
- 1.3 - Títulos e Valores Mobiliários
- 1.4 - Relações Interfinanceiras
- 1.5 - Relações Interdependências
- 1.6 - Operações de Crédito
- 1.7 - Operações de Arrendamento Mercantil
- 1.8 - Outros Créditos
- 1.9 - Outros Valores e Bens

### [2 - Passivo](/contas/passivo)

Compreende as obrigações da instituição:
- 2.1 - Depósitos
- 2.2 - Captações no Mercado Aberto
- 2.3 - Recursos de Aceites e Emissão de Títulos
- 2.4 - Relações Interfinanceiras
- 2.5 - Relações Interdependências
- 2.6 - Obrigações por Empréstimos
- 2.7 - Obrigações por Repasses
- 2.9 - Outras Obrigações

### [3 - Patrimônio Líquido](/contas/patrimonio)

Recursos próprios da instituição:
- 3.1 - Capital Social
- 3.2 - Reservas de Capital
- 3.3 - Reservas de Lucros
- 3.4 - Ajustes de Avaliação Patrimonial
- 3.9 - Lucros ou Prejuízos Acumulados

### [7 - Resultado Credor](/contas/receitas)

Receitas da instituição:
- 7.1 - Rendas de Operações de Crédito
- 7.2 - Rendas de Arrendamento Mercantil
- 7.3 - Rendas de Câmbio
- 7.4 - Rendas de Aplicações Interfinanceiras
- 7.5 - Rendas com TVM
- 7.7 - Rendas de Prestação de Serviços
- 7.8 - Rendas de Participações
- 7.9 - Outras Receitas Operacionais

### [8 - Resultado Devedor](/contas/despesas)

Despesas da instituição:
- 8.1 - Despesas de Captação
- 8.2 - Despesas de Arrendamento Mercantil
- 8.3 - Despesas de Câmbio
- 8.4 - Despesas de Provisão
- 8.5 - Despesas com TVM
- 8.7 - Despesas de Pessoal
- 8.8 - Despesas Administrativas
- 8.9 - Despesas Tributárias

## Busca de Contas

Para buscar contas específicas, utilize a [aplicação de busca](/api/) ou a API REST:

```bash
# Buscar por código
curl "https://api.example.com/api/v1/accounts/1.1.1.10.00.00-8"

# Buscar por nome
curl "https://api.example.com/api/v1/accounts/search?q=caixa"
```

## Estatísticas

- **Total de contas**: 4.026
- **Contas com descrição**: 1.370
- **Níveis hierárquicos**: 7
- **Grupos ativos**: 7
