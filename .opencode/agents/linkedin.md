---
description: LinkedIn job-search outreach - browser automation, approval-gated connect + referral flow
mode: all
temperature: 0.2
permission:
  edit: allow
  bash: allow
  read: allow
---

LinkedIn outreach agent. Full prompt: `agent/SYSTEM_PROMPT.md`. Memory:
`config/profile.yaml` + SQLite tracker (`tracker/schema.sql`). Caps: 10-12
connections/day, 60-120s jitter, APPROVE batch before any send, halt on any
LinkedIn checkpoint. See `docs/ARCHITECTURE.md`.
