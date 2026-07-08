<!-- Extracted from the README to keep it scannable. The --tf-* tuning dials. -->

# Tuning knobs

Colors come from the [palette](../README.md#palette). Everything else is driven by `--tf-*`
dials, each defined in a labeled `:root` block right above the feature it controls
in `chrome/userChrome.css`:

| Knob | Default | What it controls |
|------|---------|------------------|
| **Font** | | |
| `--tf-font-family` | `-apple-system` | chrome-wide typeface |
| `--tf-font-size` | `7pt` | chrome-wide base size (the 1.0× anchor; everything scales from it) |
| `--tf-fs-lift` | `1` | `1` = full proportional (FF's hierarchy), `0` = middle path, fractions blend |
| `--tf-fs-field` / `-md` / `-h` / … | `1.1×` … | per-tier `calc()` ratios (see [`docs/font-hierarchy.md`](https://github.com/csmarshall/trimfox/blob/main/docs/font-hierarchy.md)) |
| **Tab strip** | | |
| `--tab-min-height` | `22px` | row height |
| `--tab-collapsed-background-width` | `14px` | collapsed strip width |
| `--tf-sep-inset` | `1px` | tab-separator inline-start inset (clears the macOS frame) |
| **Pinned grid** (`#13`) | | |
| `--tf-pin-size` | `22px` | faviconized pin square |
| `--tf-pin-favicon` | `14px` | favicon inside the square |
| `--tf-pin-pitch` / `-pitch-n` | `24px` / `24` | pin-to-pin step (px + unitless) |
| `--tf-pin-area-width` | `230` | fallback grid width (auto-fit overrides via `@container`) |
| `--tf-pin-row-inset` | `4px` | left inset of pin #1 |
| **History menu** (tab-strip skin) | | |
| `--tf-hist-row-pad-block` / `-inline` | `2px` / `8px` | per-row padding |
| `--tf-hist-end-pad` | `6px` | extra pad at the menu's top/bottom rows |
| `--tf-hist-favicon` | `16px` | favicon column size |
| `--tf-hist-accent-width` / `-color` | `3px` / `--tf-glyph` | active-row left accent bar |
| **Loading indicator** | | |
| `--tf-load-fill` / `-opacity` / `-speed` | `--tf-accent` / `0.6` / `1.4s` | busy-tab fill wash |
| **Container markers** (`#12`) | | |
| `--tf-container-collapsed-flag` | `block` | `none` = hide the pill in the collapsed strip |

The dividers, separators, and container markers use `:-moz-window-inactive` so they
dim when the window loses focus, matching the rest of the themed chrome.

