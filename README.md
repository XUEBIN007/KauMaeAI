# KauMae AI

KauMae AI is an iOS-first MVP for a Japanese "buy-before-check" fashion decision app.

## Current Build

- `KauMaeCore`: tested Swift decision engine.
- `KauMaeAIApp`: SwiftUI MVP app shell for Xcode integration.
- `AppStore`: Japanese listing draft and App Review notes.
- `Legal`: Japanese privacy policy and terms drafts.
- `KauMaeAIApp/StoreKit`: local StoreKit configuration for purchase testing.

## Local Verification

Run the core behavior check:

```bash
swift run KauMaeCoreTestRunner
```

## Xcode Project

This repository includes `project.yml` for XcodeGen. On a Mac with full Xcode and XcodeGen installed:

```bash
xcodegen generate
open KauMaeAI.xcodeproj
```

Set your Apple Developer Team in Xcode, configure In-App Purchase products in App Store Connect, then archive the app for TestFlight.

This machine currently has Apple Command Line Tools but not full Xcode, so iOS archive/signing must be verified in Xcode before App Store submission.

## Release Checklist

1. Apple Developer enrollment approved.
2. Install full Xcode.
3. Install XcodeGen, then run `xcodegen generate`.
4. Open `KauMaeAI.xcodeproj`.
5. Set `DEVELOPMENT_TEAM`.
6. Confirm bundle id: `com.kaumae.KauMaeAI`.
7. Add a real App Icon PNG set to `KauMaeAIApp/Assets.xcassets/AppIcon.appiconset`.
8. Configure App Store Connect products:
   - `kaumae.pro.monthly`
   - `kaumae.checks.10`
   - `kaumae.images.10`
9. Add privacy policy and terms URLs from hosted versions of `Legal/privacy-policy-ja.md` and `Legal/terms-ja.md`.
10. Create TestFlight build.
11. Test:
    - first check consumes one free check
    - fourth free check opens paywall
    - StoreKit sandbox purchase unlocks Pro
    - photo picker permission text appears correctly
12. Submit with the notes in `AppStore/review-notes.md`.

## MVP Revenue Strategy

Start with a narrow paid loop:

- 3 free checks
- Pro monthly: ¥980
- 10-check pack: ¥480
- image generation credits later: ¥500 per 10 credits

The first App Store screenshots should lead with `この服、買っていい？`, not generic AI styling language.
