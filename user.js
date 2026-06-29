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

// ============================================================================
// Compact UI / layout  (part of the trimmed look)
// ============================================================================
user_pref("browser.uidensity", 1);                           // compact density
user_pref("browser.compactmode.show", true);                 // expose the Compact option in Settings
user_pref("browser.toolbars.bookmarks.visibility", "never"); // no bookmarks toolbar
user_pref("browser.tabs.closeWindowWithLastTab", false);     // closing the last tab keeps the window

// ============================================================================
// Content fonts  (the *chrome* is forced to 7pt by userChrome.css; these are
// the default web-page fonts)
// ============================================================================
user_pref("font.size.variable.x-western", 12);
user_pref("font.size.monospace.x-western", 14);

// ============================================================================
// Live userChrome editing via the Browser Toolbox  (optional but handy)
// ============================================================================
user_pref("devtools.chrome.enabled", true);
user_pref("devtools.debugger.remote-enabled", true);

// ============================================================================
// PERSONAL preferences (OPTIONAL) — a minimal URL bar and a stripped new-tab
// page. Delete this whole block if you only want the vertical-tabs look and
// not the behavior.
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
