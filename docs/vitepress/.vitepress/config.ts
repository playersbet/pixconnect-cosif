import { defineConfig } from 'vitepress';

export default defineConfig({
  title: 'COSIF Documentation',
  description: 'Plano Contábil das Instituições do Sistema Financeiro Nacional',
  lang: 'pt-BR',

  themeConfig: {
    nav: [
      { text: 'Manual', link: '/manual/' },
      { text: 'Contas', link: '/contas/' },
      { text: 'Funções', link: '/funcoes/' },
      { text: 'API', link: '/api/' },
    ],

    sidebar: {
      '/manual/': [
        {
          text: 'Manual COSIF',
          items: [
            { text: 'Introdução', link: '/manual/' },
            { text: 'Estrutura', link: '/manual/estrutura' },
          ],
        },
      ],
      '/contas/': [
        {
          text: 'Plano de Contas',
          items: [
            { text: 'Visão Geral', link: '/contas/' },
            { text: 'Ativo', link: '/contas/ativo' },
            { text: 'Passivo', link: '/contas/passivo' },
          ],
        },
      ],
    },

    search: {
      provider: 'local',
    },
  },
});
