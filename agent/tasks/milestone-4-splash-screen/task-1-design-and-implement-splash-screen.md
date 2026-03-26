# Task 1

**Milestone**
Milestone 4

**Status**
in_progress

**Dependencies**
Milestone 3 complete

**Estimated Time**
90 minutes

## Objective

Design and implement a branded splash screen for DisturbMyLive.

## Design choices locked

- title lockup uses Disturb My Live stacked text
- subtitle uses Live interaction engine
- style is aggressive TikTok-energy
- transition uses a simple timer first
- full-screen gradient must remain visible during splash
- splash content respects safe area

## Implementation outline

1. Create SplashScreenView
2. Add title lockup and subtitle
3. Add animated accent glow dots
4. Add timer-based reveal into LiveConnectionRootView
5. Verify no black flash or letterboxing on device

## Verification

- splash appears full screen on device
- gradient covers full screen
- content respects safe area
- subtitle is visible and legible
- timed transition feels smooth
- live connection screen appears correctly after splash
