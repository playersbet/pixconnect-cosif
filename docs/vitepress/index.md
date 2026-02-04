---
layout: home

hero:
  name: "COSIF"
  text: "Plano Contábil das Instituições Financeiras"
  tagline: Documentação completa e API para consulta do plano de contas COSIF do Banco Central do Brasil
  actions:
    - theme: brand
      text: Começar
      link: /manual/
    - theme: alt
      text: API Reference
      link: /api/
    - theme: alt
      text: Plano de Contas
      link: /contas/

features:
  - icon: 🔍
    title: Busca Inteligente
    details: Pesquise contas por código, nome ou descrição com busca em tempo real e sugestões automáticas.
  - icon: 🌳
    title: Hierarquia Visual
    details: Navegue pela estrutura hierárquica do plano de contas com visualização em árvore interativa.
  - icon: 📖
    title: Funções Documentadas
    details: Acesse a função completa de cada conta, incluindo base normativa e exemplos de uso.
  - icon: ⚡
    title: API REST
    details: Integre o COSIF em suas aplicações através de uma API REST moderna e bem documentada.
  - icon: 🔄
    title: Tempo Real
    details: WebSocket para busca ao vivo com latência mínima e atualizações instantâneas.
  - icon: 📊
    title: Exportação
    details: Exporte dados em múltiplos formatos incluindo JSON, CSV e Excel.
---

## Sobre o COSIF

O **COSIF** (Plano Contábil das Instituições do Sistema Financeiro Nacional) é o plano de contas padronizado pelo Banco Central do Brasil para todas as instituições financeiras autorizadas a funcionar no país.

### Estrutura do Código

As contas COSIF seguem o formato: `X.X.X.XX.XX.XX-D`

| Posição | Descrição | Exemplo |
|---------|-----------|---------|
| 1º dígito | Grupo | 1 = Ativo |
| 2º dígito | Subgrupo | 1.1 = Disponibilidades |
| 3º dígito | Desdobramento | 1.1.1 = Caixa |
| 4º-5º | Título | 1.1.1.10 = Caixa Moeda Nacional |
| 6º-7º | Subtítulo | 1.1.1.10.00 |
| 8º-9º | Item | 1.1.1.10.00.00 |
| Último | Dígito verificador | 1.1.1.10.00.00-8 |

### Grupos Principais

| Grupo | Descrição |
|-------|-----------|
| **1** | Ativo Circulante e Realizável a Longo Prazo |
| **2** | Passivo Circulante e Exigível a Longo Prazo |
| **3** | Patrimônio Líquido |
| **6** | Compensação |
| **7** | Contas de Resultado Credoras |
| **8** | Contas de Resultado Devedoras |
| **9** | Contas Transitórias |
