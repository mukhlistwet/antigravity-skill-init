---
name: antigravity-dev-workflow
description: End-to-end development workflow optimized for Google Antigravity. Structured phases from planning to deployment with integrated skill orchestration.
allowed-tools: Read Write Bash Grep Glob
metadata:
  tags: antigravity, workflow, development, end-to-end, planning, implementation, verification
  platforms: Gemini, Antigravity
  keyword: dev-workflow
  version: 1.0.0
  source: custom
---

# Antigravity Dev Workflow

## When to use this skill

- Starting a new project or feature from scratch
- User asks to "build", "create", "implement" a full feature/app
- Multi-file changes spanning frontend + backend + tests
- Any task that benefits from structured Plan → Build → Verify flow

---

## 1. Workflow Phases

### Phase 1: PLANNING (Required)

1. **Understand Requirements**
   - Ask clarifying questions if intent is ambiguous
   - Identify scope: single file change vs multi-component feature
   - Check for related skills: `api-design`, `database-schema-design`, `design-system`

2. **Research Existing Codebase**
   - Use `view_file_outline` to map project structure
   - Use `grep_search` to find related patterns
   - Identify dependencies and potential conflicts

3. **Create Implementation Plan**
   - Write `implementation_plan.md` artifact with:
     - Goal description and context
     - Proposed changes grouped by component
     - File list: [NEW], [MODIFY], [DELETE]
     - Verification plan
   - Request user review via `notify_user`
   - **Do NOT proceed until approved**

### Phase 2: EXECUTION

4. **Build Foundation First**
   - Create/modify config files, schemas, types first
   - Then implement core logic
   - Then add UI/presentation layer
   - Follow dependency order (dependencies before dependents)

5. **Apply Relevant Skills**
   - Load matching skills from catalog automatically:
     - Backend work → `api-design`, `authentication-setup`, `database-schema-design`
     - Frontend work → `design-system`, `react-best-practices`, `responsive-design`
     - New project → `file-organization`, `environment-setup`
   - Max 3 skills per phase

6. **Code Quality Gates**
   - Run build/compile after significant changes
   - Fix errors immediately before proceeding
   - Follow patterns from `code-refactoring` skill

### Phase 3: VERIFICATION

7. **Test Changes**
   - Run existing test suites
   - Verify build succeeds
   - Test in browser if UI changes (use `browser_subagent`)
   - Cross-reference with `testing-strategies` skill

8. **Create Walkthrough**
   - Document what was done, what was tested, results
   - Include screenshots/recordings for UI changes
   - Notify user with summary

---

## 2. Decision Framework

```
Is it a simple question/small edit?
  → YES: Skip workflow, just do it
  → NO: Is it multi-file or complex?
    → YES: Full workflow (Plan → Build → Verify)
    → NO: Abbreviated workflow (Build → Verify)
```

---

## 3. Skill Integration Map

| Task Type         | Primary Skills             | Secondary Skills                             |
| ----------------- | -------------------------- | -------------------------------------------- |
| New API           | `api-design`               | `authentication-setup`, `backend-testing`    |
| New UI Feature    | `design-system`            | `responsive-design`, `web-accessibility`     |
| Database Change   | `database-schema-design`   | `backend-testing`                            |
| Bug Fix           | `debugging`                | `code-review`, `testing-strategies`          |
| Performance Issue | `performance-optimization` | `monitoring-observability`                   |
| New Project       | `file-organization`        | `environment-setup`, `git-workflow`          |
| Deployment        | `deployment-automation`    | `security-best-practices`                    |
| Documentation     | `technical-writing`        | `api-documentation`, `changelog-maintenance` |

---

## 4. Antigravity-Specific Patterns

- Use `task_boundary` to communicate progress (PLANNING → EXECUTION → VERIFICATION)
- Create artifacts in brain directory for plans and walkthroughs
- Use `notify_user` as the ONLY way to communicate during tasks
- Keep `TaskStatus` describing NEXT steps, not past steps
- Update `task.md` checklist as work progresses

---

## 5. Quality Checklist (Before Completion)

- [ ] All files compile/build without errors
- [ ] Existing tests still pass
- [ ] New functionality verified (manually or via tests)
- [ ] No hardcoded secrets or credentials
- [ ] Code follows project conventions
- [ ] Walkthrough created with proof of work
