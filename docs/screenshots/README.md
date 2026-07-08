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

| file | shows |
|---|---|
| `tabstrip-collapsed-{dark,light}.png` | the skinny ~14px tab column (the headline) |
| `tabstrip-expanded-{dark,light}.png`  | hover state — labels revealed |
| `window-overview-{dark,light}.png`    | the whole restyled chrome |
| `findbar-{dark,light}.png`            | the compact refined find bar (`Cmd+F`) |
| `urlbar-nav-{dark,light}.png`         | toolbar + unified nav button close-up |

## Why both modes

trimfox supports light and dark (it follows the OS via "System theme — auto").
Showing both in the README proves that at a glance.

Captures come **pre-sized** — the helper locks the window to a fixed size
(`xulstore.json`), so every shot shares dimensions and light/dark pairs line up.

Once the PNGs are here, they get laid into the top of the main README as a gallery —
**dark first, then light** (trimfox's default is dark) — with the collapsed-vs-expanded
tab-strip pair leading (that's the money shot).
