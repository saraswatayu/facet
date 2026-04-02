#!/usr/bin/env python3
"""Parse YAML frontmatter from Facet config files.

Replaces the sed-based parse_frontmatter() in sim.sh with a single
Python parser that handles both scalar values and YAML arrays.

Usage:
    python3 parse_config.py <file> <key>          # print scalar value
    python3 parse_config.py <file> <key> --list   # print array, one item per line
    python3 parse_config.py <file> --body          # print body (everything after frontmatter)
"""

import sys
import yaml


def parse_frontmatter(filepath):
    """Extract YAML frontmatter and body from a markdown file."""
    with open(filepath, 'r') as f:
        content = f.read()

    if not content.startswith('---'):
        return {}, content

    # Find the closing ---
    end = content.find('---', 3)
    if end == -1:
        return {}, content

    frontmatter_str = content[3:end].strip()
    body = content[end + 3:].strip()

    try:
        frontmatter = yaml.safe_load(frontmatter_str) or {}
    except yaml.YAMLError:
        frontmatter = {}

    return frontmatter, body


def main():
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <file> <key> [--list]", file=sys.stderr)
        print(f"       {sys.argv[0]} <file> --body", file=sys.stderr)
        sys.exit(1)

    filepath = sys.argv[1]

    if sys.argv[2] == '--body':
        _, body = parse_frontmatter(filepath)
        print(body)
        return

    key = sys.argv[2]
    as_list = '--list' in sys.argv

    frontmatter, _ = parse_frontmatter(filepath)
    value = frontmatter.get(key, '')

    if as_list:
        if isinstance(value, list):
            for item in value:
                if isinstance(item, dict):
                    # Handle list of dicts — extract 'config' key if present, else first value
                    if 'config' in item:
                        print(item['config'])
                    else:
                        first_val = next(iter(item.values()), None)
                        if first_val is not None:
                            print(first_val)
                else:
                    print(item)
        elif value:
            print(value)
    else:
        if value is None:
            value = ''
        print(value)


if __name__ == '__main__':
    main()
