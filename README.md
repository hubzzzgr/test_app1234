# tuff test

A tiny SwiftUI iPhone app with one liquid-glass-style **test** button. Tapping it gives a soft haptic and flashes the rear torch for about 0.18 seconds. Camera permission is requested only when the torch is used; camera capture is not started.

## Build manually

1. Push this repository to GitHub.
2. Open **Actions → Build iOS app → Run workflow**.
3. Download the `tuff-test-ios` artifact from the completed run.

The workflow builds an unsigned iOS device app and packages `TuffTest.app` in a ZIP. Installing it on a device requires signing; this workflow does not require signing secrets.
