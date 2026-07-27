# Agentic Engineering skills

A repeatable idea → shipped-code pipeline. Skills here are surface-agnostic: they work for any
project in this repo (or any other), not just the connector skills optimizer.

| Skill | What it does | How it's used |
|---|---|---|
| `grill-with-docs` | Stress-tests an idea against the repo's loaded docs (`CONTEXT.md`, spec, ADRs) before anything is built. | You invoke it |
| `to-spec` | Folds the agreed design into `docs/spec.md` — seams included. | You invoke it |
| `to-tickets` | Turns the spec into tracer-bullet GitHub issues. | You invoke it |
| `implement` | Drives implementation of a spec'd slice. | Called by the ralph loop |
| `tdd` | Red-green-refactor at pre-agreed seams. | Called by the ralph loop |
| `code-review` | Reviews changes since a fixed point against standards + spec, in parallel sub-agents. | Called by the ralph loop |

Only the first three are meant for direct invocation. `implement`, `tdd`, and `code-review` are
driven by the ralph loop prompt on every iteration — you don't call them by hand (though you can,
if you're doing a step manually).

## The flow

```
/grill-with-docs  →  /to-spec  →  /to-tickets  →  ralph loop (drives /implement + /tdd + /code-review)
```

### 1. `/grill-with-docs`

Bring the raw idea. The skill loads existing docs and grills the design until it holds up.

**Caveat — externalizing context.** When the grilling settles, it asks whether to externalize the
outcome into `CONTEXT.md`, `spec.md`, and ADRs. **Answer with an explicit target folder**
(e.g. "put these under `my-project/docs/`"). Otherwise it picks a default location that may not
match your project layout, and every downstream skill (and the ralph prompt) points at the wrong
docs.

### 2. `/to-spec`

Updates the project's `docs/spec.md` with the agreed design and the seams the feature will be
tested at. The spec is standalone — it never cites ADR numbers.

### 3. `/to-tickets`

Creates _"tracer-bullet" vertical slice_ issues from the spec.

**Caveat — review the issue split before confirming.** The skill proposes a decomposition and asks
whether it's a correct representation. Do not rubber-stamp it:

- The first pass often produces **horizontal, layer-shaped issues** (all the models, then all the
  CLI, then all the tests) instead of **cross-cutting tracer bullets** — thin vertical slices that
  go end-to-end through every layer. Newer models sometimes get this right on the first try; verify
  rather than assume.
- Read the proposed titles/bodies, then push back concretely: ask it to **merge** issues that are
  too thin to stand alone, **split** ones that span multiple slices, or **re-cut everything as
  vertical slices**.
- Only confirm creation once each issue could plausibly be shipped and demoed on its own.

### 4. Ralph loop

The ralph loop runs an unattended agent repeatedly against the open `ready-for-agent` issues. Each
iteration picks a task, runs `/implement` (which uses `/tdd` at the agreed seams), gates on
`/code-review`, then commits and pushes — so those three skills are invoked by the prompt, not by
you.

**Create the prompt first.** Copy [`.ralph/prompts/TEMPLATE.md`](../../../.ralph/prompts/TEMPLATE.md)
to `.ralph/prompts/<your-project>.md` and fill in every `{{PLACEHOLDER}}` — doc paths, project
directory, setup commands, and feedback-loop commands. `connector-skills-optimizer.md` in the same
folder is a filled-in example.

Not sure what goes in the placeholders? Don't guess — ask Copilot **in the same session** that just
did the grilling, spec, and issue creation. It already holds the project context, so a prompt like
_"use `.ralph/prompts/TEMPLATE.md` to create the ralph loop prompt for this project"_ fills in the
doc paths, project directory, and commands correctly. Skim the result before running it.

**Run it** from the repo root (or the project directory — the script resolves prompt paths relative
to the repo root and `cd`s there itself):

```powershell
.\.ralph\akf.ps1 -Iterations 5 -PromptFile ".ralph/prompts/<your-project>.md"
```

| Parameter | Meaning |
|---|---|
| `-Iterations` | Max agent runs. The loop exits early when the agent emits `NO MORE TASKS`. |
| `-PromptFile` | Prompt to run each iteration. Relative to the repo root. |
| `-Model` | Optional; defaults to `claude-opus-4.8`. |

For a single iteration, use `.\.ralph\once.ps1` with the same arguments.

Each iteration re-reads the prompt and the last 5 commits, so progress is carried forward through
commit messages — keep them decision-rich.

## VS Code setup

Settings → search `skills` → add to **Chat: Agent Skills Locations**:

```
.agents/skills/for_development/
```
