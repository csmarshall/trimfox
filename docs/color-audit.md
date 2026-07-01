# Color-leak audit — how to find chrome colors trimfox isn't overriding

Use this when a chrome surface suddenly looks the *wrong shade* (usually a stray
light gray on dark) — e.g. the focused URL bar going gray, a button hover, a
panel edge. It's almost always the **same class of bug**, described below.

## Why leaks happen

trimfox doesn't paint the chrome directly. It maps **Firefox's own theme
variables** (`--toolbar-*`, `--urlbar-*`, `--lwt-*`, `--tab-*`, `--panel-*`, …)
onto its `--tf-*` tokens, in the `:root` block near the top of
`chrome/userChrome.css`. A chrome element that reads a FF variable trimfox
**doesn't map** falls through to whatever the **active base theme** sets.

The trap: trimfox now ships on **"System theme — auto"** (`default-theme@mozilla.org`)
so light/dark can follow macOS. Under the *old* built-in **Dark** theme, unmapped
vars fell back to **dark** defaults — so gaps were invisible. Under **auto**, the
same gaps fall back to the auto theme's defaults, whose dark side is often a
**lighter gray** → the leak becomes visible.

> **Rule of thumb:** every leak is a FF variable used for a `background-color`,
> `border-color`, or `fill` on a visible surface that trimfox's `:root` doesn't
> map. Find the variable, add one mapping line, done.

## The 5-minute recipe

**1. Identify the leaking element's variable.** Two ways:

- *Live (most reliable)* — open the **Browser Toolbox** (Cmd+Opt+Shift+I; needs
  `devtools.chrome.enabled` + `devtools.debugger.remote-enabled`, both in
  `user.js`). Inspect the element, read its computed `background-color` /
  `border-color`, and in the Rules pane find which `var(--…)` feeds it. For
  popups that vanish, set `ui.popup.disable_autohide = true` first.

- *Static* — grep Firefox's own CSS for what paints that element. The chrome CSS
  is inside two archives; read with `unzip -p`:

  ```sh
  JA=/Applications/Firefox.app/Contents/Resources/browser/omni.ja
  # list the chrome CSS files
  unzip -l "$JA" | grep -iE '\.css'
  # find the rule that colors an element (example: the urlbar pill)
  unzip -p "$JA" chrome/browser/skin/classic/browser/urlbar-searchbar.css \
    | grep -niE '\.urlbar-background|background-color:'
  ```

  Key skin files: `browser.css`, `toolbarbutton.css`, `urlbar-searchbar.css`,
  `urlbar/*.css`, `tabbrowser/*.css`, `sidebar/*.css`, `menupanel.css`;
  and in `…/Resources/omni.ja`: `chrome/toolkit/skin/classic/global/menu.css`,
  `menupopup.css`, `panel*.css`.

  **Watch the exact variable name** — FF 152 uses the suffix pattern
  `--toolbar-field-background-color-focus` (color-*focus*), **not**
  `--toolbar-field-focus-background-color`. A wrong-order name is a silent no-op.
  This is exactly what bit the urlbar-focus fix the first time.

**2. Check whether trimfox already maps it.**

```sh
SRC="$HOME/work/trimfox/chrome/userChrome.css"   # or the live profile copy
grep -c -- "--toolbar-field-background-color-focus" "$SRC"   # 0 = leak
```

**3. Add the mapping** in the `:root` "Map Firefox theme vars onto the tokens"
block. Pick the token by role:

| surface / role                    | token             |
|-----------------------------------|-------------------|
| chrome (toolbar, sidebar, strip)  | `--tf-surface`    |
| inset field (urlbar, search box)  | `--tf-field`      |
| hover / selected / raised         | `--tf-raised`     |
| selection (dropdown row, hilite)  | `--tf-select`     |
| separators / borders              | `--tf-line-solid` |
| accent (buttons, focus, checkbox) | `--tf-accent`     |
| attention badge (dl, update dot)  | `--tf-attention`  |

```css
--toolbar-field-background-color-focus: var(--tf-field) !important;
```

**4. Verify:** brace-check (`grep -o '{' … | wc -l` == `}`), `cp -p` to the repo,
Cmd+Q + relaunch, confirm the shade.

## Leave these alone (semantic, not decorative)

Do **not** map these to a neutral token — they carry meaning and should stay bold:

