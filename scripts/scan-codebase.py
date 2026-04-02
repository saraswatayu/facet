#!/usr/bin/env python3
"""Scan a codebase for pricing, feature, and onboarding data.

Pattern-based file discovery and value extraction. Finds facts (dollar amounts,
plan names, feature names) without attempting semantic code understanding.

Usage:
    python3 scan-codebase.py [--root /path/to/project]

Outputs JSON to stdout with extracted data for the /facet skill to present to the user.
"""

import glob
import json
import os
import re
import sys


# --- Filename patterns ---

PATTERNS = {
    'pricing': ['*pricing*', '*plan*', '*tier*', '*subscription*', '*billing*'],
    'features': ['*feature*', '*flag*', '*capability*'],
    'onboarding': ['*onboarding*', '*signup*', '*welcome*', '*tutorial*'],
}

EXCLUDE_DIRS = {
    'node_modules', 'vendor', '.git', 'dist', 'build', '__pycache__',
    '.next', '.nuxt', 'coverage', '.tox', 'venv', '.venv', 'env',
}

MAX_LINES_PER_FILE = 200


# --- Value extraction ---

DOLLAR_PATTERN = re.compile(r'\$\d+(?:\.\d{2})?(?:/(?:mo|month|yr|year|seat|user))?', re.IGNORECASE)
PLAN_NAME_PATTERN = re.compile(r'(?:plan|tier|level)\s*[:\-=]\s*["\']?([A-Za-z][A-Za-z0-9 ]+)', re.IGNORECASE)
FEATURE_NAME_PATTERN = re.compile(r'(?:feature|flag)\s*[:\-=]\s*["\']?([A-Za-z][A-Za-z0-9_\- ]+)', re.IGNORECASE)


def should_exclude(path):
    """Check if a path contains an excluded directory."""
    parts = path.split(os.sep)
    return any(part in EXCLUDE_DIRS for part in parts)


def find_matching_files(root, category):
    """Find files matching patterns for a category."""
    matches = []
    for pattern in PATTERNS[category]:
        for filepath in glob.glob(os.path.join(root, '**', pattern), recursive=True):
            if os.path.isfile(filepath) and not should_exclude(filepath):
                matches.append(filepath)
    return sorted(set(matches))


def extract_values(filepath, root):
    """Extract concrete values from a file's first N lines."""
    results = {
        'file': os.path.relpath(filepath, root),
        'dollar_amounts': [],
        'plan_names': [],
        'feature_names': [],
    }

    try:
        with open(filepath, 'r', errors='replace') as f:
            lines = []
            for i, line in enumerate(f):
                if i >= MAX_LINES_PER_FILE:
                    break
                lines.append(line)
    except (IOError, OSError):
        return results

    text = ''.join(lines)

    # Extract dollar amounts
    for match in DOLLAR_PATTERN.finditer(text):
        val = match.group(0)
        if val not in results['dollar_amounts']:
            results['dollar_amounts'].append(val)

    # Extract plan/tier names
    for match in PLAN_NAME_PATTERN.finditer(text):
        name = match.group(1).strip().rstrip('"\'')
        if name and name not in results['plan_names'] and len(name) < 50:
            results['plan_names'].append(name)

    # Extract feature names
    for match in FEATURE_NAME_PATTERN.finditer(text):
        name = match.group(1).strip().rstrip('"\'')
        if name and name not in results['feature_names'] and len(name) < 50:
            results['feature_names'].append(name)

    return results


# --- Main ---

def scan(root):
    """Scan a project root and return structured findings."""
    findings = {}

    for category in PATTERNS:
        files = find_matching_files(root, category)
        if not files:
            findings[category] = {'files': [], 'values': []}
            continue

        values = []
        for filepath in files:
            extracted = extract_values(filepath, root)
            if extracted['dollar_amounts'] or extracted['plan_names'] or extracted['feature_names']:
                values.append(extracted)

        findings[category] = {
            'files': [os.path.relpath(f, root) for f in files],
            'values': values,
        }

    # Summary
    total_files = sum(len(f['files']) for f in findings.values())
    has_data = any(len(f['values']) > 0 for f in findings.values())

    return {
        'root': root,
        'total_files_found': total_files,
        'has_extractable_data': has_data,
        'findings': findings,
    }


def main():
    root = os.getcwd()
    args = sys.argv[1:]
    i = 0
    while i < len(args):
        if args[i] == '--root' and i + 1 < len(args):
            root = args[i + 1]
            i += 2
        else:
            print(f'Unknown argument: {args[i]}', file=sys.stderr)
            sys.exit(1)

    root = os.path.abspath(root)
    if not os.path.isdir(root):
        print(f'Not a directory: {root}', file=sys.stderr)
        sys.exit(1)

    result = scan(root)
    json.dump(result, sys.stdout, indent=2)
    print()


if __name__ == '__main__':
    main()
