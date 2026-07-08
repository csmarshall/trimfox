<h1 align="center">
  <img src="https://raw.githubusercontent.com/csmarshall/trimfox/main/wordmark.png" alt="trimfox" width="260">
</h1>

<p align="center">
  <img src="https://raw.githubusercontent.com/csmarshall/trimfox/main/logo.png" alt="running low-poly fox mark" width="420">
</p>

<p align="center">
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
  <a href="https://buymeacoffee.com/cs_marshall"><img src="https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?logo=buy-me-a-coffee&logoColor=black" alt="Buy Me a Coffee"></a>
  <a href="https://github.com/sponsors/csmarshall"><img src="https://img.shields.io/badge/Sponsor-GitHub-ea4aaa?logo=github-sponsors" alt="Sponsor"></a>
</p>

A minimal Firefox `userChrome` setup built around **native vertical tabs** — no
Tree Style Tab, no sidebar extension, just the browser's own chrome restyled to
get out of the way.

The headline is the tab strip (Firefox's own native sidebar, restyled): collapsed, it's a skinny ~14px column of separator
lines that just tells you how many tabs are open; hover it and it expands to
readable labels. No favicons when collapsed, no pills, no close buttons, no
new-tab button, no hover-preview cards, no launcher clutter.

It's called *trimfox* because that's the point — trim everything that isn't a tab.

> **Heads up — this is opinionated.** trimfox collapses Back + Forward into a *single*,
> history-aware nav button (the old unified-back/forward look): a **‹** chevron when only
> back is available, a **›** when only forward is, a **⌄** down-chevron when both are (a
> hint the history menu is a right-click away), and a **–** dash when there's nowhere to go
> yet (a fresh tab, no history either way). Left-click navigates; the other direction
> and full history are on **right-click** (or the keyboard — `Cmd+[` / `Cmd+]`). If you rely
> on always-visible **separate Back and Forward buttons**, or you don't reach for
> keyboard/right-click navigation, trimfox probably isn't for you.

## Screenshots

trimfox follows the OS light/dark theme — everything below is shown in both.

> These images are served from the repo on GitHub; the downloadable **zip omits them to stay
> small** (a couple hundred KB instead of ~3 MB). View them here or in the repo.

### The tab strip

The collapse/expand-on-hover strip — dark on top, light beneath.

<p align="center"><b>Expanded</b> (on hover) &nbsp;·&nbsp; <b>Collapsed</b></p>
<div align="center">
  <table align="center">
    <tr>
      <td><img src="https://raw.githubusercontent.com/csmarshall/trimfox/main/docs/screenshots/tabstrip-expanded-dark.png" width="400" alt="Expanded tab strip, dark"></td>
      <td><img src="https://raw.githubusercontent.com/csmarshall/trimfox/main/docs/screenshots/tabstrip-collapsed-dark.png" width="400" alt="Collapsed tab strip, dark"></td>
    </tr>
    <tr>
      <td><img src="https://raw.githubusercontent.com/csmarshall/trimfox/main/docs/screenshots/tabstrip-expanded-light.png" width="400" alt="Expanded tab strip, light"></td>
      <td><img src="https://raw.githubusercontent.com/csmarshall/trimfox/main/docs/screenshots/tabstrip-collapsed-light.png" width="400" alt="Collapsed tab strip, light"></td>
    </tr>
  </table>
</div>

### The URL bar

Focused, with the results dropdown restyled to match the chrome — dark on top, light below.

<div align="center">
  <table align="center">
    <tr><td><img src="https://raw.githubusercontent.com/csmarshall/trimfox/main/docs/screenshots/urlbar-dark.png" width="720" alt="URL bar with results dropdown, dark"></td></tr>
    <tr><td><img src="https://raw.githubusercontent.com/csmarshall/trimfox/main/docs/screenshots/urlbar-light.png" width="720" alt="URL bar with results dropdown, light"></td></tr>
  </table>
</div>

### The find bar

The compact refined find bar (`Cmd+F`) — dark on top, light below.

<div align="center">
  <table align="center">
    <tr><td><img src="https://raw.githubusercontent.com/csmarshall/trimfox/main/docs/screenshots/findbar-dark.png" width="720" alt="Find bar, dark"></td></tr>
    <tr><td><img src="https://raw.githubusercontent.com/csmarshall/trimfox/main/docs/screenshots/findbar-light.png" width="720" alt="Find bar, light"></td></tr>
  </table>
</div>

### Themed menus

Even the right-click menus are skinned — trimfox forces XUL menus precisely because native
macOS menus can't be CSS-themed, so they match the chrome instead of popping up as stock
system menus. Dark and light in each pair.

<p align="center"><b>Tab right-click menu</b></p>
<div align="center">
  <table align="center">
    <tr>
      <td><img src="https://raw.githubusercontent.com/csmarshall/trimfox/main/docs/screenshots/menu-tab-dark.png" height="360" alt="Themed tab context menu, dark"></td>
      <td><img src="https://raw.githubusercontent.com/csmarshall/trimfox/main/docs/screenshots/menu-tab-light.png" height="360" alt="Themed tab context menu, light"></td>
    </tr>
  </table>
</div>

<p align="center"><b>Back/forward history menu</b> (off the unified nav button)</p>
<div align="center">
  <table align="center">
    <tr>
      <td><img src="https://raw.githubusercontent.com/csmarshall/trimfox/main/docs/screenshots/menu-history-dark.png" width="380" alt="Themed history menu, dark"></td>
      <td><img src="https://raw.githubusercontent.com/csmarshall/trimfox/main/docs/screenshots/menu-history-light.png" width="380" alt="Themed history menu, light"></td>
    </tr>
  </table>
</div>

## Requirements

- **Firefox 138+** — trimfox's collapse-and-**expand-on-hover** tab strip needs the sidebar's
  expand-on-hover, which shipped in 138 (native vertical tabs themselves landed in 136). The
  **instant** hover-expand trimfox sets needs the zero-delay pref from **145+**; 138–144 work
  but use Firefox's default hover delay. Developed and verified on **152**.
- **macOS** — what trimfox is *themed for*, not a hard requirement. The core (native vertical
  tabs + userChrome) is cross-platform, so it should largely work on Linux/Windows; the
  macOS-specific bits (traffic-light hiding, the native-menu prefs, `-moz-platform`-gated rules)
  just won't apply and are untested there — [testers welcome](#platform-support).
- A swappable palette (see [Palette](#palette)): default is neutral grayscale,
  zero-blue, with **dark + light** that auto-follows macOS Appearance. Preview the
  default light/dark on the [palette explorer](https://csmarshall.github.io/trimfox/palette.html).

## Install

**Prefer a single download?** Grab the
**[latest release zip](https://github.com/csmarshall/trimfox/releases/latest)**, unzip it,
and follow the `QUICKSTART.txt` inside (it's just `./install.sh`). No git, no command-line
know-how required beyond running one script.

Or clone it:

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

**Already have a `user.js`?** trimfox ships its own and **replaces** yours (your old one is
backed up to `user.js.bak-*`). Keep your own prefs in **`user-overrides.js`** (gitignored) — the
installer seeds it from `user-overrides.example.js`, appends it *after* trimfox's prefs
so yours win, and preserves it across updates. Every pref trimfox sets, with its Firefox
default, is in **[SETTINGS.md](SETTINGS.md)**. (That's the *prefs* layer; colors and dials
have a separate override file — `chrome/user-overrides.css`, covered under [Palette](#palette).)

To revert: restore the `.bak-*` files (or delete `chrome/`, `user.js`, and your
`user-overrides.*`) and restart. If you installed the error-page accent, run
`chrome/autoconfig/install-neterror-accent.sh -u` first.

### After install — two one-time steps

1. **Set the theme to "System theme — auto"** — `about:addons` → Themes, so light/dark
   follows the OS. If it doesn't take, see [Light / dark](#light--dark-auto-follows-macos)
   for the one-time toggle-and-back fix.
2. **Sidebar width** — drag the expanded sidebar edge to your taste (~240px) once;
   Firefox persists it.

> **Prefer the strip always open, or wider?** You can. Set `sidebar.visibility="always-show"`
> in `user-overrides.js` (or use Firefox's own **Settings → General → Browser Layout**) to keep
> it expanded, and drag the sidebar edge any time to resize — Firefox remembers the width.
> trimfox defaults to **collapse-and-expand-on-hover** on purpose: an always-open strip eats
> horizontal space, which cuts against the trim-the-chrome, slim-and-fast point of the theme.

### Troubleshooting: chrome is themed but the tab strip is missing

If the URL bar / toolbar are clearly restyled but there's **no vertical-tab strip
on the left**, the sidebar *panel* is closed on that profile — and trimfox hides
the sidebar toggle button, so there's no obvious way to reopen it. **Open the
sidebar once** via **View → Sidebar** (macOS menu bar), or open any panel (e.g.
History) — the tab strip appears and **stays** after you close the panel. You only
need to do this once per profile.

(If the chrome *isn't* themed either, `userChrome.css` didn't load: confirm
`toolkit.legacyUserProfileCustomizations.stylesheets` is `true`, that `chrome/` +
`user.js` landed in the **running** profile — `about:support` → Profile Directory —
and that you fully **Cmd+Q**'d before relaunching.)

### Optional — skin the error pages too

CSS already reaches essentially the whole browser — chrome, toolbars, menus, the urlbar,
every in-content `about:` page. There's exactly one surface it can't: error pages
(`about:neterror`, `about:certerror`, `about:blocked`, `about:httpsonlyerror`) load in a
privileged context that never injects `userContent.css`. If you want the *entire*
interface — error pages included — in the palette, that's what
`chrome/autoconfig/install-neterror-accent.sh` is for. Everyone else can skip this;
trimfox is already fully themed without it.

```sh
cd chrome/autoconfig
./install-neterror-accent.sh            # install
./install-neterror-accent.sh -u         # uninstall
./install-neterror-accent.sh            # re-run after any Firefox update (see below)
```

It registers a global AutoConfig `USER_SHEET` — the only style origin privileged error
pages honor — so it writes two files *into* the `Firefox.app` bundle and needs
`general.config.sandbox_enabled=false`. Two trade-offs before opting in:

- **Sandbox off.** AutoConfig can't run with the config sandbox enabled, so installing
  flips `general.config.sandbox_enabled` to `false` for as long as it's installed. `-u`
  removes both files and restores the default.
- **Lives in the app bundle, so Firefox updates wipe it.** Both files sit under
  `Firefox.app/Contents/Resources/`, overwritten on every update — re-running the script
  (idempotent) reapplies it.

If Firefox isn't at `/Applications/Firefox.app`, pass `-a PATH`.

> Note: the error-page gray is hardcoded in the script, so it won't follow a palette swap
> (e.g. to `firefox.css`'s blue accent) — error pages stay gray. Edit the hex in the
> script's `.cfg` block to match a different palette.

## Firefox compatibility — including "Nova"

Built and tuned on **Firefox 152**, and **already compatible with Firefox's 2026
["Nova" redesign](https://blog.mozilla.org/en/firefox/new-firefox-design/)** — on purpose.
A companion tool, **[trimfox-drift](https://github.com/csmarshall/trimfox-drift)**, diffed
trimfox's Firefox dependencies against a Nova Nightly (154) build and flagged the three
chrome vars Nova removes that trimfox relied on. Those were fixed pre-emptively with `var()`
fallbacks ([#33](https://github.com/csmarshall/trimfox/issues/33),
[`f555f9b`](https://github.com/csmarshall/trimfox/commit/f555f9b)) — so nothing changes on
152, and — hopefully — far less should break when Nova lands. Nova is still in Nightly and
will keep changing, so this is a cautiously-optimistic head start, not a guarantee.

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

Every visual change trimfox makes — grouped by area (palette, tabs, URL bar, menus, pinned
tabs, findbar, in-content, prefs), with the selectors / `--tf-*` tokens and the *why* — is
catalogued separately to keep this README scannable:
**[docs/tweak-catalog.md](https://github.com/csmarshall/trimfox/blob/main/docs/tweak-catalog.md)**.

## Tuning knobs

Colors come from the [palette](#palette); everything else is driven by `--tf-*` dials — font &
scale, tab strip, the pinned grid, history-menu skin, loading wash, container markers — each
with its default and what it controls, tabulated in
**[docs/tuning-knobs.md](https://github.com/csmarshall/trimfox/blob/main/docs/tuning-knobs.md)**.

## Palette

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

Token vocabulary: `field`, `content`, `surface`, `raised`, `select`, `accent`
(+ `-hover`/`-active`), `text`, `text-dim`, `line` (+ `-solid`/`-inactive`),
`highlight`, `glyph`. The accent (`--tf-accent`) replaces Firefox's default teal
on buttons, focus rings and checkboxes — in the chrome, on `about:` pages
(`userContent.css`), and on privileged error pages (`chrome/autoconfig/`).

**Interactive tools** — self-contained HTML; open locally, or try them live on
GitHub Pages:

- **[Tint picker](https://csmarshall.github.io/trimfox/tint-picker.html)** (`tint-picker.html`) —
  pick a base color, or dial hue + tint strength, and compare your palette against
  *stock* grayscale side by side; copy the two `tinted.css` values.
- **[Palette explorer](https://csmarshall.github.io/trimfox/palette.html)** (`palette.html`) —
  a 4-way preview (trimfox dark/light, Firefox-default dark/light) that re-colors a
  live browser-chrome mockup and a full swatch table.

**Tinted palette (`palettes/tinted.css`) — adjustable.** An opt-in alternative to
the stock grayscale. Two knobs at the top drive the whole theme, keeping trimfox's
exact lightness/contrast ramp and just tinting it:

| knob | range | meaning |
|------|-------|---------|
| `--tf-hue` | 0–360 | which color the tint leans toward |
| `--tf-chroma` | 0–~0.05 | how much color (`0` = neutral) |

`--tf-chroma: 0` reproduces grayscale — for the *exact* stock look, use
`grayscale.css` itself. Swap the `@import` to `palettes/tinted.css` and set the two
values. Example hues: **slate `260`**, **terracotta `40`**, **forest `150`**,
**plum `330`** (chroma ~0.025–0.035).

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

### Light / dark (auto-follows macOS)

Each palette carries a dark set plus an `@media (prefers-color-scheme: light)`
set, so trimfox switches with your **macOS Appearance** (System Settings →
Appearance). No restart once it's wired — flip the OS and the chrome follows.

**One-time setup — Firefox's chrome scheme is driven by its active *theme*, not by
macOS directly.** A built-in **Dark** or **Light** theme hardcodes the scheme and
*pins* the palette; you need **System theme — auto** so the chrome tracks the OS.
trimfox's `user.js` sets `browser.theme.toolbar-theme` / `content-theme` to `2`
(auto) and `extensions.activeThemeID` to `default-theme@mozilla.org`, but the
**Add-ons Manager owns the active theme and often wins over the pref**. If light
mode doesn't engage:

> Open **`about:addons` → Themes** and switch to **"System theme — auto".**
> If it's already selected but stuck, toggle to any other theme and back — that
> forces the Add-ons Manager to re-apply *auto* (the pref alone may not take).

(trimfox overrides every chrome color regardless, so the theme choice only
controls *which* light/dark palette engages — not the look otherwise.)

> **Note:** `--tf-glyph` can't reach into `data:` SVG icons (CSS `var()` doesn't
> resolve inside a data URI), so the no-history nav-button dash bakes its color
> in. It ships a light-gray dash plus a dark-gray copy swapped in under
> `@media (prefers-color-scheme: light)` — so a *custom* palette that flips
> light/dark differently would need the same one-line media override.

## docs/ (maintainer notes)

Reverse-engineering method and hard-won gotchas from building trimfox — read
these before a tricky chrome change:

- **[`docs/theming-playbook.md`](https://github.com/csmarshall/trimfox/blob/main/docs/theming-playbook.md)** — how to reverse-
  engineer Firefox chrome: reading FF's source out of `omni.ja`, live Browser-
  Toolbox probes, piercing UA shadow DOM, SVG-icon theming, live-reactive
  `:has()` selectors, condensed case studies (pinned grid, URL bar, menus, nav
  button, drag-reorder), and a gotchas quick-reference.
- **[`docs/color-audit.md`](https://github.com/csmarshall/trimfox/blob/main/docs/color-audit.md)** — when a chrome surface is the
  wrong shade: the 5-minute procedure to find the unmapped Firefox variable and
  bind it to a `--tf-*` token.
- **[`docs/adr/`](https://github.com/csmarshall/trimfox/tree/main/docs/adr)** — **Architecture Decision Records**: the *why* behind
  trimfox's load-bearing choices (the slim philosophy, the collapsed tab strip, XUL menus,
  native tabs, the `--tf-*` token system, the override layer, drift monitoring), numbered
  by decision date.

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

**Porting or sending a PR?** See **[CONTRIBUTING.md](CONTRIBUTING.md)** — how to gate
per-OS changes with `@media (-moz-platform: …)`, the "don't change the macOS look" rule,
and the **before/after screenshots every visual PR needs**. Firefox is only run/tested
on macOS here, so a platform PR can't be reviewed without them.

## Acknowledgements

trimfox builds on other people's work:

- **Mozilla and the Firefox team** — for native vertical tabs, the revamped sidebar, and for
  keeping **`userChrome.css`** alive at all. trimfox restyles Firefox's *own* chrome; it's a
  theme, not a replacement.
- **[refined-findbar](https://github.com/ravindUwU/firefox-refined-findbar)** by ravindUwU
  (MIT) — the compact find bar in `chrome/refined-findbar/findbar.css` is adapted from it;
  the MIT notice is retained in that file.
- **[firefox-csshacks](https://github.com/MrOtherGuy/firefox-csshacks)** by MrOtherGuy — the
  community's reference collection of userChrome/userContent techniques; trimfox leans on the
  vocabulary and tricks documented there.
- **[Tree Style Tab](https://github.com/piroor/treestyletab)** by Piro — trimfox reproduces
  its vertical-tab look using Firefox's own native vertical tabs (this profile was migrated
  *off* TST; see `reference/`). Inspiration, not code.
- **[Cascade](https://github.com/andreasgrafen/cascade)** by andreasgrafen — a kindred
  one-line, minimalist userChrome theme; not code, but the same strip-everything-non-essential
  ethos. Inspiration.
- **[SimpleFox](https://github.com/migueravila/SimpleFox)** by Miguel Ávila — an earlier
  minimalist, keyboard-centered Firefox theme (now dormant, last updated 2021) that Cascade
  itself credits; a root of this minimalist lineage. Inspiration.
- **[ShadowFox](https://github.com/overdodactyl/ShadowFox)** by overdodactyl — a pioneering
  *universal* dark theme from the Firefox-57 userChrome era (now dormant, pre-Proton). It's
  where trimfox literally began: the earliest ancestor of this setup was a hand-modified
  ShadowFox, from before Firefox had native light/dark. No code survives the years of rewriting
  since (see [ADR-0001](https://github.com/csmarshall/trimfox/blob/main/docs/adr/0001-design-philosophy.md)), but it charted this ground first.
- **The [r/FirefoxCSS](https://www.reddit.com/r/FirefoxCSS/) community** — for the userChrome
  techniques this builds on, including hiding the macOS traffic-light window controls.
- **Logo** — the running-fox mark started as a generation from **[Google Gemini](https://gemini.google.com)**,
  then took a fair bit of hand-work to ship: chroma-keyed off a red background, indexed to trimfox's own
  grayscale palette, and given a keyline outline so it holds up on both light and dark backgrounds.

**How this was built.** trimfox is hand-built and AI-*assisted* — not AI-generated. It began
as years of hand-tuned Firefox `about:config` tweaks and userChrome hacks, a personal setup
refined by hand, decision by decision, over a long time. More recently, AI (Anthropic's
Claude) helped document, refactor, extend, and package it — but every change was reviewed,
understood, and directed by a human. The design decisions and the craft are human; the AI
was a power tool that sped up the polish, not the author of the theme.

## License

MIT — see [LICENSE](LICENSE).
