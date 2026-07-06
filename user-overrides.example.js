// ============================================================================
// user-overrides.example.js   →   copy to  user-overrides.js
// ----------------------------------------------------------------------------
// Your personal Firefox prefs. Copy this to `user-overrides.js` (gitignored, so
// `git pull` never touches it). install.sh APPENDS it to the end of the profile's
// user.js, AFTER trimfox's prefs — and Firefox uses the LAST value seen for a pref,
// so anything here overrides trimfox's for that pref. It survives every re-install
// (install.sh seeds it once, then never overwrites it).
//
//   cp user-overrides.example.js user-overrides.js      # install.sh does this for you
//
// Migrating from your own user.js? trimfox's install REPLACES user.js (your old one
// is backed up to user.js.bak-<timestamp>). Copy the prefs you want to keep from that
// backup into here so they survive.
//
// See SETTINGS.md for every pref trimfox sets and its Firefox default. Uncomment or
// add prefs below — same syntax as user.js:
// ============================================================================

// user_pref("browser.tabs.closeWindowWithLastTab", true);   // restore Firefox's default
// user_pref("browser.startup.page", 1);                     // blank start instead of restore-session
// user_pref("ui.tooltipDelay", 500);                        // Firefox's default tooltip delay
// user_pref("browser.uidensity", 0);                        // normal density instead of compact

// Maintainer: live userChrome editing via the Browser Toolbox. Enables chrome devtools +
// remote debugging — both off by default for SECURITY; only enable if you edit chrome:
// user_pref("devtools.chrome.enabled", true);
// user_pref("devtools.debugger.remote-enabled", true);
