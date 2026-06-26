# Draft Bugzilla report

Not yet filed — ready to paste into <https://bugzilla.mozilla.org/>.
Suggested product/component: **Core → Widget: Cocoa**.

---

**Summary:** Back/forward button history menu renders as a native macOS menu
(ignores userChrome.css) even with `widget.macos.native-context-menus=false`

**Platform:** macOS, Firefox 152.0.3

**Steps to reproduce:**
1. `toolkit.legacyUserProfileCustomizations.stylesheets = true`
2. `widget.macos.native-context-menus = false`
3. In `chrome/userChrome.css`:
   `menupopup, menupopup * { font-size: 7pt !important; background: red !important; }`
4. Restart Firefox.
5. Right-click a page → the context menu honors the CSS (small red items). ✓
6. Click-and-hold the **Back** (or Forward) button → the history dropdown.

**Actual result:** the history dropdown ignores the CSS entirely — default
(system) font size, no red background. Verified in the Browser Toolbox
(parent-process console):
- Its `menuitem[uri]` / `menuitem[historyindex]` items report
  `getBoundingClientRect().height === 0` while the menu is visibly open
  (context-menu items report real heights).
- A live-injected stylesheet setting `background: red`, `color: lime`,
  `font-size: 7pt`, and `appearance: none !important` on those items has **no
  visual effect** — the same injection reddens the right-click context menu.

i.e. the menu is being drawn as a native macOS menu; CSS cannot reach it.

**Expected result:** with `widget.macos.native-context-menus = false`, the
back/forward history menu should render as a XUL menu and honor userChrome.css,
consistent with right-click context menus — **or** there should be a pref to
control it, as there is for context menus (`widget.macos.native-context-menus`)
and `<select>` popups (`widget.non-native-theme.enabled`). Button-anchored popup
menus currently have no equivalent toggle.

**Notes / related:**
- Bug 1712734 — native context menus don't honor userChrome.css (about context
  menus with the pref *on*; this report is a *button* menu that's native with
  the pref *off*).
- Bug 1698997 — initial native context-menu support.
- The `appearance: none` workaround that disables native macOS window-control
  buttons (revealing XUL `.titlebar-button`s) does **not** work here — there's no
  XUL menupopup twin to reveal.
