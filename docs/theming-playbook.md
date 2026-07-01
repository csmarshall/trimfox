# trimfox theming playbook

How to reverse-engineer and restyle Firefox chrome without guessing. This is the
method behind trimfox's harder features (pinned-tab grid, URL-bar spacing/borders,
menu theming, the combined nav button, drag-to-reorder). Read it before a tricky
change; add to it when you learn something new.

See also **`color-audit.md`** for the narrower "a surface is the wrong shade"
procedure.

---

## 0. The workflow

- **Edit the LIVE profile, test, then mirror to the repo.**
  Live file: `…/Profiles/<profile>/chrome/userChrome.css`. Edit it, **Cmd+Q +
  relaunch** to test (userChrome is parsed once at startup — no hot reload), then
  `cp -p` the live file into `~/work/trimfox/chrome/` and commit.
- **Brace-check before every commit:** `grep -o '{' file | wc -l` must equal
  `grep -o '}' …`. A mismatch = a dropped rule that fails silently.
- **Big edits via Python string-replace with a uniqueness assert**
  (`assert s.count(old)==1`) so a match is exact and unambiguous — safer than
  hand-editing a 1200-line file. Include trailing comments in `old` or the count
  breaks.
- **The chrome is USER-origin CSS.** `!important` is usually required to beat
  Firefox's own `!important` rules. Specificity alone rarely wins.

---

## 1. Read Firefox's own source (the foundational move)

Ninety percent of "what element is this / what variable feeds it / what JS moves
it" is answered by reading the shipping CSS and JS, which live in two zip
archives:

```sh
JA=/Applications/Firefox.app/Contents/Resources/browser/omni.ja   # browser chrome
TA=/Applications/Firefox.app/Contents/Resources/omni.ja           # toolkit (menus, panels)

unzip -l "$JA" | grep -iE '\.css|\.js'          # list files
unzip -p "$JA" chrome/browser/skin/classic/browser/urlbar-searchbar.css | sed -n '280,300p'
unzip -p "$JA" chrome/browser/content/browser/tabbrowser/drag-and-drop.js | grep -n 'dropIndicator'
```

High-value files:
- Tabs / sidebar: `…/browser/tabbrowser/tabs.css`, `tab.tokens.css`,
  `drag-and-drop.js`, `tabs.js`; `…/browser/sidebar/*.css`.
- URL bar: `…/browser/urlbar-searchbar.css`, `…/browser/urlbar/*.css`.
- Menus / panels: `$TA` → `chrome/toolkit/skin/classic/global/menu.css`,
  `menupopup.css`, `elements/menupopup.js`, `panel*.css`.
- Design tokens (real hex values): `$TA` →
  `chrome/toolkit/skin/classic/global/design-system/tokens-*.css`.

This is how we learned: the drag "drop index" is computed from element rects
(`drag-and-drop.js`); the macOS menu checkmark is a `menupopup[needsgutter]
::before { content:"\2713" }`; `.menu-icon` defaults to `display:none;
visibility:hidden`; the popup wraps items in a shadow `<arrowscrollbox
class="menupopup-arrowscrollbox">`; the focused urlbar reads
`--toolbar-field-background-color-focus`.

---

## 2. Inspect the live chrome (Browser Toolbox)

For anything you can't infer statically — computed values, live attributes, the
exact class Firefox stamped on a cloned node.

- Enable once (both in `user.js`): `devtools.chrome.enabled`,
  `devtools.debugger.remote-enabled`. Open with **Cmd+Opt+Shift+I**.
- **Popups that vanish when you click away:** set
  `ui.popup.disable_autohide = true`, open the popup, then switch to the toolbox.
- **Measure, don't eyeball.** Paste a JS probe into the toolbox console to read
  real numbers — this is how we solved the history-menu insets and the nav-button
  alignment. Pattern:

  ```js
  const el = document.querySelector('SELECTOR');
  const cs = getComputedStyle(el);
  JSON.stringify({ pad: cs.padding, border: cs.borderWidth,
                   rect: el.getBoundingClientRect() }, null, 2);
  ```

  Probes told us the shadow `arrowscrollbox` still had `4px` padding + `1px`
  border (`gapLeft/right = 6`) after a `::part()` rule *looked* right — see §4.

