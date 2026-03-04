# JEO Workflow — Detailed Reference

## Complete Execution Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                      JEO WORKFLOW                               │
│                                                                 │
│  [START] User activates "jeo" keyword with task description     │
│                          │                                      │
│          ┌───────────────▼──────────────────┐                  │
│          │         PHASE 1: PLAN             │                  │
│          │   ralph creates plan.md           │                  │
│          │   plannotator reviews visually    │                  │
│          │   ┌──────────────────────────┐   │                  │
│          │   │  Approve → continue      │   │                  │
│          │   │  Feedback → re-plan      │   │                  │
│          │   └──────────────────────────┘   │                  │
│          └───────────────┬──────────────────┘                  │
│                          │                                      │
│          ┌───────────────▼──────────────────┐                  │
│          │         PHASE 2: EXECUTE          │                  │
│          │                                   │                  │
│          │  team available?                  │                  │
│          │  ├─ YES: /omc:team N:executor    │                  │
│          │  │       staged pipeline          │                  │
│          │  └─ NO:  /bmad /workflow-init    │                  │
│          │          Analysis→Planning→       │                  │
│          │          Solutioning→Implementation│                 │
│          └───────────────┬──────────────────┘                  │
│                          │                                      │
│          │         PHASE 3: VERIFY           │                  │
│          │   agent-browser snapshot <url>    │                  │
│          │   UI/기능 동작 확인               │                  │
│          │                                   │                  │
│          │   [agentui keyword?]              │                  │
│          │   └─ YES: VERIFY_UI (agentation)  │                  │
│          │       watch_annotations loop      │                  │
│          │       ack → fix → resolve         │                  │
│          └───────────────┬──────────────────┘                  │
│          │         PHASE 3: VERIFY           │                  │
│          │   agent-browser snapshot <url>    │                  │
│          │   UI/기능 동작 확인               │                  │
│          └───────────────┬──────────────────┘                  │
│                          │                                      │
│          ┌───────────────▼──────────────────┐                  │
│          │         PHASE 4: CLEANUP          │                  │
│          │   bash scripts/worktree-cleanup.sh│                  │
│          │   git worktree prune              │                  │
│          └───────────────┬──────────────────┘                  │
│                          │                                      │
│                       [DONE]                                    │
└─────────────────────────────────────────────────────────────────┘
```

---

## agentui — agentation Watch Loop (VERIFY_UI Sub-Phase)

```
agentui keyword detected (or user requests UI annotation review)
    │
    ▼
[PRE-CHECK]  npx agentation-mcp server running? → http://localhost:4747/pending
             <Agentation endpoint="http://localhost:4747" /> mounted in app?
    │
    ▼
[WATCH]  agentation_watch_annotations({batchWindowSeconds:10, timeoutSeconds:120})
         blocking — waits for annotations or timeout
    │
    ├─ Annotations received:
    │   │
    │   ▼
    │  [ACK]   agentation_acknowledge_annotation({id})
    │          → status: 'acknowledged' → spinner shown in toolbar
    │   │
    │   ▼
    │  [FIND]  grep/AST search using annotation.elementPath (CSS selector)
    │          annotation.comment → understand desired change
    │   │
    │   ▼
    │  [FIX]   apply code change to matched component/file
    │   │
    │   ▼
    │  [RESOLVE] agentation_resolve_annotation({id, summary})
    │            → status: 'resolved' → green checkmark in toolbar
    │   │
    │   └─ Next annotation → repeat ACK→FIND→FIX→RESOLVE
    │
    ├─ count=0 (all resolved)
    │   └─ VERIFY_UI complete → proceed to CLEANUP
    │
    └─ timeout (120s)
        └─ summarize what was/wasn't addressed → proceed to CLEANUP
```

**HTTP REST API (Codex / Gemini / OpenCode fallback — no MCP):**
```
LOOP:
  GET  http://localhost:4747/pending         → {count, annotations[]}
  if count == 0 → break (done)
  for each annotation:
    PATCH .../annotations/:id {status:"acknowledged"}
    [search & fix code via elementPath]
    PATCH .../annotations/:id {status:"resolved", resolution:"<summary>"}
  sleep 5 → repeat
```


---

## Platform-Specific Execution Paths

### Claude Code (Primary)

```
jeo keyword detected
    │
    ├─ omc available? → /omc:team N:executor (team orchestration)
    │   ├─ team-plan: explore + planner agents
    │   ├─ team-prd: analyst agent
    │   ├─ team-exec: executor agents (parallel)
    │   ├─ team-verify: verifier + reviewers
    │   └─ team-fix: debugger/executor (loop until done)
    │
    └─ plannotator hook: ExitPlanMode → plannotator plan -
        └─ User reviews in browser UI
```

**State file**: `{worktree}/.omc/state/jeo-state.json`

### Codex CLI

```
/prompts:jeo activated
    │
    ├─ Plan: Write plan.md manually or via ralph prompt
    ├─ Execute: BMAD /workflow-init (no native team support)
    ├─ Verify: agent-browser snapshot <url>
    └─ Cleanup: bash .agent-skills/jeo/scripts/worktree-cleanup.sh
