---
name: issue-batch-sdd
description: Triage, prioritize, and implement a branch-isolated batch of issue fixes via subagent-driven development. Invoke when given an issue list, bug backlog, QA notes, or improvement list.
---

# Issue Batch SDD

Turn a loose issue list into a small, serial batch of branch-isolated development work using `subagent-driven-development`.

This is a controller skill. The main agent handles intake, triage, context grouping, prioritization, branch sequencing, and durable progress. It should not implement directly; dispatch subagents for deeper analysis and implementation.

## Core Rules

- Default to 3 issues when the user does not specify a count.
- Process at most 5 issues in one batch. If the user requests more than 5, explain the cap and ask them to split the work or select the first batch.
- Execute issues serially under main-agent coordination.
- Allow grouping for shared context only. Do not merge multiple issues into one implementation task or one branch.
- Use one branch per issue.
- Store batch artifacts under `.agents/issue-sdd/`.
- Do not merge completed issue branches. The human reviews and decides whether to merge.

## Relationship To Subagent-Driven Development

This skill depends on the local `subagent-driven-development` skill. If it is not present, install it:

```bash
npx skills add https://github.com/obra/superpowers --skill subagent-driven-development
```

Before implementing any issue, read and follow the local `subagent-driven-development` skill. This skill only decides issue selection, ordering, context handoff, and batch bookkeeping.

Avoid restating the full SDD workflow. For implementer/reviewer dispatches, refer to `subagent-driven-development` for:

- implementer and reviewer prompts
- task brief and report handoffs
- diff package generation
- review loops and fix dispatches
- durable progress expectations
- final review behavior

## Batch Artifacts

Initialize the workspace and gitignore with the provided script:

```bash
bash skills/issue-batch-sdd/init-workspace.sh
```

Then create the batch directory:

```text
.agents/issue-sdd/YYYY-MM-DD-HHMM/
```

Recommended files:

```text
intake.md
triage.md
progress.md
issue-<n>-<slug>/
  brief.md
  implementer-report.md
  reviewer-report.md
  decision-needed.md
```

Create only useful files. `decision-needed.md` is only needed when an issue requires human direction. Test commands and results belong in `implementer-report.md` or `reviewer-report.md`, not a separate test-results file.

## Intake

Read the issue list once and normalize it into `intake.md`.

```text
# Intake

Source: <issue list source>

## Issues

### Issue <issue-id/local-id>: <title>

- Type: bug | improvement | UX | performance | test | docs | ops | unknown
- Original text: <verbatim>
- User impact: <who/what affected, severity>
- Likely surface area: <from light inspection only>
- Ambiguity: <missing reproduction steps, unclear expected behavior>
- Dependencies/Conflicts: <other issues, shared code, ordering>

### Issue <issue-id/local-id>: <title>

```

Light inspection means enough context to route work, not tracing implementation. If deeper code analysis is needed during triage, dispatch a subagent for focused investigation and have it write findings to the batch artifacts.

## Triage

Write selected order, deferred issues, and their rationales to `triage.md`.

```text
# Triage

Batch size: <count>

## Selected Issues (In Execution Order)

### Issue <issue-id>: <title>

- Priority rationale: <reason>
- Scope fit: <reason>
- Context sharing: <dependency analysis - whether sharing context with previous issues>
- Branch: <branch name>

### Issue <issue-id>: <title>

...

## Deferred Issues

- <issue-id>: <defer reason>
...

```

### Prioritization

Rank issues using this order:

1. Data loss, security, permissions, or production-blocking failures.
2. Broken core workflows.
3. High-frequency user pain or confusing behavior.
4. Regression risk reducers and missing tests for fragile behavior.
5. Small improvements with clear scope.
6. Nice-to-have polish.

Within the same priority class, prefer issues with clearer reproduction steps, smaller blast radius, dependency-unblocking value, or higher uncertainty reduction for the batch.

Select the requested count, or 3 by default. Never select more than 5 in one batch.

### Dependency Analysis

Within selected issues, mark the issues as context-sharing when they should be understood together because they may share:

- the same screen, API, workflow, data model, or permission path
- the same root cause
- sequential dependency
- potentially conflicting behavior expectations

Dependency analysis can be deeper than light inspection, but still should not trace implementation details.

Context grouping never means combined development. Each selected issue still gets its own branch and implementer/reviewer cycle.

## Process

Use these statuses in `progress.md`:

```text
# Process

## Status

| Issue ID | Title | Status |
| --- | --- | --- |
| <issue-id> | <title> | <status> |
...

## Ledger

- YYYY-MM-DD HH:MM:SS: <action>
...

```

### Statuses

