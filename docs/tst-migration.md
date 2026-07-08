# Migrating off Tree Style Tab

trimfox reproduces the **Tree Style Tab** (TST) collapsed vertical-tab look using Firefox's
*native* vertical tabs — no extension. This profile was migrated off TST once native vertical
tabs + expand-on-hover made the extension redundant (see
[ADR-0002](adr/0002-collapse-expand-on-hover.md) and [ADR-0004](adr/0004-native-vertical-tabs.md)).

## Where the old TST material went

The exported TST settings and userstyles this reskin was modeled on **aren't shipped** — they're
personal config, not needed to run trimfox — but they're preserved:

- **Git history.** `reference/tst-config.json` (exported TST settings) and
  `reference/tst-userstyles.css` (the TST userChrome styling) lived under `reference/` until they
  were removed. Recover them with `git log --all --diff-filter=D -- reference/` to find the
  commit, then `git show <commit>^:reference/tst-config.json`.
- **TST itself.** <https://github.com/piroor/treestyletab> — the extension, its wiki, and its own
  userChrome recipes.

## Where trimfox does what TST did

| In TST… | In trimfox (native) |
|---|---|
| Collapsed strip that expands on hover | `sidebar.visibility="expand-on-hover"` + the collapsed-strip CSS — see **Vertical-tabs reskin** in [tweak-catalog.md](tweak-catalog.md) |
| Faviconized pinned tabs | the `#13` pinned-grid rules in `chrome/userChrome.css` — **Pinned tabs** in [tweak-catalog.md](tweak-catalog.md) |
| Tab separators / row height | `--tab-min-height` + the separator rules — [customizing.md](customizing.md) |
| TST's config options | TST's own settings UI / wiki (linked above) |
