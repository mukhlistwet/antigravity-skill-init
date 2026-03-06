# 🧠 Agent Skills — Local Setup

Personal installation of [supercent-io/skills-template](https://github.com/supercent-io/skills-template) with TOON auto-injection for **Google Antigravity**.

## Overview

| Item          | Detail                                       |
| ------------- | -------------------------------------------- |
| Skills        | **72** across 11 categories (+1 custom)      |
| Source        | `supercent-io/skills-template` (v2026-03-06) |
| Platform      | Google Antigravity (Gemini)                  |
| Auto-inject   | ✅ TOON Format via `GEMINI.md`               |
| Custom Skills | `antigravity-dev-workflow`                   |

## Directory Structure

```
m:\Project\2026\Pribadi\Skill\
├── .agent-skills/              # 72 skill folders (source)
│   ├── skills.json             # Full manifest
│   ├── skills.toon             # TOON format catalog
│   ├── antigravity-dev-workflow/  # ⭐ Custom skill
│   └── [71 upstream folders]/
├── docs/                       # Featured tool docs
├── toon-skill-inject.ps1       # 🔧 Catalog regeneration script
├── README.local.md             # This file
└── README.md                   # Original upstream README
```

## Global Paths (Auto-Synced)

| Path                                      | Purpose                             |
| ----------------------------------------- | ----------------------------------- |
| `~/.agent-skills/`                        | Canonical skills (cross-platform)   |
| `~/.gemini/skills/`                       | Antigravity global skills           |
| `~/.gemini/GEMINI.md`                     | Auto-injected skill catalog + rules |
| `~/.gemini/scripts/toon-skill-inject.ps1` | Global script copy                  |

## How Auto-Injection Works

### Two-Tier Architecture

- **Tier 1** (always loaded): `GEMINI.md` catalog (~3,700 tokens) — loaded every session
- **Tier 2** (on-demand): Full `SKILL.md` (~292 tokens/skill, max 3) — loaded when matched

### Built-in Rules

`GEMINI.md` includes mandatory rules that enforce:

1. Always search skill catalog before any task
2. Auto-load matching `SKILL.md` via `view_file`
3. Follow skill instructions strictly
4. Smart selection priority: exact match → tag match → category match

### No Special Prompts Needed

Antigravity auto-matches your task to skills. But you can also be explicit:

```
"Buat REST API, refer skill api-design"
"Debug error ini, pakai skill debugging"
```

## Categories (72 Skills)

| Category           | Count | Key Skills                                                              |
| ------------------ | ----- | ----------------------------------------------------------------------- |
| Agent Development  | 7     | `bmad-orchestrator`, `agentic-workflow`                                 |
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

| Skill                             | Description                                      |
| --------------------------------- | ------------------------------------------------ |
| **`antigravity-dev-workflow`** ⭐ | End-to-end dev workflow: Plan → Build → Verify   |
| **`ohmg`**                        | Multi-agent orchestrator for Gemini/Antigravity  |
| **`jeo`**                         | Full workflow: Plan → Execute → Verify → Cleanup |
| **`ralph`**                       | Loop-until-pass specification-first development  |
| **`plannotator`**                 | Visual plan review before coding                 |

---

## 🖥️ Setup on Another PC / Device

### Prerequisites

- **Node.js** v18+ (for `skills` CLI)
- **Git** (to clone the repo)
- **Google Antigravity** installed

### Step 1: Clone Repository

```bash
git clone https://github.com/supercent-io/skills-template.git <your-skills-directory>
```

### Step 2: Copy Custom Skill

Copy the `antigravity-dev-workflow` folder from your existing setup or create it manually:

```powershell
# If syncing from another machine, copy the custom skill folder:
# .agent-skills/antigravity-dev-workflow/SKILL.md
```

### Step 3: Run TOON Inject Script

```powershell
# Copy the script to the new machine's global path
mkdir -Force "$env:USERPROFILE\.gemini\scripts"
Copy-Item "toon-skill-inject.ps1" "$env:USERPROFILE\.gemini\scripts\"

# Run with -Sync to copy skills + generate catalog
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.gemini\scripts\toon-skill-inject.ps1" -Sync
```

> **Note:** Edit the `$RepoPath` parameter in the script if your clone path differs from the default.

### Step 4: Verify Installation

```powershell
# Check skill count
(Get-ChildItem -Directory "$env:USERPROFILE\.gemini\skills").Count
# Expected: 72

# Check GEMINI.md exists
Test-Path "$env:USERPROFILE\.gemini\GEMINI.md"
# Expected: True

# Check SKILL.md count
(Get-ChildItem -Recurse -Filter "SKILL.md" "$env:USERPROFILE\.gemini\skills").Count
# Expected: 72
```

### Step 5: Test in Antigravity

Open any project in Antigravity and verify skills are auto-discovered:

```
"List all available skills"
```

### Quick Setup (One-Liner)

```powershell
# Clone + sync + generate catalog in one go
git clone https://github.com/supercent-io/skills-template.git "$env:TEMP\skills-template"; Copy-Item "$env:TEMP\skills-template\toon-skill-inject.ps1" "$env:USERPROFILE\.gemini\scripts\" -Force; powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.gemini\scripts\toon-skill-inject.ps1" -Source "$env:TEMP\skills-template\.agent-skills" -Sync
```

---

## Maintenance

### Update Skills (After Upstream Changes)

```powershell
cd <your-skills-directory>
git pull
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.gemini\scripts\toon-skill-inject.ps1" -Sync
```

### Add a Custom Skill

1. Create folder: `.agent-skills/<skill-name>/SKILL.md`
2. Add to `$categoryMap` in `toon-skill-inject.ps1` (optional)
3. Re-run: `powershell -ExecutionPolicy Bypass -File "~\.gemini\scripts\toon-skill-inject.ps1" -Sync`

### Script Parameters

| Parameter   | Default                      | Description                      |
| ----------- | ---------------------------- | -------------------------------- |
| `-Source`   | `~/.gemini/skills`           | Skills source directory          |
| `-Output`   | `~/.gemini/GEMINI.md`        | Output catalog file              |
| `-RepoPath` | `m:\...\Skill\.agent-skills` | Repo source for sync             |
| `-Sync`     | `false`                      | Pull from repo before generating |

---

_Setup: 2026-03-06 · Upstream: [supercent-io/skills-template](https://github.com/supercent-io/skills-template)_
