$ErrorActionPreference = 'Stop'

$CodexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME '.codex' }
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir '..')).Path
$CodexDocUrl = 'https://github.com/openai/codex#installation'

$SkipProvider = $false
$SkipAuth = $false
$ProviderName = ''
$ProviderUrl = ''
$Model = ''
$ApiKey = ''
$ExistingModel = ''
$ExistingProvider = ''
$ExistingApiKey = ''
$InstallLogPath = $env:OPEN_THESIS_INSTALL_LOG
$TranscriptStarted = $false

function Write-Info { param([string]$Message) Write-Host "[INFO] $Message" -ForegroundColor Blue }
function Write-Warn { param([string]$Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Fail { param([string]$Message) Write-Host "[ERROR] $Message" -ForegroundColor Red; exit 1 }

if (-not [string]::IsNullOrWhiteSpace($InstallLogPath)) {
  try {
    Start-Transcript -Path $InstallLogPath -Append -Force | Out-Null
    $TranscriptStarted = $true
    Write-Info "Transcript logging enabled: $InstallLogPath"
  } catch {
    Write-Warn "Unable to start transcript log at: $InstallLogPath"
  }
}

function Check-Deps {
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Fail 'Git is required.' }
}

function Ensure-CodexCli {
  if (Get-Command codex -ErrorAction SilentlyContinue) {
    $version = (& codex --version 2>$null)
    if ([string]::IsNullOrWhiteSpace($version)) { $version = 'installed' }
    Write-Info "Detected Codex CLI: $version"
    return
  }

  Write-Warn 'Codex CLI not found. Attempting automatic install...'
  if (Get-Command npm -ErrorAction SilentlyContinue) {
    try {
      npm install -g @openai/codex | Out-Host
    } catch {
      Write-Warn 'Automatic install via npm failed.'
    }
  } else {
    Write-Warn 'npm not found; cannot auto-install Codex CLI.'
  }

  if (Get-Command codex -ErrorAction SilentlyContinue) {
    $version = (& codex --version 2>$null)
    if ([string]::IsNullOrWhiteSpace($version)) { $version = 'installed' }
    Write-Info "Codex CLI installed successfully: $version"
  } else {
    Write-Warn 'Codex CLI is still unavailable.'
    Write-Warn "Official installation docs: $CodexDocUrl"
    Write-Warn 'Official quick install: npm install -g @openai/codex'
  }
}

function Ensure-Dir([string]$Path) {
  if (-not (Test-Path $Path)) { New-Item -ItemType Directory -Force -Path $Path | Out-Null }
}

function Get-TomlValue {
  param(
    [string]$Path,
    [string]$Key
  )

  if (-not (Test-Path $Path)) { return '' }

  $content = Get-Content -Raw -Path $Path
  if ([string]::IsNullOrWhiteSpace($content)) { return '' }

  # Handle UTF-8 BOM and CRLF safely.
  $content = $content -replace "^\uFEFF", ''
  $lines = $content -split "`n"
  $keyPattern = '^\s*' + [regex]::Escape($Key) + '\s*=\s*(.+?)\s*$'

  foreach ($rawLine in $lines) {
    $line = $rawLine.TrimEnd("`r")
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    # Remove inline comments outside quotes.
    $sb = [System.Text.StringBuilder]::new()
    $inDouble = $false
    $inSingle = $false
    foreach ($ch in $line.ToCharArray()) {
      if ($ch -eq '"' -and -not $inSingle) {
        $inDouble = -not $inDouble
        [void]$sb.Append($ch)
        continue
      }
      if ($ch -eq "'" -and -not $inDouble) {
        $inSingle = -not $inSingle
        [void]$sb.Append($ch)
        continue
      }
      if ($ch -eq '#' -and -not $inDouble -and -not $inSingle) { break }
      [void]$sb.Append($ch)
    }
    $line = $sb.ToString().Trim()
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    $match = [regex]::Match($line, $keyPattern)
    if (-not $match.Success) { continue }

    $value = $match.Groups[1].Value.Trim()
    if ($value.StartsWith('"') -and $value.EndsWith('"') -and $value.Length -ge 2) {
      return $value.Substring(1, $value.Length - 2)
    }
    if ($value.StartsWith("'") -and $value.EndsWith("'") -and $value.Length -ge 2) {
      return $value.Substring(1, $value.Length - 2)
    }
    return $value
  }

  return ''
}

function Detect-Existing {
  $configPath = Join-Path $CodexHome 'config.toml'
  $authPath = Join-Path $CodexHome 'auth.json'
  $hasConfig = $false

  if (Test-Path $configPath) {
    $hasConfig = $true
    Write-Info "Existing config.toml found: $configPath"
    $global:ExistingModel = Get-TomlValue -Path $configPath -Key 'model'
    $global:ExistingProvider = Get-TomlValue -Path $configPath -Key 'model_provider'
    $global:ExistingApiKey = Get-TomlValue -Path $configPath -Key 'OPENAI_API_KEY'
    if (-not [string]::IsNullOrWhiteSpace($ExistingModel)) { Write-Info "  Current model: $ExistingModel" }
    if (-not [string]::IsNullOrWhiteSpace($ExistingProvider)) { Write-Info "  Current provider: $ExistingProvider" }
  }

  if (Test-Path $authPath) {
    try {
      $authObj = Get-Content -Raw -Path $authPath | ConvertFrom-Json
      if (-not [string]::IsNullOrWhiteSpace($authObj.OPENAI_API_KEY)) {
        $global:ExistingApiKey = $authObj.OPENAI_API_KEY
      }
    } catch {}
  }

  if (-not [string]::IsNullOrWhiteSpace($ExistingApiKey)) {
    $prefix = if ($ExistingApiKey.Length -ge 8) { $ExistingApiKey.Substring(0, 8) } else { $ExistingApiKey }
    $suffix = if ($ExistingApiKey.Length -ge 4) { $ExistingApiKey.Substring($ExistingApiKey.Length - 4) } else { $ExistingApiKey }
    Write-Info "Existing API key found: $prefix...$suffix"
  }

  if ($hasConfig -or -not [string]::IsNullOrWhiteSpace($ExistingApiKey)) {
    $keepAll = Read-Host 'Keep existing configuration (provider/model/API key if available)? [Y/n]'
    if ($keepAll -ne 'n' -and $keepAll -ne 'N') {
      if ($hasConfig) {
        $global:SkipProvider = $true
        if (-not [string]::IsNullOrWhiteSpace($ExistingModel) -and -not [string]::IsNullOrWhiteSpace($ExistingProvider)) {
          Write-Info 'Keeping existing provider/model configuration'
        } elseif (-not [string]::IsNullOrWhiteSpace($ExistingModel)) {
          Write-Info 'Keeping existing model configuration (no explicit model_provider found).'
        } else {
          Write-Warn 'Could not parse model from existing config.toml, but keeping existing config as requested.'
        }

        $cfgOverride = Read-Host 'Reconfigure provider/model now? [y/N]'
        if ($cfgOverride -eq 'y' -or $cfgOverride -eq 'Y') {
          $global:SkipProvider = $false
          Write-Info 'Will reconfigure provider/model.'
        }
      } else {
        Write-Warn 'No existing config.toml found; provider/model input is required.'
      }

      if (-not [string]::IsNullOrWhiteSpace($ExistingApiKey)) {
        $global:SkipAuth = $true
        Write-Info 'Keeping existing API key'
        $keyOverride = Read-Host 'Re-enter API key now? [y/N]'
        if ($keyOverride -eq 'y' -or $keyOverride -eq 'Y') {
          $global:SkipAuth = $false
          Write-Info 'Will re-enter API key.'
        }
      } else {
        $keyNow = Read-Host 'No reusable API key found. Enter API key now? [Y/n]'
        if ($keyNow -eq 'n' -or $keyNow -eq 'N') {
          $global:SkipAuth = $true
          Write-Warn 'Skipping API key input; ensure OPENAI_API_KEY is set before running codex.'
        }
      }
      return
    }
  }

  if (-not [string]::IsNullOrWhiteSpace($ExistingApiKey)) {
    $keepAuth = Read-Host 'Reuse existing API key? [Y/n]'
    if ($keepAuth -ne 'n' -and $keepAuth -ne 'N') {
      $global:SkipAuth = $true
      Write-Info 'Keeping existing API key'
    }
  }
}

function Choose-Provider {
  if ($SkipProvider) { return }

  Write-Host ''
  Write-Host 'Select API provider:'
  Write-Host '  1) OpenAI (official)'
  Write-Host '  2) Custom provider'

  $choice = Read-Host 'Enter choice [1-2] (default: 1)'
  if ([string]::IsNullOrWhiteSpace($choice)) { $choice = '1' }

  switch ($choice) {
    '1' {
      $global:ProviderName = 'openai'
      $global:ProviderUrl = 'https://api.openai.com/v1'
      $global:Model = 'gpt-5'
      $inputModel = Read-Host "Model name (default: $Model)"
      if (-not [string]::IsNullOrWhiteSpace($inputModel)) { $global:Model = $inputModel }
    }
    '2' {
      $global:ProviderName = Read-Host 'Provider name'
      $global:ProviderUrl = Read-Host 'Base URL'
      $global:Model = Read-Host 'Model name'
    }
    default { Fail "Invalid choice: $choice" }
  }

  Write-Info "Provider: $ProviderName | URL: $ProviderUrl | Model: $Model"
}

function Configure-ApiKey {
  if ($SkipAuth) { return }

  $askNow = Read-Host 'Configure API key now? [Y/n]'
  if ($askNow -eq 'n' -or $askNow -eq 'N') {
    $global:SkipAuth = $true
    Write-Warn 'Skipping API key input. Ensure OPENAI_API_KEY exists in your environment.'
    return
  }

  $global:ApiKey = Read-Host 'Enter API key (OPENAI_API_KEY, Enter to skip)'
  if ([string]::IsNullOrWhiteSpace($ApiKey)) {
    $global:SkipAuth = $true
    Write-Warn 'No API key written. Ensure OPENAI_API_KEY exists in your environment.'
  }
}

function Add-BlockIfMissing {
  param(
    [string]$File,
    [string]$Pattern,
    [string]$Block
  )

  $content = Get-Content -Raw -Path $File
  if ($content -notmatch $Pattern) {
    Add-Content -Path $File -Value "`n$Block`n"
    return $true
  }
  return $false
}

function Merge-OpenThesisSections {
  param([string]$ConfigPath)

  Copy-Item -Path $ConfigPath -Destination "$ConfigPath.bak" -Force
  Write-Info 'Backed up config.toml -> config.toml.bak'

  $added = 0
  if (Add-BlockIfMissing -File $ConfigPath -Pattern '(?m)^developer_instructions\s*=' -Block 'developer_instructions = "用中文回答。thesis_mode=true。严格优先 GB/T 7713.1-2006 与 GB/T 7714-2015。输出优先给结构化 Markdown，并在需要时附 LaTeX(ctex) 版本。"') { $added++ }
  if (Add-BlockIfMissing -File $ConfigPath -Pattern '(?m)^sandbox_mode\s*=' -Block 'sandbox_mode = "workspace-write"') { $added++ }
  if (Add-BlockIfMissing -File $ConfigPath -Pattern '(?m)^\[features\]' -Block "[features]`nmulti_agent = true`nmemories = true`nskill_approval = true") { $added++ }

  $mcpBlock = @"
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
"@
  if (Add-BlockIfMissing -File $ConfigPath -Pattern '(?m)^\[mcp_servers\.zotero\]' -Block $mcpBlock) { $added++ }

  if ($added -gt 0) {
    Write-Info "Merged $added Open Thesis section(s) into existing config.toml"
  } else {
    Write-Info 'Config already has all Open Thesis sections'
  }
}

function Generate-Config {
  $templatePath = Join-Path $RepoRoot 'codex/config.toml'
  $targetPath = Join-Path $CodexHome 'config.toml'
  if (-not (Test-Path $templatePath)) { Fail "Template not found: $templatePath" }

  Ensure-Dir $CodexHome

  if ($SkipProvider) {
    Merge-OpenThesisSections -ConfigPath $targetPath
    return
  }

  if (Test-Path $targetPath) {
    Copy-Item -Path $targetPath -Destination "$targetPath.bak" -Force
    Write-Info 'Backed up config.toml -> config.toml.bak'
  }

  $template = Get-Content -Raw -Path $templatePath
  $template = $template.Replace('__MODEL__', $Model)
  $template = $template.Replace('__PROVIDER_NAME__', $ProviderName)
  $template = $template.Replace('__PROVIDER_URL__', $ProviderUrl)
  Set-Content -Path $targetPath -Value $template -Encoding UTF8

  Write-Info 'Generated config.toml'
}

function Write-Auth {
  if ($SkipAuth) { return }

  $authPath = Join-Path $CodexHome 'auth.json'
  if (Test-Path $authPath) { Copy-Item -Path $authPath -Destination "$authPath.bak" -Force }

  $auth = @{
    OPENAI_API_KEY = $ApiKey
  } | ConvertTo-Json -Depth 5

  Set-Content -Path $authPath -Value ($auth + [Environment]::NewLine) -Encoding UTF8
  Write-Info 'Wrote auth.json'
}

function Copy-Components {
  Ensure-Dir $CodexHome

  $srcSkills = Join-Path $RepoRoot 'skills'
  if (Test-Path $srcSkills) {
    $dstSkills = Join-Path $CodexHome 'skills'
    Ensure-Dir $dstSkills
    Get-ChildItem -LiteralPath $srcSkills -Force | Copy-Item -Destination $dstSkills -Recurse -Force
    Write-Info 'Synced skills/'
  }

  $srcAgents = Join-Path $RepoRoot 'codex/agents'
  if (Test-Path $srcAgents) {
    $dstAgents = Join-Path $CodexHome 'agents'
    Ensure-Dir $dstAgents
    Get-ChildItem -LiteralPath $srcAgents -Force | Copy-Item -Destination $dstAgents -Recurse -Force
    Write-Info 'Synced codex agents/'
  }

  $srcInstructions = Join-Path $RepoRoot 'codex/AGENTS.md'
  if (Test-Path $srcInstructions) {
    $dstInstructions = Join-Path $CodexHome 'AGENTS.md'
    if (Test-Path $dstInstructions) { Copy-Item -Path $dstInstructions -Destination "$dstInstructions.bak" -Force }
    Copy-Item -Path $srcInstructions -Destination $dstInstructions -Force
    Write-Info "Synced $dstInstructions"
  }
}

function Main {
  Write-Host ''
  Write-Host '======================================'
  Write-Host '   Open Thesis Installer (Codex)      '
  Write-Host '======================================'
  Write-Host ''

  Check-Deps
  Ensure-CodexCli
  Write-Info "Source: $RepoRoot"
  Write-Info "Target: $CodexHome"

  Detect-Existing
  Choose-Provider
  Configure-ApiKey
  Generate-Config
  Write-Auth
  Copy-Components

  Write-Host ''
  Write-Info 'Installation complete.'
  Write-Host "  Config: $(Join-Path $CodexHome 'config.toml')"
  Write-Host "  Auth:   $(Join-Path $CodexHome 'auth.json')"
  Write-Host "  Skills: $(Join-Path $CodexHome 'skills')"
  Write-Host "  Agents: $(Join-Path $CodexHome 'agents')"
  Write-Host ''
  Write-Host "Run 'codex' to start."
}

try {
  Main
}
finally {
  if ($TranscriptStarted) {
    try { Stop-Transcript | Out-Null } catch {}
  }
}
