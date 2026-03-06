# 🧠 Antigravity Skill Init

🌐 Language: English | [Bahasa Indonesia](README.id.md)

Personal skill setup for **Google Antigravity** — forked from [supercent-io/skills-template](https://github.com/supercent-io/skills-template) with TOON auto-injection and custom workflow skills.

## Overview

| Item         | Detail                                     |
| ------------ | ------------------------------------------ |
| Skills       | **72** across 11 categories (+1 custom)    |
| Source       | `supercent-io/skills-template` v2026-03-06 |
| Platform     | Google Antigravity (Gemini)                |
| Auto-inject  | ✅ TOON Format via `GEMINI.md`             |
| Custom Skill | `antigravity-dev-workflow`                 |

## Features

- **🔄 TOON Auto-Injection** — Skills catalog auto-loaded on every Antigravity session
- **📋 Mandatory Rules** — Agent always searches skills before solving tasks
- **🎯 Smart Selection** — 5-level priority matching (exact → tag → category)
- **🛠️ Custom Workflow** — End-to-end dev workflow: Plan → Build → Verify
- **🔀 Upstream Sync** — Pull latest skills from supercent-io anytime

## Quick Setup

### 1. Clone

```bash
git clone git@github.com:mukhlistwet/antigravity-skill-init.git <your-dir>
cd <your-dir>
```

### 2. Run TOON Inject Script

```powershell
mkdir -Force "$env:USERPROFILE\.gemini\scripts"
Copy-Item "toon-skill-inject.ps1" "$env:USERPROFILE\.gemini\scripts\"
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.gemini\scripts\toon-skill-inject.ps1" -Sync
```

### 3. Verify

```powershell
(Get-ChildItem -Directory "$env:USERPROFILE\.gemini\skills").Count  # Expected: 72
Test-Path "$env:USERPROFILE\.gemini\GEMINI.md"                      # Expected: True
```

### 4. Done!

Open any project in Antigravity — skills are auto-discovered.

## How It Works

### Two-Tier Architecture

| Tier       | What                         | When            | Tokens             |
| ---------- | ---------------------------- | --------------- | ------------------ |
| **Tier 1** | Skill catalog in `GEMINI.md` | Every session   | ~3,700             |
| **Tier 2** | Full `SKILL.md` content      | On-demand match | ~292/skill (max 3) |

### Auto-Detection

No special prompts needed. The agent:

1. Reads the catalog at session start
2. Matches your task to skill tags/names
3. Loads the relevant `SKILL.md`
4. Follows instructions

### Explicit Usage

```
"Buat REST API, refer skill api-design"
"Debug error ini, pakai skill debugging"
"Review code, refer skill code-review"
```

## Directory Structure

```
.
├── .agent-skills/                  # 72 skill folders (source)
│   ├── antigravity-dev-workflow/   # ⭐ Custom skill
│   ├── skills.json                 # Full manifest
│   ├── skills.toon                 # TOON format catalog
│   └── [71 upstream folders]/
├── docs/                           # Featured tool docs
│   ├── bmad/
│   ├── omc/
│   ├── plannotator/
│   ├── ralph/
│   └── vibe-kanban/
├── toon-skill-inject.ps1           # 🔧 Catalog regeneration script
├── README.md                       # This file (English)
└── README.id.md                    # Bahasa Indonesia
```

## Skill Categories (72 Total)

| Category           | Count | Key Skills                                                              |
| ------------------ | ----- | ----------------------------------------------------------------------- |
| Agent Development  | 7     | `bmad-orchestrator`, `agentic-workflow`, `prompt-repetition`            |
| Backend            | 5     | `api-design`, `authentication-setup`, `database-schema-design`          |
| Frontend           | 7     | `design-system`, `react-best-practices`, `responsive-design`            |
| Code Quality       | 5     | `debugging`, `code-review`, `code-refactoring`                          |
| Infrastructure     | 10    | `deployment-automation`, `firebase-ai-logic`, `security-best-practices` |
| Documentation      | 4     | `technical-writing`, `changelog-maintenance`                            |
| Project Management | 4     | `task-planning`, `task-estimation`                                      |
| Search & Analysis  | 4     | `codebase-search`, `data-analysis`                                      |
| Creative Media     | 3     | `image-generation`, `video-production`                                  |
| Marketing          | 1     | `marketing-automation`                                                  |
| Utilities          | 22    | `antigravity-dev-workflow` ⭐, `ohmg`, `jeo`, `ralph`, `plannotator`    |

## Key Skills for Antigravity

| Skill                             | Description                                           |
| --------------------------------- | ----------------------------------------------------- |
| **`antigravity-dev-workflow`** ⭐ | Structured Plan → Build → Verify workflow             |
| **`ohmg`**                        | Multi-agent orchestrator for Gemini/Antigravity       |
| **`jeo`**                         | Full orchestration: Plan → Execute → Verify → Cleanup |
| **`ralph`**                       | Loop-until-pass specification-first development       |
| **`plannotator`**                 | Visual plan review before coding                      |

## Global Paths

After running the inject script, skills are synced to:

| Path                                      | Purpose                       |
| ----------------------------------------- | ----------------------------- |
| `~/.agent-skills/`                        | Canonical (cross-platform)    |
| `~/.gemini/skills/`                       | Antigravity global            |
| `~/.gemini/GEMINI.md`                     | Auto-injected catalog + rules |
| `~/.gemini/scripts/toon-skill-inject.ps1` | Global script                 |

## Setup on Another Device

### Prerequisites

- Node.js v18+, Git, Google Antigravity

### Steps

```powershell
# 1. Clone
git clone git@github.com:mukhlistwet/antigravity-skill-init.git "C:\Skills"
cd "C:\Skills"

# 2. Edit RepoPath in script (if clone path differs)
# Default: m:\Project\2026\Pribadi\Skill\.agent-skills

# 3. Run inject script
mkdir -Force "$env:USERPROFILE\.gemini\scripts"
Copy-Item "toon-skill-inject.ps1" "$env:USERPROFILE\.gemini\scripts\"
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.gemini\scripts\toon-skill-inject.ps1" -Source ".\.agent-skills" -Sync

# 4. Verify
(Get-ChildItem -Directory "$env:USERPROFILE\.gemini\skills").Count  # 72
```

## Maintenance

### Update from Upstream

```bash
git fetch upstream
git merge upstream/main
git push origin main
# Then re-run inject script
powershell -ExecutionPolicy Bypass -File "~\.gemini\scripts\toon-skill-inject.ps1" -Sync
```

### Add Custom Skills

1. Create `.agent-skills/<name>/SKILL.md`
2. Add to `$categoryMap` in `toon-skill-inject.ps1` (optional)
3. Run: `powershell -ExecutionPolicy Bypass -File "~\.gemini\scripts\toon-skill-inject.ps1" -Sync`

### Script Parameters

| Parameter   | Default                      | Description                 |
| ----------- | ---------------------------- | --------------------------- |
| `-Source`   | `~/.gemini/skills`           | Skills source directory     |
| `-Output`   | `~/.gemini/GEMINI.md`        | Output catalog file         |
| `-RepoPath` | `m:\...\Skill\.agent-skills` | Repo source for sync        |
| `-Sync`     | `false`                      | Copy from repo + regenerate |

## Credits

- **Upstream**: [supercent-io/skills-template](https://github.com/supercent-io/skills-template) (71 skills)
- **Skills CLI**: [vercel-labs/skills](https://github.com/vercel-labs/skills)
- **Custom**: `antigravity-dev-workflow` by [@mukhlistwet](https://github.com/mukhlistwet)

---

_Setup: 2026-03-06 · 72 Skills · TOON Format · Antigravity Ready_
