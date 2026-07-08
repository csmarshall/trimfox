# ADR-0005 — `--tf-*` token vocabulary + swappable palettes

- **Status:** Accepted
- **Date:** 2026-07 (consolidation)

## Context

Consolidating years of ad-hoc tweaks ([ADR-0001](0001-design-philosophy.md)) meant colors and
sizes were **scattered and hardcoded** throughout the CSS — hard to retheme, and brittle against
Firefox's constantly-renamed internal variables and selectors.

## Decision

Route the whole theme through a **stable `--tf-*` token vocabulary**. `userChrome.css` never
hardcodes a color or size — it **maps Firefox's own (unstable) theme variables onto `--tf-*`
tokens**. Primitive *color* tokens live in a **swappable palette file** (`grayscale` = default,
`firefox`, `tinted`); structural *dials* (sizes, motion, density) live in `dials.css`. The
`--tf-*` names are trimfox's **stable API**; Firefox's names churn underneath it.

The shipped default palette is **zero-blue grayscale** — the look whose origin is
[ADR-0001](0001-design-philosophy.md).

## Consequences

- **Positive:** a whole retheme is one token set (or one palette `@import` swap); the token
  layer **absorbs Firefox's renames**, so a rename breaks one mapping line, not scattered rules;
  it enables the parametric `tinted` palette and the live pickers (`palette.html`,
  `tint-picker.html`).
- **Trade-off:** a layer of indirection between Firefox's vars and the final look; requires
  discipline (never hardcode a value — always a token). That Firefox-var → `--tf-*` mapping is
  itself the maintenance surface that [trimfox-drift](0007-trimfox-drift-monitor.md) watches.
