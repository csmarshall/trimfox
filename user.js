// ============================================================================
// user.js  —  managed by trimfox (https://github.com/csmarshall/trimfox)
// Firefox reads this at every startup and applies it OVER prefs.js.
// Firefox never writes to this file, so these values are pinned.
// Created: 2026-06-25
// ============================================================================

// ============================================================================
// 1. REQUIRED — enable the reskin
// Without these, userChrome.css won't load and vertical tabs won't appear.
// ============================================================================

// --- Required for userChrome.css / userContent.css to load -----------------
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Native vertical tabs  (replacing Tree Style Tab — TST kept installed as
// fallback; set sidebar.verticalTabs=false to revert).
// Pref names/defaults verified against Firefox 152.0.3 omni.ja.
// Derived from TST config: maxTreeLevel=0 (flat), animation=false,
// width~240px, left side, Photon theme, system color scheme.
//
// Enable the revamped sidebar + vertical tabs
user_pref("sidebar.revamp", true);                 // default false
user_pref("sidebar.verticalTabs", true);           // default false

// Drop the rounded/inset content area — it adds a dark gutter we don't want
user_pref("sidebar.revamp.round-content-area", false);  // default true

// ============================================================================
// 2. APPEARANCE & COLOR
// Theming — how trimfox looks: menus, color scheme/theme, highlight, density.
// ============================================================================

// XUL menus — swap native macOS menus (un-styleable) to styleable XUL so userChrome.css
// can theme them. Covers right-click CONTEXT menus AND ANCHORED menus (the urlbar dropdown
// + the click-and-hold Back/Forward HISTORY menu — the one #6 thought had no pref!).
user_pref("widget.macos.native-context-menus", false);       // default true (right-click menus)
user_pref("widget.macos.native-anchored-menus", false);      // default true (anchored/button menus)

// Chrome color scheme must FOLLOW THE OS for trimfox's light/dark palette to
// auto-switch. The chrome prefers-color-scheme is set by the ACTIVE Firefox
// THEME, not by macOS directly — so trimfox ships on "System theme — auto"
// (default-theme@mozilla.org) with toolbar/content-theme = 2 (auto). A built-in
// "Dark"/"Light" theme hardcodes the scheme and pins the palette; auto lets
// @media (prefers-color-scheme) in palettes/*.css track macOS Appearance.
// (trimfox overrides every chrome color regardless, so this only affects which
// light/dark palette engages — not the look otherwise.)
// NOTE: the active theme is owned by the Add-ons Manager; if these prefs don't
// take, switch it once in about:addons → Themes → "System theme — auto".
user_pref("browser.theme.toolbar-theme", 2);   // 0=dark 1=light 2=auto(OS)
user_pref("browser.theme.content-theme", 2);
user_pref("extensions.activeThemeID", "default-theme@mozilla.org");

// Override the OS Highlight system color so native widgets / selection stay
// grayscale. This is a PREF (static, cross-platform), so it can't reference the
// --tf-* palette or switch with light/dark — it needs one MODE-AGNOSTIC mid-gray
// that reads in both. #919093 fits that; #808080 (= --tf-accent-hover) is the
// nearest palette-token value if you prefer a conceptual link.
// Companion: set ui.highlighttext to force the text-on-highlight color (default here).
user_pref("ui.highlight", "#919093");

// Compact UI / layout  (part of the trimmed look)
user_pref("browser.tabs.inTitlebar", 1);                     // tabs/chrome integrate with the titlebar
                                                             // (trimfox removes the native window
                                                             // controls via userChrome.css)
user_pref("browser.uidensity", 1);                           // compact density
user_pref("browser.compactmode.show", true);                 // expose the Compact option in Settings

// OPTIONAL: force all WEB CONTENT to dark regardless of OS appearance (0=dark, 1=light, 2=auto).
// Leave commented to let pages follow the system. NOTE: if you set this to 0 and then switch
// macOS to Light, the trimfox CHROME goes light but web pages stay dark — that's this pref, not
// a theme bug.
// user_pref("layout.css.prefers-color-scheme.content-override", 0);

// ============================================================================
// 3. BEHAVIOR
// How the sidebar/tabs act, not how they look.
// ============================================================================

// Collapse to a favicon strip, expand on hover (your TST autohide behavior)
user_pref("sidebar.visibility", "expand-on-hover"); // was "hide-sidebar"
user_pref("sidebar.expandOnHover", true);           // default true (assert it)

// Sidebar on the left (TST sidebarPosition=1)
user_pref("sidebar.position_start", true);          // default true (assert it)

// Snappy, no slide animation (TST animation=false)
user_pref("sidebar.animation.enabled", false);      // default true

// Make hover-expand instant — no delay, no slide (the 200ms delay made the
// hover target feel small/finicky vs TST's instant expand).
user_pref("sidebar.animation.expand-on-hover.delay-duration-ms", 0);  // default 200
user_pref("sidebar.animation.expand-on-hover.duration-ms", 0);        // default 400

// The launcher (sidebar tool/extension icon strip) is hidden via userChrome.css,
// so this list is purely cosmetic — left empty. Set to taste if you re-show it,
// e.g. "history,bookmarks,aichat" or your own extension IDs.
user_pref("sidebar.main.tools", "");

// NOTE: expanded sidebar width has no clean pref — drag the sidebar edge to
// ~240px once and Firefox persists it. Collapsed-strip width (the hover target)
// is a CSS tweak we'll do in the live-inspect pass if it still feels narrow.

// Kill the tab hover-preview card (the popup that shows the tab title/thumbnail
// to the right when you hover a tab). Hovering expands the bar to show labels
// anyway, so the card is redundant.
user_pref("browser.tabs.hoverPreview.enabled", false);          // default true
user_pref("browser.tabs.hoverPreview.showThumbnails", false);

user_pref("browser.toolbars.bookmarks.visibility", "never"); // no bookmarks toolbar
user_pref("browser.tabs.closeWindowWithLastTab", false);     // closing the last tab keeps the window

// Content fonts  (the *chrome* is forced to 7pt by userChrome.css; these are
// the default web-page fonts)
user_pref("font.size.variable.x-western", 12);
user_pref("font.size.monospace.x-western", 14);

// Live userChrome editing via the Browser Toolbox  (optional but handy)
user_pref("devtools.chrome.enabled", true);
user_pref("devtools.debugger.remote-enabled", true);

// ============================================================================
// 4. OPTIONAL — personal
// Safe to delete; not part of the look. A minimal URL bar and a stripped
// new-tab page. Delete this whole block if you only want the vertical-tabs
// look and not the behavior.
// ============================================================================
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.quickactions", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.urlbar.suggest.recentsearches", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.showSearchSuggestionsFirst", false);
user_pref("browser.urlbar.openViewOnFocus", false);
user_pref("browser.urlbar.groupLabels.enabled", false);
user_pref("browser.startup.page", 3);                        // restore the previous session
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showSearch", false);
user_pref("browser.newtabpage.activity-stream.showWeather", false);

// Faster tooltips (e.g. the pinned-tab title hint). Default is 500ms; global pref.
user_pref("ui.tooltipDelay", 300);
