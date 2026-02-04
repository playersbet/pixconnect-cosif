/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_URL: string
  readonly VITE_WS_URL: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}

declare module 'phoenix' {
  export class Socket {
    constructor(endPoint: string, opts?: object)
    connect(): void
    disconnect(): void
    channel(topic: string, params?: object): Channel
    onOpen(callback: () => void): void
    onError(callback: (error: any) => void): void
    onClose(callback: () => void): void
  }

  export class Channel {
    join(): Push
    leave(): Push
    push(event: string, payload?: object): Push
    on(event: string, callback: (payload: any) => void): void
  }

  export class Push {
    receive(status: string, callback: (response: any) => void): Push
  }
}
