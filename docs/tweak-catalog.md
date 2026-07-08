<!-- Extracted from the README to keep it scannable. The full catalog of trimfox tweaks. -->

# Tweak catalog

Every change the theme makes, grouped by area. Selectors / `--tf-*` tokens are
noted where they're the handle you'd reach for. GitHub issue numbers in
parentheses point at the comment that documents the fix.

## Palette & color tokens (`--tf-*`)

The single source of truth. The **primitive tokens live in a swappable palette
file** (`chrome/palettes/grayscale.css` by default) imported at the top of
`chrome/userChrome.css`; userChrome maps those onto Firefox's own theme vars and
never hardcodes a color. Each palette carries a dark set **and** a
`@media (prefers-color-scheme: light)` set — see [Palette](../README.md#palette).

- **Surfaces** — `--tf-field` (inset URL/search boxes), `--tf-content` (page bg),
  `--tf-surface` (toolbar/sidebar/tab strip), `--tf-raised` (hover/selected),
  `--tf-select` (text + dropdown selection).
- **Accent** — `--tf-accent` / `-hover` / `-active` replace Firefox's teal on
  buttons, focus rings, checkboxes.
- **Text** — `--tf-text`, `--tf-text-dim`.
- **Lines & highlights** — `--tf-line` / `-inactive` (translucent separators),
  `--tf-line-solid` / `-inactive` (opaque form so an edge reads the same over the
  active highlight and dark tabs, #2), `--tf-highlight` / `-inactive` (active-tab
  fill).
- **Glyph & attention** — `--tf-glyph` (fixed glyph ink: nav dash, history accent
  bar, neutral container marker — bright on dark / dark on light); `--tf-attention`
  (download / update / media *attention* badges Firefox otherwise paints blue/
  green/teal — neutralized so grayscale stays zero-blue; blue in the firefox
  palette).
- **Structural (not a color, stays in userChrome)** — `--tf-sep-inset` (separator
  inline-start inset clearing the macOS frame, #2).
- **Theme-var mapping** — `--toolbar-bgcolor`, `--lwt-*`, `--sidebar-*`, the urlbar
  field backgrounds (`--toolbar-field-background-color[-focus]`, `--urlbar-box-*`),
  the `--color-accent-primary*` and `*-attention*` sets, the arrowpanel/menu
  surfaces (`--panel-background-color`, `--panel-border-color`,
  `--toolbar-background-color`, `--button-background-color-hover/-active`), and the
  urlbar-popup / autocomplete / chrome-selection highlight vars — all pointed at the
  tokens with `!important`. (These panel/field mappings close the "leak" class of
  bug — see [`docs/color-audit.md`](https://github.com/csmarshall/trimfox/blob/main/docs/color-audit.md).)
- Most lines/dividers gain a `:root:-moz-window-inactive` variant so they dim when
  the window loses focus. **Semantic colors are deliberately left unmapped** —
  security red, warning yellow, and container colors stay bold.

## Window & titlebar

- Remove the macOS native traffic-light buttons (`.titlebar-buttonbox` →
  `appearance: none`), hide the XUL `.titlebar-button` / `.titlebar-spacer`
  replacements, and shrink `.titlebar-buttonbox-container` to an 8px inset before
  Back. No window buttons at all — use Cmd+W / Cmd+Q / Cmd+M.

## Toolbar & nav buttons

- Re-icon Back/Forward with the devtools `play.svg`, flipping Back via
  `scaleX(-1)` (`#back-button` / `#forward-button`).
- Hide the bookmark star in the URL bar; Cmd+D still bookmarks (`#star-button-box`,
  #10).
- Hide the un-removable flexible space between Back/Forward and the URL bar
  (`#nav-bar #vertical-spacer`) — added flexible space to the right still works.
- Hide the sidebar toggle button (`#sidebar-button`) — expand-on-hover makes it
  redundant.

## Menus & fonts

- Chrome font is driven by two dials — **`--tf-font-family`** (`-apple-system`) +
  **`--tf-font-size`** (`7pt`, the 1.0× base) — set on `:root` and inherited (not a
  blunt `*`; popups get explicit `menupopup`/`panel` rules). Non-base sizes reproduce
  **Firefox's own proportional hierarchy** via `--tf-fs-*` tiers, toggled by
  **`--tf-fs-lift`** (`1` = full proportional, `0` = flat-ish middle path). Ratios &
  the regeneration recipe live in [`docs/font-hierarchy.md`](https://github.com/csmarshall/trimfox/blob/main/docs/font-hierarchy.md).
- Theme the (now-XUL) context/popup menus: `--tf-surface` bg, `--tf-select` hover,
  themed text/separators, trimmed padding, `min-height: 0`, 7pt (requires
  `widget.macos.native-context-menus = false`). The tight padding is scoped to the
  history popup via `:has(.unified-nav-current)` so context menus keep a comfortable
  inset.
- **Back/forward history menu** reskinned as the vertical **tab strip** (requires
  `widget.macos.native-anchored-menus = false`, which also resolves #6): current
  page = active-tab highlight + a `--tf-glyph` left accent bar; back/forward =
  inactive-tab rows; full-width separators (none under the last row); a favicon
  column; hover swaps the favicon for a themed arrowhead. Tune with the
  `--tf-hist-*` dials (see [Tuning knobs](../README.md#tuning-knobs)).
- Re-hide the searchmode-switcher placeholder glyph that the universal 7pt rule
  leaks (`.urlbar-visually-hidden`).

## URL bar

- Field background pinned to `--tf-field` for **resting, focus, and hover**
  (`--toolbar-field-background-color[-focus]`, the `--urlbar-box-background-color*`
  set) so the field stays dark regardless of the base theme — the focus background
  is otherwise unmapped and leaks a lighter gray on "System — auto". 7pt, readable
  `--tf-text` input incl. focused state; selection forced to `--tf-select` bg /
  white text (HTML-namespaced `input` selectors).
- Tab-style 1px border on `.urlbar-background` matching the tabs/sidebar; when
  results open, the border frames field + popup as one window (#11).
- **No-grow on focus**: pin the breakout-extend state back to the compact box
  using Firefox's own live vars (`--urlbar-width`, `--urlbar-height`,
  `--urlbar-toolbar-height`) so only the results panel drops below (#11).
- Hide the placeholder text, the "search with" one-offs, and the search-engine
  one-off row.
- `--urlbar-toolbar-height: 34px` — **not** a height lever; it only feeds the
  focus-centering `calc()`. Removing it breaks the focused-urlbar/results rendering
  (to actually slim the bar, lower `--urlbar-min-height` or use UI density).

## URL bar dropdown / results

- Force URLs/actions to `--tf-text-dim` gray (kills the teal accent), override
  link styling, and white text on the selected row (`--tf-select` bg).
- Compact results: trimmed block padding (with 6px breathing room under the last
  row, #11), dimmed icon fill, 7pt.
- Hide the redundant first row when it's a "search with" / "visit" item, and the
  title-separator + secondary text on row 0.
- **Kill the field↔results divider** (`--urlbarview-separator-color: transparent`)
  so the field and popup read as one seamless panel.
- **"Switch to Tab" chiclet**: themed pill (`--tf-raised` bg, `--tf-line-solid`
  border) with the tab glyph repainted via `mask` + `background-color: var(--tf-text)`
  — Firefox's `context-fill` wouldn't take our color (same quirk as the nav dash).

## Vertical-tabs reskin

- Native vertical tabs styled to the old Tree Style Tab look: compact **22px**
  rows (`--tab-min-height`), skinny **14px** collapsed strip
  (`--tab-collapsed-background-width`).
- Collapsed strip is constrained to the strip width and clipped so tabs don't
  overflow; favicons hidden **only** when collapsed (`display:none` so they
  reclaim width) → the strip becomes a stack of separator lines = a tab count.
- Expanded tabs get a 10px label inset to balance the right-side title fade.
- Flatten the tab "pill": no rounded background, margins, border, box-shadow, or
  the native inset `outline` (#3); square flush full-width rows.
- Hide tab close buttons (`display:none` so the label doesn't reflow on hover),
  the new-tab button / periphery, and the tab-list scrollbar.
- Auto-hide the entire sidebar when only one tab is open
  (`#sidebar-main:not(:has(.tabbrowser-tab ~ .tabbrowser-tab))`, live).
- `-moz-window-dragging: no-drag` so tabs read as draggable content.

## Tab separators & dividers

- Per-tab separator drawn as a 1px bottom **gradient** on `.tab-background`, inset
  from the inline-start by `--tf-sep-inset` so it clears the window frame (#2);
  opaque `--tf-line-solid` so it reads identically over active and inactive tabs.
- Active tab `.tab-background` clipped off the leftmost `--tf-sep-inset` px so the
  window-edge highlight always sits over dark background — identical left edge on
  every tab (#2).
- Unified full-width line under the toolbar via `#navigator-toolbox`
  `border-block-end` in `--tf-line-solid`.
- Kill the stray native `#tabbrowser-tabs::after` 1px line (#1).

## Sidebar & launcher

- Right divider: `#vertical-tabs` border when collapsed (constrained to strip
  width via `:has()`), `#sidebar-main` border when expanded.
- Hide the vestigial resize splitter `#sidebar-launcher-splitter` (drew a stray
  line at the top of the tab area, #1).
- Expand-on-hover flush fix: pull the overlay up 1px and draw the toolbar line as
  a box-shadow so it runs continuous (scoped to
  `#main-window[sidebar-expand-on-hover]`, #1).
- Hide the launcher icon strip without collapsing the sidebar: keep
  `.buttons-wrapper` in flow (it anchors the width) but clip to zero height /
  invisible / non-interactive, pinned to the collapsed-strip width.

## Tab states

- Active tab: flat `--tf-highlight` fill (Photon makes selected == sidebar bg,
  i.e. invisible) — `--tf-highlight-inactive` when unfocused.
- Muted tabs dimmed to `opacity: 0.5` (TST parity).
- **Loading indicator**: the native throbber (spinner/"hourglass") is hidden and
  replaced with an animated fill wash while a tab is `[busy]` — **vertical**
  (bottom→top) when collapsed, **left→right** when expanded. It's *indeterminate*
  (loops to hint "loading") because Firefox exposes only boolean `[busy]`/
  `[progress]` to CSS, not a load percentage — a real progress bar would need
  userChrome.js. Dials: `--tf-load-fill`, `--tf-load-opacity`, `--tf-load-speed`.

## Container-tab indicators (#12)

- The marker color is **dynamic** — Firefox's live `var(--identity-tab-color)`, so
  each container renders in its own color (Personal blue, Work orange, …). No
  hardcoded colors, except `toolbar`-colored containers (e.g. the Facebook Container
  add-on), which resolve to `currentColor` (white); those are pinned to `--tf-glyph`
  so they read on-theme instead of stark white (per `usercontextid`).
- **Two markers, one per mode** (so they never stack): a half-**pill** on the
  inline-start (left) edge, and the container **glyph** on the right (icon mapped
  per `usercontextid` — FF exposes no var for it). **Collapsed** shows the pill;
  **expanded** shows the glyph.
- Firefox's own native `.tab-context-line` is **hidden** (it duplicated our marker,
  and stayed white for `toolbar` containers).
- Both dim on blur. The collapsed pill is toggleable via
  `--tf-container-collapsed-flag` (`none` = clean strip).

## Pinned tabs (#13)

- Pins become **favicon-only squares** (`--tf-pin-size`, favicon
  `--tf-pin-favicon`) in a single horizontal **sliding row**: taken out of flow
  with `position:absolute` and placed by `:nth-child` step patterns →
  `--pin-col` / `--pin-row` → `left` offset (works around the unstyleable
  UA-widget shadow and missing `sibling-index()`).
- Labels / close button hidden; separators, borders and outline neutralized on
  pins; favicon centered both axes.
- Hover highlight (`--tf-select`, rounded) as you slide across; clean filled
  square on selection.
- Overflow fade: once pins exceed the viewport (~9th pin) the right edge is
  masked to signal "more, scroll right".
- The native pinned↔normal splitter re-rendered as a clean 1px full-width line
  (`#vertical-pinned-tabs-splitter`), and the gap above the first normal tab
  removed.
- Tunables: `--tf-pin-size`, `--tf-pin-favicon`, `--tf-pin-pitch`,
  `--tf-pins-per-row` (must match the `7n` patterns), `--tf-pin-row-inset`,
  `--tf-pin-area-width`.

## Drag-to-reorder (#14)

- Theme only (native FF vertical tabs already support drag-reorder): the faint
  native `.tab-drop-indicator` is re-rendered as a bold opaque `--tf-accent` bar
  with a glow. Container markers are `pointer-events:none` so they don't block the
  drag. (Mid-drag blanking, if seen, is a known upstream FF bug.)

## Findbar

- Compact find bar imported from `chrome/refined-findbar/findbar.css`.
- Collapse the findbar to zero height when not focused
  (`findbar:not(:focus-within)`).

## In-content pages (`chrome/userContent.css`)

- Dark `#1c1c1c` background on `about:blank`.
- On `about:` / `chrome:` pages: gray selection and the gray accent (the
  `--in-content-*` / `--color-accent-primary*` button, focus and form-control
  vars) replacing teal.
- Note: error pages (`about:neterror` etc.) can't be styled here — they use the
  optional AutoConfig USER_SHEET in `chrome/autoconfig/`.

## Prefs (`user.js`)

- **Enable the reskin**: `toolkit.legacyUserProfileCustomizations.stylesheets`,
  `sidebar.revamp`, `sidebar.verticalTabs`,
  `sidebar.revamp.round-content-area=false`.
- **Themeable XUL menus**: `widget.macos.native-context-menus=false` (right-click
  menus) and `widget.macos.native-anchored-menus=false` (urlbar dropdown +
  click-and-hold history menu — the latter resolves #6).
- **Color scheme follows the OS**: `browser.theme.toolbar-theme=2` /
  `content-theme=2` + `extensions.activeThemeID=default-theme@mozilla.org` (System
  — auto), so trimfox's light/dark palette tracks macOS Appearance — see
  [Light / dark](../README.md#light--dark-auto-follows-macos).
- **Behavior**: `sidebar.visibility="expand-on-hover"`, `sidebar.expandOnHover`,
  `sidebar.position_start` (left), animations off, and **instant** hover-expand
  (`...expand-on-hover.delay-duration-ms=0` / `duration-ms=0`). Empty
  `sidebar.main.tools` (launcher is CSS-hidden). `browser.tabs.inTitlebar=1` keeps the
  chrome in the title bar.
- **No hover-preview card**: `browser.tabs.hoverPreview.enabled` /
  `showThumbnails` off.
- **Compact layout**: `browser.uidensity=1`, `compactmode.show`, bookmarks toolbar
  `never`, keep window on last-tab close.
- **Content fonts**: `font.size.variable.x-western=12`, monospace `14` (chrome is
  forced to 7pt in CSS).
- **Live editing**: `devtools.chrome.enabled`, `devtools.debugger.remote-enabled`.
- **Optional personal block**: trimmed URL-bar suggestions, stripped new-tab page,
  restore previous session, and faster tooltips (`ui.tooltipDelay=300`).

