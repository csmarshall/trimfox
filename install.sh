#!/usr/bin/env bash
# trimfox installer — copy chrome/ (userChrome.css, userContent.css, assets) and
# user.js into a Firefox profile, backing up anything it replaces.
# https://github.com/csmarshall/trimfox
unset TMOUT
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"

usage() {
  cat <<EOF
trimfox installer

Usage: ${0##*/} [-p PROFILE_DIR] [-n] [-h]

  -p PROFILE_DIR   Target Firefox profile directory.
                   Default: auto-detected default profile (macOS / Linux).
  -n               Dry run — print actions, change nothing.
  -h               This help.

Installs (existing files backed up to <name>.bak-${TS} first):
  chrome/   -> PROFILE_DIR/chrome/
  user.js   -> PROFILE_DIR/user.js

After installing: fully quit Firefox (Cmd+Q / close all windows) and relaunch —
userChrome.css and user.js only load at startup.
EOF
}

PROFILE=""
DRYRUN=0
while getopts ":p:nh" opt; do
  case "$opt" in
    p) PROFILE="$OPTARG" ;;
    n) DRYRUN=1 ;;
    h) usage; exit 0 ;;
    \?) echo "Unknown option: -$OPTARG" >&2; usage; exit 2 ;;
    :)  echo "Option -$OPTARG requires an argument" >&2; exit 2 ;;
  esac
done

ff_root() {
  case "$(uname -s)" in
    Darwin) echo "$HOME/Library/Application Support/Firefox" ;;
    Linux)  echo "$HOME/.mozilla/firefox" ;;
    *)      echo "" ;;
  esac
}

# Resolve the default profile from profiles.ini (prefer [Install*] Default=,
# else the [Profile*] marked Default=1).
detect_profile() {
  local root ini path
  root="$(ff_root)"; [ -n "$root" ] || return 1
  ini="$root/profiles.ini"; [ -f "$ini" ] || return 1
  path="$(awk '
    /^\[Install/{i=1} /^\[Profile/{i=0}
    i && /^Default=/{sub(/^Default=/,"");print;exit}' "$ini")"
  if [ -z "$path" ]; then
    path="$(awk '
      /^\[Profile/{p="";d=0}
      /^Path=/{sub(/^Path=/,"");p=$0}
      /^Default=1/{d=1}
      d&&p{print p;exit}' "$ini")"
  fi
  [ -n "$path" ] || return 1
  case "$path" in
    /*) echo "$path" ;;
    *)  echo "$root/$path" ;;
  esac
}

[ -n "$PROFILE" ] || PROFILE="$(detect_profile || true)"
if [ -z "$PROFILE" ] || [ ! -d "$PROFILE" ]; then
  echo "ERROR: could not determine a valid Firefox profile directory." >&2
  echo "Pass one explicitly:  ${0##*/} -p /path/to/profile" >&2
  exit 1
fi

echo "trimfox -> $PROFILE"
[ "$DRYRUN" = 1 ] && echo "(dry run — no changes will be made)"

backup() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "  backup:  $(basename "$target") -> $(basename "$target").bak-${TS}"
    [ "$DRYRUN" = 1 ] || mv "$target" "${target}.bak-${TS}"
  fi
}

install_item() {
  local src="$1" dst="$2"
  [ -e "$src" ] || { echo "  skip (missing in repo): $(basename "$src")"; return; }
  backup "$dst"
  echo "  install: $(basename "$dst")"
  [ "$DRYRUN" = 1 ] || cp -Rp "$src" "$dst"
}

install_item "$SCRIPT_DIR/chrome"  "$PROFILE/chrome"
install_item "$SCRIPT_DIR/user.js" "$PROFILE/user.js"

# Personal overrides (chrome/user-overrides.css) are per-user + gitignored; the repo
# never ships one. The theme @imports it, so preserve the user's existing file across
# a re-install (it was moved into the chrome.bak-${TS} backup above), else seed it from
# the template so the @import resolves cleanly.
if [ "$DRYRUN" = 1 ]; then
  echo "  overrides: preserve-or-seed chrome/user-overrides.css"
else
  overrides="$PROFILE/chrome/user-overrides.css"
  prior="$PROFILE/chrome.bak-${TS}/user-overrides.css"
  rm -f "$overrides"
  if [ -f "$prior" ]; then
    cp -p "$prior" "$overrides"
    echo "  overrides: restored your existing chrome/user-overrides.css"
  else
    cp "$PROFILE/chrome/user-overrides.example.css" "$overrides"
    echo "  overrides: seeded chrome/user-overrides.css from the template"
  fi
fi

cat <<EOF

Done.
  1. Fully quit Firefox (Cmd+Q on macOS / close all windows), then relaunch.
  2. user.js sets toolkit.legacyUserProfileCustomizations.stylesheets=true; the
     restart is what makes userChrome.css take effect.
  3. No vertical-tab strip but the chrome IS themed? The sidebar panel is closed on
     this profile — open it once via View -> Sidebar (trimfox hides the toggle
     button); the tab strip appears and stays after you close the panel.
  4. For light/dark to follow the OS: about:addons -> Themes -> "System theme - auto".
EOF
