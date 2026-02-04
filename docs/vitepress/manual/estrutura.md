# Estrutura do Plano de Contas

O COSIF segue uma estrutura hierárquica bem definida, permitindo a classificação detalhada de todas as operações contábeis das instituições financeiras.

## Formato do Código

```
X.X.X.XX.XX.XX-D
│ │ │ │  │  │  └── Dígito verificador
│ │ │ │  │  └───── Item (6º grau)
│ │ │ │  └──────── Subtítulo (5º grau)
│ │ │ └─────────── Título (4º grau)
│ │ └───────────── Desdobramento (3º grau)
│ └─────────────── Subgrupo (2º grau)
└───────────────── Grupo (1º grau)
```

## Níveis Hierárquicos

### Grau 1 - Grupo

O primeiro dígito identifica o grupo principal:

| Código | Descrição | Natureza |
|--------|-----------|----------|
| 1 | Ativo | Devedora |
| 2 | Passivo | Credora |
| 3 | Patrimônio Líquido | Credora |
| 6 | Compensação | Mista |
| 7 | Contas de Resultado Credoras | Credora |
| 8 | Contas de Resultado Devedoras | Devedora |
| 9 | Contas Transitórias | Mista |

### Grau 2 - Subgrupo

Divide os grupos em categorias mais específicas:

**Exemplo - Grupo 1 (Ativo):**
- 1.1 - Disponibilidades
- 1.2 - Aplicações Interfinanceiras de Liquidez
- 1.3 - Títulos e Valores Mobiliários
- 1.4 - Relações Interfinanceiras
- 1.5 - Relações Interdependências

### Grau 3 - Desdobramento do Subgrupo

Maior especificação dentro do subgrupo:

**Exemplo - Subgrupo 1.1 (Disponibilidades):**
- 1.1.1 - Caixa
- 1.1.2 - Depósitos Bancários
- 1.1.3 - Reservas Livres
- 1.1.5 - Disponibilidades em Moedas Estrangeiras

### Graus 4, 5 e 6 - Detalhamento

Permitem o detalhamento progressivo das contas até o nível de item:

```
1.1.1.10.00.00-8 CAIXA
      │  │  │
      │  │  └── Item
      │  └───── Subtítulo
      └──────── Título
```

## Dígito Verificador

O dígito verificador é calculado através do módulo 11, aplicado sobre os demais dígitos do código da conta. Ele garante a integridade do código e evita erros de digitação.

### Exemplo de Cálculo

Para o código `1.1.1.10.00.00`:

1. Remove-se os pontos: `111100000`
2. Aplica-se o módulo 11
3. O resultado é o dígito verificador: `8`
4. Código completo: `1.1.1.10.00.00-8`

## Contas Sintéticas e Analíticas

- **Contas Sintéticas**: Representam agregações e não recebem lançamentos diretos
- **Contas Analíticas**: São as contas de último nível, onde são feitos os lançamentos contábeis

## Atributos das Contas

Cada conta possui atributos que definem seu comportamento:

| Atributo | Descrição |
|----------|-----------|
| Natureza | Devedora ou Credora |
| Aceita Débito | Se a conta pode receber débitos |
| Aceita Crédito | Se a conta pode receber créditos |
| Analítica | Se é conta de último nível |
| Redutora | Se é conta redutora do grupo |
