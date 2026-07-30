#!/usr/bin/env bash
# ============================================================================
# promote.sh — push the repo's chrome/ (and optionally user.js) INTO a live
#              Firefox profile. The repo is the source of truth; you edit here
#              and promote into the profile, never the reverse.
#
# Protects personal, gitignored files in the profile:
#   - chrome/user-overrides.css   (your --tf-* overrides)
#   - user-overrides.js           (your personal prefs, incl. devtools)
#
# Usage:
#   tools/promote.sh [--profile DIR] [--with-userjs] [--dry-run] [--no-backup]
#
#   --profile DIR    target profile (default: $TRIMFOX_PROFILE or the toad path)
#   --with-userjs    also copy user.js (then re-append user-overrides.js so your
#                    personal prefs stay the last word)
#   --dry-run        show what would change, copy nothing
#   --no-backup      skip the timestamped backup of the profile's chrome/
#
# After a promote: fully quit Firefox (Cmd+Q) and relaunch — userChrome.css is
# parsed once at startup, there is no hot reload.
# ============================================================================
unset TMOUT
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DEFAULT_PROFILE="/Users/charles/Library/Application Support/Firefox/Profiles/kwwdkrt4.default-1548787295256"
PROFILE="${TRIMFOX_PROFILE:-$DEFAULT_PROFILE}"
WITH_USERJS=0
DRY_RUN=0
BACKUP=1

log() { printf '%s [%s] %s\n' "$(date +'%F %T')" "$1" "$2"; }
die() { log ERROR "$1"; exit "${2:-1}"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile)     PROFILE="${2:?--profile needs a path}"; shift 2 ;;
    --with-userjs) WITH_USERJS=1; shift ;;
    --dry-run)     DRY_RUN=1; shift ;;
    --no-backup)   BACKUP=0; shift ;;
    -h|--help)     sed -n '2,25p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *)             die "unknown arg: $1 (try --help)" 2 ;;
  esac
done

[[ -d "$REPO_ROOT/chrome" ]] || die "repo chrome/ not found at $REPO_ROOT/chrome"
[[ -d "$PROFILE" ]]          || die "profile not found: $PROFILE"

log INFO "repo:    $REPO_ROOT"
log INFO "profile: $PROFILE"

# --- pre-flight sanity on the source we're about to ship --------------------
UC="$REPO_ROOT/chrome/userChrome.css"
if [[ -f "$UC" ]]; then
  OPEN=$(grep -o '{' "$UC" | wc -l | tr -d ' ')
  CLOSE=$(grep -o '}' "$UC" | wc -l | tr -d ' ')
  CO=$(grep -o '/\*' "$UC" | wc -l | tr -d ' ')
  CC=$(grep -o '\*/' "$UC" | wc -l | tr -d ' ')
  [[ "$OPEN" == "$CLOSE" ]] || die "userChrome.css brace mismatch: { =$OPEN  } =$CLOSE"
  [[ "$CO" == "$CC" ]]      || die "userChrome.css comment mismatch: /* =$CO  */ =$CC (nested comment?)"
  log INFO "pre-flight OK: braces $OPEN/$CLOSE, comments $CO/$CC"
fi

RSYNC_FLAGS=(-a --delete
  --exclude 'user-overrides.css'   # personal — never overwrite/delete
  --exclude '.DS_Store')
[[ $DRY_RUN -eq 1 ]] && RSYNC_FLAGS+=(-n)
RSYNC_FLAGS+=(-i)                  # itemize changes

# --- backup the profile's chrome/ before we touch it ------------------------
if [[ $BACKUP -eq 1 && $DRY_RUN -eq 0 && -d "$PROFILE/chrome" ]]; then
  STAMP="$(date +'%F-%H%M.%S')"
  BAK="$PROFILE/chrome.bak-$STAMP"
  cp -a "$PROFILE/chrome" "$BAK"
  log INFO "backed up profile chrome/ -> $BAK"
fi

# --- the promote ------------------------------------------------------------
log INFO "syncing chrome/  (repo -> profile)$([[ $DRY_RUN -eq 1 ]] && echo '  [DRY RUN]')"
rsync "${RSYNC_FLAGS[@]}" "$REPO_ROOT/chrome/" "$PROFILE/chrome/"

if [[ $WITH_USERJS -eq 1 ]]; then
  log INFO "syncing user.js  (repo -> profile)$([[ $DRY_RUN -eq 1 ]] && echo '  [DRY RUN]')"
  if [[ $DRY_RUN -eq 0 ]]; then
    cp "$REPO_ROOT/user.js" "$PROFILE/user.js"
    if [[ -f "$PROFILE/user-overrides.js" ]]; then
      { printf '\n// --- appended by promote.sh from user-overrides.js ---\n';
        cat "$PROFILE/user-overrides.js"; } >> "$PROFILE/user.js"
      log INFO "re-appended user-overrides.js (your personal prefs win)"
    fi
  fi
fi

log INFO "done. Quit Firefox (Cmd+Q) and relaunch for changes to take."
