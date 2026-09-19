# Architecture

## Agent loop (browser / computer-use)

Goal → plan (which board, which company) → Playwright observe (snapshot/DOM)
→ reason (rank people, score roles) → act (click/type) → verify (assert result)
→ log to tracker. Tool choice per step: browser for navigation, Gmail for mail,
GitHub for project context, tracker for dedupe.

## Memory model (3 layers)

1. Profile memory: resume, skills, projects, preferences (`config/profile.yaml`).
2. Execution memory: processed people/jobs, sent messages, past decisions (tracker DB).
3. Long-running state: scheduler loads tracker each run; checkpoints after every
   action, so run N+1 continues where run N stopped. No restart-from-zero.

## Failure handling

Playwright step fails → screenshot + retry once with re-anchored selector →
still failing → mark blocked, continue batch, report. Checkpoint/verification
screen → halt whole day (ToS safety). Duplicate send prevented by
tracker-first check on every action (idempotency key = profile URL / job URL hash).

## Scheduler

Cron (or OpenCode scheduled run): `RESUME` → poll accepted → draft referrals →
await approval → send → checkpoint. Approval gates mean outbound never fires unattended.
