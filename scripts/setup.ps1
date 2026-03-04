$ErrorActionPreference = 'Stop'

$ClaudeDir = Join-Path $HOME '.claude'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SrcDir = (Resolve-Path (Join-Path $ScriptDir '..')).Path
$Components = @('skills', 'commands', 'agents', 'rules', 'hooks', 'scripts', 'CLAUDE.md', 'CLAUDE.zh-CN.md')
$ClaudeCodeDocUrl = 'https://code.claude.com/docs/en/getting-started'

function Write-Info {
  param([string]$Message)
  Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Warn {
  param([string]$Message)
  Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Fail {
  param([string]$Message)
  Write-Host "[ERROR] $Message" -ForegroundColor Red
  exit 1
}

function Set-ObjectProperty {
  param(
    [Parameter(Mandatory = $true)] [psobject]$Object,
    [Parameter(Mandatory = $true)] [string]$Name,
    [Parameter(Mandatory = $true)] $Value
  )

  $prop = $Object.PSObject.Properties[$Name]
  if ($null -eq $prop) {
    $Object | Add-Member -NotePropertyName $Name -NotePropertyValue $Value
  } else {
    $prop.Value = $Value
  }
}

function Ensure-ObjectProperty {
  param(
    [Parameter(Mandatory = $true)] [psobject]$Object,
    [Parameter(Mandatory = $true)] [string]$Name
  )

  $prop = $Object.PSObject.Properties[$Name]
  if ($null -eq $prop) {
    $newObj = [pscustomobject]@{}
    $Object | Add-Member -NotePropertyName $Name -NotePropertyValue $newObj
    return $newObj
  }

  if ($null -eq $prop.Value) {
    $newObj = [pscustomobject]@{}
    $prop.Value = $newObj
    return $newObj
  }

  return $prop.Value
}

function Check-Deps {
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Fail 'Git is required. Install it first.'
  }

  if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Fail 'Node.js is required (hooks depend on it). Install it first.'
  }
}

function Ensure-ClaudeCli {
  if (Get-Command claude -ErrorAction SilentlyContinue) {
    $version = (& claude --version 2>$null)
    if ([string]::IsNullOrWhiteSpace($version)) { $version = 'installed' }
    Write-Info "Detected Claude Code CLI: $version"
    return
  }

  Write-Warn 'Claude Code CLI not found. Attempting automatic install...'
  if (Get-Command npm -ErrorAction SilentlyContinue) {
    try {
      npm install -g @anthropic-ai/claude-code | Out-Host
    } catch {
      Write-Warn 'Automatic install via npm failed.'
    }
  } else {
    Write-Warn 'npm not found; cannot auto-install Claude Code CLI.'
  }

  if (Get-Command claude -ErrorAction SilentlyContinue) {
    $version = (& claude --version 2>$null)
    if ([string]::IsNullOrWhiteSpace($version)) { $version = 'installed' }
    Write-Info "Claude Code CLI installed successfully: $version"
  } else {
    Write-Warn 'Claude Code CLI is still unavailable.'
    Write-Warn "Official installation docs: $ClaudeCodeDocUrl"
    Write-Warn 'Official quick install:'
    Write-Warn '  macOS/Linux/WSL: curl -fsSL https://claude.ai/install.sh | bash'
    Write-Warn '  Windows PowerShell: irm https://claude.ai/install.ps1 | iex'
  }
}

function Check-ThesisToolchain {
  if (Get-Command xelatex -ErrorAction SilentlyContinue) {
    Write-Info 'Detected xelatex (ctex compile supported).'
  } else {
    Write-Warn 'xelatex not found. Install TeX Live/MiKTeX for ctex compilation.'
  }

  if (Get-Command biber -ErrorAction SilentlyContinue) {
    Write-Info 'Detected biber (GB/T 7714 biblatex workflow supported).'
  } else {
    Write-Warn 'biber not found. GB/T 7714 biblatex references may not compile.'
  }
}

