#!/usr/bin/env python3
"""Generate Facet panel and study configs from structured conversation data.

Reads JSON from stdin describing a product and research question.
Produces valid YAML-frontmatter markdown configs that parse_config.py accepts.

Usage:
    echo '{"product_name": "TaskFlow", ...}' | python3 generate_config.py [--output-dir /path]

Prints the study config path to stdout on success. Exit 1 on validation failure.
"""

import json
import os
import re
import sys
import tempfile

import yaml

# Add parent directory to path so we can import parse_config
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
from parse_config import parse_frontmatter


# --- Study naming ---

def make_unique_slug(slug, output_dir=None):
    """Auto-increment a slug to avoid directory collisions.

    "homepage-layout" → "homepage-layout" (first time)
    "homepage-layout" → "homepage-layout-2" (second time)
    """
    if not output_dir:
        return slug
    base_slug = slug
    counter = 2
    while os.path.exists(os.path.join(output_dir, slug)):
        slug = f"{base_slug}-{counter}"
        counter += 1
    return slug


def fallback_slug(product_name):
    """Simple fallback slug from product name when no study_name is provided."""
    return re.sub(r'[^\w]', '-', product_name.lower()).strip('-')[:30]


# --- Study type matching ---

STUDY_TYPE_KEYWORDS = {
    'pricing': ['price', 'charge', 'cost', 'tier', 'plan', 'subscription', 'pay',
                'afford', 'freemium', 'free tier', 'annual', 'monthly'],
    'copy': ['copy', 'messaging', 'headline', 'positioning', 'tagline', 'slogan',
             'brand voice', 'landing page', 'variant'],
    'features': ['feature', 'should we build', 'worth adding', 'capability',
                 'functionality', 'prioritize', 'roadmap'],
    'onboarding': ['onboard', 'activation', 'first-time', 'signup',
                   'getting started', 'tutorial', 'welcome'],
    'retention': ['retain', 'churn', 'keep users', 'engagement', 'loyalty',
                  'cancel', 'renew', 'subscription fatigue'],
}


def match_study_type(question):
    """Match a natural language question to a study type via keyword heuristics."""
    question_lower = question.lower()
    scores = {}
    for study_type, keywords in STUDY_TYPE_KEYWORDS.items():
        score = sum(1 for kw in keywords if kw in question_lower)
        if score > 0:
            scores[study_type] = score
    if not scores:
        return 'custom'
    return max(scores, key=scores.get)


# --- Config generation ---

def generate_study_config_file(data, output_dir):
    """Generate a single study config file."""
    study_type = data.get('study_type') or match_study_type(data.get('research_question', ''))
    study_name_val = data.get('study_name') or f"{data['product_name'].lower().replace(' ', '-')}-{study_type}"
    options = data.get('options', [])

    # Build YAML frontmatter (use yaml.dump to handle quoting/escaping)
    frontmatter = {
        'study_name': study_name_val,
        'study_type': study_type,
        'options': [{'name': opt['name'], 'description': opt['description']} for opt in options],
    }
    lines = ['---']
    lines.append(yaml.dump(frontmatter, default_flow_style=False, sort_keys=False).rstrip())
    lines.append('---')
    lines.append('')

    # Build body
    lines.append('## Options to Test')
    lines.append('')
    for opt in options:
        lines.append(f'### {opt["name"]}')
        lines.append('')
        lines.append(opt.get('details', opt['description']))
        lines.append('')

    content = '\n'.join(lines)
    filepath = os.path.join(output_dir, f'{study_name_val}.md')
    with open(filepath, 'w') as f:
        f.write(content)
    return filepath, study_name_val


def auto_scale(data):
    """Pick segment/persona counts based on study complexity.

    Research basis (validation-and-failure-modes.md, Section 6):
    - Below ~12 personas risks missing segments entirely
    - 20-30 is the sweet spot; diminishing returns above 30
    - Beyond ~50 is wasted (errors are systematic, not sample-size)

    Quick check (2 options, single study):      4 segments × 3 = 12 personas
    Standard study (2-4 options):              5 segments × 5 = 25 personas
    Deep study (multi-study or 5+ options):    6 segments × 8 = 48 personas
    """
    num_options = len(data.get('options', []))
    question = data.get('research_question', '').lower()

    # User explicitly asked for quick/fast
    if any(word in question for word in ['quick', 'fast', 'rough', 'sanity check']):
        return 4, 3

    # Multi-study or lifecycle
    if data.get('studies') or any(word in question for word in ['full audit', 'lifecycle', 'comprehensive']):
        return 6, 8

    # Many options = deeper study
    if num_options >= 5:
        return 6, 8

    # Simple A/B or A/B/C
    if num_options <= 3:
        return 5, 5

    # Default
    return 5, 5


