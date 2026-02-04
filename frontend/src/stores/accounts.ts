// frontend/src/stores/accounts.ts
import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import { accountsApi, type Account, type SearchParams } from '@/services/api';
import { liveSearch, type SearchSuggestion } from '@/services/socket';

export const useAccountsStore = defineStore('accounts', () => {
  // State
  const accounts = ref<Account[]>([]);
  const currentAccount = ref<Account | null>(null);
  const suggestions = ref<SearchSuggestion[]>([]);
  const loading = ref(false);
  const error = ref<string | null>(null);
  const searchQuery = ref('');
  const filters = ref<SearchParams>({});

  // Actions
  async function search(params: SearchParams) {
    loading.value = true;
    error.value = null;

    try {
      const response = await accountsApi.search(params);
      accounts.value = response.data;
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Search failed';
    } finally {
      loading.value = false;
    }
  }

  async function getAccount(code: string) {
    loading.value = true;
    error.value = null;

    try {
      const response = await accountsApi.getByCode(code);
      currentAccount.value = response.data;
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to load account';
    } finally {
      loading.value = false;
    }
  }

  function updateSuggestions(query: string) {
    searchQuery.value = query;
    if (query.length < 2) {
      suggestions.value = [];
      return;
    }

    liveSearch(query, (results) => {
      suggestions.value = results;
    });
  }

  function clearSuggestions() {
    suggestions.value = [];
  }

  function setFilters(newFilters: SearchParams) {
    filters.value = { ...filters.value, ...newFilters };
  }

  function clearFilters() {
    filters.value = {};
  }

  return {
    // State
    accounts,
    currentAccount,
    suggestions,
    loading,
    error,
    searchQuery,
    filters,

    // Actions
    search,
    getAccount,
    updateSuggestions,
    clearSuggestions,
    setFilters,
    clearFilters,
  };
});
