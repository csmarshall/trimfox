# Firefox 152 chrome font-size hierarchy → trimfox ratios

A reference chart of the font sizes Firefox 152 uses across its chrome, expressed
as **ratios to the base chrome font**, so trimfox can *optionally* reproduce
Firefox's native proportions with `calc(var(--tf-font-size) * N)` instead of
flattening everything to one size.

Verified against **Firefox 152.0.4 (macOS)**. Sources are the two shipping omni
archives:

- Browser skin: `/Applications/Firefox.app/Contents/Resources/browser/omni.ja`
  → `chrome/browser/skin/classic/browser/…`
- Toolkit/global: `/Applications/Firefox.app/Contents/Resources/omni.ja`
  → `chrome/toolkit/skin/classic/global/…`

Read with `unzip -p <archive> <path>`.

---

## 1. The base font (the 1.0× anchor)

Firefox chrome has **two** notions of "base", and it matters which one an element
scales off:

1. **The chrome window default** — the macOS system font. Mozilla's own comment in
   `browser.css` pegs it: *"Default font size is 11px on mac."* Menus, tabs,
   panels and toolbar buttons re-assert this via `font: menu` /
   `font: message-box`. **Every `em`-based rule in the chrome scales off this
   inherited size** — so an `em` value *is already a ratio to base*
   (`1.25em` = `1.25×`).

2. **The design-system rem root** — `--font-size-root: 15px` on macOS
   (`design-system/tokens-brand.css`). This is the `1.0×` anchor for the
   *token scale* (`--font-size-small`, `--font-size-large`, …) and for
   `rem`-based rules. It's used by in-content pages (`about:*`, newtab) and by
   the newer token-driven panels.

> **trimfox collapses both of these into a single dial.** `--tf-font-size`
> (currently `7pt` ≈ `9.33px`, set on `:root`) replaces the window default, the
> `font: menu` resets, and — in flat mode — every downstream override too. **That
> dial is the `1.0×` anchor for this whole document.** Ratios below are what you
> multiply `--tf-font-size` by to mirror Firefox's proportion.

Two ratio bases coexist below, and they're labelled per row:

- **em rows** → ratio is the literal `em` multiplier (relative to inherited chrome
  base = `1.0×`).
- **rem/token rows** → ratio is `value ÷ 15px` (the design-system root).

---

## 2. Design-system font-size token scale

From `chrome/toolkit/skin/classic/global/design-system/tokens-brand.css`
(macOS values; `tokens-platform.css` leaves them `unset`, `tokens-shared.css`
defines the heading/button aliases). Root = `15px`, so `1rem = 15px`.

| FF token | value | resolves to | ratio to base | trimfox `calc(…)` |
|---|---|---|---|---|
| `--font-size-xsmall` | `0.733rem` | `11.0px` | `0.733×` | `calc(var(--tf-font-size) * 0.75)` |
| `--font-size-small` | `0.867rem` | `13.0px` | `0.867×` | `calc(var(--tf-font-size) * 0.85)` |
| `--font-size-root` | `15px` | `15.0px` | `1.000×` | `var(--tf-font-size)` |
| `--font-size-large` | `1.133rem` | `17.0px` | `1.133×` | `calc(var(--tf-font-size) * 1.15)` |
| `--font-size-xlarge` | `1.467rem` | `22.0px` | `1.467×` | `calc(var(--tf-font-size) * 1.5)` |
| `--font-size-xxlarge` | `1.6rem` | `24.0px` | `1.600×` | `calc(var(--tf-font-size) * 1.6)` |
| `--font-size-xxxlarge` | `2.2rem` | `33.0px` | `2.200×` | `calc(var(--tf-font-size) * 2.2)` |

Aliases defined in `tokens-shared.css` (no new values, just semantic names):

