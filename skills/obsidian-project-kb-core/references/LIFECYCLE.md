# Lifecycle Rules

## Project lifecycle

- `detach`: remove repo binding, keep vault project content
- `archive`: move the project root under vault archive storage and disable sync
- `purge`: delete binding metadata and project root permanently

## Note lifecycle

- `archive`: move note into `Archive/`, repair links, update registry and index
- `rename`: move note in place, repair links, update registry and index
- `purge`: permanently delete note, repair links, update registry and index

Defaults:
- “remove project knowledge” means archive, not purge
- archive retains history in `_system/registry.md`
