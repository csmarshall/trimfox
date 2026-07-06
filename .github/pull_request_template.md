<!-- Thanks for contributing to trimfox! Fill this in — especially screenshots. -->

## What & why

<!-- One or two lines. Link an issue if there is one, e.g. "Fixes #8". -->

## Platform

- OS + version:
- Firefox version:
- [ ] This is a **platform port/fix** (Linux / Windows)

## Screenshots

<!--
REQUIRED for anything that changes the look. Before + after, dark and light if relevant.
Platform PRs CANNOT be reviewed without them — Firefox here is only run/tested on macOS,
so Linux/Windows changes can't be verified visually without them. Drag images into this box.
-->

**Before:**

**After:**

## Checklist

- [ ] Does **not** change the look or layout on **macOS** (hard rule).
- [ ] Any platform-specific CSS is gated behind `@media (-moz-platform: …)` so it can't
      leak onto other OSes.
- [ ] New knobs (if any) go through the `--tf-*` dials in `chrome/dials.css`, not hardcoded.
- [ ] Braces/comments balanced; tested by fully quitting Firefox and relaunching.
