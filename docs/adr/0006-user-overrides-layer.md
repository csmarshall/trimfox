# ADR-0006 — `user-overrides` layer: customize without forking

- **Status:** Accepted
- **Date:** 2026-07 (this consolidation)

## Context

Users will want their own colors, dials, and prefs. If they edit the committed files to get
them, every `git pull` — including the eventual Firefox **Nova** re-map — becomes a merge
conflict. That friction is exactly what keeps personal setups scattered and unmaintainable
([ADR-0001](0001-design-philosophy.md)).

## Decision

Two **gitignored, user-owned** override files, loaded/applied **last** so they win with plain
declarations (no `!important`):

- **`chrome/user-overrides.css`** — colors and dials, `@import`ed *after* the palette in
  `userChrome.css`, so source order makes them the final word.
- **`user-overrides.js`** — prefs, appended *after* trimfox's in the profile's `user.js`.

The installer seeds both from `*.example` templates and preserves them across re-installs.

## Consequences

- **Positive:** users customize — or swap to a whole different palette — **without touching
  tracked files**; `git pull` updates the theme underneath while personal settings persist; no
  fork, no hand-merge. The `--tf-*` names ([ADR-0005](0005-tf-token-palette-architecture.md))
  are the stable surface they override against.
- **Trade-off:** two more files/concepts to explain (the README disambiguates prefs vs
  colors/dials); it relies on **CSS source order** (overrides imported last) rather than
  specificity — correct, but a subtlety a contributor has to know.
