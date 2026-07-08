<!-- Extracted from the README to keep it scannable. How light/dark switching works + setup. -->

# Light / dark (auto-follows macOS)

Each palette carries a dark set plus an `@media (prefers-color-scheme: light)` set, so trimfox
switches with your **macOS Appearance** (System Settings → Appearance). No restart once it's
wired — flip the OS and the chrome follows.

**One-time setup — Firefox's chrome scheme is driven by its active *theme*, not by macOS
directly.** A built-in **Dark** or **Light** theme hardcodes the scheme and *pins* the palette;
you need **System theme — auto** so the chrome tracks the OS. trimfox's `user.js` sets
`browser.theme.toolbar-theme` / `content-theme` to `2` (auto) and `extensions.activeThemeID` to
`default-theme@mozilla.org`, but the **Add-ons Manager owns the active theme and often wins over
the pref**. If light mode doesn't engage:

> Open **`about:addons` → Themes** and switch to **"System theme — auto".** If it's already
> selected but stuck, toggle to any other theme and back — that forces the Add-ons Manager to
> re-apply *auto* (the pref alone may not take).

(trimfox overrides every chrome color regardless, so the theme choice only controls *which*
light/dark palette engages — not the look otherwise.)

> **Note:** `--tf-glyph` can't reach into `data:` SVG icons (CSS `var()` doesn't resolve inside a
> data URI), so the no-history nav-button dash bakes its color in. It ships a light-gray dash
> plus a dark-gray copy swapped in under `@media (prefers-color-scheme: light)` — so a *custom*
> palette that flips light/dark differently would need the same one-line media override.
