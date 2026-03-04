# Open Thesis AGENTS

This file enables project-level instructions for Codex CLI when working in this repository.

For the full Codex instruction set, see:
- `codex/AGENTS.md`

## Quick Rules

- `thesis_mode: true`
- Prioritize standards:
  1. GB/T 7713.1-2006
  2. GB/T 7714-2015
  3. University template details
- Prefer concise, rigorous Chinese academic language.
- For thesis drafting/format checks, provide structured Markdown and (when needed) LaTeX `ctex` snippets.
- Prefer DOI import; if missing, prompt CNKI URL import.

## Suggested Setup

Install Codex support with:

```bash
bash setup-codex.sh
```

Windows:

```powershell
./setup-codex.ps1
```

or double-click `setup-codex.bat`.
