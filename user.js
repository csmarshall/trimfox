// ============================================================================
// user.js  —  managed by trimfox (https://github.com/csmarshall/trimfox)
// Firefox reads this at every startup and applies it OVER prefs.js.
// Firefox never writes to this file, so these values are pinned.
// Created: 2026-06-25
// ============================================================================

// --- Required for userChrome.css / userContent.css to load -----------------
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// ============================================================================
// Native vertical tabs  (replacing Tree Style Tab — TST kept installed as
// fallback; set sidebar.verticalTabs=false to revert).
// Pref names/defaults verified against Firefox 152.0.3 omni.ja.
// Derived from TST config: maxTreeLevel=0 (flat), animation=false,
// width~240px, left side, Photon theme, system color scheme.
// ============================================================================

// Enable the revamped sidebar + vertical tabs
user_pref("sidebar.revamp", true);                 // default false
user_pref("sidebar.verticalTabs", true);           // default false

// Drop the rounded/inset content area — it adds a dark gutter we don't want
user_pref("sidebar.revamp.round-content-area", false);  // default true

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
