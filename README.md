# LinkedIn Job-Search Automation Agent

An AI agent that automates job searching and professional outreach on LinkedIn
(plus YC Jobs and Indeed) using real browser automation — with human approval
gates before anything is ever sent.

## What it does

1. **Discovers people** — given a company name or job URL, it searches LinkedIn
   and ranks people: recruiters first, then hiring managers, then relevant
   senior engineers, then alumni/second-degree connections.
2. **Sends connection requests** — each with a personalized 300-character note
   (their work + your fit + a low-friction ask). Nothing sends without your
   explicit `APPROVE`.
3. **Tracks acceptances** — polls who accepted, skips anyone already contacted
   (duplicate-proof via tracker + chat-history check).
4. **Drafts referral messages** — one personalized 500–700 character message per
   accepted connection, tied to their company and your best-fit role. Sends
   only after approval.
5. **Matches job-board roles** — opens YC Jobs / Indeed listings, scores fit
   1–10 against your profile memory, persists matches.

## How it works

```
Scheduler → load tracker state + profile memory
  → Browser agent (Playwright, persistent logged-in profile)
    → LinkedIn / YC Jobs / Indeed: search roles + people
  → Evaluate vs profile memory → dedupe vs tracker
  → Human approves batch → act (connect / message / email draft)
  → Checkpoint tracker → next run
```

- **Browser / computer-use:** Playwright MCP over a headed Chromium profile
  you log into once manually. Observe → reason → act → verify each step.
- **Memory (3 layers):** profile memory (`config/profile.yaml`: resume,
  skills, projects) · execution memory (SQLite tracker: processed
  people/jobs, sent messages) · long-running state (scheduler resumes from
  checkpoints; runs never restart from zero).
- **Tools:** Gmail MCP (outreach email drafts) · GitHub MCP (project context
  for fit scoring and message personalization).

## Safety rules (LinkedIn ToS)

- Max 10–12 connections/day, 60–120s jitter between actions.
- Headed browser, human-like pacing, one active session at a time.
- **Halt everything** on any LinkedIn verification/checkpoint screen.
- Never invent profile URLs or names.

## Setup

```bash
cp config/profile.example.yaml config/profile.yaml  # fill your details
sqlite3 tracker.db < tracker/schema.sql             # init memory
```

1. Log in to LinkedIn once in the persistent Chromium profile.
2. Copy `.opencode/agents/linkedin.md` into your project's `.opencode/agents/`.
3. Commands: `START <company|job URL>` · `APPROVE <batch_id>` ·
   `REJECT <batch_id>` · `POLL ACCEPTED` · `SHOW TRACKER` · `RESUME`.

## Repo layout

| Path | Purpose |
|---|---|
| `agent/SYSTEM_PROMPT.md` | Full agent prompt (workflow, caps, commands) |
| `tracker/schema.sql` | SQLite memory schema (`people`, `applications`) |
| `config/profile.example.yaml` | Candidate profile template (never commit real data) |
| `docs/ARCHITECTURE.md` | Agent loop, memory model, failure handling |
| `.opencode/agents/linkedin.md` | Drop-in OpenCode agent definition |

## What this demonstrates

Browser/computer-use agents · long-running scheduled agents · layered agent
memory (profile, execution, checkpointed state) · approval-gated automation ·
idempotent outreach (no duplicates) · graceful failure recovery.