---

## 3. Render previews reliably (not qlmanage)

`qlmanage` is a flaky SVG renderer (blanks ~half in bulk; ignores a root `<svg
fill>`). For trustworthy SVG/HTML → PNG previews, use **Firefox headless**:

```sh
/Applications/Firefox.app/Contents/MacOS/firefox --headless --no-remote \
  --profile "$(mktemp -d)" --window-size 1200,760 \
  --screenshot out.png "file:///abs/path/to/page.html"
```

Used for the glyph-weight checks and the `palette.html` preview.

---

## 4. Piercing UA-widget shadow DOM

Some chrome (menupopup, arrowscrollbox, the pinned-tab container) is a UA widget
with a shadow tree. From userChrome:

- **`::part(name)` works only if the widget exports that part** — and it
  **cannot** override the widget's own internal `!important` styles. Our
  `menupopup::part(arrowscrollbox)` looked correct but never applied.
- **A direct descendant/class selector pierces the UA shadow tree** and wins:
  `.menupopup-arrowscrollbox { padding:0 !important }` fixed what `::part()`
  couldn't. Prefer the class selector when `::part()` silently no-ops.
- Some shadow content is simply **unreachable** — that's why the pinned-tab grid
  positions pins in the **light DOM** instead (§6).

---

## 5. SVG icon theming (`-moz-context-properties`)

- `-moz-context-properties: fill;` + `fill: <color>` themes an SVG icon's
  **fill** — but **not its stroke** (`stroke="context-fill"` renders blank). So
  custom glyphs must be **filled** shapes (use `fill-rule:evenodd` for hollow
  looks), never stroked.
- `currentColor` inside toolbar icons often resolves **dark** — pin an explicit
  `fill: var(--toolbar-color)` / a token instead.
- **`var()` does not resolve inside a `data:` URI.** A data-URI SVG's color is
  baked in; to make it theme-aware, provide a second copy under
  `@media (prefers-color-scheme: light)` (that's how the no-history nav dash
  flips light/dark).
- Real Firefox icons are extractable from `omni.ja` (e.g.
  `chrome://devtools/skin/images/arrowhead-*.svg`) — reuse them so custom states
  match the native look.

---

## 6. Live-reactive selectors

Firefox toggles attributes as state changes; `:has()` re-evaluates live, so you
can build reactive UI with pure CSS:

- **Combined nav button** — `#nav-bar:has(#back-button[disabled]):has(
  #forward-button[disabled])` swaps the glyph by history position; FF sets
  `[disabled]` on the buttons, `:has()` reads it, no JS.
- **Auto-hide at one tab** — `#sidebar-main:not(:has(.tabbrowser-tab ~
  .tabbrowser-tab))` (the `~` only matches with 2+ tabs).
- **Pinned-grid count** — a `:has(:nth-child(n))` ladder derives the pin count.

Gotcha: because `:has()` is live, a selector can flip **mid-drag** (a tab
detaches, sibling count drops) — keep that in mind when reorder/DnD misbehaves.

---

## 7. Case studies (condensed)

### Pinned-tab grid (auto-fitting square favicons)
- The pinned container is a UA widget whose shadow is unreachable (§4), so pins
  are positioned in the **light DOM**: `position:absolute` + computed
  `--pin-col/--pin-row` from an `:nth-child → --pin-i` ladder.
- **Live auto-fit** via a **container query**: `#tabbrowser-tabs {
  container-type: inline-size }` + a `@container` breakpoint ladder sets
  pins-per-row from the *actual* sidebar width — resize the sidebar, the grid
  reflows, no restart.
- **Gotcha:** `container-type` establishes layout containment on the whole tab
  container; we suspected (and tested) it as a drag-reorder breaker. It wasn't
  the culprit here, but containment *can* perturb geometry — scope it as tightly
  as possible.