```

**Config**: `~/.codex/config.toml` (developer_instructions)
**Prompt**: `~/.codex/prompts/jeo.md`

### Gemini CLI

```
gemini --approval-mode plan
    │
    ├─ Plan mode: write plan → exit → plannotator fires
    ├─ Execute: ohmg (bunx oh-my-ag) or BMAD /workflow-init
    ├─ Verify: agent-browser snapshot <url>
    └─ Cleanup: bash .agent-skills/jeo/scripts/worktree-cleanup.sh
```

**Config**: `~/.gemini/settings.json` (AfterAgent hook)
**Instructions**: `~/.gemini/GEMINI.md`

### OpenCode

```
/jeo-plan → /jeo-exec → /jeo-status → /jeo-cleanup
    │
    ├─ omx (oh-my-opencode): /omx:team N:executor "<task>"
    ├─ BMAD fallback: /workflow-init
    ├─ plannotator: /plannotator-review (code review)
    └─ Slash commands registered via opencode.json
```

**Config**: `opencode.json` (plugins + instructions)

---

## State Machine

```
States: plan → execute → verify → verify_ui? → cleanup → done

Transitions:
  plan     → execute  (plan approved)
  plan     → plan     (feedback received, re-plan)
  execute  → verify   (tasks complete, browser UI present)
  verify   → verify_ui (agentui keyword detected, agentation running)
  verify   → cleanup  (no agentui, verification passed)
  verify_ui → cleanup (annotations all resolved or timeout)

  cleanup  → done     (worktrees removed, prune complete)
  cleanup  → done     (worktrees removed, prune complete)
```

State persisted in: `.omc/state/jeo-state.json`

```json
{
  "phase": "plan",
  "task": "Implement user authentication",
  "plan_approved": false,
  "plan_path": ".omc/plans/jeo-plan.md",
  "team_available": true,
  "worktrees": [],
  "bmad_phase": null,
  "created_at": "2026-02-24T00:00:00Z",
  "updated_at": "2026-02-24T00:00:00Z",
  "cleanup_completed": false
}
```

---

## Team vs BMAD Decision Matrix

| Condition | Executor | Notes |
|-----------|----------|-------|
| Claude Code + omc + AGENT_TEAMS=1 | **team** | Best option — parallel staged pipeline |
| Claude Code + omc (no teams) | **ralph** | Single-agent loop with verification |
| Codex CLI | **BMAD** | Structured phases, no native team |
| Gemini CLI + ohmg | **ohmg** | Multi-agent via oh-my-ag |
| Gemini CLI (basic) | **BMAD** | Fallback structured workflow |
| OpenCode + omx | **omx team** | oh-my-opencode team orchestration |
| OpenCode (basic) | **BMAD** | Fallback structured workflow |

---

## agent-browser Verify Pattern

```bash
# 앱 실행 중인 URL에서 스냅샷 캡처
agent-browser snapshot http://localhost:3000

# 특정 요소 확인 (accessibility tree ref 방식)
agent-browser snapshot http://localhost:3000 -i
# → @eN ref 번호로 요소 상태 확인

# 스크린샷 저장
agent-browser screenshot http://localhost:3000 -o verify.png
```

---

## Worktree Manual Cleanup

```bash
# List all worktrees
git worktree list

# Remove specific worktree
git worktree remove /path/to/worktree --force

# Prune stale references
git worktree prune
```

---

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | Enable native team orchestration | `1` |
| `PLANNOTATOR_REMOTE` | Remote mode (no auto browser open) | unset |
| `PLANNOTATOR_PORT` | Fixed plannotator port | auto |
| `JEO_MAX_ITERATIONS` | Max ralph loop iterations | `20` |

| `AGENTATION_PORT` | agentation MCP server port | `4747` |
| `AGENTATION_TIMEOUT` | agentui watch loop timeout (seconds) | `120` |
---

## Troubleshooting

### plannotator not opening on plan exit
```bash
# Check hook is configured
bash scripts/check-status.sh

# Re-run hook setup
bash scripts/setup-claude.sh  # or setup-gemini.sh

# Verify plannotator CLI is installed
which plannotator || plannotator --version
```

### team mode not working
```bash
# Ensure env variable is set
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

# Or add to ~/.claude/settings.json:
# "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" }

# Fall back to ralph:
/ralph "<task>" --max-iterations=20
```

### worktree removal fails
```bash
# Force remove
git worktree remove /path/to/wt --force

# If git objects missing
git worktree prune --verbose

# Manual directory removal
rm -rf /path/to/worktree
git worktree prune
```

### agentui (agentation) watch loop not triggering
```bash
# Verify agentation-mcp server is running
curl -sf http://localhost:4747/pending
# Should return: {"count": N, "annotations": [...]}

# Check MCP registration (Claude Code)
cat ~/.claude/settings.json | python3 -c "import sys,json; s=json.load(sys.stdin); print(s.get('mcpServers', {}))"

# Restart agentation-mcp server
npx agentation-mcp server
```
