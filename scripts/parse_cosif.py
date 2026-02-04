#!/usr/bin/env python3
"""
Parse COSIF accounts from converted JSON files into database-ready format.
Extracts account codes, names, descriptions, and attributes.
"""

import json
import re
from pathlib import Path
from typing import List, Dict, Optional, Tuple


def calculate_account_level(code: str) -> int:
    """Calculate hierarchy level from account code."""
    # Remove check digit suffix
    base_code = code.split('-')[0] if '-' in code else code
    parts = base_code.split('.')

    level = 1
    for i, part in enumerate(parts):
        if part != '0' and part != '00':
            level = i + 1

    return min(level, 7)


def normalize_code(code: str) -> str:
    """Normalize account code format."""
    code = code.strip()
    # Remove extra spaces
    code = re.sub(r'\s+', '', code)
    return code


def parse_funcoes_text(text: str) -> Dict[str, Dict]:
    """
    Parse the Funcoes.pdf text to extract account descriptions.

    Format in the PDF:
    1.1.1.10.00.00-8
    Título: CAIXA
    Função:
    Registrar o numerário existente em moeda corrente nacional.
    Base normativa: INBCB493
    """
    accounts = {}

    # Pattern to match account code at start of a block
    code_pattern = r'^(\d+\.\d+\.\d+\.\d+\.\d+\.\d+-\d+)'

    # Split into blocks by account code
    lines = text.split('\n')
    current_code = None
    current_title = None
    current_function = []
    current_base = None
    in_function = False

    for line in lines:
        line = line.strip()
        if not line:
            continue

        # Check if this is a new account code
        code_match = re.match(code_pattern, line)
        if code_match:
            # Save previous account if exists
            if current_code and current_function:
                accounts[current_code] = {
                    'title': current_title,
                    'description': ' '.join(current_function).strip(),
                    'base_normativa': current_base
                }

            # Start new account
            current_code = normalize_code(code_match.group(1))
            current_title = None
            current_function = []
            current_base = None
            in_function = False
            continue

        # Parse title
        if line.startswith('Título:'):
            current_title = line.replace('Título:', '').strip()
            continue

        # Parse function start
        if line.startswith('Função:'):
            in_function = True
            rest = line.replace('Função:', '').strip()
            if rest:
                current_function.append(rest)
            continue

        # Parse base normativa (ends the function section)
        if line.startswith('Base normativa:'):
            current_base = line.replace('Base normativa:', '').strip()
            in_function = False
            continue

        # If we're in the function section, accumulate text
        if in_function and current_code:
            # Skip if it looks like a new account code
            if not re.match(code_pattern, line):
                current_function.append(line)

    # Don't forget the last account
    if current_code and current_function:
        accounts[current_code] = {
            'title': current_title,
            'description': ' '.join(current_function).strip(),
            'base_normativa': current_base
        }

    return accounts


def parse_contas_text(text: str) -> List[Dict]:
    """
    Parse the Contas.pdf text to extract account codes and names.

    Format: CODE TITLE ATTRIBUTES
    1.1.0.00.00.00-2 DISPONIBILIDADES -
    """
    accounts = []

    # Pattern for account lines
    # Match: code (with check digit) followed by title and optional attributes
    pattern = r'^(\d+\.\d+\.\d+\.\d+\.\d+\.\d+-\d+)\s+(.+?)(?:\s+(\d{3}|-))?$'

    for line in text.split('\n'):
        line = line.strip()
        if not line:
            continue

        match = re.match(pattern, line)
        if match:
            code = normalize_code(match.group(1))
            name = match.group(2).strip()
            attr = match.group(3) if match.group(3) else None

            # Clean up name - remove trailing dash or attribute code
            name = re.sub(r'\s*-\s*$', '', name)
            name = re.sub(r'\s+\d{3}\s*$', '', name)

            accounts.append({
                'code': code,
                'name': name,
                'level': calculate_account_level(code),
                'attribute_code': attr if attr and attr != '-' else None
            })

    return accounts


def parse_tables_for_accounts(tables: List) -> List[Dict]:
    """Extract accounts from table data."""
    accounts = []

    for table in tables:
        if not table:
            continue

        for row in table:
            if not row or len(row) < 2:
                continue

            code_cell = str(row[0] or '').strip()
            name_cell = str(row[1] or '').strip()

            # Check if first cell looks like an account code
            if re.match(r'^\d+\.\d+\.\d+\.\d+\.\d+\.\d+-\d+$', code_cell):
                accounts.append({
                    'code': normalize_code(code_cell),
                    'name': name_cell,
                    'level': calculate_account_level(code_cell)
                })

    return accounts


