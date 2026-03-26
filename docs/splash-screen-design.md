# Splash Screen Design

## Intent

The splash screen should immediately reinforce the DisturbMyLive brand, confirm the app launched correctly, and transition quickly into the live connection screen.

## Visual direction

The splash screen should use the existing TikTokTheme visual system.

- full-screen gradient background from TikTokBackgroundView
- aggressive TikTok-energy presentation
- high contrast
- punchy glow accents
- no new visual language outside the current theme

## Core content

Primary lockup:

DISTURB
MY LIVE

Supporting subtitle:

Live interaction engine

## Layout

- full-screen gradient background
- centered vertical layout
- title lockup centered on screen
- subtitle directly beneath title
- two glowing accent dots integrated near the lockup
- no controls
- no user interaction

## Motion

- title fades in with slight scale-up
- accent dots pulse with pink and cyan glow
- subtle energy without looking noisy
- total display duration should stay short

## Timing

- simple timer-based transition
- target duration around 1.2 seconds
- reveal live connection screen automatically after timer completes

## Transition

- fade out splash
- reveal live connection screen cleanly
- no navigation push feeling
- no black flash between splash and app

## Constraints

- SwiftUI only
- reuse TikTokTheme colors and styling
- full-screen background
- content should respect safe area
- implementation should be simple enough to validate on device quickly
