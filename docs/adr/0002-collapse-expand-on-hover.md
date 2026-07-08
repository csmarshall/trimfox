# ADR-0002 — Collapse / expand-on-hover as the tab-strip interaction

- **Status:** Accepted
- **Date:** early (approximate; predates the move to native vertical tabs)

## Context

The founding look ([ADR-0001](0001-design-philosophy.md)) wanted the tab list *present but out
of the way*. **[Tree Style Tab](https://github.com/piroor/treestyletab)** (TST) — the extension
trimfox used for vertical tabs at the time — shipped a **collapsed** presentation: the strip
sits as a thin rail and widens when you reach for it. That was exactly the right trade, and
trimfox cribbed it — a tab strip you can see the *shape* of at a glance that stays out of the
way until you need it.

## Decision

Make the tab strip **collapsed by default, expanding on hover** — a skinny ~14px column of
separator lines (a live tab count) at rest, full labels on hover. This interaction, borrowed
from TST's collapsed theme, is the tab strip's defining behavior.

When trimfox later moved to Firefox's **native** vertical tabs
([ADR-0004](0004-native-vertical-tabs.md)), this preference carried straight over — native
vertical tabs offer the same collapse + expand-on-hover, now tuned to instant (zero-delay)
expansion.

## Consequences

- **Positive:** the strip costs ~14px at rest instead of a full column — the trim /
  get-out-of-the-way ethos ([ADR-0001](0001-design-philosophy.md)) made concrete, and the single
  most recognizable thing about trimfox.
- **Trade-off:** trades persistent tab visibility for space; the hover-expand motion can surprise
  newcomers (the README's "Heads up" sets expectations). Always-open stays one pref away
  (`sidebar.visibility="always-show"`), just not the default. On native tabs this sets the
  version floor — expand-on-hover needs **Firefox 138+**, instant hover **145+**.
