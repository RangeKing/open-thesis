#!/usr/bin/env bash
# Open Thesis - Codex CLI Installer
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

SKIP_PROVIDER=false
SKIP_AUTH=false
PROVIDER_NAME=""
PROVIDER_URL=""
MODEL=""
API_KEY=""

info()  { echo -e "\033[1;34m[INFO]\033[0m $*"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m $*"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $*"; exit 1; }

check_deps() {
  command -v git >/dev/null || error "Git is required."
  if ! command -v codex >/dev/null 2>&1; then
    warn "Codex CLI not found. Install: npm i -g @openai/codex"
  fi
}

detect_existing() {
  if [ -f "$CODEX_HOME/config.toml" ]; then
    info "Existing config.toml found: $CODEX_HOME/config.toml"
    local cur_model cur_provider
    cur_model=$(grep '^model ' "$CODEX_HOME/config.toml" 2>/dev/null | head -1 | sed 's/.*= *"//;s/".*//' || true)
    cur_provider=$(grep '^model_provider ' "$CODEX_HOME/config.toml" 2>/dev/null | head -1 | sed 's/.*= *"//;s/".*//' || true)
    [ -n "$cur_model" ] && info "  Current model: $cur_model"
    [ -n "$cur_provider" ] && info "  Current provider: $cur_provider"

    read -rp "Keep existing provider/model config? [Y/n]: " keep
    if [ "$keep" != "n" ] && [ "$keep" != "N" ]; then
      SKIP_PROVIDER=true
      info "Keeping existing provider/model configuration"
    fi
  fi

  if [ -f "$CODEX_HOME/auth.json" ]; then
    local masked key
    key=$(grep -o '"OPENAI_API_KEY"[[:space:]]*:[[:space:]]*"[^"]*"' "$CODEX_HOME/auth.json" 2>/dev/null | sed 's/.*: *"//;s/"$//' || true)
    if [ -n "$key" ]; then
      masked="${key:0:8}...${key: -4}"
      info "Existing API key found: $masked"
      read -rp "Keep existing API key? [Y/n]: " keep_key
      if [ "$keep_key" != "n" ] && [ "$keep_key" != "N" ]; then
        SKIP_AUTH=true
        info "Keeping existing API key"
      fi
    fi
  fi
}

choose_provider() {
  [ "$SKIP_PROVIDER" = true ] && return

  echo ""
  echo "Select API provider:"
  echo "  1) OpenAI (official)"
  echo "  2) Custom provider"
  echo ""

  local choice
  read -rp "Enter choice [1-2] (default: 1): " choice
  choice="${choice:-1}"

  case "$choice" in
    1)
      PROVIDER_NAME="openai"
      PROVIDER_URL="https://api.openai.com/v1"
      MODEL="gpt-5"
      read -rp "Model name (default: $MODEL): " input_model
      MODEL="${input_model:-$MODEL}"
      ;;
    2)
      read -rp "Provider name: " PROVIDER_NAME
      read -rp "Base URL: " PROVIDER_URL
      read -rp "Model name: " MODEL
      ;;
    *)
      error "Invalid choice: $choice"
      ;;
  esac

  info "Provider: $PROVIDER_NAME | URL: $PROVIDER_URL | Model: $MODEL"
}

configure_api_key() {
  [ "$SKIP_AUTH" = true ] && return

  echo ""
  read -rp "Enter API key (OPENAI_API_KEY, or press Enter to skip): " API_KEY
  if [ -z "$API_KEY" ]; then
    warn "No API key written. Ensure OPENAI_API_KEY is available in your environment."
    SKIP_AUTH=true
  fi
}

