#!/usr/bin/env python3
"""Filter claude --output-format stream-json into a readable live feed.

Adapted from mosaic's stream_filter.py for persona simulation context.
Shows phase progress, persona generation status, and tool activity.
"""

import json
import sys
import os

C = {
    "cyan": "\033[36m",
    "yellow": "\033[33m",
    "magenta": "\033[35m",
    "green": "\033[32m",
    "red": "\033[31m",
    "dim": "\033[2m",
    "bold": "\033[1m",
    "reset": "\033[0m",
}

# Track persona writes for progress display
persona_count = 0
phase_label = os.environ.get("FACET_PHASE", "")


def format_tool(name, inp):
    global persona_count

    if name == "Read":
        path = inp.get("file_path", "")
        short = path.split("/")[-1] if "/" in path else path
        return f"{C['cyan']}[read]{C['reset']} {short}"

    if name == "Write":
        path = inp.get("file_path", "")
        short = path.split("/")[-1] if "/" in path else path
        # Detect persona file writes for progress tracking
        if "persona-" in short:
            persona_count += 1
            return f"{C['yellow']}[write]{C['reset']} {short} {C['dim']}(persona #{persona_count}){C['reset']}"
        return f"{C['yellow']}[write]{C['reset']} {short}"

    if name == "Edit":
        path = inp.get("file_path", "")
        short = path.split("/")[-1] if "/" in path else path
        return f"{C['yellow']}[edit]{C['reset']} {short}"

    if name == "Glob":
        return f"{C['cyan']}[glob]{C['reset']} {inp.get('pattern', '')}"

    if name == "Grep":
        return f"{C['cyan']}[grep]{C['reset']} /{inp.get('pattern', '')}/"

    if name == "Bash":
        cmd = inp.get("command", "")
        first_line = cmd.split("\n")[0].strip()
        if len(first_line) > 120:
            first_line = first_line[:117] + "..."
        return f"{C['magenta']}[bash]{C['reset']} {first_line}"

    if name == "Agent":
        desc = inp.get("description", inp.get("prompt", "")[:60])
        return f"{C['magenta']}[agent]{C['reset']} {desc}"

    summary = json.dumps(inp)
    if len(summary) > 100:
        summary = summary[:97] + "..."
    return f"[{name.lower()}] {summary}"


def main():
    if phase_label:
        print(f"\n{C['bold']}{C['green']}▸ {phase_label}{C['reset']}\n", flush=True)

    for raw in sys.stdin:
        raw = raw.strip()
        if not raw:
            continue
        try:
            event = json.loads(raw)
        except json.JSONDecodeError:
            continue

        t = event.get("type")

        if t == "assistant":
            msg = event.get("message", {})
            for block in msg.get("content", []):
                if block.get("type") == "tool_use":
                    print(format_tool(block["name"], block.get("input", {})), flush=True)
                elif block.get("type") == "text":
                    text = block.get("text", "").strip()
                    if text:
                        # Show first 200 chars of text output
                        display = text[:200] + "..." if len(text) > 200 else text
                        print(f"{C['green']}[text]{C['reset']} {display}", flush=True)

        elif t == "user":
            msg = event.get("message", {})
            for block in msg.get("content", []):
                if isinstance(block, dict) and block.get("type") == "tool_result":
                    if block.get("is_error"):
                        err = block.get("content", "")
                        if isinstance(err, str):
                            print(f"  {C['red']}error: {err[:200]}{C['reset']}", flush=True)

        elif t == "result":
            result = event.get("result", "")
            if isinstance(result, str) and result.strip():
                print(f"\n{C['green']}[done]{C['reset']} {result.strip()[:200]}", flush=True)
            elif isinstance(result, dict):
                rc = result.get("exit_code", "?")
                print(f"\n{C['green']}[done]{C['reset']} exit_code={rc}", flush=True)


if __name__ == "__main__":
    main()
