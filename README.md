# trimfox

A minimal Firefox `userChrome` setup built around **native vertical tabs** — no
Tree Style Tab, no sidebar extension, just the browser's own chrome restyled to
get out of the way.

The headline is the tab strip: collapsed, it's a skinny ~14px column of separator
lines that just tells you how many tabs are open; hover it and it expands to
readable labels. No favicons when collapsed, no pills, no close buttons, no
new-tab button, no hover-preview cards, no launcher clutter.

It's called *trimfox* because that's the point — trim everything that isn't a tab.

> **Heads up — this is opinionated.** trimfox collapses Back + Forward into a *single*,
> history-aware nav button (the old unified-back/forward look): a **‹** chevron when only
> back is available, a **›** when only forward is, and a **⌄** down-chevron in between (a
> hint the history menu is a right-click away). Left-click navigates; the other direction
> and full history are on **right-click** (or the keyboard — `Cmd+[` / `Cmd+]`). If you rely
> on always-visible **separate Back and Forward buttons**, or you don't reach for
> keyboard/right-click navigation, trimfox probably isn't for you.

## Requirements

- **Firefox 136+** (native vertical tabs); developed and verified on **152**.
- **macOS.** Built and tuned on macOS only — see [Platform support](#platform-support).
- A dark setup: the palette is a neutral grayscale (see `palette.html`) and the
  separators/dividers assume a dark sidebar.

## Install

```sh
git clone https://github.com/csmarshall/trimfox.git
cd trimfox
./install.sh            # auto-detects your default profile
# or target one explicitly / preview first:
./install.sh -p "/path/to/profile"
./install.sh -n         # dry run
```

The installer copies `chrome/` and `user.js` into your profile, **backing up**
anything it replaces (`<name>.bak-<timestamp>`). Then **fully quit Firefox**
(Cmd+Q / close all windows) and relaunch — `userChrome.css` and `user.js` only
load at startup.

To revert: restore the `.bak-*` files (or delete `chrome/` and `user.js`) and
restart.

## What's in here

```
chrome/
  userChrome.css        the bulk — vertical-tab reskin + urlbar/findbar tweaks
  userContent.css       in-content page tweaks
  refined-findbar/      compact find bar
  autoconfig/           optional: AutoConfig installer for error-page accent color
user.js                 prefs that enable/shape native vertical tabs (see below)
install.sh              copy-with-backup installer
reference/              how this was migrated off Tree Style Tab (not installed)
```

`user.js` is the behavioral half — it enables `sidebar.verticalTabs`, sets
collapse + instant expand-on-hover, kills the tab hover-preview card, etc. Every
pref is commented. `chrome/userChrome.css` is the visual half.

## Tweak catalog

Every change the theme makes, grouped by area. Selectors / `--tf-*` tokens are
noted where they're the handle you'd reach for. GitHub issue numbers in
parentheses point at the comment that documents the fix.

### Palette & color tokens (`--tf-*`)

The single source of truth: a neutral, zero-blue grayscale defined once in
`:root` (`chrome/userChrome.css`), then mapped onto Firefox's own theme vars.

- **Surfaces** — `--tf-field` (inset URL/search boxes), `--tf-content` (page bg),
  `--tf-surface` (toolbar/sidebar/tab strip), `--tf-raised` (hover/selected),
  `--tf-select` (text + dropdown selection).
- **Accent** — `--tf-accent` / `-hover` / `-active` replace Firefox's teal on
  buttons, focus rings, checkboxes.
- **Text** — `--tf-text`, `--tf-text-dim`.
- **Lines & highlights** — `--tf-line` / `-inactive` (translucent separators),
  `--tf-line-solid` / `-inactive` (opaque form so an edge reads the same over the
  active highlight and dark tabs, #2), `--tf-sep-inset` (separator inline-start
  inset clearing the macOS frame, #2), `--tf-highlight` / `-inactive` (active-tab
  fill).
- **Theme-var mapping** — `--toolbar-bgcolor`, `--lwt-*`, `--sidebar-*`,
  `--urlbar-box-bgcolor`, the `--color-accent-primary*` set, the urlbar-popup /
  autocomplete / chrome-selection highlight vars — all pointed at the tokens with
  `!important`.
- Most lines/dividers gain a `:root:-moz-window-inactive` variant so they dim when
  the window loses focus.

### Window & titlebar

- Remove the macOS native traffic-light buttons (`.titlebar-buttonbox` →
  `appearance: none`), hide the XUL `.titlebar-button` / `.titlebar-spacer`
  replacements, and shrink `.titlebar-buttonbox-container` to an 8px inset before
  Back. No window buttons at all — use Cmd+W / Cmd+Q / Cmd+M.

### Toolbar & nav buttons

- Re-icon Back/Forward with the devtools `play.svg`, flipping Back via
  `scaleX(-1)` (`#back-button` / `#forward-button`).
- Hide the bookmark star in the URL bar; Cmd+D still bookmarks (`#star-button-box`,
  #10).
- Hide the un-removable flexible space between Back/Forward and the URL bar
  (`#nav-bar #vertical-spacer`) — added flexible space to the right still works.
- Hide the sidebar toggle button (`#sidebar-button`) — expand-on-hover makes it
  redundant.

### Menus & fonts

- Force the whole chrome to **7pt `-apple-system`** (`* { font-size: 7pt }`).
- Compact menu-popup rows: trimmed padding, `min-height: 0`, 7pt text on
  `menupopup` and all descendants (requires `widget.macos.native-context-menus =
  false` — XUL menus only).
- Re-hide the searchmode-switcher placeholder glyph that the universal 7pt rule
  leaks (`.urlbar-visually-hidden`).

### URL bar

- Field background `--tf-surface`, 7pt, readable `--tf-text` input incl. focused
  state; selection forced to `--tf-select` bg / white text (HTML-namespaced
  `input` selectors).
- Tab-style 1px border on `.urlbar-background` matching the tabs/sidebar; when
  results open, the border frames field + popup as one window (#11).
- **No-grow on focus**: pin the breakout-extend state back to the compact box
  using Firefox's own live vars (`--urlbar-width`, `--urlbar-height`,
  `--urlbar-toolbar-height`) so only the results panel drops below (#11).
- Hide the placeholder text, the "search with" one-offs, and the search-engine
  one-off row.
- Megabar height fix (`--urlbar-toolbar-height: 34px`).

### URL bar dropdown / results

- Force URLs/actions to `--tf-text-dim` gray (kills the teal accent), override
  link styling, and white text on the selected row (`--tf-select` bg).
- Compact results: trimmed block padding (with 6px breathing room under the last
  row, #11), dimmed icon fill, 7pt.
- Hide the redundant first row when it's a "search with" / "visit" item, and the
  title-separator + secondary text on row 0.

### Vertical-tabs reskin

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

### Tab separators & dividers

- Per-tab separator drawn as a 1px bottom **gradient** on `.tab-background`, inset
  from the inline-start by `--tf-sep-inset` so it clears the window frame (#2);
  opaque `--tf-line-solid` so it reads identically over active and inactive tabs.
- Active tab `.tab-background` clipped off the leftmost `--tf-sep-inset` px so the
  window-edge highlight always sits over dark background — identical left edge on
  every tab (#2).
- Unified full-width line under the toolbar via `#navigator-toolbox`
  `border-block-end` in `--tf-line-solid`.
- Kill the stray native `#tabbrowser-tabs::after` 1px line (#1).

### Sidebar & launcher

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

### Tab states

- Active tab: flat `--tf-highlight` fill (Photon makes selected == sidebar bg,
  i.e. invisible) — `--tf-highlight-inactive` when unfocused.
- Muted tabs dimmed to `opacity: 0.5` (TST parity).

### Container-tab indicators (#12)

- A **dynamic** container-color line down the inline-start edge in both states,
  using Firefox's live `var(--identity-tab-color)` — no hardcoded colors.
- Expanded tabs also get the container **glyph** inset on the right, color-masked
  to the container color (icon mapped per `usercontextid`: Personal / Work /
  Banking / Shopping / Facebook, since FF exposes no var for the icon).
- Collapsed strip shows only the line (glyph hidden); the line itself is
  toggleable via `--tf-container-collapsed-flag` (`none` = clean strip). Both dim
  on blur.

### Pinned tabs (#13)

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

### Drag-to-reorder (#14)

- Theme only (native FF vertical tabs already support drag-reorder): the faint
  native `.tab-drop-indicator` is re-rendered as a bold opaque `--tf-accent` bar
  with a glow. Container markers are `pointer-events:none` so they don't block the
  drag. (Mid-drag blanking, if seen, is a known upstream FF bug.)

### Findbar

- Compact find bar imported from `chrome/refined-findbar/findbar.css`.
- Collapse the findbar to zero height when not focused
  (`findbar:not(:focus-within)`).

### In-content pages (`chrome/userContent.css`)

- Dark `#1c1c1c` background on `about:blank`.
- On `about:` / `chrome:` pages: gray selection and the gray accent (the
  `--in-content-*` / `--color-accent-primary*` button, focus and form-control
  vars) replacing teal.
- Note: error pages (`about:neterror` etc.) can't be styled here — they use the
  optional AutoConfig USER_SHEET in `chrome/autoconfig/`.

### Prefs (`user.js`)

- **Enable the reskin**: `toolkit.legacyUserProfileCustomizations.stylesheets`,
  `sidebar.revamp`, `sidebar.verticalTabs`,
  `sidebar.revamp.round-content-area=false`.
- **Behavior**: `sidebar.visibility="expand-on-hover"`, `sidebar.expandOnHover`,
  `sidebar.position_start` (left), animations off, and **instant** hover-expand
  (`...expand-on-hover.delay-duration-ms=0` / `duration-ms=0`). Empty
  `sidebar.main.tools` (launcher is CSS-hidden).
- **No hover-preview card**: `browser.tabs.hoverPreview.enabled` /
  `showThumbnails` off.
- **Compact layout**: `browser.uidensity=1`, `compactmode.show`, bookmarks toolbar
  `never`, keep window on last-tab close.
- **Content fonts**: `font.size.variable.x-western=12`, monospace `14` (chrome is
  forced to 7pt in CSS).
- **Live editing**: `devtools.chrome.enabled`, `devtools.debugger.remote-enabled`.
- **Optional personal block**: trimmed URL-bar suggestions, stripped new-tab page,
  restore previous session, and faster tooltips (`ui.tooltipDelay=300`).

## Tuning knobs

Most of the look is driven from a few spots near the top of the vertical-tabs
section in `chrome/userChrome.css`:

| Knob | What it controls |
|------|------------------|
| `--tab-collapsed-background-width` | collapsed strip width (default `14px`) |
| `--tab-min-height` | row height (default `22px`) |
| `.tabbrowser-tab` `border-bottom` alpha | separator brightness |
| `.tab-background` selected `background-color` | active-tab highlight |
| `#sidebar-main` / `#vertical-tabs` `border-inline-end` | right divider color |

The divider and separators use `:-moz-window-inactive` so they dim when the
window loses focus, matching the rest of the themed chrome.

## Palette

All colors are neutral-grayscale `--tf-*` tokens defined once at the top of
`chrome/userChrome.css` (`:root`), with Firefox's own theme variables mapped onto
them — so there's a single place to change any color. Open **`palette.html`** in a
browser for a visual swatch reference and the token vocabulary: `field`,
`content`, `surface`, `raised`, `select`, `accent`, `text`, `text-dim`, `line`,
`highlight`.

The accent (`--tf-accent`) replaces Firefox's default teal on buttons, focus
rings and checkboxes — in the chrome, on `about:` pages (`userContent.css`), and
on privileged error pages (the optional AutoConfig in `chrome/autoconfig/`).

## reference/

`reference/` documents the migration *off* Tree Style Tab — the exported TST
user stylesheet and config that the native setup was modeled on. It's a record,
not something you install.

## Platform support

Built and tuned on **macOS only** (Firefox 152). It likely works on Windows and
Linux with tweaks, but a couple of things are macOS-specific and untested
elsewhere:

- layout/spacing assumes the macOS titlebar and traffic-light window controls;
- `install.sh` profile auto-detection includes the Linux path but is only
  verified on macOS.

**PRs for other platforms are very welcome** — with one hard rule: **they must not
change the look or layout on macOS.** Gate any platform-specific differences behind
the right selectors (e.g. `@media (-moz-platform: windows)` /
`:root[platform="linux"]`) or separate files, so the macOS default stays exactly
as-is.

### 🙋 Volunteers wanted (Linux / Windows testing)

trimfox is built and tuned on macOS only, so a handful of things genuinely need
eyes on other platforms. Anything that needs other-OS or other-hardware testing is
tagged **[`user-testing`](https://github.com/csmarshall/trimfox/labels/user-testing)**
— currently:

- **Validate the overall look on Linux** (issue #8) and **Windows** (#9).
- **Confirm the pinned-tab row's two-finger / horizontal scroll** works off macOS
  (#17). On macOS the pinned row is a single sliding row; elsewhere it wraps to
  rows as a fallback — if scroll works on your platform, we can switch it to slide.

You don't need to write a fix — just run it, try the thing, and report back (a
screenshot or even a plain "works / doesn't" is genuinely useful). Grab a
[`user-testing` issue](https://github.com/csmarshall/trimfox/labels/user-testing)
and comment.

## License

MIT — see [LICENSE](LICENSE).
