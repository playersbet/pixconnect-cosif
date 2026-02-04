<!-- frontend/src/components/AccountCard.vue -->
<script setup lang="ts">
import type { Account } from '@/services/api';

defineProps<{
  account: Account;
}>();

defineEmits<{
  (e: 'select', code: string): void;
}>();
</script>

<template>
  <div
    class="p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition cursor-pointer"
    @click="$emit('select', account.code)"
  >
    <div class="flex justify-between items-start mb-2">
      <span class="font-mono text-sm text-blue-600 font-semibold">
        {{ account.code }}
      </span>
      <span class="text-xs px-2 py-1 bg-gray-100 rounded">
        Nível {{ account.level }}
      </span>
    </div>

    <h3 class="text-lg font-medium text-gray-900 mb-1">
      {{ account.name }}
    </h3>

    <p v-if="account.description" class="text-sm text-gray-600 line-clamp-2">
      {{ account.description }}
    </p>

    <div class="mt-3 flex gap-2">
      <span
        v-if="account.accepts_credit"
        class="text-xs px-2 py-1 bg-green-100 text-green-800 rounded"
      >
        Crédito
      </span>
      <span
        v-if="account.accepts_debit"
        class="text-xs px-2 py-1 bg-red-100 text-red-800 rounded"
      >
        Débito
      </span>
      <span
        v-if="account.is_analytical"
        class="text-xs px-2 py-1 bg-purple-100 text-purple-800 rounded"
      >
        Analítica
      </span>
    </div>
  </div>
</template>
