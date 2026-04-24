# CANVAS

Canvas files are optional derived artifacts stored under `Maps/`. They are not the source of truth.

## Placement and intent

- Default location: `Maps/*.canvas`
- Default automatically maintained canvas: `Maps/literature.canvas`
- Other canvases are explicit-only unless a workflow clearly requires them

## Supported node usage

Use the JSON Canvas structure with `nodes` and `edges`.

Common node patterns:
- `text` nodes for synthesized summaries or section labels
- `file` nodes for canonical notes or attachments
- `link` nodes for external references when needed
- `group` nodes for visual organization

## Layout rules

- Keep 50–100 px spacing between unrelated nodes.
- Use groups for major clusters instead of overlapping nodes.
- Prefer stable, legible layouts over dense maps.
- Keep file-node targets valid and project-local when possible.

## Reference validity

- Every file node must point to an existing note or asset.
- Edge endpoints must resolve to existing node IDs.
- If a note is archived, repair or intentionally preserve the canvas reference according to the workflow; do not leave dangling file references.

## When to generate canvases

Generate or update a canvas when:
- the user explicitly asks for a map
- literature synthesis needs `Maps/literature.canvas`
- a derived visualization materially improves navigation

Do not generate project-wide canvases by default just because the capability exists.
