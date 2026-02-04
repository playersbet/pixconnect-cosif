<!-- frontend/src/components/SearchBar.vue -->
<script setup lang="ts">
import { ref, watch } from 'vue';
import { useDebounceFn } from '@vueuse/core';
import { useAccountsStore } from '@/stores/accounts';

const store = useAccountsStore();
const inputRef = ref<HTMLInputElement | null>(null);
const showSuggestions = ref(false);

const debouncedSearch = useDebounceFn((query: string) => {
  store.updateSuggestions(query);
}, 150);

function onInput(event: Event) {
  const value = (event.target as HTMLInputElement).value;
  debouncedSearch(value);
  showSuggestions.value = true;
}

function selectSuggestion(code: string) {
  store.getAccount(code);
  showSuggestions.value = false;
  if (inputRef.value) {
    inputRef.value.value = code;
  }
}

function onSubmit() {
  showSuggestions.value = false;
  store.search({ q: store.searchQuery, ...store.filters });
}
</script>

<template>
  <div class="relative w-full max-w-2xl">
    <form @submit.prevent="onSubmit" class="flex gap-2">
      <input
        ref="inputRef"
        type="text"
        placeholder="Buscar conta, código ou descrição..."
        class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
        @input="onInput"
        @focus="showSuggestions = true"
        @blur="() => setTimeout(() => showSuggestions = false, 200)"
      />
      <button
        type="submit"
        class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
      >
        Buscar
      </button>
    </form>

    <!-- Suggestions dropdown -->
    <div
      v-if="showSuggestions && store.suggestions.length > 0"
      class="absolute z-10 w-full mt-1 bg-white border border-gray-200 rounded-lg shadow-lg max-h-64 overflow-y-auto"
    >
      <button
        v-for="suggestion in store.suggestions"
        :key="suggestion.code"
        class="w-full px-4 py-2 text-left hover:bg-gray-100 flex justify-between items-center"
        @click="selectSuggestion(suggestion.code)"
      >
        <span class="font-mono text-sm text-gray-600">{{ suggestion.code }}</span>
        <span class="text-gray-800 truncate ml-2">{{ suggestion.name }}</span>
      </button>
    </div>
  </div>
</template>
