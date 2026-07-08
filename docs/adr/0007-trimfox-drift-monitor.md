# ADR-0007 — trimfox-drift: catch Firefox private-chrome drift before it breaks anything

- **Status:** Accepted
- **Date:** 2026-07 (newest, this consolidation)

## Context

trimfox depends on Firefox's **private** chrome — custom-property names, selectors, element
ids/anonids, and attribute *values* — none of which Firefox promises to keep stable. A Firefox
update can silently break a rule with **no error** (real case: **Firefox 149** switched the
findbar checkbox from `checked="true"` to a boolean `checked`, killing every `[checked=true]`
rule overnight). This is the **harness** that [ADR-0001](0001-design-philosophy.md) named as the
missing piece — the reason personal userChrome setups rot across Firefox versions.

## Decision

Build **[trimfox-drift](https://github.com/csmarshall/trimfox-drift)** — a stdlib-only Python
tool that extracts what the theme depends on and cross-checks it against a Firefox build,
splitting "will break" (bare `var()`) from "handled" (has a fallback). An **accepted-drift
allowlist** suppresses already-triaged items, so only *new* drift surfaces. A **weekly GitHub
Action** runs it against fresh **release + nightly** Firefox and **opens an issue** on new
drift — it *alerts* rather than auto-fixing, because a CSS fix needs human judgment (the one
place it diverges from the gluetun-monitor `base-drift` pattern it's modeled on).

## Consequences

- **Positive:** trimfox hears about breakage **the week it happens**, not when a user files a
  bug; it caught Firefox **Nova**'s removed vars ahead of any release ([#33](https://github.com/csmarshall/trimfox/issues/33));
  it turns "does this still work?" from a manual audit into a report. It's the harness that makes
  a *maintained* deep-chrome theme viable.
- **Trade-off:** a separate tool and repo to maintain; the heuristic id/anonid/class checks are
  noisy (hence the allowlist); the theme's monitor needs the drift repo to stay **public** (it's
  `pip install`ed from there). See [`.github/workflows/firefox-drift.yml`](../../.github/workflows/firefox-drift.yml).
