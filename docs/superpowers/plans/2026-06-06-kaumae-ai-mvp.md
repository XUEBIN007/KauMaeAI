# KauMae AI MVP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a first SwiftUI iOS MVP skeleton plus tested fashion decision core for KauMae AI.

**Architecture:** Keep the scoring engine in a Swift Package target named `KauMaeCore` so it can be tested without Xcode. Keep the iOS app shell in `KauMaeAIApp/` so it can be opened or copied into a full Xcode project for signing and archive.

**Tech Stack:** Swift 6, Swift Testing, SwiftUI, StoreKit-ready product identifiers, local deterministic MVP scoring.

---

### Task 1: Tested Decision Core

**Files:**
- Create: `Package.swift`
- Create: `Sources/KauMaeCore/KauMaeCore.swift`
- Create: `Tests/KauMaeCoreTests/StyleAdvisorTests.swift`

- [ ] Write failing tests for buy, skip, and try-different-color decisions.
- [ ] Run `swift test` and confirm the missing model and advisor types fail compilation.
- [ ] Implement the minimal model and scoring engine.
- [ ] Run `swift test` and confirm the core behavior passes.

### Task 2: SwiftUI App Shell

**Files:**
- Create: `KauMaeAIApp/KauMaeAIApp.swift`
- Create: `KauMaeAIApp/Views/ContentView.swift`
- Create: `KauMaeAIApp/Views/ProfileSetupView.swift`
- Create: `KauMaeAIApp/Views/ItemCheckView.swift`
- Create: `KauMaeAIApp/Views/ResultView.swift`
- Create: `KauMaeAIApp/Views/PaywallView.swift`

- [ ] Build a tabless single-flow SwiftUI app around the core advisor.
- [ ] Include Japanese App Store-facing copy.
- [ ] Keep paid copy clear: free checks, Pro monthly, and credit pack.

### Task 3: App Store Readiness Files

**Files:**
- Create: `KauMaeAIApp/Resources/PrivacyInfo.xcprivacy`
- Create: `KauMaeAIApp/Resources/Info.plist`
- Create: `AppStore/listing-ja.md`
- Create: `AppStore/review-notes.md`

- [ ] Add privacy usage descriptions for camera and photo library.
- [ ] Add Japanese listing title, subtitle, screenshots copy, and subscription notes.
- [ ] Add App Review notes explaining AI advice limitations and privacy handling.

### Task 4: Verification

**Files:**
- Read: all created files

- [ ] Run `swift test`.
- [ ] Run a source scan for placeholders and forbidden overclaims.
- [ ] Report that full iOS archive verification requires complete Xcode, because this machine only has Command Line Tools.
