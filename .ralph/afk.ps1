param(
    [Parameter(Mandatory)][int]$Iterations,
    [Parameter(Mandatory)][string]$PromptFile,
    [string]$Model = "claude-opus-4.8"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$repoRoot = Split-Path $PSScriptRoot -Parent
Set-Location $repoRoot

# Resolve prompt file path relative to repo root if not absolute
if (-not [System.IO.Path]::IsPathRooted($PromptFile)) {
    $PromptFile = Join-Path $repoRoot $PromptFile
}

$modelArgs = if ($Model) { @('--model', $Model) } else { @() }

for ($i = 1; $i -le $Iterations; $i++) {
    Write-Host "`n=== Iteration $i / $Iterations ===" -ForegroundColor Cyan

    $commits = git log -n 5 --format="%H%n%ad%n%B---" --date=short 2>$null
    if (-not $commits) { $commits = "No commits found" }

    $prompt = Get-Content $PromptFile -Raw

    $fullPrompt = "Previous commits: $commits $prompt"

    $output = copilot --prompt $fullPrompt --allow-all-tools @modelArgs 2>&1 | ForEach-Object {
        Write-Host $_
        $_
    }

    $combined = $output -join "`n"

    if ($combined -match '<promise>NO MORE TASKS</promise>') {
        Write-Host "`nRalph complete after $i iteration(s)." -ForegroundColor Green
        exit 0
    }
}

Write-Host "`nReached iteration limit ($Iterations)." -ForegroundColor Yellow