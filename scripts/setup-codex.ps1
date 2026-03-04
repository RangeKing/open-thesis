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
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$SafeDeveloperInstructionsLine = 'developer_instructions = "Respond in Chinese. thesis_mode=true. Prioritize GB/T 7713.1-2006 and GB/T 7714-2015. Prefer structured Markdown and add LaTeX (ctex) when needed."'

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

function Read-TextWithBestEffort {
  param([string]$Path)

  if (-not (Test-Path $Path)) { return '' }

  $bytes = [System.IO.File]::ReadAllBytes($Path)
  if ($bytes.Length -eq 0) { return '' }

  try {
    $strictUtf8 = New-Object System.Text.UTF8Encoding($false, $true)
    return $strictUtf8.GetString($bytes)
  } catch {}

  $nullCount = 0
  foreach ($b in $bytes) {
    if ($b -eq 0) { $nullCount++ }
  }

  if ($nullCount -gt ($bytes.Length / 10)) {
    return [System.Text.Encoding]::Unicode.GetString($bytes)
  }

  return [System.Text.Encoding]::Default.GetString($bytes)
}

function Write-Utf8NoBom {
  param(
    [string]$Path,
    [string]$Content
  )

  [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

function Append-Utf8NoBom {
  param(
    [string]$Path,
    [string]$Content
  )

  [System.IO.File]::AppendAllText($Path, $Content, $Utf8NoBom)
}

function Normalize-FileToUtf8 {
  param([string]$Path)

  if (-not (Test-Path $Path)) { return }
  $text = Read-TextWithBestEffort -Path $Path
  Write-Utf8NoBom -Path $Path -Content $text
}

function Get-TomlValue {
  param(
    [string]$Path,
    [string]$Key
  )

  if (-not (Test-Path $Path)) { return '' }

  $content = Read-TextWithBestEffort -Path $Path
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
    $script:ExistingModel = Get-TomlValue -Path $configPath -Key 'model'
    $script:ExistingProvider = Get-TomlValue -Path $configPath -Key 'model_provider'
    $script:ExistingApiKey = Get-TomlValue -Path $configPath -Key 'OPENAI_API_KEY'
    if (-not [string]::IsNullOrWhiteSpace($ExistingModel)) { Write-Info "  Current model: $ExistingModel" }
    if (-not [string]::IsNullOrWhiteSpace($ExistingProvider)) { Write-Info "  Current provider: $ExistingProvider" }
  }

  if (Test-Path $authPath) {
    try {
      $authObj = Get-Content -Raw -Path $authPath | ConvertFrom-Json
      if (-not [string]::IsNullOrWhiteSpace($authObj.OPENAI_API_KEY)) {
        $script:ExistingApiKey = $authObj.OPENAI_API_KEY
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
        $script:SkipProvider = $true
        $script:SkipAuth = $true
        if (-not [string]::IsNullOrWhiteSpace($ExistingModel) -and -not [string]::IsNullOrWhiteSpace($ExistingProvider)) {
          Write-Info 'Keeping existing provider/model configuration'
        } elseif (-not [string]::IsNullOrWhiteSpace($ExistingModel)) {
          Write-Info 'Keeping existing model configuration (no explicit model_provider found).'
        } else {
          Write-Info 'Keeping existing config.toml as requested (model/provider values were not re-parsed).'
        }
        if (-not [string]::IsNullOrWhiteSpace($ExistingApiKey)) {
          Write-Info 'Keeping existing API key'
        } else {
          Write-Info 'Keeping existing auth configuration (no API key re-entry in keep-existing mode).'
        }
        return
      } else {
        Write-Warn 'No existing config.toml found; provider/model input is required.'
      }

      if (-not [string]::IsNullOrWhiteSpace($ExistingApiKey)) {
        $script:SkipAuth = $true
        Write-Info 'Keeping existing API key'
        $keyOverride = Read-Host 'Re-enter API key now? [y/N]'
        if ($keyOverride -eq 'y' -or $keyOverride -eq 'Y') {
          $script:SkipAuth = $false
          Write-Info 'Will re-enter API key.'
        }
      } else {
        $keyNow = Read-Host 'No reusable API key found. Enter API key now? [Y/n]'
        if ($keyNow -eq 'n' -or $keyNow -eq 'N') {
          $script:SkipAuth = $true
          Write-Warn 'Skipping API key input; ensure OPENAI_API_KEY is set before running codex.'
        }
      }
      return
    }
  }

  if (-not [string]::IsNullOrWhiteSpace($ExistingApiKey)) {
    $keepAuth = Read-Host 'Reuse existing API key? [Y/n]'
    if ($keepAuth -ne 'n' -and $keepAuth -ne 'N') {
      $script:SkipAuth = $true
      Write-Info 'Keeping existing API key'
    }
  }
}

function Choose-OpenAiModel {
  Write-Host 'Select OpenAI model:'
  Write-Host '  1) gpt-5.3-codex (recommended)'
  Write-Host '  2) gpt-5'
  Write-Host '  3) Custom model name'

  $modelChoice = Read-Host 'Enter choice [1-3] (default: 1)'
  if ([string]::IsNullOrWhiteSpace($modelChoice)) { $modelChoice = '1' }

  switch ($modelChoice) {
    '1' { return 'gpt-5.3-codex' }
    '2' { return 'gpt-5' }
    '3' {
      $customModel = Read-Host 'Custom model name'
      if ([string]::IsNullOrWhiteSpace($customModel)) { Fail 'Custom model name is required.' }
      return $customModel
    }
    default { Fail "Invalid model choice: $modelChoice" }
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
      $script:ProviderName = 'openai'
      $script:ProviderUrl = 'https://api.openai.com/v1'
      $script:Model = Choose-OpenAiModel
    }
    '2' {
      $script:ProviderName = Read-Host 'Provider name'
      $script:ProviderUrl = Read-Host 'Base URL'
      $script:Model = Read-Host 'Model name'
    }
    default { Fail "Invalid choice: $choice" }
  }

  Write-Info "Provider: $ProviderName | URL: $ProviderUrl | Model: $Model"
}