function Create-Settings {
  param([string]$RepoRoot)

  $template = Join-Path $RepoRoot 'settings.json.template'
  $target = Join-Path $ClaudeDir 'settings.json'

  if ((Test-Path $template) -and -not (Test-Path $target)) {
    New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null
    Copy-Item -Path $template -Destination $target -Force
    Write-Info 'Created settings.json from template.'
    Write-Info "  -> Edit $target to add your GITHUB_PERSONAL_ACCESS_TOKEN (optional)."
  }
}

function Merge-Settings {
  param([string]$RepoRoot)

  $template = Join-Path $RepoRoot 'settings.json.template'
  $target = Join-Path $ClaudeDir 'settings.json'

  if (-not (Test-Path $template)) {
    return
  }

  if (-not (Test-Path $target)) {
    Create-Settings -RepoRoot $RepoRoot
    return
  }

  Copy-Item -Path $target -Destination "$target.bak" -Force
  Write-Info 'Backed up settings.json -> settings.json.bak'

  try {
    $existing = Get-Content -Raw -Path $target | ConvertFrom-Json
    $templateObj = Get-Content -Raw -Path $template | ConvertFrom-Json

    if ($templateObj.PSObject.Properties['hooks']) {
      Set-ObjectProperty -Object $existing -Name 'hooks' -Value $templateObj.hooks
    }

    if ($templateObj.PSObject.Properties['mcpServers']) {
      $existingMcp = Ensure-ObjectProperty -Object $existing -Name 'mcpServers'
      foreach ($p in $templateObj.mcpServers.PSObject.Properties) {
        if (-not $existingMcp.PSObject.Properties[$p.Name]) {
          $existingMcp | Add-Member -NotePropertyName $p.Name -NotePropertyValue $p.Value
        }
      }
    }

    if ($templateObj.PSObject.Properties['enabledPlugins']) {
      $existingPlugins = Ensure-ObjectProperty -Object $existing -Name 'enabledPlugins'
      foreach ($p in $templateObj.enabledPlugins.PSObject.Properties) {
        if (-not $existingPlugins.PSObject.Properties[$p.Name]) {
          $existingPlugins | Add-Member -NotePropertyName $p.Name -NotePropertyValue $p.Value
        }
      }
    }

    $json = $existing | ConvertTo-Json -Depth 100
    Set-Content -Path $target -Value ($json + [Environment]::NewLine) -Encoding UTF8
  }
  catch {
    Write-Warn 'Auto-merge failed. Please manually copy settings from settings.json.template.'
    return
  }

  Write-Info 'Merged hooks/mcpServers/enabledPlugins into settings.json.'
}

function Copy-Components {
  param([string]$RepoRoot)

  New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null

  foreach ($comp in $Components) {
    $srcPath = Join-Path $RepoRoot $comp
    if (-not (Test-Path $srcPath)) {
      continue
    }

    if (Test-Path $srcPath -PathType Container) {
      $dstPath = Join-Path $ClaudeDir $comp
      New-Item -ItemType Directory -Force -Path $dstPath | Out-Null
      Get-ChildItem -LiteralPath $srcPath -Force | Copy-Item -Destination $dstPath -Recurse -Force
    }
    else {
      Copy-Item -Path $srcPath -Destination (Join-Path $ClaudeDir $comp) -Force
    }
  }

  Write-Info ('Copied components: ' + ($Components -join ' '))
}

function Main {
  Write-Host ''
  Write-Host '======================================'
  Write-Host '       Open Thesis Installer          '
  Write-Host '======================================'
  Write-Host ''

  Check-Deps
  Ensure-ClaudeCli
  Check-ThesisToolchain

  Write-Info "Installing from: $SrcDir"
  Copy-Components -RepoRoot $SrcDir
  Merge-Settings -RepoRoot $SrcDir
  Write-Info 'Your existing env/permissions are preserved.'
  Write-Info "Chinese thesis template: $ClaudeDir/skills/chinese-degree-thesis-writing/template-latex-ctex.md"
  Write-Info 'Zotero default collection: 中文学位论文 (configurable in settings.json)'

  Write-Host ''
  Write-Info 'Done! Restart Claude Code CLI to activate.'
  Write-Host ''
}

Main
