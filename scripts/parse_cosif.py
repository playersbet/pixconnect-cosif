#!/usr/bin/env python3
"""
Parse COSIF accounts from converted JSON files into database-ready format.
"""

import json
import re
from pathlib import Path
from typing import List, Dict, Optional


def parse_account_line(line: str) -> Optional[Dict]:
    """Parse a single account line from COSIF documents."""
    # Pattern for account codes like "1.0.0.00.00.00-9" or "1.1.1.10.01.10-001"
    pattern = r'^(\d+(?:\.\d+)*(?:-\d+)?)\s+(.+)$'
    match = re.match(pattern, line.strip())

    if match:
        code = match.group(1)
        name = match.group(2).strip()
        return {
            "code": code,
            "name": name,
            "level": calculate_account_level(code)
        }
    return None


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


def extract_accounts_from_json(json_path: Path) -> List[Dict]:
    """Extract account information from a converted JSON file."""
    accounts = []

    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # Parse text content for account patterns
    if data.get('text'):
        for line in data['text'].split('\n'):
            account = parse_account_line(line)
            if account:
                accounts.append(account)

    # Parse tables for structured account data
    if data.get('tables'):
        for table in data['tables']:
            for row in table:
                if row and len(row) >= 2:
                    # Try to parse first column as code, second as name
                    code_cell = str(row[0] or '').strip()
                    name_cell = str(row[1] or '').strip()

                    if re.match(r'^\d+\.\d+', code_cell):
                        accounts.append({
                            "code": code_cell,
                            "name": name_cell,
                            "level": calculate_account_level(code_cell)
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
        # Find parent by looking for shorter matching prefix
        parts = code.split('.')
        for i in range(len(parts) - 1, 0, -1):
            parent_code = '.'.join(parts[:i])
            if parent_code in code_to_account:
                account['parent_code'] = parent_code
                break

    return accounts


def main():
    """Process all JSON files and output structured accounts."""
    docs_dir = Path(__file__).parent.parent / "docs"
    json_dir = docs_dir / "json"
    output_path = json_dir / "accounts_structured.json"

    all_accounts = []

    for json_file in json_dir.glob("*.json"):
        if json_file.name == "accounts_structured.json":
            continue

        print(f"Parsing: {json_file.name}")
        accounts = extract_accounts_from_json(json_file)
        all_accounts.extend(accounts)
        print(f"  Found {len(accounts)} accounts")

    # Remove duplicates by code
    unique_accounts = {}
    for account in all_accounts:
        code = account['code']
        if code not in unique_accounts:
            unique_accounts[code] = account

    accounts_list = list(unique_accounts.values())
    accounts_list = build_hierarchy(accounts_list)

    # Save structured output
    output_path.write_text(
        json.dumps(accounts_list, ensure_ascii=False, indent=2),
        encoding='utf-8'
    )
    print(f"\nSaved {len(accounts_list)} unique accounts to {output_path}")


if __name__ == "__main__":
    main()
