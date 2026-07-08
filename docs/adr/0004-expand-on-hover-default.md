# ADR-0004 — Collapse / expand-on-hover as the default tab-strip interaction

- **Status:** Accepted
- **Date:** 2025 (with native vertical tabs)

## Context

Firefox's native vertical tabs ([ADR-0002](0002-native-vertical-tabs.md)) can be presented two
ways: **always shown** at full width, or **collapsed** to a skinny column that **expands on
hover** (`sidebar.visibility`). The theme has to pick a default.

## Decision

Default to the **collapsed skinny strip that expands on hover** — instant, with the zero-delay
hover pref (`...expand-on-hover.delay-duration-ms=0`). Collapsed, it's a ~14px column of
separator lines that reads as a live tab count; hover reveals full labels.

Always-open remains one pref away (`sidebar.visibility="always-show"`, plus drag-to-resize),
and the README documents it — but it is **not** the default.

## Consequences

- **Positive:** reclaims horizontal space — the tab strip costs ~14px at rest instead of a
  full sidebar column. This is the trim / get-out-of-the-way ethos ([ADR-0001](0001-design-philosophy.md))
  made concrete.
- **Trade-off:** trades persistent tab visibility for space; the expand-on-hover motion can
  surprise newcomers (the README's "Heads up" sets expectations). Sets the version floor —
  expand-on-hover needs **Firefox 138+**, instant hover needs **145+**.