- security **red** (unsafe site, permission-denied, cert errors)
- warning **yellow** (breach / insecure-form alerts)
- `--identity-tab-color` (container-tab colors are user-assigned & dynamic; a
  `toolbar`-colored container is special-cased per-`usercontextid` instead)

## Known coverage

trimfox maps the primary surfaces: toolbar/sidebar/tab bg, text colors, the
urlbar field (resting + focus + hover) and its border, the results-popup
selection, menu/popup surfaces, the accent set, and `--tf-attention`. The audit
findings that produced the current mapping list are tracked below.

## Findings from the theme=auto audit

The `theme = auto` switch exposed a family of leaks (all from the same
`:root:not([lwtheme])` default block in
`toolkit/…/design-system/tokens-shared.css`, lines ~641–668). Fixed:

| variable | paints | leaked (dark side) | mapped to |
|---|---|---|---|
| `--toolbar-field-background-color-focus` | focused URL bar + results pill | `#42414d` | `--tf-field` |
| `--panel-background-color` | all arrowpanels (☰/app menu, Downloads, Bookmarks, permissions, page-action popups) | `#42414d` | `--tf-surface` |
| `--panel-border-color` | arrowpanel borders | `#52525e` | `--tf-line-solid` |
| `--toolbar-background-color` | `#navigator-toolbox` + `#sidebar-main` (Nova) | `#2b2a33` | `--tf-surface` |
| `--button-background-color-hover` | in-panel ghost buttons (Nova) | **violet** `#75669f` | `--tf-raised` |
| `--button-background-color-active` | in-panel ghost buttons pressed | darker violet | `--tf-select` |

**Left unmapped on purpose** (translucent `color-mix(currentColor …)` values that
correctly follow the theme, or genuinely-dark defaults): `--urlbarview-background-color-hover`,
`--toolbarbutton-background-color-hover/-active`, `--toolbox-background-color`,
`--panel-separator-color`. And the semantic set (see above): container colors,
security red / warning yellow / success green, the `#confirmation-hint` info blue.

## The exact recipe (copy-paste)

```bash
BR=/Applications/Firefox.app/Contents/Resources/browser/omni.ja   # browser skin
TK=/Applications/Firefox.app/Contents/Resources/omni.ja           # toolkit/global skin
UC="$HOME/Library/Application Support/Firefox/Profiles/<profile>/chrome/userChrome.css"
mkdir -p /tmp/ffcss && cd /tmp/ffcss

# 1. Extract the surfaces that matter (add files as needed).
for f in browser-shared.css sidebar.css tabbrowser/tabs.css urlbar/view-nova.css \
         urlbar/view-proton.css customizableui/panelUI-shared.css; do
  unzip -p "$BR" "chrome/browser/skin/classic/browser/$f" > "B_$(echo $f|tr / _)"; done
for f in popup.css menu.css design-system/tokens-shared.css global-shared.css; do
  unzip -p "$TK" "chrome/toolkit/skin/classic/global/$f" > "T_$(echo $f|tr / _)"; done

# 2. Every var used as a background/border/fill on a chrome surface, by frequency.
grep -rhoiE '(background(-color)?|border(-[a-z]+)?|fill)[[:space:]]*:[^;]*var\(--[a-z0-9-]+' . \
  | grep -oiE 'var\(--[a-z0-9-]+' | sed 's/var(//' | sort | uniq -c | sort -rn

# 3. For a suspect var: its default(s), and whether trimfox maps it.
grep -rEn "^[[:space:]]*--VARNAME[[:space:]]*:" .        # default value(s)
grep -c -- "--VARNAME" "$UC"                             # 0 = UNMAPPED leak candidate

# 4. THE KEY TABLE — the auto-theme defaults that leak all live here:
sed -n '641,668p' T_design-system_tokens-shared.css      # :root:not([lwtheme]) block
```

**Decision rule:** a var is a leak if — (a) `grep -c` in userChrome.css is `0`,
**and** (b) its value in the `:root:not([lwtheme])` block (or a `light-dark(...)`)
has a **solid light-ish dark side** (`rgb(66,65,77)` `#42414d`, `rgb(43,42,51)`
`#2b2a33`, `rgb(82,82,94)` `#52525e`, any `--color-gray-50`/`--color-violet-*`),
**and** (c) it paints a surface the user sees. A `color-mix(… currentColor …,
transparent)` value is **not** a leak — it follows trimfox's text color.
