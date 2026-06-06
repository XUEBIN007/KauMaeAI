# KauMae AI MVP Design

## Goal

Build a first iOS MVP for a paid "buy-before-check" fashion decision app for the Japanese market. The first version helps a user decide whether to buy a photographed or manually entered clothing item.

## Product Scope

Version 1 focuses on one paid loop: profile setup, candidate clothing input, wardrobe context, AI-style decision, and payment-ready limits. The app does not include social feeds, affiliate commerce, full wardrobe management, or guaranteed sizing.

## Core Flow

1. User enters basic profile: age range, gender, body shape, skin tone, hair, glasses, and style goal.
2. User adds a candidate item from a store photo or manual fields.
3. User adds a small starter wardrobe of commonly worn clothes.
4. App returns a score, buy/skip/try-different-color decision, reasons, and a suggested outfit.
5. App shows paywall copy after free checks are exhausted.

## Architecture

The first implementation separates decision logic from UI. `KauMaeCore` contains the style profile, wardrobe, candidate item, and scoring engine. The SwiftUI app consumes that core and can later replace the local scoring engine with OpenAI or a backend service.

## Monetization

Free users receive a small number of checks. Paid users unlock more checks and optional image generation credits. The first code version prepares the paywall UI and product identifiers but does not hardcode live Apple product configuration.

## App Store Constraints

The app will avoid guaranteed sizing, body-shaming language, brand names in the app title, and misleading AI claims. User photos are private by default and the privacy manifest describes photo library and camera usage.
