---
name: kb-index
description: Regenerate the human-readable 02-Index.md from the current active registry surface.
tags: [Research, Obsidian, KB]
---

# /kb-index

```bash
python3 "${CLAUDE_PLUGIN_ROOT}/skills/obsidian-project-kb-core/scripts/project_kb.py" sync --cwd "$PWD" --scope index
```

The index is a human navigation note, not a registry mirror.
