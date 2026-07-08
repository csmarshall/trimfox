# Screenshots

Source screenshots for the README gallery live here. They're captured from a
**throwaway** Firefox profile (never a real one) so no personal data ships in a
public repo.

## Capture

```sh
./docs/screenshots/capture.sh
```

It installs trimfox into a temp profile, opens neutral demo tabs (Mozilla
Foundation front page + generic content), and prints a checklist. Capture each
state in **dark**, flip macOS Appearance to **light**, repeat. Save the PNGs here
using `<state>-<mode>.png`:

| file | shows | how to capture |
|---|---|---|
| `tabstrip-collapsed-{dark,light}.png` | the skinny ~14px tab column (the headline) | window capture: `Shift+Cmd+4` → Space → click the window |
| `tabstrip-expanded-{dark,light}.png`  | hover state — labels revealed | hover the strip so it widens, then window-capture |
| `menu-tab-{dark,light}.png`           | the themed tab right-click menu | right-click a tab, then the **timer** capture below |
| `menu-history-{dark,light}.png`       | the themed back/forward history menu | click-and-hold **Back**, then the **timer** capture below |

Menus dismiss the instant you enter `Shift+Cmd+4`, so capture them on a delay — open the
menu, leave it open, and let a timed full-screen grab fire, then crop to the menu:

```sh
screencapture -T 5 ~/Desktop/menu.png   # open the menu, wait 5s; crop after
```

## Why both modes

trimfox supports light and dark (it follows the OS via "System theme — auto").
Showing both in the README proves that at a glance.

Captures come **pre-sized** — the helper locks the window to a fixed size (1280×800 logical
px, via `xulstore.json`), so every shot shares dimensions and light/dark pairs line up.

Once the PNGs are here, they get laid into the top of the main README as a gallery —
**dark first, then light** (trimfox's default is dark) — with the collapsed-vs-expanded
tab-strip pair leading (that's the money shot).
