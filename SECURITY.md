# Security Policy

## Reporting a Vulnerability

Email ayush@perch.deals with details. Expect a response within 7 days. Do not open public issues for security vulnerabilities.

## Scope

Facet is a CLI tool that orchestrates Claude CLI invocations. It does not run a server, accept network input, or store credentials.

## Security Design

- Claude invocations are restricted to Read, Write, Glob, Grep tools — no Bash (no arbitrary code execution)
- Config files and calibration data are passed to Claude as prompt content
- Output is written to the local filesystem only
- Templates are version-locked at init/exercise time for reproducibility

## What to Watch For

- **Do not commit sensitive calibration data** (customer interviews, proprietary research) — it becomes part of Claude's prompt context
- **output/ is gitignored by default** — keep it that way to avoid committing persona narratives or synthesis results
- **.env is gitignored** — do not store API keys in tracked files
