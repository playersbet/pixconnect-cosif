import { defineConfig } from 'vitepress';

export default defineConfig({
  title: 'COSIF',
  description: 'Plano Contábil das Instituições do Sistema Financeiro Nacional',
  lang: 'pt-BR',
  base: '/docs/',

  head: [
    ['link', { rel: 'icon', href: '/favicon.ico' }],
    ['meta', { name: 'theme-color', content: '#3b82f6' }],
    ['meta', { name: 'og:type', content: 'website' }],
    ['meta', { name: 'og:title', content: 'COSIF - Documentação' }],
    ['meta', { name: 'og:description', content: 'Plano Contábil das Instituições do Sistema Financeiro Nacional' }],
  ],

  themeConfig: {
    logo: '/logo.svg',
    siteTitle: 'COSIF',

    nav: [
      { text: 'Início', link: '/' },
      { text: 'Manual', link: '/manual/' },
      { text: 'Plano de Contas', link: '/contas/' },
      { text: 'Funções', link: '/funcoes/' },
      { text: 'API', link: '/api/' },
    ],

    sidebar: {
      '/manual/': [
        {
          text: 'Manual COSIF',
          collapsed: false,
          items: [
            { text: 'Introdução', link: '/manual/' },
            { text: 'Estrutura do Plano', link: '/manual/estrutura' },
            { text: 'Normas Básicas', link: '/manual/normas' },
            { text: 'Documentos', link: '/manual/documentos' },
          ],
        },
      ],
      '/contas/': [
        {
          text: 'Plano de Contas',
          collapsed: false,
          items: [
            { text: 'Visão Geral', link: '/contas/' },
            { text: '1 - Ativo', link: '/contas/ativo' },
            { text: '2 - Passivo', link: '/contas/passivo' },
            { text: '3 - Patrimônio Líquido', link: '/contas/patrimonio' },
            { text: '7 - Contas de Resultado Credoras', link: '/contas/receitas' },
            { text: '8 - Contas de Resultado Devedoras', link: '/contas/despesas' },
          ],
        },
      ],
      '/funcoes/': [
        {
          text: 'Funções das Contas',
          collapsed: false,
          items: [
            { text: 'Visão Geral', link: '/funcoes/' },
            { text: 'Buscar Função', link: '/funcoes/busca' },
          ],
        },
      ],
      '/api/': [
        {
          text: 'API Reference',
          collapsed: false,
          items: [
            { text: 'Introdução', link: '/api/' },
            { text: 'Autenticação', link: '/api/auth' },
            { text: 'Contas', link: '/api/accounts' },
            { text: 'Busca', link: '/api/search' },
            { text: 'WebSocket', link: '/api/websocket' },
          ],
        },
      ],
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/playersbet/pixconnect-cosif' },
    ],

    footer: {
      message: 'Documentação baseada no COSIF - Banco Central do Brasil',
      copyright: 'Copyright © 2026 PixConnect',
    },

    search: {
      provider: 'local',
      options: {
        translations: {
          button: {
            buttonText: 'Buscar',
            buttonAriaLabel: 'Buscar',
          },
          modal: {
            noResultsText: 'Nenhum resultado para',
            resetButtonTitle: 'Limpar busca',
            footer: {
              selectText: 'para selecionar',
              navigateText: 'para navegar',
              closeText: 'para fechar',
            },
          },
        },
      },
    },

    outline: {
      label: 'Nesta página',
      level: [2, 3],
    },

    docFooter: {
      prev: 'Anterior',
      next: 'Próximo',
    },

    lastUpdated: {
      text: 'Atualizado em',
      formatOptions: {
        dateStyle: 'short',
        timeStyle: 'short',
      },
    },

    editLink: {
      pattern: 'https://github.com/playersbet/pixconnect-cosif/edit/main/docs/vitepress/:path',
      text: 'Editar esta página no GitHub',
    },
  },
});
