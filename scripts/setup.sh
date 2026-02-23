#!/usr/bin/env bash
set -euo pipefail

OPENCODE_DIR="$HOME/.opencode"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
COMPONENTS=(skills commands plugins scripts utils AGENTS.md package.json)

info()  { echo -e "\033[1;34m[INFO]\033[0m $*"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m $*"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $*"; exit 1; }

check_deps() {
  command -v git  >/dev/null || error "Git is required. Install it first."
  command -v node >/dev/null || error "Node.js is required (plugins depend on it). Install it first."
}

copy_components() {
  local src="$1"
  for comp in "${COMPONENTS[@]}"; do
    if [ -e "$src/$comp" ]; then
      if [ -d "$src/$comp" ]; then
        mkdir -p "$OPENCODE_DIR/$comp"
        cp -r "$src/$comp/." "$OPENCODE_DIR/$comp/"
      else
        cp "$src/$comp" "$OPENCODE_DIR/$comp"
      fi
    fi
  done
  info "Copied components: ${COMPONENTS[*]}"
}

install_config() {
  local src="$1/opencode.jsonc"
  local target="$OPENCODE_DIR/opencode.jsonc"

  [ -f "$src" ] || return 0

  if [ -f "$target" ]; then
    cp "$target" "${target}.bak"
    info "Backed up opencode.jsonc → opencode.jsonc.bak"
  fi

  cp "$src" "$target"
  info "Installed opencode.jsonc (agents, mcp, permissions)."
}

install_deps() {
  if [ -f "$OPENCODE_DIR/package.json" ]; then
    (cd "$OPENCODE_DIR" && npm install --silent 2>/dev/null) \
      && info "Installed plugin dependencies (npm)." \
      || warn "npm install failed. Run 'cd ~/.opencode && npm install' manually."
  fi
}

main() {
  echo ""
  echo "╔══════════════════════════════════════╗"
  echo "║  Claude Scholar Installer (OpenCode) ║"
  echo "╚══════════════════════════════════════╝"
  echo ""

  check_deps

  info "Installing from: $SRC_DIR"
  mkdir -p "$OPENCODE_DIR"
  copy_components "$SRC_DIR"
  install_config "$SRC_DIR"
  install_deps

  echo ""
  info "Done! Restart OpenCode CLI to activate."
  echo ""
}

main "$@"