merge_open_thesis_sections() {
  local target="$1"
  local template="$2"
  local added=0

  cp "$target" "${target}.bak"
  info "Backed up config.toml -> config.toml.bak"

  if ! grep -q '^developer_instructions' "$target" 2>/dev/null; then
    echo '' >> "$target"
    echo 'developer_instructions = "用中文回答。thesis_mode=true。严格优先 GB/T 7713.1-2006 与 GB/T 7714-2015。输出优先给结构化 Markdown，并在需要时附 LaTeX(ctex) 版本。"' >> "$target"
    added=$((added + 1))
  fi

  if ! grep -q '^sandbox_mode' "$target" 2>/dev/null; then
    echo 'sandbox_mode = "workspace-write"' >> "$target"
    added=$((added + 1))
  fi

  if ! grep -q '^\[features\]' "$target" 2>/dev/null; then
    cat >> "$target" << 'FEATURES'

[features]
multi_agent = true
memories = true
skill_approval = true
FEATURES
    added=$((added + 1))
  fi

  if ! grep -q '^\[mcp_servers\.zotero\]' "$target" 2>/dev/null; then
    cat >> "$target" << 'MCP'

[mcp_servers.zotero]
command = "zotero-mcp"
args = ["serve"]
enabled = false
[mcp_servers.zotero.env]
ZOTERO_API_KEY = "your-api-key"
ZOTERO_LIBRARY_ID = "your-library-id"
ZOTERO_LIBRARY_TYPE = "user"
UNPAYWALL_EMAIL = "your-email@example.com"
UNSAFE_OPERATIONS = "all"
ZOTERO_DEFAULT_COLLECTION = "中文学位论文"
ZOTERO_IMPORT_HINT = "Use DOI first; if DOI is missing, import with CNKI URL"
MCP
    added=$((added + 1))
  fi

  if ! grep -q '^\[agents\.' "$target" 2>/dev/null; then
    sed -n '/^# Agents$/,$p' "$template" >> "$target"
    added=$((added + 1))
  fi

  if [ "$added" -gt 0 ]; then
    info "Merged $added Open Thesis section(s) into existing config.toml"
  else
    info "Config already has all Open Thesis sections"
  fi
}

generate_config() {
  local template="$SRC_DIR/codex/config.toml"
  local target="$CODEX_HOME/config.toml"
  [ -f "$template" ] || error "Template not found: $template"
  mkdir -p "$CODEX_HOME"

  if [ "$SKIP_PROVIDER" = true ]; then
    merge_open_thesis_sections "$target" "$template"
    return
  fi

  [ -f "$target" ] && cp "$target" "${target}.bak" && info "Backed up config.toml -> config.toml.bak"

  sed -e "s|__MODEL__|$MODEL|g" \
      -e "s|__PROVIDER_NAME__|$PROVIDER_NAME|g" \
      -e "s|__PROVIDER_URL__|$PROVIDER_URL|g" \
      "$template" > "$target"

  info "Generated config.toml"
}

write_auth() {
  [ "$SKIP_AUTH" = true ] && return

  local target="$CODEX_HOME/auth.json"
  [ -f "$target" ] && cp "$target" "${target}.bak"
  cat > "$target" << EOF2
{
  "OPENAI_API_KEY": "$API_KEY"
}
EOF2
  chmod 600 "$target" || true
  info "Wrote auth.json"
}

copy_components() {
  mkdir -p "$CODEX_HOME"

  if [ -d "$SRC_DIR/skills" ]; then
    mkdir -p "$CODEX_HOME/skills"
    cp -r "$SRC_DIR/skills/." "$CODEX_HOME/skills/"
    info "Synced skills/"
  fi

  if [ -d "$SRC_DIR/codex/agents" ]; then
    mkdir -p "$CODEX_HOME/agents"
    cp -r "$SRC_DIR/codex/agents/." "$CODEX_HOME/agents/"
    info "Synced codex agents/"
  fi

  if [ -f "$SRC_DIR/codex/AGENTS.md" ]; then
    [ -f "$CODEX_HOME/AGENTS.md" ] && cp "$CODEX_HOME/AGENTS.md" "$CODEX_HOME/AGENTS.md.bak"
    cp "$SRC_DIR/codex/AGENTS.md" "$CODEX_HOME/AGENTS.md"
    info "Synced $CODEX_HOME/AGENTS.md"
  fi
}

main() {
  echo ""
  echo "╔══════════════════════════════════════╗"
  echo "║     Open Thesis Installer (Codex)    ║"
  echo "╚══════════════════════════════════════╝"
  echo ""

  check_deps
  info "Source: $SRC_DIR"
  info "Target: $CODEX_HOME"

  detect_existing
  choose_provider
  configure_api_key
  generate_config
  write_auth
  copy_components

  echo ""
  info "Installation complete"
  echo "  Config: $CODEX_HOME/config.toml"
  echo "  Auth:   $CODEX_HOME/auth.json"
  echo "  Skills: $CODEX_HOME/skills/"
  echo "  Agents: $CODEX_HOME/agents/"
  echo ""
  echo "Run 'codex' to start."
}

main "$@"
