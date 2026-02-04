<!-- frontend/src/views/SearchView.vue -->
<script setup lang="ts">
import { ref } from 'vue';
import { useAccountsStore } from '@/stores/accounts';
import { accountsApi, type Account } from '@/services/api';
import SearchBar from '@/components/SearchBar.vue';
import AccountCard from '@/components/AccountCard.vue';

const store = useAccountsStore();
const children = ref<Account[]>([]);
const ancestry = ref<Account[]>([]);
const loadingDetails = ref(false);

async function handleAccountSelect(code: string) {
  loadingDetails.value = true;
  await store.getAccount(code);

  // Load children and ancestry
  try {
    const [childrenRes, ancestryRes] = await Promise.all([
      accountsApi.getChildren(code),
      accountsApi.getAncestry(code)
    ]);
    children.value = childrenRes.data;
    ancestry.value = ancestryRes.data;
  } catch (e) {
    console.error('Failed to load account details:', e);
  } finally {
    loadingDetails.value = false;
  }
}

function closeModal() {
  store.currentAccount = null;
  children.value = [];
  ancestry.value = [];
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

    <section v-else-if="store.accounts.length > 0">
      <p class="text-sm text-gray-500 mb-4">{{ store.accounts.length }} resultados encontrados</p>
      <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        <AccountCard
          v-for="account in store.accounts"
          :key="account.id"
          :account="account"
          @select="handleAccountSelect"
        />
      </div>
    </section>

    <!-- Current Account Detail Modal -->
    <Teleport to="body">
      <div
        v-if="store.currentAccount"
        class="fixed inset-0 z-50 bg-black/60 flex items-center justify-center p-4"
        @click.self="closeModal"
      >
        <div class="bg-white rounded-xl shadow-2xl max-w-3xl w-full max-h-[90vh] overflow-hidden flex flex-col">
          <!-- Modal Header -->
          <div class="bg-blue-600 text-white px-6 py-4 flex justify-between items-center">
            <div>
              <span class="font-mono text-lg opacity-90">{{ store.currentAccount.code }}</span>
              <span class="mx-2 opacity-50">|</span>
              <span class="text-sm opacity-75">Nível {{ store.currentAccount.level }}</span>
            </div>
            <button
              class="text-white/80 hover:text-white text-2xl leading-none"
              @click="closeModal"
            >
              ×
            </button>
          </div>

          <!-- Modal Body -->
          <div class="p-6 overflow-y-auto flex-1">
            <h3 class="text-2xl font-bold text-gray-900 mb-4">
              {{ store.currentAccount.name }}
            </h3>

            <p v-if="store.currentAccount.description" class="text-gray-600 mb-6 whitespace-pre-wrap">
              {{ store.currentAccount.description }}
            </p>

            <!-- Attributes -->
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
              <div class="bg-gray-50 rounded-lg p-3 text-center">
                <dt class="text-xs text-gray-500 uppercase">Grupo</dt>
                <dd class="font-semibold text-lg">{{ store.currentAccount.group_code || '-' }}</dd>
              </div>
              <div class="bg-gray-50 rounded-lg p-3 text-center">
                <dt class="text-xs text-gray-500 uppercase">Nível</dt>
                <dd class="font-semibold text-lg">{{ store.currentAccount.level }}</dd>
              </div>
              <div class="bg-gray-50 rounded-lg p-3 text-center">
                <dt class="text-xs text-gray-500 uppercase">Crédito</dt>
                <dd class="font-semibold text-lg" :class="store.currentAccount.accepts_credit ? 'text-green-600' : 'text-gray-400'">
                  {{ store.currentAccount.accepts_credit ? 'Sim' : 'Não' }}
                </dd>
              </div>
              <div class="bg-gray-50 rounded-lg p-3 text-center">
                <dt class="text-xs text-gray-500 uppercase">Débito</dt>
                <dd class="font-semibold text-lg" :class="store.currentAccount.accepts_debit ? 'text-red-600' : 'text-gray-400'">
                  {{ store.currentAccount.accepts_debit ? 'Sim' : 'Não' }}
                </dd>
              </div>
            </div>

            <!-- Ancestry (Breadcrumb) -->
            <div v-if="ancestry.length > 1" class="mb-6">
              <h4 class="text-sm font-semibold text-gray-700 mb-2">Hierarquia</h4>
              <div class="flex flex-wrap items-center gap-1 text-sm">
                <template v-for="(ancestor, idx) in ancestry" :key="ancestor.id">
                  <span
                    class="px-2 py-1 rounded cursor-pointer hover:bg-blue-100"
                    :class="idx === ancestry.length - 1 ? 'bg-blue-100 text-blue-700 font-medium' : 'bg-gray-100 text-gray-600'"
                    @click="idx !== ancestry.length - 1 && handleAccountSelect(ancestor.code)"
                  >
                    {{ ancestor.code }}
                  </span>
                  <span v-if="idx < ancestry.length - 1" class="text-gray-400">→</span>
                </template>
              </div>
            </div>

            <!-- Parent Info -->
            <div v-if="store.currentAccount.parent" class="mb-6 p-4 bg-gray-50 rounded-lg">
              <h4 class="text-sm font-semibold text-gray-700 mb-2">Conta Pai</h4>
              <p
                class="font-mono text-sm text-blue-600 cursor-pointer hover:underline"
                @click="handleAccountSelect(store.currentAccount.parent.code)"
              >
                {{ store.currentAccount.parent.code }}
              </p>
              <p class="text-sm text-gray-600">{{ store.currentAccount.parent.name }}</p>
            </div>

            <!-- Children -->
            <div v-if="children.length > 0" class="mb-4">
              <h4 class="text-sm font-semibold text-gray-700 mb-2">
                Subcontas ({{ children.length }})
              </h4>
              <div class="max-h-48 overflow-y-auto border rounded-lg divide-y">
                <div
                  v-for="child in children"
                  :key="child.id"
                  class="px-3 py-2 hover:bg-gray-50 cursor-pointer flex justify-between items-center"
                  @click="handleAccountSelect(child.code)"
                >
                  <span class="font-mono text-sm text-blue-600">{{ child.code }}</span>
                  <span class="text-sm text-gray-600 truncate ml-2">{{ child.name }}</span>
                </div>
              </div>
            </div>

            <!-- Loading indicator for details -->
            <div v-if="loadingDetails" class="text-center py-4">
              <div class="animate-spin rounded-full h-6 w-6 border-b-2 border-blue-600 mx-auto"></div>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>
