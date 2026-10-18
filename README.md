# claude-fleet

A cost-aware coding fleet for Claude Code:

```
/fleet <task>
  ├─ fleet-planner   (Opus, read-only)     -> plan + test cases + test command
  ├─ main session    (Sonnet)              -> implements, runs tests until green
  ├─ fleet-verifier  (Opus, read-only)     -> reviews the git diff: PASS / FAIL
  │      FAIL -> Sonnet fixes -> tests -> review again (max 3 reviews)
  └─ fleet-reporter  (Haiku, low effort)   -> short report for you
```

## Install (macOS / Linux / WSL)

```bash
bash install.sh
```

This copies the files into `~/.claude/agents/` and `~/.claude/skills/fleet/`,
so `/fleet` works in every repo. To use it in one repo only, copy `agents/`
and `skills/` into that repo's `.claude/` folder instead.

## Use

```bash
cd your-repo        # must be a git repo with no uncommitted changes
claude
/fleet Add pagination to GET /orders with page and size params, default size 20
```

It works on a new branch `fleet/<slug>` and never commits or pushes, so you
review the diff yourself.

## Why it's cheap

- Opus only plans (once) and reviews (at most 3 times), with read-only tools.
- The `model: sonnet` line in the skill runs the main session on Sonnet for the
  whole `/fleet` turn, even if your session default is Opus.
- Tests run before any review, so failing code never reaches Opus.
- The reviewer gets the diff and test output in its prompt instead of
  exploring the repo itself.

## Tuning

- Each file's `model:` accepts `opus`, `sonnet`, `haiku`, or a full model ID.
- Add `effort: medium` (or `low`) to a subagent to spend fewer tokens.
- The first time it runs your test command, approve it with "don't ask again"
  so later rounds don't stop for permission.
