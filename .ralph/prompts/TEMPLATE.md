# PROJECT CONTEXT

All design decisions, requirements, and architecture for this project are documented in:

- **Spec:** `{{SPEC_PATH}}` — full product requirements
- **Context:** `{{CONTEXT_PATH}}` — background and scope
- **ADRs:** `{{ADR_DIR}}` — architecture decision records

Read these before picking a task; they contain critical context that GitHub issue descriptions alone do not capture.

# ISSUES

Local issue files are available from `{{ISSUES_DIR}}`. Parse them to understand the open issues.

You will work on the AFK issues only (label `afk`), not the HITL ones (label `hitl`).

Also review the recent git log to understand what work has been done.

If all AFK tasks are complete, output <promise>NO MORE TASKS</promise>.

# TASK SELECTION

Pick the next task. Prioritize tasks in this order:

1. Critical bugfixes
2. Development infrastructure

Getting development infrastructure like tests and types and dev scripts ready is an important precursor to building features.

3. Tracer bullets for new features

Tracer bullets are small slices of functionality that go through all layers of the system, allowing you to test and validate your approach early. This helps in identifying potential issues and ensures that the overall architecture is sound before investing significant time in development.

TL;DR - build a tiny, end-to-end slice of the feature first, then expand it out.

4. Polish and quick wins
5. Refactors

# EXPLORATION

Explore the repo.

# BRANCH SETUP

Before implementing anything, check the current branch and ensure it is clean and up to date.

```sh
git branch --show-current
git status
git pull
```

**If there are uncommitted changes:** Stop immediately. Inform the user about the uncommitted changes and ask them to resolve it (commit, stash, or discard) before re-running.

**If the working tree is clean:** Continue with implementation on the currently checked-out branch. Development happens on this branch — do not switch branches or target main.

# IMPLEMENTATION

Use /implement to complete the task.

Apply TDD to {{TDD_SCOPE}}.

## {{COMPONENT_1_NAME}}

- Testing framework: **{{COMPONENT_1_TEST_FRAMEWORK}}**.
- Test files live in `{{COMPONENT_1_TEST_DIR}}`. Name them after the module they cover.
- Run tests with `{{COMPONENT_1_TEST_COMMAND}}` from `{{COMPONENT_1_WORKING_DIR}}`.
- Follow the red → green → refactor loop: write a failing test first, then implement the feature, then clean up.

## {{COMPONENT_2_NAME}}

- Testing framework: **{{COMPONENT_2_TEST_FRAMEWORK}}**.
- Test files live in `{{COMPONENT_2_TEST_DIR}}`. Name them after the module they cover.
- Run tests with `{{COMPONENT_2_TEST_COMMAND}}` from `{{COMPONENT_2_WORKING_DIR}}`.
- Follow the same red → green → refactor loop.

<!-- Add or remove component sections to match the project's layers. -->

# FEEDBACK LOOPS

Before committing, run all feedback loops:

**{{COMPONENT_1_NAME}}:**
- `{{COMPONENT_1_TEST_COMMAND_FULL}}` to run tests
- `{{COMPONENT_1_TYPECHECK_COMMAND}}` to run the type checker

**{{COMPONENT_2_NAME}}:**
- `{{COMPONENT_2_TEST_COMMAND_FULL}}` to run tests
- `{{COMPONENT_2_TYPECHECK_COMMAND}}` to type-check

- Run `/code-review` as a final safety gate before committing

# COMMIT

Make a git commit. The commit message must:

1. Include key decisions made
2. Include files changed
3. Blockers or notes for next iteration

# FINISHING UP

If the task is complete, move the issue file to `{{ISSUES_DONE_DIR}}`.

If the task is not complete, add a note to the issue file with what was done.

# CONSTRAINTS

- Only read, write, or execute files within the repository root. Never access paths outside it.
- Do not install packages globally or modify anything outside the repo (no system config, no other directories).
- {{ENVIRONMENT_CONSTRAINTS}}

# FINAL RULES

- ONLY WORK ON A SINGLE TASK
- DO NOT USE SUBAGENTS
- DO NOT ASK ANY QUESTIONS
