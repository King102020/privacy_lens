# Onboarding story: "The ad that followed you"

Decided 2026-11-06 with the owner. Replaces the Remotion and Blender intros.

## Goal

A new user should understand, in about 15 seconds:

1. Apps they already use carry hidden ad and analytics code.
2. That code sends their activity to ad companies, who profile them and
   target ads back at them.
3. Privacy Lens shows that code, blocks its lookups, and helps them take
   back permissions.

It must never look like Privacy Lens is the one collecting data.

## Visual rules

- Data only flows **from other apps to generic third parties** ("Ad network",
  "Analytics"), drawn in rose. No real company names or logos.
- Privacy Lens (rust lens, shield) appears **only in beat 4**, and only on
  the phone. Pair it with "Stays on this phone".
- Palette: paper #F6EFE6 / ink #1C1410 / rust #B45309; dark charcoal
  #1A1613 / amber #E8955A. Rose = data leaving, ochre = medium. No green.
- Formal motion: ease-out reveals, ease-in-out travel, no bounce or flash.
- 2D or 2.5D (layered depth, soft shadows). It must look polished.

## Beats (plays by itself, with optional taps)

| # | Headline | Picture | Optional tap |
|---|----------|---------|--------------|
| 1 | Your apps hide ad and tracking code | Phone showing a generic running app. A small "Ad SDK" passenger peeks out from behind the app card. | Tap the app: x-ray view shows 3 passengers (Ads, Analytics, Attribution). |
| 2 | It sends your activity to ad companies | Activity bubbles ("Ran at 6 am", "Near your home", "Looked at shoes") leave through the passenger and fly to an "Ad network" card outside the phone. | Tap a bubble: it enlarges and shows its label. |
| 3 | They build a profile to target you | The ad network fills a profile card with those tags. Then a *different* app on the phone shows a shoe ad sliding in. | Tap the profile: tags settle into "Runner · 25–34 · Shoes". |
| 4 | See it, block it, take back permissions | Rust lens reveals the passenger by name; shield cuts the line and bubbles bounce off; a "Location" permission switch flips off. "Stays on this phone" badge. | Tap the shield: replays the block. |

The Scan apps (Usage Access) and Turn on Tracker Shield actions appear on
beat 4.

Honesty: we block tracker **lookups** (DNS) and open **Android settings**
to remove permissions. We cannot remove a permission ourselves or read
what is in the data being sent. The picture must not imply more.

## Build: Rive

- Rive desktop (Early Access) via MCP at http://127.0.0.1:9791/mcp.
- One artboard, one state machine `Story`:
  - Number input `beat` (0–3), set by Flutter. Each state plays its beat
    loop; transitions are cross-fades in the same formal motion.
  - Trigger inputs `tapApp`, `tapBubble`, `tapProfile`, `tapShield`, or
    Rive listeners on the hit areas.
  - Boolean `dark` (or a view model with color properties) for theme.
- Export to `assets/rive/onboarding.riv`. Check the Rive plan first: Free
  plan exports show a Rive splash screen.

## Flutter

- Add `rive` (interactive state machine; CustomPainter and video cannot
  react to taps). Headline, Skip, Start, and the two actions stay Flutter
  widgets for l10n, semantics, and tests.
- Flutter's 14 s clock (or tap-to-advance) owns `beat` and pushes it into
  Rive. `OnboardingScreen(beat: n)` keeps working in tests.
- Update the four `onboardingBeat*` strings in `lib/l10n/app_en.arb`, run
  `flutter gen-l10n`, and update the semantics labels in the widget test.
- Keep a static fallback for tests and reduced motion.
- Once the Rive intro ships, remove `video_player`, `assets/video/`,
  `tool/intro_video/`, and `tool/intro_3d/`.