| Alias | = token | resolves to | ratio |
|---|---|---|---|
| `--font-size-heading-medium` | `--font-size-large` | `17px` | `1.133×` |
| `--font-size-heading-large` | `--font-size-xlarge` | `22px` | `1.467×` |
| `--font-size-heading-xlarge` | `--font-size-xxlarge` | `24px` | `1.600×` |
| `--button-font-size` | `--font-size-root` | `15px` | `1.000×` |
| `--button-font-size-small` | `--font-size-small` | `13px` | `0.867×` |

**Clean N ladder** (what trimfox should standardise on):
`0.75 · 0.85 · 1.0 · 1.15 · 1.5 · 1.6 · 2.2`.

---

## 3. User-visible chrome elements

Ratio column: `em` rows are literal multipliers of the inherited chrome base;
`rem` rows are `÷15px`. "inherit (`font: menu`)" means the element sets no
font-size and rides the base — i.e. `1.0×`, and trimfox already covers it with the
flat rule.

| Chrome element / selector | FF font-size (raw) | resolves to | ratio | trimfox `calc(…)` | source file |
|---|---|---|---|---|---|
| **Menu items** `menupopup`, `menuitem` | inherit (`font: menu`) | base | `1.0×` | `var(--tf-font-size)` | `global/menu.css`, `menupopup.css` (no font-size rule) |
| **App (☰) menu items** `.subviewbutton`, `panelview .toolbarbutton-1` | inherit | base | `1.0×` | `var(--tf-font-size)` | `customizableui/panelUI-shared.css:1164` |
| **Panel subheader** `.subview-subheader` | `0.9em` | `0.9×` base | `0.90×` | `calc(var(--tf-font-size) * 0.9)` | `panelUI-shared.css:1176` |
| **Toolbar buttons** `.toolbarbutton-1` | inherit | base | `1.0×` | `var(--tf-font-size)` | `global/toolbarbutton.css` (label inherits) |
| **Toolbar-button badge** `.toolbarbutton-badge` | `10px` | `10px` | ~`0.77×`* | `calc(var(--tf-font-size) * 0.75)` | `global/toolbarbutton.css:43` |
| **Tabs** `.tabbrowser-tab` / `.tab-label` | inherit (`font: menu`) | base | `1.0×` | `var(--tf-font-size)` | `tabbrowser/tabs.css` (label inherits) |
| **Tab overflow / group-suggestion text** `#tab-note-overflow-indicator`, `#tab-group-suggestions-message-container` | `0.85em` | `0.85×` base | `0.85×` | `calc(var(--tf-font-size) * 0.85)` | `tabbrowser/tabs.css:2247, 3103` |
| **URL bar field** `.urlbar`, `#searchbar` | `1.25em` | `1.25×` base | `1.25×` | `calc(var(--tf-font-size) * 1.25)` | `browser.css:85` |
| **URL bar results — small text** `--urlbarView-small-font-size` (url / action / secondary) | `0.85em` | `0.85×` base | `0.85×` | `calc(var(--tf-font-size) * 0.85)` | `urlbar/view-proton.css:15` (+ `view-nova.css`) |
| **URL bar result-menu button** `.urlbarView-button` | `0.93em` | `0.93×` base | `0.93× → 0.9×` | `calc(var(--tf-font-size) * 0.9)` | `urlbar/view-proton.css:495` |
| **URL bar rich chiclet** `.urlbarView-sports-date-chiclet-day` | `1.25em` | `1.25×` base | `1.25×` | `calc(var(--tf-font-size) * 1.25)` | `urlbar/view-proton.css:1704` |
| **Sidebar body** `#sidebar-box` | `1.0909rem` | `12px` (intent) | `0.8×` (rem)** | `calc(var(--tf-font-size) * 1.1)`** | `browser.css:139` |
| **Sidebar header** `#sidebar-header` | `1.333em` | `1.333×` base | `1.333×` | `calc(var(--tf-font-size) * 1.333)` | `sidebar.css:56` |
| **Dialogs** `dialog`, wizard headers | inherit (`font: message-box`/`caption`) | base | `1.0×` | `var(--tf-font-size)` | `global/dialog.css`, `wizard.css` (font-weight only) |
| **Findbar** `.findbar-*` | inherit | base | `1.0×` | `var(--tf-font-size)` | `global/findbar.css` (font-weight only) |
| **Confirmation hint** `#confirmation-hint` | `1.1rem` | `11px` (rem) | `0.73×` (rem) | `calc(var(--tf-font-size) * 0.75)` | `panelUI-shared.css:401` |
| **Confirmation hint w/ description** `#confirmation-hint-message` | `1.2em` | `1.2×` base | `1.2×` | `calc(var(--tf-font-size) * 1.2)` | `panelUI-shared.css:484` |
| **Protections panel — no-trackers** `#protections-popup-no-trackers-found-description` | `1.1em` | `1.1×` base | `1.1×` | `calc(var(--tf-font-size) * 1.1)` | `controlcenter/panel.css:444` |
| **Protections panel — title** `.protections-popup-message-title` | `1.3em` | `1.3×` base | `1.3×` | `calc(var(--tf-font-size) * 1.3)` | `panelUI-shared.css:1889` |
| **HTTPS-only info** `#identity-popup-security-httpsonlymode-info` | `0.85em` | `0.85×` base | `0.85×` | `calc(var(--tf-font-size) * 0.85)` | `controlcenter/panel.css:136` |
| **Customize header** `#customization-header` | `1.2em` | `1.2×` base | `1.2×` | `calc(var(--tf-font-size) * 1.2)` | `customizeMode.css:50` |
| **Customize panel header** `#customization-panelHeader` | `1.3em` | `1.3×` base | `1.3×` | `calc(var(--tf-font-size) * 1.3)` | `customizeMode.css:459` |
| **Customize panel description** `#customization-panelDescription` | `1.1em` | `1.1×` base | `1.1×` | `calc(var(--tf-font-size) * 1.1)` | `customizeMode.css:453` |
| **Downloads item host/details** (`--downloads-item-font-size-factor`) | `calc(100% * 0.8)` | `0.8×` base | `0.8×` | `calc(var(--tf-font-size) * 0.8)` | `downloads/downloads.css:9`, `downloads.inc.css:142` |
| **Notification-icon badge** `.notification-anchor-icon` badge | `0.8em` / `0.75em` | `0.75–0.8×` base | `0.8×` | `calc(var(--tf-font-size) * 0.8)` | `notification-icons.css:222, 240` |
| **Relay integration header** `.relay-integration-header` | `2em` | `2.0×` base | `2.0×` | `calc(var(--tf-font-size) * 2)` | `browser-shared.css:1316` |
| **Relay header (variation)** `.relay-integration-header-variation` | `1.5em` | `1.5×` base | `1.5×` | `calc(var(--tf-font-size) * 1.5)` | `browser-shared.css:1345` |