def build_hierarchy(accounts: List[Dict]) -> List[Dict]:
    """Build parent-child relationships for accounts."""
    # Sort by code to ensure parents come before children
    accounts = sorted(accounts, key=lambda x: x['code'])

    # Create lookup by code
    code_to_account = {a['code']: a for a in accounts}

    for account in accounts:
        code = account['code']
        # Find parent by progressively shortening the code
        code_without_check = code.rsplit('-', 1)[0] if '-' in code else code
        code_parts = code_without_check.split('.')

        for i in range(len(code_parts) - 1, 0, -1):
            # Build potential parent code
            parent_parts = code_parts[:i]
            # Pad with zeros
            while len(parent_parts) < 6:
                if len(parent_parts) < 3:
                    parent_parts.append('0')
                else:
                    parent_parts.append('00')

            parent_base = '.'.join(parent_parts)

            # Try to find this parent in our accounts
            for existing_code in code_to_account.keys():
                existing_base = existing_code.rsplit('-', 1)[0] if '-' in existing_code else existing_code
                if existing_base == parent_base:
                    # Never set parent to self
                    if existing_code != code:
                        account['parent_code'] = existing_code
                    break

            if 'parent_code' in account:
                break

    return accounts


def main():
    """Process all JSON files and output structured accounts."""
    docs_dir = Path(__file__).parent.parent / "docs"
    json_dir = docs_dir / "json"
    output_path = json_dir / "accounts_structured.json"

    # First, extract descriptions from Funcoes.json
    funcoes_path = json_dir / "Funcoes.json"
    descriptions = {}

    if funcoes_path.exists():
        print(f"Parsing descriptions from: {funcoes_path.name}")
        with open(funcoes_path, 'r', encoding='utf-8') as f:
            funcoes_data = json.load(f)

        if funcoes_data.get('text'):
            descriptions = parse_funcoes_text(funcoes_data['text'])
            print(f"  Found {len(descriptions)} account descriptions")

    # Extract accounts from Contas.json
    contas_path = json_dir / "Contas.json"
    all_accounts = []

    if contas_path.exists():
        print(f"Parsing accounts from: {contas_path.name}")
        with open(contas_path, 'r', encoding='utf-8') as f:
            contas_data = json.load(f)

        if contas_data.get('text'):
            text_accounts = parse_contas_text(contas_data['text'])
            all_accounts.extend(text_accounts)
            print(f"  Found {len(text_accounts)} accounts from text")

        if contas_data.get('tables'):
            table_accounts = parse_tables_for_accounts(contas_data['tables'])
            all_accounts.extend(table_accounts)
            print(f"  Found {len(table_accounts)} accounts from tables")

    # Remove duplicates by code, keeping the most complete version
    unique_accounts = {}
    for account in all_accounts:
        code = account['code']
        if code not in unique_accounts:
            unique_accounts[code] = account
        else:
            # Merge - keep the one with more info
            existing = unique_accounts[code]
            if not existing.get('name') and account.get('name'):
                existing['name'] = account['name']

    # Merge descriptions from Funcoes
    for code, desc_data in descriptions.items():
        if code in unique_accounts:
            unique_accounts[code]['description'] = desc_data.get('description')
            unique_accounts[code]['base_normativa'] = desc_data.get('base_normativa')
            # Use title from Funcoes if we don't have a name
            if not unique_accounts[code].get('name') and desc_data.get('title'):
                unique_accounts[code]['name'] = desc_data['title']
        else:
            # Account exists in Funcoes but not in Contas - add it
            unique_accounts[code] = {
                'code': code,
                'name': desc_data.get('title', ''),
                'description': desc_data.get('description'),
                'base_normativa': desc_data.get('base_normativa'),
                'level': calculate_account_level(code)
            }

    accounts_list = list(unique_accounts.values())
    accounts_list = build_hierarchy(accounts_list)

    # Count accounts with descriptions
    with_desc = sum(1 for a in accounts_list if a.get('description'))
    print(f"\nAccounts with descriptions: {with_desc}/{len(accounts_list)}")

    # Save structured output
    output_path.write_text(
        json.dumps(accounts_list, ensure_ascii=False, indent=2),
        encoding='utf-8'
    )
    print(f"Saved {len(accounts_list)} unique accounts to {output_path}")


if __name__ == "__main__":
    main()
