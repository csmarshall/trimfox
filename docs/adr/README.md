# Architecture Decision Records

Short records of the load-bearing decisions behind trimfox — the *why*, not just the *what*.
Lightweight [Nygard](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
format: **Context → Decision → Consequences**, plus a status. **Numbered in the order the
decisions were made** — earliest first; superseded ones stay (with a note) so the reasoning
history stays intact.

| # | Decision | Status |
|---|---|---|
| [0001](0001-design-philosophy.md) | Design philosophy: slim, get-out-of-the-way chrome for the experienced userChrome user (from a hand-modified ShadowFox) | Accepted |
| [0002](0002-collapse-expand-on-hover.md) | Collapse / expand-on-hover tab strip (cribbed from Tree Style Tab's collapsed theme) | Accepted |
| [0003](0003-themeable-xul-menus.md) | Force XUL menus so native macOS menus can be themed | Accepted |
| [0004](0004-native-vertical-tabs.md) | Native vertical tabs; retire Tree Style Tab | Accepted |
| [0005](0005-tf-token-palette-architecture.md) | `--tf-*` token vocabulary + swappable palettes | Accepted |
| [0006](0006-user-overrides-layer.md) | `user-overrides` layer: customize without forking | Accepted |
| [0007](0007-trimfox-drift-monitor.md) | trimfox-drift: catch Firefox private-chrome drift before it breaks | Accepted |

Rationale also lives in the README, inline CSS comments, and the issues.
