---
name: kb-archive
description: Archive, detach, purge, or rename KB objects while keeping registry, index, and links consistent.
args:
  - name: action
    description: detach, archive, purge, rename
    required: true
  - name: target
    description: Project-relative note path when operating on a note.
    required: false
  - name: dest
    description: Destination note path for rename.
    required: false
tags: [Research, Obsidian, KB, Lifecycle]
---

# /kb-archive

Project-level:

```bash
python3 "${CLAUDE_PLUGIN_ROOT}/skills/obsidian-project-kb-core/scripts/project_kb.py" lifecycle --cwd "$PWD" --mode "$action"
```

Note-level:

```bash
python3 "${CLAUDE_PLUGIN_ROOT}/skills/obsidian-project-kb-core/scripts/project_kb.py" note-lifecycle --cwd "$PWD" --mode "$action" --note "$target"
```

If `action=rename`, also pass `--dest "$dest"`.
