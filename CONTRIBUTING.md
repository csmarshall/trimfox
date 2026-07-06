# Contributing to trimfox

trimfox is a **macOS-first** Firefox theme. Contributions are welcome — especially
Linux/Windows ports — with a few rules that keep it maintainable.

## The one hard rule

**Don't change the look or layout on macOS.** It's built and tuned there; that's the
baseline. Any platform-specific change must be *additive* and gated so it can't touch
macOS (see below). PRs that alter the macOS look will be asked to gate their changes.

## Porting to Linux / Windows

Firefox exposes the OS to CSS via `@media (-moz-platform: …)`. Gate platform work behind
it so nothing leaks across OSes:

```css
@media (-moz-platform: windows) { /* Windows-only fixes */ }
@media (-moz-platform: linux)   { /* Linux-only fixes   */ }
@media not (-moz-platform: macos) { /* everything except macOS */ }
```

There's already a working example in `chrome/userChrome.css` (the pinned-tab row splits
behavior by `-moz-platform: macos`). Follow that shape.

Common macOS-specific assumptions to check on other platforms: the titlebar and
traffic-light window controls, window-control spacing, and font metrics.

## Screenshots are required

The maintainer only runs macOS and **cannot review a platform they can't see**. Any PR
that changes the look, and every platform report, needs **before/after screenshots**
(dark and light if relevant). A PR without them can't be verified and will stall. The PR
and issue templates ask for exactly this.

## How to test

1. Edit the files in `chrome/` (or run `./install.sh` to copy them into your profile).
2. **Fully quit** Firefox (Cmd+Q / close all windows) and relaunch — `userChrome.css`
   only loads at startup.
3. For your own personal tweaks that shouldn't be in a PR, use `user-overrides.css`
   (see the README) — it's gitignored.

## Architecture (where things go)

- **Colors** live in `chrome/palettes/*.css` (`--tf-*` tokens).
- **Structural/behavioral knobs** live in `chrome/dials.css` (`--tf-*` dials).
- `chrome/userChrome.css` only *maps* those tokens onto Firefox's own vars and styles the
  chrome — it should read `var(--tf-*)`, not hardcode values. New knobs go in `dials.css`.
- Keep braces and `/* */` comments balanced (a stray one silently breaks the theme).

## Where help is wanted

- Validate the look on **Linux** (#8) and **Windows** (#9).
- Two-finger horizontal scroll of the pinned-tab row on Linux/Windows (#17).

Thanks!
