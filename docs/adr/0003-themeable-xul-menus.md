# ADR-0003 — Force XUL menus so native macOS menus can be themed

- **Status:** Accepted
- **Date:** pre-2025 (approximate; refined 2026-07 with `native-anchored-menus`)

## Context

On macOS, Firefox draws context menus and button-anchored popups (the back/forward **history
menu**, the URL-bar dropdown) as **native macOS (Cocoa) menus** by default. Native menus are
outside the DOM — `userChrome.css` cannot reach or style them. For a theme that restyles
*everything*, an unstyled system menu popping up in the middle of a fully-themed chrome breaks
the coherence.

## Decision

Render these menus as **XUL** so CSS can reach them:

- `widget.macos.native-context-menus = false` — right-click context menus.
- `widget.macos.native-anchored-menus = false` — the URL-bar dropdown and the click-and-hold
  history menu.

trimfox then reskins them to match the rest of the chrome (the history menu as a mini tab
strip). See [SETTINGS.md](../../SETTINGS.md) and [`chrome/userChrome.css`](../../chrome/userChrome.css).

## Consequences

- **Positive:** menus match the theme instead of jarring stock system menus — the "everything
  is themed" coherence [ADR-0001](0001-design-philosophy.md) wants.
- **Trade-off:** gives up the native macOS menu look/feel and OS-level menu behaviors.
- **Fragility:** these prefs are obscure — `native-anchored-menus` in particular is
  **undocumented** (we filed a request to document/support it; see [`BUGREPORT.md`](../../BUGREPORT.md)
  and issue #6). If Mozilla removes them, menus revert to native/unstyled. This attribute/pref
  surface is part of what [trimfox-drift](0007-trimfox-drift-monitor.md) watches.