### URL bar — spacing, borders, focus (#11)
- FF's **breakout-extend** state (on focus) shifts the field up/left and grows
  it, then the results drop below. trimfox **pins it back** to the compact box
  using FF's own live vars (`top: calc((--urlbar-toolbar-height − --urlbar-height)
  /2)`, `width: var(--urlbar-width)`, `margin-inline:auto`,
  input-container `height/padding`), letting only the panel drop.
- **`--urlbar-toolbar-height` is NOT a height lever** in FF 152 — it only feeds
  that centering `calc()`. Removing it left the calc undefined and broke the
  popup. (To actually slim the bar, use UI density / `--urlbar-min-height`.)
- The field+popup **merge** into one frame via a 1px border on
  `.urlbar-background` (a *class* in FF 152, not the old id).
- **Var-name gotcha:** the focused background is
  `--toolbar-field-background-color-focus` (suffix `-color-focus`). The
  wrong-order `--toolbar-field-focus-background-color` is a silent no-op.

### Menu theming (native → XUL, then skin it)
- macOS menus are native/un-themeable until you flip
  `widget.macos.native-context-menus=false` (right-click menus) and
  `widget.macos.native-anchored-menus=false` (urlbar dropdown + click-and-hold
  history menu — this also resolved #6).
- The cloned back/forward popup has **no id**; target the classes FF stamps on
  its items (`.unified-nav-back/-forward/-current`).
- macOS gutter checkmark = `menupopup[needsgutter] > menuitem::before {
  content:"\2713" }`; kill it to reclaim the left inset. Full-width separators
  needed piercing `.menupopup-arrowscrollbox` (§4).

### Combined nav button (#5)
- One button, glyph adapts to history state via `:has()`+`[disabled]` (§6),
  using real devtools arrowhead SVGs themed with `context-fill` (§5). The
  no-history state is a weight-matched dash (data-URI, light/dark via §5).

### Drag-to-reorder breakage (#14) — the bisection method
- Symptom: regular-tab reorder snapped back; stock Firefox worked.
- **Isolate theme vs. Firefox:** move `userChrome.css` aside (or flip
  `toolkit.legacyUserProfileCustomizations.stylesheets`) → reorder worked → it's
  our CSS.
- **Binary-cut the suspect block:** the tab/sidebar section was lines 554–1202;
  re-add in halves, restart-test each, until the culprit is one rule.
- **Root cause:** `#tabbrowser-arrowscrollbox-periphery { display:none }` removed
  the tab list's **end-of-list boundary** element; FF's `_animateTabMove`
  (`drag-and-drop.js`) reads its rect to compute the drop index, so `display:none`
  collapsed the math. Fix: collapse to zero-height-in-layout (`height:0;
  overflow:hidden; opacity:0`) instead of removing it.

---

## 8. Gotchas quick-reference

| Landmine | Reality |
|---|---|
| `gsed` not on PATH | use plain BSD `sed` on this host |
| `qlmanage` SVG render | flaky/blanks; use Firefox headless (§3) |
| `context-fill` | themes **fill only**, not stroke → use filled glyphs |
| `currentColor` on toolbar icons | resolves **dark**; pin `fill: var(--toolbar-color)` |
| `var()` in a `data:` URI | **doesn't resolve**; bake color + add a light-mode copy |
| FF 152 var names | suffix order matters: `-background-color-focus`, not `-focus-background-color` |
| `::part()` from userChrome | can't override a UA widget's internal `!important`; use a class selector |
| Cloned back/forward popup | has **no id**; target `.unified-nav-*` item classes |
| `menupopup[needsgutter]` | the macOS checkmark gutter; `::before` reserves left inset |
| `-periphery { display:none }` | removes the DnD end-of-list boundary → breaks reorder |
| `container-type` | layout containment can perturb child geometry/DnD; scope tightly |
| `theme = auto` (System) | exposes any unmapped chrome var (was masked by the Dark theme) → see `color-audit.md` |
| Testing changes | userChrome parses once at startup — **Cmd+Q + relaunch**, no hot reload |
