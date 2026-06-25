# trimfox

A minimal Firefox `userChrome` setup built around **native vertical tabs** — no
Tree Style Tab, no sidebar extension, just the browser's own chrome restyled to
get out of the way.

The headline is the tab strip: collapsed, it's a skinny ~14px column of separator
lines that just tells you how many tabs are open; hover it and it expands to
readable labels. No favicons when collapsed, no pills, no close buttons, no
new-tab button, no hover-preview cards, no launcher clutter.

It's called *trimfox* because that's the point — trim everything that isn't a tab.

## Requirements

- **Firefox 136+** (native vertical tabs); developed and verified on **152**.
- macOS or Linux. Tuned on macOS with a Photon-style dark lightweight theme; the
  separator/divider colors assume a dark sidebar.

## Install

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

To revert: restore the `.bak-*` files (or delete `chrome/` and `user.js`) and
restart.

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

## Tuning knobs

Most of the look is driven from a few spots near the top of the vertical-tabs
section in `chrome/userChrome.css`:

| Knob | What it controls |
|------|------------------|
| `--tab-collapsed-background-width` | collapsed strip width (default `14px`) |
| `--tab-min-height` | row height (default `22px`) |
| `.tabbrowser-tab` `border-bottom` alpha | separator brightness |
| `.tab-background` selected `background-color` | active-tab highlight |
| `#sidebar-main` / `#vertical-tabs` `border-inline-end` | right divider color |

The divider and separators use `:-moz-window-inactive` so they dim when the
window loses focus, matching the rest of the themed chrome.

## reference/

`reference/` documents the migration *off* Tree Style Tab — the exported TST
user stylesheet and config that the native setup was modeled on. It's a record,
not something you install.

## License

MIT — see [LICENSE](LICENSE).
