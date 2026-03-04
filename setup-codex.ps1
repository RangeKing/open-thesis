$ErrorActionPreference = 'Stop'

$NoPause = $false
$ForwardArgs = @()
foreach ($arg in $args) {
  if ($arg -eq '--no-pause') {
    $NoPause = $true
  } else {
    $ForwardArgs += $arg
  }
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$InnerScript = Join-Path $ScriptDir 'scripts/setup-codex.ps1'
$ExitCode = 0

try {
  & $InnerScript @ForwardArgs
  if ($LASTEXITCODE -ne $null) { $ExitCode = [int]$LASTEXITCODE }
}
catch {
  Write-Host "[ERROR] $($_.Exception.Message)" -ForegroundColor Red
  $ExitCode = 1
}
finally {
  if (-not $NoPause -and $env:OPEN_THESIS_NO_PS_PAUSE -ne '1' -and $Host.Name -eq 'ConsoleHost') {
    Write-Host ''
    Write-Host 'Install finished. Press Enter to close this window...'
    [void](Read-Host)
  }
}

exit $ExitCode
