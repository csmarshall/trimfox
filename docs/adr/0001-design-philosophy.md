# ADR-0001 — Design philosophy: slim, get-out-of-the-way chrome for the experienced userChrome user

- **Status:** Accepted
- **Date:** 2026-07-08

## Context

Firefox's default chrome is, correctly, a **general-purpose** UI. Its padding, spacing,
affordances, and discoverability are tuned to serve the entire spectrum of users — from
someone opening a browser for the first time to a daily power user. Generous hit targets,
always-visible buttons, and roomy spacing are the right defaults for a mass-market browser.

For a user who has been writing **`userChrome.css` since its early days**, that same
generality is friction: wasted horizontal and vertical space, redundant affordances, and
visual weight an experienced user doesn't need and would rather reclaim.

People like this have typically accumulated **years of hand-tuned `about:config` and
userChrome tweaks** — but that work tends to stay **scattered and personal**: never unified,
never centralized, never versioned or documented, and painful to carry across Firefox updates.
Not for lack of effort, but for lack of a **harness** — there was no structured token system,
no clean override layer, no way to track Firefox's churning private-chrome internals, and no
packaging to make it shareable.

## Decision

trimfox's north star: **keep it simple and clean, cut UI padding and weight, and make the
chrome slim and get-out-of-the-way.** Optimize for the **experienced userChrome user**, not
the general audience Firefox rightly designs for. Every chrome element earns its space or is
trimmed.

Equally central: **consolidate** those years of scattered personal tweaks into **one unified,
maintainable, documented, distributable project** — and build the harness that was missing:
the `--tf-*` token system, the palette / dials / `user-overrides` layering, an installer, and
[trimfox-drift](https://github.com/csmarshall/trimfox-drift) to catch Firefox's private-chrome
drift before it breaks anything.

This philosophy is the **lens for every other ADR**: when a call is ambiguous, *slimmer,
quieter, gets-out-of-the-way, power-user-first* wins.

## Consequences

- **Positive:** a coherent, opinionated, slim theme; years of tribal knowledge centralized into
  something maintainable and shareable; decisions recorded rather than re-derived each time.
- **Trade-off — opinionated, not for everyone.** Being slim means removing affordances and
  discoverability a general user relies on (always-visible buttons, roomy targets) and assuming
  keyboard / right-click fluency. This is deliberate; the README's **"Heads up"** states it
  plainly so no one installs it expecting Firefox-default ergonomics.
- **Ongoing cost:** a slim theme that reaches deep into Firefox's *private* chrome must be
  **maintained** as Firefox changes — which is why the harness (drift monitoring) is part of
  this decision, not an afterthought. See [ADR-0008](0008-trimfox-drift-monitor.md).