function Configure-ApiKey {
  if ($SkipAuth) { return }

  $askNow = Read-Host 'Configure API key now? [Y/n]'
  if ($askNow -eq 'n' -or $askNow -eq 'N') {
    $script:SkipAuth = $true
    Write-Warn 'Skipping API key input. Ensure OPENAI_API_KEY exists in your environment.'
    return
  }

  $script:ApiKey = Read-Host 'Enter API key (OPENAI_API_KEY, Enter to skip)'
  if ([string]::IsNullOrWhiteSpace($ApiKey)) {
    $script:SkipAuth = $true
    Write-Warn 'No API key written. Ensure OPENAI_API_KEY exists in your environment.'
  }
}

function Add-BlockIfMissing {
  param(
    [string]$File,
    [string]$Pattern,
    [string]$Block
  )

  $content = Read-TextWithBestEffort -Path $File
  if ($content -notmatch $Pattern) {
    Append-Utf8NoBom -Path $File -Content ("`n$Block`n")
    return $true
  }
  return $false
}

function Insert-TopLevelKeyIfMissing {
  param(
    [string]$File,
    [string]$Key,
    [string]$Line
  )

  $content = Read-TextWithBestEffort -Path $File
  $keyPattern = '(?m)^\s*' + [regex]::Escape($Key) + '\s*='
  if ($content -match $keyPattern) { return $false }

  $sectionPattern = '(?m)^\[.+\]'
  $match = [regex]::Match($content, $sectionPattern)
  if ($match.Success) {
    $pos = $match.Index
    $before = $content.Substring(0, $pos).TrimEnd()
    $after = $content.Substring($pos)
    $updated = "$before`n$Line`n`n$after"
  } else {
    $updated = $content.TrimEnd() + "`n$Line`n"
  }
  Write-Utf8NoBom -Path $File -Content $updated
  return $true
}

function Ensure-Or-ReplaceLine {
  param(
    [string]$File,
    [string]$Pattern,
    [string]$Line
  )

  $content = Read-TextWithBestEffort -Path $File
  if ($content -match $Pattern) {
    $updated = [regex]::Replace($content, $Pattern, $Line, [System.Text.RegularExpressions.RegexOptions]::Multiline)
    if ($updated -ne $content) {
      Write-Utf8NoBom -Path $File -Content $updated
      return $true
    }
    return $false
  }

  Append-Utf8NoBom -Path $File -Content ("`n$Line`n")
  return $true
}

function Merge-OpenThesisSections {
  param([string]$ConfigPath)

  Copy-Item -Path $ConfigPath -Destination "$ConfigPath.bak" -Force
  Write-Info 'Backed up config.toml -> config.toml.bak'
  Normalize-FileToUtf8 -Path $ConfigPath

  $added = 0
  if (Insert-TopLevelKeyIfMissing -File $ConfigPath -Key 'developer_instructions' -Line $SafeDeveloperInstructionsLine) { $added++ }
  if (Insert-TopLevelKeyIfMissing -File $ConfigPath -Key 'sandbox_mode' -Line 'sandbox_mode = "workspace-write"') { $added++ }
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

  Normalize-FileToUtf8 -Path $ConfigPath
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

  $template = Read-TextWithBestEffort -Path $templatePath
  $template = $template.Replace('__MODEL__', $Model)
  $template = $template.Replace('__PROVIDER_NAME__', $ProviderName)
  $template = $template.Replace('__PROVIDER_URL__', $ProviderUrl)
  Write-Utf8NoBom -Path $targetPath -Content $template

  Write-Info 'Generated config.toml'
}

function Write-Auth {
  if ($SkipAuth) { return }

  $authPath = Join-Path $CodexHome 'auth.json'
  if (Test-Path $authPath) { Copy-Item -Path $authPath -Destination "$authPath.bak" -Force }

  $auth = @{
    OPENAI_API_KEY = $ApiKey
  } | ConvertTo-Json -Depth 5

  Write-Utf8NoBom -Path $authPath -Content ($auth + [Environment]::NewLine)
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
