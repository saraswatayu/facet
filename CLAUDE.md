# Facet — AI Agent Skills Repository

Multi-agent skill distribution hub. Stripe integration guidance (best practices + upgrade paths) served to 25+ coding agent platforms via symlinks from a single source of truth.

## Project Structure

```
.agents/skills/                    # Source of truth for all skills
├── stripe-best-practices/
│   ├── SKILL.md                   # Integration routing (Checkout, Connect, Billing, Treasury)
│   └── references/                # Domain-specific guides
│       ├── payments.md
│       ├── billing.md
│       ├── connect.md
│       └── treasury.md
└── upgrade-stripe/
    └── SKILL.md                   # API version + SDK upgrade guide

skills/                            # Public exports (symlinks → .agents/skills/)
.claude/skills/                    # Agent-specific symlinks (one per platform)
.continue/skills/                  #   all point to ../../.agents/skills/*
.windsurf/skills/                  #   ... 25+ agent directories total
skills-lock.json                   # Version tracking (source, hash, integrity)
```

## Critical Rules

1. **`.agents/skills/` is the single source of truth** — never create or edit skill content in agent-specific directories. Those are symlinks.
2. **Never break symlinks** — every agent dir (`.claude/`, `.continue/`, `.windsurf/`, etc.) symlinks to `.agents/skills/`. If you rename or move a skill, update all symlinks.
3. **SKILL.md frontmatter is the contract** — `name`, `description`, and optional `alwaysApply` in YAML frontmatter. Agents parse this to decide when to activate a skill.
4. **Reference files are linked from SKILL.md** — don't add reference files without linking them from the parent SKILL.md routing table.
5. **`skills-lock.json` tracks provenance** — skills are sourced from `stripe/ai` on GitHub. Don't manually edit hashes; they're computed for integrity verification.
6. **Latest Stripe API version: `2026-02-25.clover`** — keep this in sync across both SKILL.md files when it changes.
7. **Commit after every logical change** — format: `<type>: <description>` (e.g., `update: stripe API version to 2026-02-25.clover`)

## Skill Authoring

| Element | Format | Example |
|---------|--------|---------|
| Frontmatter | YAML between `---` fences | `name: my-skill` |
| Routing table | Markdown table with "Building..." / "Recommended API" / "Details" columns | See `stripe-best-practices/SKILL.md` |
| References | Markdown files in `references/` subdirectory | `references/payments.md` |
| Links to docs | Relative paths from SKILL.md | `[references/payments.md](references/payments.md)` |

## Adding a New Skill

1. Create `.agents/skills/<skill-name>/SKILL.md` with YAML frontmatter
2. Add optional `references/` subdirectory for domain-specific guides
3. Create symlinks in every agent directory: `.{agent}/skills/<skill-name> → ../../.agents/skills/<skill-name>`
4. Create public symlink: `skills/<skill-name> → ../.agents/skills/<skill-name>`
5. Update `skills-lock.json` with source and hash

## Common Gotchas

| Gotcha | Fix |
|--------|-----|
| Editing a file in `.claude/skills/` directly | You're editing via symlink — changes propagate to all agents. This is fine, but know that's what's happening. |
| Broken symlink after moving a skill | Re-create symlinks in all 25+ agent dirs. Check with `find . -type l ! -exec test -e {} \; -print` |
| Forgetting to update both SKILL.md files when API version changes | Grep for the old version string across all `.md` files |
| Adding a reference file but not linking it | Agents won't discover it — always add a row to the routing table in SKILL.md |

## When NOT to Do Things

- **Don't duplicate skill content** across agent directories — that defeats the symlink architecture
- **Don't add agent-specific logic** to SKILL.md files — skills must be platform-agnostic
- **Don't delete agent directories** you don't recognize — they serve other coding assistants
- **Don't manually edit `computedHash`** in skills-lock.json — it's for integrity verification
