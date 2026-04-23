[CmdletBinding()]
param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Arguments
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$bashScript = Join-Path $scriptDir 'agentspk-write'

$bash = Get-Command bash -ErrorAction SilentlyContinue
if (-not $bash) {
  $bash = Get-Command sh -ErrorAction SilentlyContinue
}

if ($bash) {
  & $bash.Path $bashScript @Arguments
  exit $LASTEXITCODE
}

$wsl = Get-Command wsl.exe -ErrorAction SilentlyContinue
if ($wsl) {
  $scriptForWsl = (& $wsl.Path wslpath -a ($bashScript -replace '\\', '/')).Trim()
  if ($LASTEXITCODE -eq 0 -and $scriptForWsl) {
    & $wsl.Path bash $scriptForWsl @Arguments
    exit $LASTEXITCODE
  }
}

Write-Error 'AgentSPK on Windows requires a POSIX shell available as `bash` or `sh`, or an accessible WSL installation.'
exit 1