\* `10px ÷ 13px` (macOS `font: menu` measures ~13px) ≈ `0.77`; it's a fixed badge
size, so `0.75×` is a sensible dial-relative stand-in.

\** `#sidebar-box` uses `rem` on purpose — Mozilla's comment: *"Default font size
is 11px on mac, so this is 12px."* As a **rem/token** ratio that's `12 ÷ 15 =
0.8×`; as a **chrome-base** ratio (its actual visual intent, 12px over an 11px
window) it's `1.09×`. trimfox wants the *chrome-base* reading → `~1.1×`. This is
the one row where the two bases visibly disagree; pick `1.1×`.

**28 chrome elements/selectors charted.** Roughly half (`menus, app-menu items,
toolbar buttons, tabs, dialogs, findbar`) sit at `1.0×` by inheritance — trimfox's
flat rule already nails them. The rest carry a genuine ratio.

---

## 4. Distinct ratios → the trimfox `calc()` ladder

Every distinct ratio above, rounded to a sane N:

| ratio band | rounded N | `calc(var(--tf-font-size) * N)` | who uses it |
|---|---|---|---|
| `0.73–0.77` | `0.75` | `* 0.75` | xsmall token, confirmation-hint, badges |
| `0.80` | `0.8` | `* 0.8` | downloads, notification badge |
| `0.85–0.867` | `0.85` | `* 0.85` | small token, urlbar results, tab sub-text, HTTPS-only |
| `0.90–0.93` | `0.9` | `* 0.9` | subview subheader, urlbar result-menu button |
| `1.00` | `1.0` | `var(--tf-font-size)` | **base**: menus, tabs, toolbar btns, dialogs, findbar |
| `1.09–1.10` | `1.1` | `* 1.1` | sidebar body, protections no-trackers, customize desc |
| `1.133` | `1.15` | `* 1.15` | large / heading-medium token |
| `1.20` | `1.2` | `* 1.2` | confirmation message, customize header |
| `1.25` | `1.25` | `* 1.25` | **urlbar field**, urlbar chiclet |
| `1.30` | `1.3` | `* 1.3` | protections title, customize panel header |
| `1.333` | `1.333` | `* 1.333` | sidebar header |
| `1.467–1.5` | `1.5` | `* 1.5` | xlarge / heading-large token, relay variation |
| `1.60` | `1.6` | `* 1.6` | xxlarge / heading-xlarge token |
| `2.00` | `2.0` | `* 2` | relay integration header |
| `2.20` | `2.2` | `* 2.2` | xxxlarge token |

---

## 5. FLAT (current) vs PROPORTIONAL (optional) mode

**FLAT — what trimfox does today.** `:root { font-size: var(--tf-font-size)
!important }` plus blanket `menupopup *, panel * { … !important }`, `#urlbar`,
`.urlbarView-results` etc. all pinned to `var(--tf-font-size)`. Every chrome
string renders at exactly `7pt`. This is deliberate: a dense, uniform chrome. The
in-file convention (`userChrome.css:37–40`) already anticipates proportional
(`header 25% larger → * 1.25`, `caption 10% smaller → * 0.9`).

