# ADR-0004 — Native vertical tabs; retire Tree Style Tab

- **Status:** Accepted
- **Date:** 2025 (when native vertical tabs + expand-on-hover shipped)

## Context

trimfox is built around a **collapsible vertical tab strip** — the collapse/expand-on-hover
interaction adopted early from Tree Style Tab's collapsed theme
([ADR-0002](0002-collapse-expand-on-hover.md)). Historically that strip *was* the
**[Tree Style Tab](https://github.com/piroor/treestyletab)** (TST) extension.

Firefox then shipped the capability natively: **native vertical tabs in 136** (2025) and
**expand-on-hover in 138**. For *what trimfox actually needs* — that collapsible strip — the
native feature now covers it **completely**.

## Decision

Use Firefox's **native vertical tabs** and **retire TST**.

The reasoning is deliberately simple: **when the browser natively provides the functionality you
actually need, remove the add-on that was standing in for it.** trimfox needed the collapsible
strip; Firefox 138+ provides exactly that (same collapse + expand-on-hover), so the extension
became redundant. This is not a philosophical "native is always better than extensions" stance —
it's specific to this feature and this use.

TST remains more capable (tab *trees*, grouping); trimfox never used those. It needed the strip,
and the strip is native now.

## Consequences

- **Positive:** one fewer add-on and its API surface / update risk; native tabs are first-class
  chrome, so they're styleable directly with `userChrome.css` and integrate cleanly. The
  migration off TST (including the old TST config) is preserved in [`reference/`](../../reference/).
- **Trade-off:** gives up TST's tree hierarchy and grouping. Acceptable for trimfox's slim,
  power-user focus ([ADR-0001](0001-design-philosophy.md)); anyone who needs trees should keep
  TST — this decision simply doesn't apply to them.
- **Sets a version floor:** expand-on-hover requires **Firefox 138+** (the instant zero-delay
  hover needs 145+); see the README's Requirements.
