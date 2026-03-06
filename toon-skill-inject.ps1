<#
.SYNOPSIS
    TOON Skill Catalog Injector for Antigravity (Gemini)
.DESCRIPTION
    Scans ~/.gemini/skills/ for SKILL.md files, extracts metadata,
    and generates a TOON-format catalog in ~/.gemini/GEMINI.md.
.USAGE
    powershell -ExecutionPolicy Bypass -File ~/.gemini/scripts/toon-skill-inject.ps1
    powershell -ExecutionPolicy Bypass -File ~/.gemini/scripts/toon-skill-inject.ps1 -Sync
#>

param(
    [string]$Source = "$env:USERPROFILE\.gemini\skills",
    [string]$Output = "$env:USERPROFILE\.gemini\GEMINI.md",
    [string]$RepoPath = "m:\Project\2026\Pribadi\Skill\.agent-skills",
    [switch]$Sync
)

$ErrorActionPreference = "Stop"

# Step 0: Sync from repo if requested
if ($Sync -and (Test-Path $RepoPath)) {
    Write-Host "[SYNC] Syncing from $RepoPath -> $Source" -ForegroundColor Cyan
    if (Test-Path $Source) { Remove-Item -Recurse -Force $Source }
    New-Item -ItemType Directory -Force $Source | Out-Null
    Copy-Item -Recurse -Force "$RepoPath\*" "$Source\"

    $canonical = "$env:USERPROFILE\.agent-skills"
    if (Test-Path $canonical) { Remove-Item -Recurse -Force $canonical }
    New-Item -ItemType Directory -Force $canonical | Out-Null
    Copy-Item -Recurse -Force "$RepoPath\*" "$canonical\"
    Write-Host "[SYNC] Done" -ForegroundColor Green
}

# Step 1: Discover all SKILL.md files
$skillDirs = Get-ChildItem -Directory $Source | Where-Object {
    Test-Path (Join-Path $_.FullName "SKILL.md")
}
Write-Host "[SCAN] Found $($skillDirs.Count) skills in $Source" -ForegroundColor Cyan

# Step 2: Category mapping
$categoryMap = @{
    "agent-configuration"="Agent Development"; "agent-evaluation"="Agent Development"
    "agentic-development-principles"="Agent Development"; "agentic-principles"="Agent Development"
    "agentic-workflow"="Agent Development"; "bmad-orchestrator"="Agent Development"
    "prompt-repetition"="Agent Development"
    "api-design"="Backend"; "api-documentation"="Backend"; "authentication-setup"="Backend"
    "backend-testing"="Backend"; "database-schema-design"="Backend"
    "design-system"="Frontend"; "react-best-practices"="Frontend"; "responsive-design"="Frontend"
    "state-management"="Frontend"; "ui-component-patterns"="Frontend"
    "web-accessibility"="Frontend"; "web-design-guidelines"="Frontend"
    "code-refactoring"="Code Quality"; "code-review"="Code Quality"; "debugging"="Code Quality"
    "performance-optimization"="Code Quality"; "testing-strategies"="Code Quality"
    "ai-tool-compliance"="Infrastructure"; "deployment-automation"="Infrastructure"
    "firebase-ai-logic"="Infrastructure"; "genkit"="Infrastructure"
    "llm-monitoring-dashboard"="Infrastructure"; "looker-studio-bigquery"="Infrastructure"
    "monitoring-observability"="Infrastructure"; "security-best-practices"="Infrastructure"
    "system-environment-setup"="Infrastructure"; "vercel-deploy"="Infrastructure"
    "changelog-maintenance"="Documentation"; "presentation-builder"="Documentation"
    "technical-writing"="Documentation"; "user-guide-writing"="Documentation"
    "sprint-retrospective"="Project Management"; "standup-meeting"="Project Management"
    "task-estimation"="Project Management"; "task-planning"="Project Management"
    "codebase-search"="Search and Analysis"; "data-analysis"="Search and Analysis"
    "log-analysis"="Search and Analysis"; "pattern-detection"="Search and Analysis"
    "image-generation"="Creative Media"; "pollinations-ai"="Creative Media"
    "video-production"="Creative Media"; "marketing-automation"="Marketing"
    "antigravity-dev-workflow"="Utilities"
}

