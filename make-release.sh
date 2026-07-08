#!/usr/bin/env bash
# trimfox release packager — build a clean, single-file zip for end users.
# Ships only what someone needs to install the theme (chrome/, user.js, the
# installer, docs) — not the dev cruft (pickers, drift notes, .github/, reference/).
# https://github.com/csmarshall/trimfox
unset TMOUT
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

usage() {
  cat <<EOF
trimfox release packager

Usage: ${0##*/} [VERSION]

  VERSION   Version string for the zip name (e.g. 1.0.0).
            Default: latest git tag, else today's date.

Produces: dist/trimfox-<VERSION>.zip
  A single folder 'trimfox/' containing the theme + installer + a QUICKSTART.
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }

VERSION="${1:-$(git describe --tags --abbrev=0 2>/dev/null || date +%Y.%m.%d)}"
VERSION="${VERSION#v}"   # normalize a leading v
STAGE="$(mktemp -d)"
PKG="$STAGE/trimfox"
OUT="$SCRIPT_DIR/dist/trimfox-${VERSION}.zip"

# Files a user actually needs. Anything not listed stays out of the zip.
INCLUDE=(
  chrome
  user.js
  user-overrides.example.js
  install.sh
  README.md
  SETTINGS.md
  CONTRIBUTING.md
  LICENSE
  logo.png
  wordmark.png
  palette.html
  tint-picker.html
  docs
  reference
)

echo "trimfox release: v${VERSION}"
mkdir -p "$PKG" "$SCRIPT_DIR/dist"
for item in "${INCLUDE[@]}"; do
  if [[ -e "$item" ]]; then
    mkdir -p "$PKG/$(dirname "$item")"   # preserve nested paths (e.g. docs/screenshots)
    cp -R "$item" "$PKG/$item"
  else
    echo "  WARNING: missing '$item' — skipping" >&2
  fi
done

# Dead-simple quickstart at the zip root, for people who won't read a full README.
cat > "$PKG/QUICKSTART.txt" <<EOF
trimfox — quick start (macOS)
=============================

1. Fully quit Firefox (Cmd+Q).

2. Install the theme. In Terminal, from this folder:

       ./install.sh

   (It copies chrome/ and user.js into your default Firefox profile,
   backing up anything it replaces. Run './install.sh -h' for options,
   or '-n' for a dry run.)

3. Relaunch Firefox. userChrome.css and user.js only load at startup.

Prefer to do it by hand, or on Linux? See README.md ("Install").
Prefs are documented in SETTINGS.md; the --tf-* tuning knobs are in README.md
and chrome/dials.css.

trimfox is a userChrome theme — it restyles Firefox's own chrome. No add-on,
no extension. Requires toolkit.legacyUserProfileCustomizations.stylesheets,
which user.js enables for you.
EOF

# Screenshots are referenced from GitHub (absolute URLs in the README), not bundled — this
# keeps the zip small (~a couple hundred KB instead of ~3 MB). The capture script and notes
# stay; only the PNGs are dropped.
rm -f "$PKG"/docs/screenshots/*.png

( cd "$STAGE" && zip -r -q "$OUT" trimfox )
rm -rf "$STAGE"

echo "  wrote: ${OUT#"$SCRIPT_DIR"/}  ($(du -h "$OUT" | cut -f1))"
echo "  contents:"
unzip -l "$OUT" | awk 'NR>3 && $4!="" {print "    " $4}' | head -40
