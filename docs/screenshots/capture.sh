#!/usr/bin/env bash
# trimfox screenshot capture helper.
#
# Spins up a THROWAWAY Firefox profile with trimfox installed and neutral demo tabs,
# so README screenshots contain zero personal data (this avoids shooting your real
# profile, which has your tabs/bookmarks/history). Launches a separate Firefox
# instance; you capture the windows yourself.
#
# Light vs dark: trimfox follows the OS appearance ("System theme — auto"). Capture
# one pass, flip macOS  → System Settings → Appearance (Light/Dark), capture again.
# https://github.com/csmarshall/trimfox
unset TMOUT
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/../.." && pwd)"
FF="/Applications/Firefox.app/Contents/MacOS/firefox"
[[ -x "$FF" ]] || { echo "ERROR: Firefox not found at $FF" >&2; exit 1; }

PROFILE="$(mktemp -d -t trimfox-shots.XXXX)"
echo "Throwaway capture profile: $PROFILE"

# Install trimfox exactly as a real user would (chrome/ + user.js carry the theme AND
# its prefs — vertical tabs, System-auto theme, etc.).
cp -R "$REPO/chrome" "$PROFILE/chrome"
cp "$REPO/user.js" "$PROFILE/user.js"

# Capture-only prefs: quiet, clean, no telemetry/onboarding, no personal data.
cat >> "$PROFILE/user.js" <<'PREFS'

// ---- capture helper (throwaway profile) ----
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.aboutwelcome.enabled", false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.bookmarks.showMobileBookmarks", false);
user_pref("browser.toolbars.bookmarks.visibility", "never");
PREFS

# Lock the window to a fixed size so EVERY capture comes out identical. Firefox reads
# these bounds from xulstore.json on first launch — deterministic, no accessibility
# permissions needed. (A Retina display captures at 2x these logical pixels.)
WIN_W=1280; WIN_H=800
cat > "$PROFILE/xulstore.json" <<XUL
{
  "chrome://browser/content/browser.xhtml": {
    "main-window": {
      "screenX": "80", "screenY": "60",
      "width": "${WIN_W}", "height": "${WIN_H}",
      "sizemode": "normal"
    }
  }
}
XUL

# Neutral demo tabs — Mozilla Foundation front page first, then generic content.
"$FF" --no-remote --profile "$PROFILE" \
  "https://foundation.mozilla.org/" \
  "https://en.wikipedia.org/wiki/Firefox" \
  "https://github.com/csmarshall/trimfox" \
  "https://example.com/" \
  >/dev/null 2>&1 &

cat <<EOF

── capture checklist (macOS) ─────────────────────────────────────────────
The window opens pre-sized to ${WIN_W}×${WIN_H} — so every window-capture matches.
Grab just the window:  Shift+Cmd+4 → Space → click the Firefox window.
Save into:  $REPO/docs/screenshots/
Name:       <state>-<mode>.png     e.g.  tabstrip-collapsed-dark.png

  1. tabstrip-collapsed   — the skinny ~14px tab column (window capture)
  2. tabstrip-expanded    — hover the strip so labels appear, then window-capture
  3. menu-tab             — right-click a tab (menus need the timer grab, below)
  4. menu-history         — click-and-hold Back, then the timer grab (below)

Menus vanish when you enter Shift+Cmd+4, so grab them on a delay — open the menu,
leave it open, let a timed full-screen shot fire, then crop to the menu:
  screencapture -T 5 "$REPO/docs/screenshots/menu.png"   # open menu, wait 5s

Do all 4 in DARK, then flip System Settings → Appearance to Light and repeat.
If the tab strip is missing, open it once: View → Sidebar (menu bar).

When finished, delete the throwaway profile:
  rm -rf "$PROFILE"
──────────────────────────────────────────────────────────────────────────
EOF
