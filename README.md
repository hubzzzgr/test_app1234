# tuff test

A tiny SwiftUI iPhone app with one liquid-glass-style **test** button. Tapping it gives a soft haptic and flashes the rear torch for about 0.18 seconds. Camera permission is requested only when the torch is used; camera capture is not started.

## Build manually

1. Push this repository to GitHub.
2. Open **Actions → Build iOS app → Run workflow**.
3. Click the `tuff-test.ipa` artifact on the completed run to download the IPA directly, without an extra ZIP wrapper. Start a new workflow run to get this format; older artifacts retain their original format.

The workflow builds an unsigned iOS device app and packages it in the standard IPA `Payload` layout. Installing it on a device requires signing; this workflow does not require signing secrets.

Before packaging, the workflow checks that the app's `CFBundleExecutable` identifies an existing executable with an arm64 slice, and then verifies the IPA archive's integrity.
