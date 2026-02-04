# WebSocket

A API COSIF oferece busca em tempo real via WebSocket usando Phoenix Channels.

## Conexão

### URL

```
Production: wss://cosif.playersbet.com/socket
Development: ws://localhost:4000/socket
```

### Bibliotecas

Recomendamos usar o cliente oficial do Phoenix:

```bash
npm install phoenix
```

## Conectando

```javascript
import { Socket } from 'phoenix';

// Criar conexão
const socket = new Socket('ws://localhost:4000/socket', {
  params: {}
});

// Conectar
socket.connect();

// Verificar conexão
socket.onOpen(() => console.log('Conectado!'));
socket.onError((error) => console.error('Erro:', error));
socket.onClose(() => console.log('Desconectado'));
```

## Canal de Busca

### Entrar no Canal

```javascript
const channel = socket.channel('live_search:lobby', {});

channel.join()
  .receive('ok', (response) => {
    console.log('Entrou no canal de busca');
  })
  .receive('error', (response) => {
    console.error('Erro ao entrar:', response);
  });
```

### Enviar Busca

```javascript
channel.push('search', { query: 'caixa' })
  .receive('ok', (response) => {
    console.log('Sugestões:', response.suggestions);
  })
  .receive('error', (response) => {
    console.error('Erro na busca:', response);
  });
```

### Resposta

```json
{
  "suggestions": [
    {
      "code": "1.1.1.10.00.00-8",
      "name": "CAIXA",
      "level": 6
    },
    {
      "code": "1.1.1.00.00.00-9",
      "name": "Caixa",
      "level": 3
    }
  ]
}
```

## Exemplo Completo

### Vue 3

```vue
<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import { Socket } from 'phoenix';

const socket = ref(null);
const channel = ref(null);
const query = ref('');
const suggestions = ref([]);

onMounted(() => {
  socket.value = new Socket('ws://localhost:4000/socket');
  socket.value.connect();

  channel.value = socket.value.channel('live_search:lobby');
  channel.value.join();
});

onUnmounted(() => {
  channel.value?.leave();
  socket.value?.disconnect();
});

function search() {
  channel.value.push('search', { query: query.value })
    .receive('ok', (response) => {
      suggestions.value = response.suggestions;
    });
}
</script>

<template>
  <input v-model="query" @input="search" placeholder="Buscar conta..." />
  <ul>
    <li v-for="s in suggestions" :key="s.code">
      {{ s.code }} - {{ s.name }}
    </li>
  </ul>
</template>
```

### React

```jsx
import { useState, useEffect, useRef } from 'react';
import { Socket } from 'phoenix';

function SearchComponent() {
  const [query, setQuery] = useState('');
  const [suggestions, setSuggestions] = useState([]);
  const channelRef = useRef(null);

  useEffect(() => {
    const socket = new Socket('ws://localhost:4000/socket');
    socket.connect();

    const channel = socket.channel('live_search:lobby');
    channel.join();
    channelRef.current = channel;

    return () => {
      channel.leave();
      socket.disconnect();
    };
  }, []);

  const search = (value) => {
    setQuery(value);
    channelRef.current?.push('search', { query: value })
      .receive('ok', (response) => {
        setSuggestions(response.suggestions);
      });
  };

  return (
    <div>
      <input
        value={query}
        onChange={(e) => search(e.target.value)}
        placeholder="Buscar conta..."
      />
      <ul>
        {suggestions.map((s) => (
          <li key={s.code}>{s.code} - {s.name}</li>
        ))}
      </ul>
    </div>
  );
}
```

## Debouncing

Para evitar muitas requisições, use debounce:

```javascript
import { debounce } from 'lodash';

const debouncedSearch = debounce((query) => {
  channel.push('search', { query })
    .receive('ok', (response) => {
      suggestions.value = response.suggestions;
    });
}, 150);

function onInput(event) {
  debouncedSearch(event.target.value);
}
```

## Tratamento de Erros

```javascript
channel.push('search', { query })
  .receive('ok', handleSuccess)
  .receive('error', handleError)
  .receive('timeout', () => {
    console.log('Timeout - tentando novamente...');
    // Implementar retry
  });
```

## Reconexão Automática

O cliente Phoenix já implementa reconexão automática:

```javascript
const socket = new Socket('ws://localhost:4000/socket', {
  reconnectAfterMs: (tries) => {
    return [1000, 2000, 5000, 10000][tries - 1] || 10000;
  }
});
```

## Limitações

- Máximo de 10 sugestões por busca
- Rate limit: 10 buscas por segundo por conexão
- Timeout padrão: 10 segundos
