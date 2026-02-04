// frontend/src/services/socket.ts
import { Socket, Channel } from 'phoenix';

const WS_URL = import.meta.env.VITE_WS_URL || 'ws://localhost:4000/socket';

let socket: Socket | null = null;
let searchChannel: Channel | null = null;

export function connectSocket(): Socket {
  if (socket) return socket;

  socket = new Socket(WS_URL, {});
  socket.connect();

  return socket;
}

export function joinSearchChannel(): Channel {
  if (searchChannel) return searchChannel;

  const sock = connectSocket();
  searchChannel = sock.channel('live_search:lobby', {});

  searchChannel
    .join()
    .receive('ok', () => console.log('Joined live_search channel'))
    .receive('error', (resp) => console.error('Unable to join', resp));

  return searchChannel;
}

export interface SearchSuggestion {
  code: string;
  name: string;
  level: number;
}

export function liveSearch(
  query: string,
  callback: (suggestions: SearchSuggestion[]) => void
): void {
  const channel = joinSearchChannel();

  channel
    .push('search', { query })
    .receive('ok', (response) => {
      callback(response.suggestions);
    })
    .receive('error', (err) => {
      console.error('Search error:', err);
      callback([]);
    });
}
