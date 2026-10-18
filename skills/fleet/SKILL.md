---
description: Run a coding task through a cost-aware agent fleet - Opus plans, Sonnet implements and runs tests, Opus reviews, Haiku reports.
argument-hint: "[task description]"
model: sonnet
disable-model-invocation: true
---

You are the orchestrator AND the implementer of a small agent fleet.

Task: $ARGUMENTS

The point of this fleet is to spend expensive Opus tokens only where judgment
matters (planning and review) and do everything else on cheaper models. Keep
your own messages short. Follow these steps in order.

## 0. Safety first
- Run `git status`. If there are uncommitted changes, STOP and ask me what to do.
- Create a branch: `git switch -c fleet/<short-task-slug>`.
- Never commit, push, or switch to other branches. I review the diff myself.

## 1. Plan (Opus)
Delegate to the `fleet-planner` subagent. Give it the task text exactly as written
above. Wait for its plan, which includes the test cases and a test command.

## 2. Implement (you, Sonnet)
Implement the plan with small, focused edits. Add or update the tests it lists.

## 3. Test gate (no Opus spent here)
Run the plan's test command. If it gave none, use: `pom.xml` -> `mvn -q test`,
`build.gradle(.kts)` -> `./gradlew test`, Python -> `python -m pytest -q`.
- If tests fail, fix the code and rerun. Only continue once they pass.
- Do not weaken or delete a test to make it pass. If a test itself is wrong,
  fix it and say so in the report.

## 4. Review (Opus)
Delegate to the `fleet-verifier` subagent. Its task message must contain:
1. the original task text,
2. the plan from step 1,
3. the full output of `git diff` plus `git status --short` (so new files show),
4. the last ~60 lines of the passing test output.
Do NOT include your own opinion of the work; the reviewer must judge the diff.

- `VERDICT: PASS` -> go to step 5.
- `VERDICT: FAIL` -> fix the listed issues, then go back to step 3.
- Allow at most 3 reviews. After a third FAIL, stop fixing and go to step 5.

## 5. Report (Haiku)
Delegate to the `fleet-reporter` subagent with: the task, the final verdict, how
many review rounds ran, `git diff --stat`, and any open issues from the last
review. Show me its report as your final answer, followed by the branch name.
