# trimfox — full settings catalog

Everything non-default that shapes this setup, and how each piece is applied.
There are three layers:

1. **`user.js`** — preferences, applied automatically by `install.sh`.
2. **`chrome/userChrome.css` + `userContent.css`** — the visual look, applied automatically.
3. **Customize Toolbar (manual)** — toolbar button layout, which can't be safely
   auto-applied (it lives in `browser.uiCustomization.state`, per-profile).

---

## 1. Preferences (`user.js`)

> **How install handles prefs.** `install.sh` **replaces** your profile's `user.js`
> with trimfox's (your old one is backed up to `user.js.bak-<timestamp>`), then
> **appends `user-overrides.js`** — a gitignored file for your own prefs that survives
> every update (Firefox uses the *last* value seen for a pref, so yours win). Copy
> `user-overrides.example.js` → `user-overrides.js` and put personal prefs there;
> migrating from your own `user.js` means copying the prefs you want to keep out of the
> backup and into it.

Every pref trimfox sets, with its Firefox default:

### Required — the theme won't work without these

| Pref | trimfox | FF default | Effect |
|------|---------|------------|--------|
| `toolkit.legacyUserProfileCustomizations.stylesheets` | `true` | `false` | lets `userChrome.css` / `userContent.css` load at all |
| `sidebar.revamp` | `true` | `false` | revamped sidebar that hosts native vertical tabs |
| `sidebar.verticalTabs` | `true` | `false` | tab strip goes vertical |
| `sidebar.revamp.round-content-area` | `false` | `true` | drop the rounded inset gutter |

### Appearance & color

| Pref | trimfox | FF default | Effect |
|------|---------|------------|--------|
| `widget.macos.native-context-menus` | `false` | `true` | right-click menus → themeable XUL |
| `widget.macos.native-anchored-menus` | `false` | `true` | urlbar dropdown + click-and-hold history menu → themeable XUL |
| `browser.theme.toolbar-theme` | `2` | `2` (auto) | chrome scheme follows the OS (asserted so light/dark auto-switches) |
| `browser.theme.content-theme` | `2` | `2` (auto) | in-content scheme follows the OS |
| `extensions.activeThemeID` | `default-theme@mozilla.org` | (same) | "System theme — auto"; a hardcoded Dark/Light theme would pin the scheme |
| `ui.highlight` | `#919093` | OS-derived | native selection/highlight stays grayscale (one mode-agnostic gray) |
| `browser.tabs.inTitlebar` | `1` | `-1` (auto) | tabs/chrome integrate with the titlebar |
| `browser.uidensity` | `1` | `0` | compact density |
| `browser.compactmode.show` | `true` | `false` | re-expose the Compact option in Settings |
| `layout.css.prefers-color-scheme.content-override` | *(commented out)* | `2` (auto) | optional — force web content dark regardless of the OS |

### Behavior

| Pref | trimfox | FF default | Effect |
|------|---------|------------|--------|
| `sidebar.visibility` | `expand-on-hover` | `always-show` | collapse to a strip, expand on hover |
| `sidebar.expandOnHover` | `true` | `true` | assert hover-expand |
| `sidebar.position_start` | `true` | `true` | sidebar on the left |
| `sidebar.animation.enabled` | `false` | `true` | no slide animation |
| `sidebar.animation.expand-on-hover.delay-duration-ms` | `0` | `200` | hover-expand fires instantly |
| `sidebar.animation.expand-on-hover.duration-ms` | `0` | `400` | no expand slide |
| `sidebar.main.tools` | `""` | `""` | empty launcher list (hidden in CSS anyway) |
| `browser.tabs.hoverPreview.enabled` | `false` | `true` | kill the tab hover-preview card |
| `browser.tabs.hoverPreview.showThumbnails` | `false` | `true` | no thumbnails in that card |
| `browser.toolbars.bookmarks.visibility` | `never` | `newtab` | no bookmarks toolbar |
| `browser.tabs.closeWindowWithLastTab` | `false` | `true` | closing the last tab keeps the window |
| `font.size.variable.x-western` | `12` | `16` | default web-page proportional font (chrome is 7pt via CSS) |
| `font.size.monospace.x-western` | `14` | `13` | default web-page monospace font |
| `devtools.chrome.enabled` | `true` | `false` | Browser Toolbox for live `userChrome` editing (maintainer convenience) |
| `devtools.debugger.remote-enabled` | `true` | `false` | required by the Browser Toolbox |

### Optional — personal (safe to delete; not part of the look)

A minimal URL bar and a stripped new-tab page.

| Pref | trimfox | FF default | Effect |
|------|---------|------------|--------|
| `browser.urlbar.suggest.engines` | `false` | `true` | no search-engine suggestions |
| `browser.urlbar.suggest.quickactions` | `false` | `true` | no quick-action suggestions |
| `browser.urlbar.suggest.quicksuggest.nonsponsored` | `false` | `false` | assert Firefox Suggest off |
| `browser.urlbar.suggest.quicksuggest.sponsored` | `false` | `false` | assert sponsored suggest off |
| `browser.urlbar.suggest.recentsearches` | `false` | `true` | no recent-searches suggestions |
| `browser.urlbar.suggest.topsites` | `false` | `true` | no top-sites on empty focus |
| `browser.urlbar.showSearchSuggestionsFirst` | `false` | `true` | history ranked before search suggestions |
| `browser.urlbar.openViewOnFocus` | `false` | `false` | assert: no dropdown on focus |
| `browser.urlbar.groupLabels.enabled` | `false` | `true` | no "Firefox Suggest" group headers |
| `browser.startup.page` | `3` | `1` | restore the previous session |
| `browser.newtabpage.enabled` | `false` | `true` | blank new-tab page |
| `browser.newtabpage.activity-stream.feeds.topsites` | `false` | `true` | no top-sites tiles |
| `browser.newtabpage.activity-stream.showSearch` | `false` | `true` | no new-tab search box |
| `browser.newtabpage.activity-stream.showWeather` | `false` | `true` | no new-tab weather |
| `ui.tooltipDelay` | `300` | `500` | faster tooltips |

### AutoConfig — only if you run `chrome/autoconfig/install-neterror-accent.sh`

Opt-in; writes into the Firefox.app bundle to theme error pages (see that script + the
README "skin the error pages too" section).

| Pref | value | FF default | Effect |
|------|-------|------------|--------|
| `general.config.filename` | `firefox.cfg` | *(unset)* | enables AutoConfig |
| `general.config.obscure_value` | `0` | `13` | read the `.cfg` as plaintext |
| `general.config.sandbox_enabled` | `false` | `true` | run the `.cfg` with full chrome privileges (sandbox off) |

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

## Note — the history menu is now themeable

The **back/forward history menu** (click-and-hold Back/Forward) used to be an
unstyleable native macOS menu. That's now fixed: `widget.macos.native-anchored-menus=false`
turns it (and the urlbar dropdown) into themeable XUL, and trimfox reskins it as a
tab strip. Right-click context menus, the URL bar, and all other chrome are styled
normally.

## 4. Extensions

**None are required for the look** — it's pure `userChrome.css` on native vertical
tabs (this setup was migrated *off* Tree Style Tab; see `reference/`). The custom
theme colors used to live in the **Firefox Color** extension, but they're now baked
into `userChrome.css` as the `--tf-*` palette, so that extension isn't needed
either.
