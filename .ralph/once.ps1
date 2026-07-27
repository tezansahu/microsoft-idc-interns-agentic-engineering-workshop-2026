param(
    [Parameter(Mandatory)][string]$PromptFile,
    [string]$Model = "claude-opus-4.8"
)

$repoRoot = Split-Path $PSScriptRoot -Parent

$commits = git -C $repoRoot log -n 5 --format="%H%n%ad%n%B---" --date=short 2>$null
if (-not $commits) { $commits = "No commits found" }

# Resolve prompt file path relative to repo root if not absolute
if (-not [System.IO.Path]::IsPathRooted($PromptFile)) {
    $PromptFile = Join-Path $repoRoot $PromptFile
}

$prompt = Get-Content $PromptFile -Raw

$modelArgs = if ($Model) { @('--model', $Model) } else { @() }

Set-Location $repoRoot
copilot --prompt "Previous commits: $commits $prompt" --allow-all-tools @modelArgs