def generate_run_config(data, study_paths, output_dir):
    """Generate a full-run config that references study configs."""
    product_name = data['product_name']

    # Auto-scale if user didn't specify
    default_segments, default_pps = auto_scale(data)
    segments = data.get('segments', default_segments)
    personas_per_segment = data.get('personas_per_segment', default_pps)
    description = data.get('product_description', f'{product_name} product.')
    calibration_context = data.get('calibration_context', '')
    codebase_data = data.get('codebase_data', {})

    # Study name: prefer LLM-generated name from input, fall back to product name
    raw_name = data.get('study_name') or fallback_slug(product_name)
    study_name = make_unique_slug(raw_name, output_dir=output_dir)

    # Build YAML frontmatter (use yaml.dump for safe serialization)
    frontmatter = {
        'study_name': study_name,
        'segments': segments,
        'personas_per_segment': personas_per_segment,
    }
    if calibration_context:
        frontmatter['calibration'] = 'calibration.md'
    frontmatter['studies'] = [
        {'config': os.path.relpath(path, output_dir)}
        for path in study_paths
    ]

    lines = ['---']
    lines.append(yaml.dump(frontmatter, default_flow_style=False, sort_keys=False).rstrip())
    lines.append('---')
    lines.append('')

    # Build body (product description)
    lines.append(f'# Product: {product_name}')
    lines.append('')

    # Truncate long descriptions to ~500 words
    words = description.split()
    if len(words) > 500:
        description = ' '.join(words[:500]) + '...'

    lines.append(description)
    lines.append('')

    # Add codebase context if available
    if codebase_data:
        lines.append('## Data from Codebase')
        lines.append('')
        for key, value in codebase_data.items():
            lines.append(f'- {key}: {value}')
        lines.append('')

    content = '\n'.join(lines)
    filepath = os.path.join(output_dir, f'{study_name}-study.md')
    with open(filepath, 'w') as f:
        f.write(content)
    return filepath


def generate_calibration_file(calibration_context, output_dir):
    """Write calibration context from conversation to a file."""
    filepath = os.path.join(output_dir, 'calibration.md')
    with open(filepath, 'w') as f:
        f.write('# Calibration Context\n\n')
        f.write('From user interview during /facet skill invocation.\n\n')
        f.write(calibration_context)
        f.write('\n')
    return filepath


# --- Validation ---

def validate_config(filepath, config_type):
    """Validate a generated config using parse_config.py's parser."""
    frontmatter, body = parse_frontmatter(filepath)
    errors = []

    if config_type == 'run':
        for field in ('segments', 'personas_per_segment'):
            if field not in frontmatter:
                errors.append(f'Missing required field: {field}')
            elif not isinstance(frontmatter[field], int) or frontmatter[field] <= 0:
                errors.append(f'Field {field} must be a positive integer, got: {frontmatter[field]}')
        if 'studies' not in frontmatter:
            errors.append('Missing required field: studies')
        if not body.strip():
            errors.append('Missing product description body')

    elif config_type == 'study':
        for field in ('study_name', 'study_type', 'options'):
            if field not in frontmatter:
                errors.append(f'Missing required field: {field}')
        if 'options' in frontmatter:
            opts = frontmatter['options']
            if not isinstance(opts, list) or len(opts) == 0:
                errors.append('Options must be a non-empty list')
            else:
                for i, opt in enumerate(opts):
                    if not isinstance(opt, dict):
                        errors.append(f'Option {i} must be a dict with name and description')
                    elif 'name' not in opt or 'description' not in opt:
                        errors.append(f'Option {i} missing name or description')

    return errors



# --- Main ---

def main():
    output_dir = None
    args = sys.argv[1:]
    i = 0
    while i < len(args):
        if args[i] == '--output-dir' and i + 1 < len(args):
            output_dir = args[i + 1]
            i += 2
        else:
            print(f'Unknown argument: {args[i]}', file=sys.stderr)
            sys.exit(1)

    if output_dir is None:
        output_dir = tempfile.mkdtemp(prefix='facet-config-')

    os.makedirs(output_dir, exist_ok=True)

    # Read JSON from stdin
    try:
        data = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f'Invalid JSON input: {e}', file=sys.stderr)
        sys.exit(1)

    # Validate required fields
    if 'product_name' not in data:
        print('Missing required field: product_name', file=sys.stderr)
        sys.exit(1)

    # Auto-detect study type if not provided
    if 'study_type' not in data and 'research_question' in data:
        data['study_type'] = match_study_type(data['research_question'])

    # Generate calibration file if context provided
    if data.get('calibration_context'):
        generate_calibration_file(data['calibration_context'], output_dir)

    # Generate study config(s)
    study_paths = []
    study_filepath, study_name_val = generate_study_config_file(data, output_dir)

    # Validate study config
    errors = validate_config(study_filepath, 'study')
    if errors:
        print(f'Study config validation failed:', file=sys.stderr)
        for err in errors:
            print(f'  - {err}', file=sys.stderr)
        sys.exit(1)

    study_paths.append(study_filepath)

    # Generate full-run config
    run_filepath = generate_run_config(data, study_paths, output_dir)

    # Validate run config
    errors = validate_config(run_filepath, 'run')
    if errors:
        print(f'Run config validation failed:', file=sys.stderr)
        for err in errors:
            print(f'  - {err}', file=sys.stderr)
        sys.exit(1)

    # Print the study config path to stdout; the skill flow passes this path to
    # `sim.sh init` and `sim.sh study` phase-by-phase.
    print(study_filepath)


if __name__ == '__main__':
    main()
