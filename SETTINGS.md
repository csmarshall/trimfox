# trimfox — full settings catalog

Everything non-default that shapes this setup, and how each piece is applied.
There are three layers:

1. **`user.js`** — preferences, applied automatically by `install.sh`.
2. **`chrome/userChrome.css` + `userContent.css`** — the visual look, applied automatically.
3. **Customize Toolbar (manual)** — toolbar button layout, which can't be safely
   auto-applied (it lives in `browser.uiCustomization.state`, per-profile).

---

## 1. Preferences (`user.js`, applied automatically)

| Pref | Value | Effect |
|------|-------|--------|
| `toolkit.legacyUserProfileCustomizations.stylesheets` | `true` | **Required** — lets `userChrome.css` load |
| `sidebar.revamp` / `sidebar.verticalTabs` | `true` | native vertical tabs |
| `sidebar.visibility` | `expand-on-hover` | collapse to a strip, expand on hover |
| `sidebar.expandOnHover` | `true` | hover behavior |
| `sidebar.animation.enabled` | `false` | no slide animation |
| `sidebar.animation.expand-on-hover.delay-duration-ms` / `.duration-ms` | `0` | instant expand |
| `sidebar.revamp.round-content-area` | `false` | drop the rounded inset gutter |
| `sidebar.position_start` | `true` | sidebar on the left |
| `sidebar.main.tools` | `""` | empty — launcher is hidden in CSS anyway |
| `browser.tabs.hoverPreview.enabled` / `.showThumbnails` | `false` | no tab hover-preview card |
| `browser.uidensity` | `1` | **compact** density |
| `browser.compactmode.show` | `true` | exposes the Compact option in Settings |
| `browser.toolbars.bookmarks.visibility` | `never` | no bookmarks toolbar |
| `browser.tabs.closeWindowWithLastTab` | `false` | closing the last tab keeps the window |
| `font.size.variable.x-western` / `.monospace.x-western` | `12` / `14` | default content fonts (chrome is 7pt via CSS) |
| `devtools.chrome.enabled` / `devtools.debugger.remote-enabled` | `true` | enables the Browser Toolbox for live `userChrome` editing |

**Optional personal block** (delete from `user.js` if you only want the look):
minimal URL bar (`browser.urlbar.suggest.*` off, `openViewOnFocus` off,
`groupLabels` off) and a stripped new-tab page (`browser.newtabpage.enabled`
off, `browser.startup.page = 3` to restore the session, topsites/search/weather off).

---

## 2. Visual features (`chrome/userChrome.css`)

Non-obvious things the stylesheet does — all driven by the `--tf-*` palette tokens
(see `palette.html`):

- **7pt chrome font** everywhere (`* { font-size: 7pt }`).
- **Vertical tabs reskin:** ~14px collapsed strip (`--tab-collapsed-background-width`),
  22px rows (`--tab-min-height`), favicons hidden when collapsed, flat tabs (no
  pills), separators between tabs.
- **Tab bar framed** with `line`-colored dividers on its **top and right**, in both
  collapsed and expanded states; dividers/separators dim on window blur
  (`:-moz-window-inactive`).
- **Auto-hide the sidebar when only one tab is open** (`:has()`), reappears at 2+.
- **Hidden chrome:** the launcher tool strip, new-tab `+` button, per-tab close
  buttons, the toolbar sidebar-toggle button, and the un-removable nav-bar
  flexible space (`#vertical-spacer`).
- **Tab hover-preview / scrollbar** removed from the strip.
- **Compact menu rows** — `padding-block: 1px; min-height: 0` on menu items, so
  dropdowns (e.g. the back/forward history menu) aren't tall.
- **Neutral-gray accent** replacing Firefox's teal on buttons/focus, in chrome and
  in-content (`userContent.css`); error pages handled by the optional
  `chrome/autoconfig/` AutoConfig.

---

## 3. Manual steps (Customize Toolbar)

These can't ride along in `user.js`/`userChrome.css` cleanly — do them once after
installing (right-click the toolbar → **Customize Toolbar**):

1. **Remove the buttons you don't want** from the toolbar (drag them to the
   palette). The minimal nav-bar here is essentially just back/forward + the URL
   bar. Note Firefox **won't let you remove** the sidebar-toggle button or the
   flexible space — those are hidden via CSS instead (already handled).
2. **Density:** the `browser.uidensity` pref sets Compact automatically, but you
   can confirm via the **Density** dropdown at the bottom of Customize Toolbar.
3. The **bookmarks toolbar** is set to *never* by `user.js`; no action needed.

> If you re-open Customize Toolbar and the horizontal tab strip momentarily
> reappears, just click **Done** and restart — it's a known quirk with vertical
> tabs, not a misconfiguration.

---

## 4. Extensions

**None are required for the look** — it's pure `userChrome.css` on native vertical
tabs (this setup was migrated *off* Tree Style Tab; see `reference/`). The custom
theme colors used to live in the **Firefox Color** extension, but they're now baked
into `userChrome.css` as the `--tf-*` palette, so that extension isn't needed
either.
