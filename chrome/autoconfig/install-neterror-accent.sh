#!/usr/bin/env bash
#
# install-neterror-accent.sh
#
# Restyle Firefox error-page primary buttons (about:neterror / about:certerror /
# about:blocked / about:httpsonlyerror) from Firefox's built-in teal accent to
# trimfox's gray (#707070).
#
# THIS IS THE ONE OPT-IN STEP IN ALL OF TRIMFOX
#   trimfox's userChrome.css + userContent.css already skin essentially every surface
#   CSS can reach — chrome, toolbars, menus, the urlbar, and every in-content about:
#   page. That's ~100% of the browser, no script required. Error pages are the one
#   surface CSS legally can't touch (see WHY below). Run this ONLY if you want the
#   entire interface, error pages included, in the grayscale palette. Skip it and
#   trimfox is still fully themed everywhere CSS reaches; this just closes the last gap.
#
# WHY THIS EXISTS
#   Error pages load in a privileged context that does NOT inject userContent.css,
#   so they can't be themed the normal way. The only mechanism that reaches them is
#   an AutoConfig (.cfg) script that registers a global USER_SHEET via
#   nsIStyleSheetService. AutoConfig files MUST live inside the Firefox.app bundle:
#     <App>/Contents/Resources/defaults/pref/autoconfig-neterror.js
#     <App>/Contents/Resources/firefox.cfg
#
# TRADE-OFFS — know these before you opt in
#   - Sandbox off: AutoConfig only runs with general.config.sandbox_enabled=false, so
#     firefox.cfg executes with full chrome privileges for as long as this is installed.
#     -u removes the pref and the .cfg and restores the default.
#   - Lives inside the app bundle: both files sit under Firefox.app itself, which Firefox
#     updates overwrite — see UPDATES.
#
# UPDATES: Firefox updates overwrite the app bundle and wipe these files. Just
#   re-run this script after a Firefox update to reapply. (It's idempotent.)
#
# USAGE
#   ./install-neterror-accent.sh           Install.
#   ./install-neterror-accent.sh -u        Uninstall.
#   ./install-neterror-accent.sh -h        Help.
#     -a PATH   Path to Firefox.app (default: /Applications/Firefox.app)

set -euo pipefail
unset TMOUT

APP="/Applications/Firefox.app"
UNINSTALL=0

log() { printf '%s [%s] %s\n' "$(date +"%F %T")" "$1" "$2"; }
usage() { sed -n '/^# USAGE/,/^$/p' "$0" | sed 's/^# \{0,1\}//'; }

while getopts ":a:uh" opt; do
  case "$opt" in
    a) APP="$OPTARG" ;;
    u) UNINSTALL=1 ;;
    h) usage; exit 0 ;;
    :) log ERROR "Option -$OPTARG requires an argument."; exit 2 ;;
    *) log ERROR "Unknown option: -$OPTARG"; usage; exit 2 ;;
  esac
done

RES="$APP/Contents/Resources"
PREF_DIR="$RES/defaults/pref"
PREF_FILE="$PREF_DIR/autoconfig-neterror.js"
CFG_FILE="$RES/firefox.cfg"

if [[ ! -d "$APP" ]]; then
  log ERROR "Firefox.app not found at: $APP  (use -a to point at it)"
  exit 1
fi

if [[ "$UNINSTALL" -eq 1 ]]; then
  rm -f "$PREF_FILE" "$CFG_FILE"
  log INFO "Removed $PREF_FILE"
  log INFO "Removed $CFG_FILE"
  log INFO "Fully quit Firefox (Cmd+Q) and relaunch to revert to the default accent."
  exit 0
fi

if [[ ! -w "$RES" ]]; then
  log ERROR "No write permission to: $RES — the Firefox.app bundle must be writable."
  exit 1
fi

mkdir -p "$PREF_DIR"

cat > "$PREF_FILE" <<'PREF_EOF'
// Managed by install-neterror-accent.sh — do not edit by hand.
// Enable AutoConfig (firefox.cfg) with full chrome privileges, plaintext.
pref("general.config.filename", "firefox.cfg");
pref("general.config.obscure_value", 0);
pref("general.config.sandbox_enabled", false);
PREF_EOF
log INFO "Wrote $PREF_FILE"

cat > "$CFG_FILE" <<'CFG_EOF'
// AutoConfig: the FIRST LINE IS ALWAYS IGNORED by the parser — do not remove it.
// Managed by install-neterror-accent.sh — do not edit by hand.
//
// Registers a global USER_SHEET (the only style origin that reaches privileged
// error pages) overriding the in-content accent design tokens so primary buttons
// render as #707070 gray instead of Firefox's teal. USER_SHEET + !important beats
// the chrome author tokens. (If this ever fails to take effect, change USER_SHEET
// to AGENT_SHEET below — UA-important is the strongest origin.)
try {
  var sss = Components.classes["@mozilla.org/content/style-sheet-service;1"]
              .getService(Components.interfaces.nsIStyleSheetService);
  var ios = Components.classes["@mozilla.org/network/io-service;1"]
              .getService(Components.interfaces.nsIIOService);

  var css = [
    '@-moz-document url-prefix("about:neterror"),',
    '               url-prefix("about:certerror"),',
    '               url-prefix("about:blocked"),',
    '               url-prefix("about:httpsonlyerror") {',
    '  :root {',
    '    --color-accent-primary: #707070 !important;',
    '    --color-accent-primary-hover: #808085 !important;',
    '    --color-accent-primary-active: #606065 !important;',
    '    --button-background-color-primary: #707070 !important;',
    '    --button-background-color-primary-hover: #808085 !important;',
    '    --button-background-color-primary-active: #606065 !important;',
    '    --focus-outline-color: #707070 !important;',
    '    accent-color: #707070 !important;',
    '  }',
    '}'
  ].join('\n');

  var uri = ios.newURI('data:text/css;charset=utf-8,' + encodeURIComponent(css));
  if (!sss.sheetRegistered(uri, sss.USER_SHEET)) {
    sss.loadAndRegisterSheet(uri, sss.USER_SHEET);
  }
} catch (e) {
  Components.utils.reportError("[neterror-accent.cfg] " + e);
}
CFG_EOF
log INFO "Wrote $CFG_FILE"

log INFO "Done. Cmd+Q Firefox, relaunch, load http://adjal/ — Try Again button should be gray."
log INFO "Re-run this script after any Firefox update (it overwrites the bundle)."