$catOrder = @("Agent Development","Backend","Frontend","Code Quality","Infrastructure","Documentation","Project Management","Search and Analysis","Creative Media","Marketing","Utilities")
$categories = @{}
foreach ($c in $catOrder) { $categories[$c] = [System.Collections.ArrayList]@() }

# Step 3: Extract metadata
$skills = [System.Collections.ArrayList]@()

foreach ($dir in $skillDirs) {
    $skillName = $dir.Name
    $skillMd = Join-Path $dir.FullName "SKILL.md"
    $content = Get-Content $skillMd -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }

    $desc = ""
    $tags = ""
    if ($content -match '(?s)^---\s*\r?\n(.*?)\r?\n---') {
        $fm = $Matches[1]
        if ($fm -match 'description:\s*(.+)') {
            $desc = $Matches[1].Trim().Trim('"').Trim("'")
            if ($desc.Length -gt 80) { $desc = $desc.Substring(0, 77) + "..." }
        }
        if ($fm -match 'tags:\s*(.+)') {
            $rawTags = $Matches[1].Trim()
            $tagList = $rawTags -split '[,\s]+' | Where-Object { $_ } | Select-Object -First 4
            $tags = ($tagList -join ", ")
        }
    }
    if (-not $desc) { $desc = "Skill: $skillName" }

    $cat = if ($categoryMap.ContainsKey($skillName)) { $categoryMap[$skillName] } else { "Utilities" }
    $bt = '``'
    $entry = "- ${bt}${skillName}${bt} - $desc | Tags: $tags"
    [void]$categories[$cat].Add($entry)
    [void]$skills.Add($skillName)
}

# Step 4: Generate GEMINI.md content
$nl = [Environment]::NewLine
$lines = [System.Collections.ArrayList]@()

[void]$lines.Add("# Agent Skills Catalog (Auto-Injected)")
[void]$lines.Add("")
[void]$lines.Add("You have $($skills.Count) agent skills installed at ``~/.gemini/skills/``. When a user's task matches a skill below, **automatically** read the full ``SKILL.md`` from the matching skill folder using ``view_file`` and follow its instructions.")
[void]$lines.Add("")
[void]$lines.Add("## Skill Usage Rules (MANDATORY)")
[void]$lines.Add("")
[void]$lines.Add("1. ALWAYS search this skill catalog before solving any task")
[void]$lines.Add("2. If a matching skill exists, load its ``SKILL.md`` via ``view_file``")
[void]$lines.Add("3. Follow the skill instructions strictly — do not improvise")
[void]$lines.Add("4. Max 3 skills per prompt to conserve context tokens")
[void]$lines.Add("5. If user explicitly names a skill, prioritize that skill")
[void]$lines.Add("")
[void]$lines.Add("## Skill Selection Priority")
[void]$lines.Add("")
[void]$lines.Add("1. **Exact match**: User says `"use X`" or `"refer skill X`" -> load X immediately")
[void]$lines.Add("2. **Tag match**: Task keywords match skill tags (e.g., `"REST API`" -> ``api-design``)")
[void]$lines.Add("3. **Category match**: Task domain matches category (e.g., `"frontend styling`" -> ``design-system``)")
[void]$lines.Add("4. **Ambiguous**: Prefer the more specific skill over generic ones")
[void]$lines.Add("5. **No match**: Proceed without skill — do not force-fit")
[void]$lines.Add("")
[void]$lines.Add("## Skill Catalog (TOON Format)")
[void]$lines.Add("")

foreach ($cat in $catOrder) {
    if ($categories[$cat].Count -gt 0) {
        [void]$lines.Add("### $cat")
        foreach ($entry in $categories[$cat]) {
            [void]$lines.Add($entry)
        }
        [void]$lines.Add("")
    }
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
[void]$lines.Add("---")
[void]$lines.Add("*Catalog auto-generated on $timestamp. Source: ``~/.gemini/skills/``. To update: run ``~/.gemini/scripts/toon-skill-inject.ps1``*")

$output_content = $lines -join $nl

# Write output
Set-Content -Path $Output -Value $output_content -Encoding UTF8
Write-Host "[DONE] Generated $Output with $($skills.Count) skills" -ForegroundColor Green
Write-Host "[INFO] Categories:" -ForegroundColor Yellow
foreach ($cat in $catOrder) {
    if ($categories[$cat].Count -gt 0) {
        Write-Host "  $cat : $($categories[$cat].Count)" -ForegroundColor Gray
    }
}
