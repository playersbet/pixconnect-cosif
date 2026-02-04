<!-- frontend/src/views/SearchView.vue -->
<script setup lang="ts">
import { useAccountsStore } from '@/stores/accounts';
import SearchBar from '@/components/SearchBar.vue';
import AccountCard from '@/components/AccountCard.vue';

const store = useAccountsStore();

function handleAccountSelect(code: string) {
  store.getAccount(code);
}
</script>

<template>
  <div class="space-y-8">
    <!-- Search Section -->
    <section class="flex flex-col items-center py-8">
      <h2 class="text-3xl font-bold text-gray-900 mb-6">
        Busca de Contas COSIF
      </h2>
      <SearchBar />
    </section>

    <!-- Results Section -->
    <section v-if="store.loading" class="text-center py-8">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
      <p class="mt-4 text-gray-600">Carregando...</p>
    </section>

    <section v-else-if="store.error" class="text-center py-8">
      <p class="text-red-600">{{ store.error }}</p>
    </section>

    <section v-else-if="store.accounts.length > 0" class="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
      <AccountCard
        v-for="account in store.accounts"
        :key="account.id"
        :account="account"
        @select="handleAccountSelect"
      />
    </section>

    <!-- Current Account Detail -->
    <section
      v-if="store.currentAccount"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4"
      @click.self="store.currentAccount = null"
    >
      <div class="bg-white rounded-lg shadow-xl max-w-2xl w-full max-h-[80vh] overflow-y-auto p-6">
        <div class="flex justify-between items-start mb-4">
          <span class="font-mono text-xl text-blue-600">
            {{ store.currentAccount.code }}
          </span>
          <button
            class="text-gray-400 hover:text-gray-600"
            @click="store.currentAccount = null"
          >
            ✕
          </button>
        </div>

        <h3 class="text-2xl font-bold text-gray-900 mb-4">
          {{ store.currentAccount.name }}
        </h3>

        <p v-if="store.currentAccount.description" class="text-gray-600 mb-4">
          {{ store.currentAccount.description }}
        </p>

        <dl class="grid grid-cols-2 gap-4 text-sm">
          <div>
            <dt class="text-gray-500">Nível</dt>
            <dd class="font-medium">{{ store.currentAccount.level }}</dd>
          </div>
          <div>
            <dt class="text-gray-500">Grupo</dt>
            <dd class="font-medium">{{ store.currentAccount.group_code || '-' }}</dd>
          </div>
          <div>
            <dt class="text-gray-500">Aceita Crédito</dt>
            <dd class="font-medium">{{ store.currentAccount.accepts_credit ? 'Sim' : 'Não' }}</dd>
          </div>
          <div>
            <dt class="text-gray-500">Aceita Débito</dt>
            <dd class="font-medium">{{ store.currentAccount.accepts_debit ? 'Sim' : 'Não' }}</dd>
          </div>
        </dl>

        <div v-if="store.currentAccount.parent" class="mt-4 pt-4 border-t">
          <p class="text-sm text-gray-500">Conta Pai:</p>
          <p class="font-mono text-sm">
            {{ store.currentAccount.parent.code }} - {{ store.currentAccount.parent.name }}
          </p>
        </div>
      </div>
    </section>
  </div>
</template>
