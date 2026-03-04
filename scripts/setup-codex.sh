#!/usr/bin/env bash
# Open Thesis - Codex CLI Installer
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CODEX_DOC_URL="https://github.com/openai/codex#installation"

SKIP_PROVIDER=false
SKIP_AUTH=false
PROVIDER_NAME=""
PROVIDER_URL=""
MODEL=""
API_KEY=""
EXISTING_MODEL=""
EXISTING_PROVIDER=""
EXISTING_API_KEY=""

info()  { echo -e "\033[1;34m[INFO]\033[0m $*"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m $*"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $*"; exit 1; }

check_deps() {
  command -v git >/dev/null || error "Git is required."
}

# Ensure Codex CLI exists; try automatic install if missing.
ensure_codex_cli() {
  if command -v codex >/dev/null 2>&1; then
    info "Detected Codex CLI: $(codex --version 2>/dev/null || echo 'installed')"
    return
  fi

  warn "Codex CLI not found. Attempting automatic install..."
  if command -v npm >/dev/null 2>&1; then
    if npm install -g @openai/codex; then
      hash -r
    else
      warn "Automatic install via npm failed."
    fi
  else
    warn "npm not found; cannot auto-install Codex CLI."
  fi

  if command -v codex >/dev/null 2>&1; then
    info "Codex CLI installed successfully: $(codex --version 2>/dev/null || echo 'installed')"
  else
    warn "Codex CLI is still unavailable."
    warn "Official installation docs: $CODEX_DOC_URL"
    warn "Official quick install: npm install -g @openai/codex"
  fi
}

extract_toml_value() {
  local key="$1"
  local file="$2"
  awk -v key="$key" '
    NR==1 { sub(/^\xef\xbb\xbf/, "", $0) }
    {
      line=$0
      sub(/\r$/, "", line)
      sub(/[ \t]*#.*/, "", line)
      if (line ~ "^[ \t]*" key "[ \t]*=") {
        sub("^[ \t]*" key "[ \t]*=[ \t]*", "", line)
        gsub(/^[ \t]+|[ \t]+$/, "", line)
        if (line ~ /^".*"$/) {
          line=substr(line, 2, length(line)-2)
        } else if (line ~ /^'\''.*'\''$/) {
          line=substr(line, 2, length(line)-2)
        }
        print line
        exit
      }
    }
  ' "$file"
}

detect_existing() {
  local has_config=false
  local config_path="$CODEX_HOME/config.toml"
  local auth_path="$CODEX_HOME/auth.json"

  if [ -f "$config_path" ]; then
    has_config=true
    info "Existing config.toml found: $config_path"
    EXISTING_MODEL=$(extract_toml_value "model" "$config_path" || true)
    EXISTING_PROVIDER=$(extract_toml_value "model_provider" "$config_path" || true)
    [ -n "$EXISTING_MODEL" ] && info "  Current model: $EXISTING_MODEL"
    [ -n "$EXISTING_PROVIDER" ] && info "  Current provider: $EXISTING_PROVIDER"
  fi

  if [ -f "$auth_path" ]; then
    EXISTING_API_KEY=$(grep -o '"OPENAI_API_KEY"[[:space:]]*:[[:space:]]*"[^"]*"' "$auth_path" 2>/dev/null | sed 's/.*: *"//;s/"$//' || true)
  fi
  if [ -z "$EXISTING_API_KEY" ] && [ -f "$config_path" ]; then
    EXISTING_API_KEY=$(extract_toml_value "OPENAI_API_KEY" "$config_path" || true)
  fi
  if [ -n "$EXISTING_API_KEY" ]; then
    local masked="${EXISTING_API_KEY:0:8}...${EXISTING_API_KEY: -4}"
    info "Existing API key found: $masked"
  fi

  if [ "$has_config" = true ] || [ -n "$EXISTING_API_KEY" ]; then
    local keep_all
    read -rp "Keep existing configuration (provider/model/API key if available)? [Y/n]: " keep_all
    if [ "$keep_all" != "n" ] && [ "$keep_all" != "N" ]; then
      if [ "$has_config" = true ]; then
        SKIP_PROVIDER=true
        if [ -n "$EXISTING_MODEL" ] && [ -n "$EXISTING_PROVIDER" ]; then
          info "Keeping existing provider/model configuration"
        elif [ -n "$EXISTING_MODEL" ]; then
          info "Keeping existing model configuration (no explicit model_provider found)."
        else
          info "Keeping existing config.toml as requested (model/provider values were not re-parsed)."
        fi
        local cfg_override
        read -rp "Reconfigure provider/model now? [y/N]: " cfg_override
        if [ "$cfg_override" = "y" ] || [ "$cfg_override" = "Y" ]; then
          SKIP_PROVIDER=false
          info "Will reconfigure provider/model."
        fi
      else
        warn "No existing config.toml found; provider/model input is required."
      fi

      if [ -n "$EXISTING_API_KEY" ]; then
        SKIP_AUTH=true
        info "Keeping existing API key"
        local key_override
        read -rp "Re-enter API key now? [y/N]: " key_override
        if [ "$key_override" = "y" ] || [ "$key_override" = "Y" ]; then
          SKIP_AUTH=false
          info "Will re-enter API key."
        fi
      else
        local key_now
        read -rp "No reusable API key found. Enter API key now? [Y/n]: " key_now
        if [ "$key_now" = "n" ] || [ "$key_now" = "N" ]; then
          SKIP_AUTH=true
          warn "Skipping API key input; ensure OPENAI_API_KEY is set before running codex."
        fi
      fi
      return
    fi
  fi

  if [ -n "$EXISTING_API_KEY" ]; then
    local keep_key
    read -rp "Reuse existing API key? [Y/n]: " keep_key
    if [ "$keep_key" != "n" ] && [ "$keep_key" != "N" ]; then
      SKIP_AUTH=true
      info "Keeping existing API key"
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
  local input_now
  read -rp "Configure API key now? [Y/n]: " input_now
  if [ "$input_now" = "n" ] || [ "$input_now" = "N" ]; then
    warn "Skipping API key input. Ensure OPENAI_API_KEY is available in your environment."
    SKIP_AUTH=true
    return
  fi

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
  ensure_codex_cli
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
