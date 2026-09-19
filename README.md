# LinkedIn Job-Search Automation Agent (OpenCode + Playwright)

Browser-driven outreach agent: drives a real logged-in LinkedIn session via
Playwright MCP, discovers people/roles, sends approval-gated connection
requests and referral outreach, and persists everything to a tracker.
Scheduler + profile memory make it long-running across executions.

## Architecture

```
Scheduler (cron) → load tracker state + profile memory
  → Browser Agent (Playwright MCP, persistent profile)
    → LinkedIn / YC Jobs / Indeed: search roles + people
  → Evaluate vs profile memory (resume, skills, projects)
  → Dedupe vs tracker (skip already processed)
  → Approval gate (human approves batch)
  → Act: connect w/ note, referral message, Gmail draft
  → Checkpoint tracker → next run
```

Tools: Playwright MCP (browser) · Gmail MCP (outreach email) ·
GitHub MCP (project context) · SQLite tracker (memory/state).

## Repo layout

- `agent/SYSTEM_PROMPT.md` — the full agent prompt (phases, gates, commands)
- `tracker/schema.sql` — SQLite memory/state schema (people, applications)
- `config/profile.example.yaml` — candidate profile template (copy to `profile.yaml`, never commit real data)
- `docs/ARCHITECTURE.md` — loop, memory model, safety caps, failure handling
- `.opencode/agents/linkedin.md` — drop-in OpenCode agent definition

## Safety caps (LinkedIn ToS)

Max 10–12 connections/day, 60–120s jitter, approval before every outbound
batch, halt on any checkpoint/CAPTCHA. One active session at a time.

## Setup

1. Copy `config/profile.example.yaml` → `config/profile.yaml`, fill your details.
2. Init tracker: `sqlite3 tracker.db < tracker/schema.sql`.
3. Log in once manually in the persistent Chromium profile.
4. Copy `.opencode/agents/linkedin.md` into your project's `.opencode/agents/`.
5. `START <company|job URL>`, `APPROVE <batch_id>`, `POLL ACCEPTED`, `SHOW TRACKER`.
