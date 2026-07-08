# Draft Bugzilla report

Not yet filed — ready to paste into <https://bugzilla.mozilla.org/>.
Suggested product/component: **Core → Widget: Cocoa** (documentation / support request).

> **History:** an earlier version of this draft reported the back/forward history menu as
> *unreachable* by userChrome.css. It turns out it isn't — `widget.macos.native-anchored-menus=false`
> makes it themeable. So this is no longer a "can't be done" bug; it's a request to
> **document and support that pref**, which is currently undiscoverable.

---

**Summary:** `widget.macos.native-anchored-menus` — the pref that makes button-anchored
popups (the back/forward history menu, the URL-bar dropdown) themeable via userChrome.css on
macOS — is undocumented and carries no apparent support guarantee.

**Platform:** macOS, Firefox 152.0.x

**Background:** On macOS, button-anchored popup menus render as *native* macOS menus by
default, so `userChrome.css` can't reach them — unlike right-click context menus, which
`widget.macos.native-context-menus=false` already makes themeable. The most visible case is
the **back/forward history menu** (click-and-hold Back/Forward).

**What works:** setting **`widget.macos.native-anchored-menus=false`** renders these
button-anchored menus as XUL, and userChrome.css then styles them normally (verified: the
history menu and the URL-bar dropdown both take custom `font-size`/`background`/etc., exactly
like a right-click context menu with `native-context-menus=false`). This is precisely the
toggle that appeared to be missing.

**Request:** please **document and/or officially bless** `widget.macos.native-anchored-menus`,
parallel to `widget.macos.native-context-menus`. Today it's undiscoverable, and being
undocumented it could change or be removed without notice — themes that rely on it to keep
these menus visually consistent with the rest of the chrome have no stability guarantee.

**Notes / related:**
- Bug 1712734 — native context menus don't honor userChrome.css.
- Bug 1698997 — initial native context-menu support.
- `widget.macos.native-context-menus` (right-click menus) and `widget.non-native-theme.enabled`
  (`<select>` popups) are the analogous, better-known toggles; `native-anchored-menus` is the
  button-anchored-popup equivalent and deserves the same visibility.
