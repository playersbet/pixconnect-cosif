#!/usr/bin/env python3
"""
COSIF PDF to Markdown/JSON Converter
Extracts tables and text from COSIF documentation PDFs.
"""

import os
import json
import re
from pathlib import Path
from typing import List, Dict, Any

import pdfplumber


def extract_text_from_pdf(pdf_path: str) -> str:
    """Extract all text from a PDF file."""
    text_content = []
    with pdfplumber.open(pdf_path) as pdf:
        for page in pdf.pages:
            text = page.extract_text()
            if text:
                text_content.append(text)
    return "\n\n".join(text_content)


def extract_tables_from_pdf(pdf_path: str) -> List[List[List[str]]]:
    """Extract all tables from a PDF file."""
    all_tables = []
    with pdfplumber.open(pdf_path) as pdf:
        for page in pdf.pages:
            tables = page.extract_tables()
            if tables:
                all_tables.extend(tables)
    return all_tables


def parse_account_code(code: str) -> Dict[str, Any]:
    """Parse a COSIF account code into its components."""
    # Pattern: X.X.X.XX.XX.XX-X or variations
    pattern = r'^(\d)\.(\d)\.(\d)\.(\d{2})\.(\d{2})\.(\d{2})-?(\d)?$'
    match = re.match(pattern, code.replace(' ', ''))

    if match:
        groups = match.groups()
        return {
            "code": code,
            "group": groups[0],
            "subgroup1": groups[1],
            "subgroup2": groups[2],
            "subgroup3": groups[3],
            "subgroup4": groups[4],
            "subgroup5": groups[5],
            "check_digit": groups[6] if groups[6] else None,
            "level": calculate_level(groups)
        }
    return None


def calculate_level(groups: tuple) -> int:
    """Calculate the hierarchy level based on non-zero groups."""
    level = 1
    for i, g in enumerate(groups[:6]):
        if g and g != '0' and g != '00':
            level = i + 1
    return min(level, 7)


def convert_to_markdown(pdf_name: str, text: str, tables: List) -> str:
    """Convert extracted content to Markdown format."""
    md_content = [f"# {pdf_name.replace('.pdf', '').replace('_', ' ').title()}\n"]

    # Add text content
    if text:
        md_content.append("## Conteúdo\n")
        md_content.append(text)

    # Add tables
    if tables:
        md_content.append("\n## Tabelas\n")
        for i, table in enumerate(tables):
            if table and len(table) > 1:
                md_content.append(f"\n### Tabela {i + 1}\n")
                # Header row
                header = table[0]
                md_content.append("| " + " | ".join(str(h or '') for h in header) + " |")
                md_content.append("|" + "|".join(["---"] * len(header)) + "|")
                # Data rows
                for row in table[1:]:
                    md_content.append("| " + " | ".join(str(c or '') for c in row) + " |")

    return "\n".join(md_content)


def main():
    """Main conversion function."""
    docs_dir = Path(__file__).parent.parent / "docs"
    pdfs_dir = docs_dir / "pdfs"
    markdown_dir = docs_dir / "markdown"
    json_dir = docs_dir / "json"

    # Create output directories
    markdown_dir.mkdir(exist_ok=True)
    json_dir.mkdir(exist_ok=True)

    # Move existing PDFs to pdfs subdirectory
    pdfs_dir.mkdir(exist_ok=True)
    for pdf in docs_dir.glob("*.pdf"):
        pdf.rename(pdfs_dir / pdf.name)

    # Process each PDF
    for pdf_file in pdfs_dir.glob("*.pdf"):
        print(f"Processing: {pdf_file.name}")

        # Extract content
        text = extract_text_from_pdf(str(pdf_file))
        tables = extract_tables_from_pdf(str(pdf_file))

        # Save as Markdown
        md_content = convert_to_markdown(pdf_file.name, text, tables)
        md_path = markdown_dir / f"{pdf_file.stem}.md"
        md_path.write_text(md_content, encoding='utf-8')
        print(f"  Created: {md_path}")

        # Save raw data as JSON
        json_data = {
            "source": pdf_file.name,
            "text": text,
            "tables": tables
        }
        json_path = json_dir / f"{pdf_file.stem}.json"
        json_path.write_text(json.dumps(json_data, ensure_ascii=False, indent=2), encoding='utf-8')
        print(f"  Created: {json_path}")

    print("\nConversion complete!")


if __name__ == "__main__":
    main()
