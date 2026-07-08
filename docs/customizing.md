<!-- The full guide to customizing trimfox: palettes, overrides, dials, light/dark. -->

# Customizing trimfox

Colors and layout are all `--tf-*` tokens and dials — change them **without editing the theme
or forking**. Your values live in a gitignored `chrome/user-overrides.css` (loaded last,
survives `git pull`). The README has the quick version; this is the full reference.

## Palettes & colors

Two ways to change colors, depending on who you are:

- **Users** — set yours in
  [`user-overrides.css`](#personal-overrides--user-overridescss-survives-upgrades): it loads
  *after* the palette (no `!important`) and survives `git pull`. `@import` a different shipped
  palette there, or override individual tokens (example below).
- **Maintainers / forks** — change trimfox's *shipped default* via the palette `@import` in
  `userChrome.css` (further below).

```css
/* chrome/user-overrides.css — the user layer, loaded last */
@import url('./palettes/tinted.css');   /* switch palette here, not in userChrome.css */
:root {
  --tf-hue: 260;  --tf-chroma: 0.03;    /* tune the tinted palette…         */
  /* --tf-accent: #6a7fb0; */           /* …or just override a token or two */
}
```

All colors are `--tf-*` tokens, and `userChrome.css` never hardcodes a color — it
maps Firefox's own theme variables onto the tokens, so a whole theme is just one
token set. The **primitive tokens live in a swappable palette file**, imported at
the top of `chrome/userChrome.css`:

```css
@import url('./palettes/grayscale.css');   /* ← swap this one line */
```

Each file in **`chrome/palettes/`** defines the token set for **both dark and
light**, so the scheme follows the OS automatically (see below):

| file | look |
|------|------|
| `grayscale.css` *(default — stock)* | neutral grayscale, zero-blue — dark + inverted light. The exact reference look. |
| `firefox.css` | trimfox layout with Firefox's own default chrome colors + blue accent |
| `tinted.css` *(adjustable)* | parametric one-hue tint — derives the whole ramp from `--tf-hue` + `--tf-chroma` (see below) |

The accent (`--tf-accent`) replaces Firefox's default teal on buttons, focus rings and
checkboxes — in the chrome, on `about:` pages, and on error pages. The full `--tf-*` token
vocabulary is catalogued in
[docs/tweak-catalog.md](https://github.com/csmarshall/trimfox/blob/main/docs/tweak-catalog.md).

**Interactive tools** — self-contained HTML; open locally, or try them live on
GitHub Pages:

- **[Tint picker](https://csmarshall.github.io/trimfox/tint-picker.html)** (`tint-picker.html`) —
  pick a base color, or dial hue + tint strength, and compare your palette against
  *stock* grayscale side by side; copy the two `tinted.css` values.
- **[Palette explorer](https://csmarshall.github.io/trimfox/palette.html)** (`palette.html`) —
  a 4-way preview (trimfox dark/light, Firefox-default dark/light) that re-colors a
  live browser-chrome mockup and a full swatch table.

**Tinted palette — adjustable.** `palettes/tinted.css` derives the whole ramp from two knobs
(`--tf-hue` 0–360, `--tf-chroma` 0–~0.05; `0` = grayscale), keeping trimfox's exact
lightness/contrast. Dial it visually with the tint picker above, or set the values by hand —
example hues: slate `260`, terracotta `40`, forest `150`, plum `330` (chroma ~0.025–0.035).

### Personal overrides — `user-overrides.css` (survives upgrades)

**Don't edit the committed files to customize.** trimfox loads
**`chrome/user-overrides.css`** *last* — a gitignored, per-user file where you set any
`--tf-*` color or dial with a **plain declaration (no `!important`)** and it wins as if it
were the shipped default. Because it's untracked, `git pull` (including the eventual
Firefox **Nova** re-map) updates the theme underneath while your settings persist — no
hand-merging.

```sh
cp chrome/user-overrides.example.css chrome/user-overrides.css   # install.sh does this for you
```

Then uncomment what you want:

```css
:root {
  --tf-font-size: 9pt;      /* bigger chrome text     */
  --tf-anim:      120ms;    /* add find-bar motion    */
  --tf-accent:    #6a7fb0;  /* a different accent     */
}
```

Every knob lives in **`chrome/dials.css`** (structural dials) and the palette
(`palettes/*.css`, colors) — both loaded before your overrides. The `--tf-*` names are
trimfox's stable API: Firefox's own var/selector names churn under it, yours don't.


## Tuning knobs

Colors come from the [palette](#palettes--colors). Everything else is driven by `--tf-*`
dials, each defined in a labeled `:root` block right above the feature it controls
in `chrome/userChrome.css`:

| Knob | Default | What it controls |
|------|---------|------------------|
| **Font** | | |
| `--tf-font-family` | `-apple-system` | chrome-wide typeface |
| `--tf-font-size` | `7pt` | chrome-wide base size (the 1.0× anchor; everything scales from it) |
| `--tf-fs-lift` | `1` | `1` = full proportional (FF's hierarchy), `0` = middle path, fractions blend |
| `--tf-fs-field` / `-md` / `-h` / … | `1.1×` … | per-tier `calc()` ratios (see [`docs/font-hierarchy.md`](https://github.com/csmarshall/trimfox/blob/main/docs/font-hierarchy.md)) |
| **Tab strip** | | |
| `--tab-min-height` | `22px` | row height |
| `--tab-collapsed-background-width` | `14px` | collapsed strip width |
| `--tf-sep-inset` | `1px` | tab-separator inline-start inset (clears the macOS frame) |
| **Pinned grid** (`#13`) | | |
| `--tf-pin-size` | `22px` | faviconized pin square |
| `--tf-pin-favicon` | `14px` | favicon inside the square |
| `--tf-pin-pitch` / `-pitch-n` | `24px` / `24` | pin-to-pin step (px + unitless) |
| `--tf-pin-area-width` | `230` | fallback grid width (auto-fit overrides via `@container`) |
| `--tf-pin-row-inset` | `4px` | left inset of pin #1 |
| **History menu** (tab-strip skin) | | |
| `--tf-hist-row-pad-block` / `-inline` | `2px` / `8px` | per-row padding |
| `--tf-hist-end-pad` | `6px` | extra pad at the menu's top/bottom rows |
| `--tf-hist-favicon` | `16px` | favicon column size |
| `--tf-hist-accent-width` / `-color` | `3px` / `--tf-glyph` | active-row left accent bar |
| **Loading indicator** | | |
| `--tf-load-fill` / `-opacity` / `-speed` | `--tf-accent` / `0.6` / `1.4s` | busy-tab fill wash |
| **Container markers** (`#12`) | | |
| `--tf-container-collapsed-flag` | `block` | `none` = hide the pill in the collapsed strip |

The dividers, separators, and container markers use `:-moz-window-inactive` so they
dim when the window loses focus, matching the rest of the themed chrome.


## Light / dark (auto-follows macOS)

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