| Status | Meaning | Trigger |
| --- | --- | --- |
| `TRIAGED` | The issue has been normalized and lightly classified. | Intake has enough information to rank or defer the issue. |
| `DEFERRED` | The issue is not selected for the current batch. | It falls below the batch cutoff, lacks enough detail, duplicates another issue, or should wait for another branch/decision. |
| `IN_DEVELOPMENT` | An implementer/fix subagent is working on the issue branch. | The branch and `brief.md` exist and implementation or focused investigation has started. |
| `IN_REVIEW` | A reviewer subagent is checking the issue implementation. | Implementer reports completion and the review package is ready. |
| `NEEDS_FIX` | Review found blocking issues that require another implementation pass. | Reviewer fails spec compliance or code quality, or raises Critical/Important findings. |
| `NEEDS_HUMAN_DECISION` | The issue requires a product, architecture, data, permission, UX, or scope decision before code should be changed. | Implementer or main agent writes `decision-needed.md` and stops implementation for this issue. |
| `DONE_FOR_HUMAN_REVIEW` | The issue branch passed the implementer/reviewer loop and is ready for human review. | Reviewer passes spec compliance and approves code quality. |
| `BLOCKED` | The issue cannot make useful progress in this batch. | Required context, environment, dependency, or reproduction path is unavailable after reasonable focused investigation. |

### Ledger

Append progress entries as work completes. This ledger is the recovery source after context compaction.

## Per-Issue Workflow

For each selected issue, in priority order:

1. Create or switch to a dedicated branch.
2. Write `brief.md` with the single issue scope, relevant context group notes, and links to exact prior artifacts if needed.
3. Run the implementation/review loop according to `subagent-driven-development`.
4. If a major decision is required, write or verify `decision-needed.md`, mark `NEEDS_HUMAN_DECISION`, and continue to the next issue.
5. If the implementer finds the current issue is sequentially dependent on or conflicts with previous issues, treat it as `NEEDS_HUMAN_DECISION`.
6. If the issue is blocked, mark `BLOCKED` with the blocker and continue.
7. When review passes, mark `DONE_FOR_HUMAN_REVIEW`.

Do not start the next issue until the current issue is done, blocked, or waiting for human decision.

## Branch Rules

Use one branch per issue. Prefer:

```text
issue-sdd/<issue-id-or-slug>
```

If a later issue depends on an earlier completed branch, note the dependency and ask the human whether to base the later branch on the earlier issue branch or wait until it is merged.

## Human Decision Notes

Create `decision-needed.md` when implementation would require the agent to choose among meaningful product or architecture options. Include:

- decision needed
- options considered
- affected files, docs, or workflows
- risk of choosing wrong
- recommended human action

Do not let the implementer make the decision implicitly.

## Context Handoff To Later Issues

Later issue agents may read earlier artifacts when helpful, such as:

- `triage.md`
- earlier `brief.md`
- earlier `implementer-report.md`
- earlier `reviewer-report.md`
- earlier `decision-needed.md`

Tell them exactly which files matter. Do not ask a later subagent to read the whole batch directory unless the issue genuinely requires it.

Prior issue context is advisory. It must not expand the current issue's scope without explicit human approval.

## Human Review Output

At the end of the batch, report:

- selected issues and rationale
- deferred issues and rationale
- status per issue
- branch per completed issue
- tests/checks summarized from reports
- decision notes needing human input
- recommended merge order if dependencies exist

Make clear that branches are ready for human review, not automatically merged.

## Red Flags

Stop, defer, or request human direction if:

- the issue requires undefined product behavior
- the fix would change database schema, permission semantics, audit behavior, or storage layout without a clear written requirement
- two selected issues need incompatible changes
- a later issue depends on an unmerged earlier branch and the base branch choice matters
- the issue cannot be reproduced or scoped after focused investigation
- the reviewer finds a cross-issue conflict

## Example Summary

```text
Batch complete.

1. QL-18 export button fails on filtered product list
   Status: DONE_FOR_HUMAN_REVIEW
   Branch: issue-sdd/ql-18-export-filtered-list
   Verification: see issue-1-ql-18-export-filtered-list/implementer-report.md

2. QL-22 document permissions unclear for archived files
   Status: NEEDS_HUMAN_DECISION
   Decision note: .agents/issue-sdd/2026-06-24-1430/issue-2-ql-22-archived-permissions/decision-needed.md

3. QL-31 search result ordering feels inconsistent
   Status: DONE_FOR_HUMAN_REVIEW
   Branch: issue-sdd/ql-31-search-ordering
   Verification: see issue-3-ql-31-search-ordering/implementer-report.md
```
