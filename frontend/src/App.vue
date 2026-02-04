<!-- frontend/src/App.vue -->
<script setup lang="ts">
</script>

<template>
  <div class="min-h-screen bg-gray-50">
    <header class="bg-white shadow-sm border-b">
      <div class="max-w-7xl mx-auto px-4 py-4">
        <div class="flex justify-between items-center">
          <h1 class="text-2xl font-bold text-gray-900">
            COSIF
          </h1>
          <nav class="flex gap-4">
            <a href="/" class="text-gray-600 hover:text-gray-900">
              Busca
            </a>
            <a href="/explorer" class="text-gray-600 hover:text-gray-900">
              Explorador
            </a>
            <a href="/docs" class="text-gray-600 hover:text-gray-900">
              Documentação
            </a>
          </nav>
        </div>
      </div>
    </header>

    <main class="max-w-7xl mx-auto px-4 py-8">
      <SearchView />
    </main>
  </div>
</template>

<script lang="ts">
import SearchView from '@/views/SearchView.vue';

export default {
  components: {
    SearchView,
  },
};
</script>
