# Documentos COSIF

Esta seção lista os principais documentos e modelos utilizados no contexto do COSIF.

## Documentos Obrigatórios

### 4010 - Balancete

O documento 4010 é o balancete mensal que deve ser enviado ao Banco Central.

**Características:**
- Periodicidade: Mensal
- Prazo: Até o 5º dia útil do mês subsequente
- Formato: Leiaute padronizado pelo BACEN

**Conteúdo:**
- Saldos de todas as contas do plano de contas
- Movimentação do período (débitos e créditos)
- Código da instituição e data-base

### 4016 - Balancete Combinado

Utilizado por instituições com múltiplas dependências.

### 4060 - Estatística Bancária

Informações estatísticas complementares ao balancete.

## Demonstrações Financeiras

### Balanço Patrimonial

Estrutura básica:

```
ATIVO                          PASSIVO
├── Circulante                 ├── Circulante
│   ├── Disponibilidades       │   ├── Depósitos
│   ├── Aplicações             │   ├── Captações
│   ├── TVM                    │   └── Outras Obrigações
│   └── Operações de Crédito   │
├── Realizável LP              ├── Exigível LP
│   └── ...                    │   └── ...
└── Permanente                 └── Patrimônio Líquido
    ├── Investimentos              ├── Capital Social
    ├── Imobilizado                ├── Reservas
    └── Diferido                   └── Lucros/Prejuízos
```

### Demonstração do Resultado

```
RECEITA DA INTERMEDIAÇÃO FINANCEIRA
  (+) Operações de Crédito
  (+) Operações de Arrendamento Mercantil
  (+) Resultado de TVM
  (+) Resultado de Câmbio
  (+) Resultado de Aplicações Compulsórias

(-) DESPESA DA INTERMEDIAÇÃO FINANCEIRA
  (-) Operações de Captação
  (-) Operações de Empréstimos
  (-) Provisão para Créditos de Liquidação Duvidosa

(=) RESULTADO BRUTO DA INTERMEDIAÇÃO

(+/-) OUTRAS RECEITAS/DESPESAS OPERACIONAIS
  (+) Receitas de Prestação de Serviços
  (-) Despesas de Pessoal
  (-) Outras Despesas Administrativas
  (-) Despesas Tributárias
  (+/-) Outras Receitas/Despesas Operacionais

(=) RESULTADO OPERACIONAL

(+/-) RESULTADO NÃO OPERACIONAL

(=) RESULTADO ANTES DA TRIBUTAÇÃO

(-) Imposto de Renda e Contribuição Social

(=) LUCRO LÍQUIDO
```

## Modelos de Lançamento

### Captação de Depósitos à Vista

```
D - 1.1.1.10.00.00 CAIXA
C - 2.1.1.10.00.00 DEPÓSITOS À VISTA
```

### Concessão de Empréstimo

```
D - 1.6.1.10.00.00 EMPRÉSTIMOS
C - 1.1.1.10.00.00 CAIXA

D - 1.8.1.10.00.00 RENDAS A APROPRIAR
C - 7.1.1.10.00.00 RENDAS DE EMPRÉSTIMOS
```

### Provisão para Devedores Duvidosos

```
D - 8.1.8.10.00.00 DESPESA DE PROVISÃO
C - 1.6.9.10.00.00 PROVISÃO P/ CRÉD. LIQ. DUVIDOSA
```

## Links Úteis

- [Banco Central - COSIF](https://www.bcb.gov.br/estabilidadefinanceira/cosif)
- [Leiautes de Documentos](https://www.bcb.gov.br/estabilidadefinanceira/leiautes)
- [Circulares e Normativos](https://www.bcb.gov.br/estabilidadefinanceira/exibenormativo)
