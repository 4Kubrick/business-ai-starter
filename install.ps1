param(
  [Parameter(Mandatory=$true)][string]$TargetPath,
  [ValidateSet('Both','Claude','Codex')][string]$Mode='Both',
  [switch]$Force
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
New-Item -ItemType Directory -Force -Path $TargetPath | Out-Null

function Copy-Safe($src,$dst){
  if((Test-Path $dst) -and -not $Force){ Write-Host "SKIP $dst"; return }
  $parent=Split-Path -Parent $dst; if($parent){ New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  Copy-Item $src $dst -Recurse -Force
}

Copy-Safe (Join-Path $root 'BUSINESS.md') (Join-Path $TargetPath 'BUSINESS.md')
foreach($d in @('projects','ideas','decisions','research','experiments','meetings')){ New-Item -ItemType Directory -Force -Path (Join-Path $TargetPath $d) | Out-Null }
Copy-Safe (Join-Path $root 'templates') (Join-Path $TargetPath 'templates')
if($Mode -in @('Both','Claude')){
  Copy-Safe (Join-Path $root 'CLAUDE.md') (Join-Path $TargetPath 'CLAUDE.md')
  Copy-Safe (Join-Path $root '.claude') (Join-Path $TargetPath '.claude')
}
if($Mode -in @('Both','Codex')){
  Copy-Safe (Join-Path $root 'AGENTS.md') (Join-Path $TargetPath 'AGENTS.md')
  Copy-Safe (Join-Path $root '.agents') (Join-Path $TargetPath '.agents')
  if(Test-Path (Join-Path $root '.codex')){ Copy-Safe (Join-Path $root '.codex') (Join-Path $TargetPath '.codex') }
}
Write-Host "Business AI Starter installed: $Mode"