**PROPORTIONAL — adopt the ratios above.** Keep `--tf-font-size` as the `1.0×`
dial, but let non-base elements carry their Firefox ratio via `calc()`. The base
tier (`menus, tabs, toolbar buttons, dialogs, findbar, app-menu items`) is
unchanged — it's already `1.0×`. **Only these elements would visibly change:**

| Element | Flat (now) | Proportional | Direction |
|---|---|---|---|
| URL bar field (`.urlbar`, `#searchbar`) | `1.0×` | `1.25×` | **larger** (most noticeable) |
| URL bar chiclet | `1.0×` | `1.25×` | larger |
| Sidebar header | `1.0×` | `1.333×` | larger |
| Sidebar body | `1.0×` | `1.1×` | slightly larger |
| Panel/customize headers, hints, protections title | `1.0×` | `1.1–1.3×` | larger |
| Relay headers | `1.0×` | `1.5–2.0×` | much larger |
| URL bar result url/action/secondary | `1.0×` | `0.85×` | **smaller** |
| Result-menu button | `1.0×` | `0.9×` | smaller |
| Subview subheader, tab overflow/suggestion text, downloads, HTTPS-only info, badges | `1.0×` | `0.75–0.9×` | smaller |

**Recommendation:** the single change with the most "feels like Firefox" payoff is
the **URL bar field at `1.25×`** (it's the one place FF deliberately enlarges
text). A middle path — proportional for the URL bar + panel headings, flat
everywhere else — keeps trimfox's density while restoring the one hierarchy cue
users actually read. A full proportional pass is a straight swap of the pinned
`var(--tf-font-size)` for the `calc(…)` in the tables above, gated behind a
`--tf-font-scale-mode` toggle if both modes should ship.
