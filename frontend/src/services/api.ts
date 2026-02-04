// frontend/src/services/api.ts
const API_BASE = import.meta.env.VITE_API_URL || 'http://localhost:4000/api/v1';

export interface Account {
  id: number;
  code: string;
  name: string;
  description?: string;
  level: number;
  accepts_credit: boolean;
  accepts_debit: boolean;
  is_analytical: boolean;
  group_code?: string;
  parent?: { code: string; name: string };
  children_count: number;
}

export interface SearchParams {
  q?: string;
  level?: number;
  group?: string;
  accepts_credit?: boolean;
  accepts_debit?: boolean;
  limit?: number;
  offset?: number;
}

async function fetchJson<T>(url: string): Promise<T> {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  return response.json();
}

export const accountsApi = {
  async getByCode(code: string): Promise<{ data: Account }> {
    return fetchJson(`${API_BASE}/accounts/${encodeURIComponent(code)}`);
  },

  async search(params: SearchParams): Promise<{ data: Account[] }> {
    const query = new URLSearchParams();
    Object.entries(params).forEach(([key, value]) => {
      if (value !== undefined && value !== null) {
        query.set(key, String(value));
      }
    });
    return fetchJson(`${API_BASE}/accounts/search?${query}`);
  },

  async getChildren(code: string): Promise<{ data: Account[] }> {
    return fetchJson(`${API_BASE}/accounts/${encodeURIComponent(code)}/children`);
  },

  async getAncestry(code: string): Promise<{ data: Account[] }> {
    return fetchJson(`${API_BASE}/accounts/${encodeURIComponent(code)}/ancestry`);
  },
};
