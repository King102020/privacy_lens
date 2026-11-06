# Onboarding intro (Blender)

Dev-only source for `assets/video/intro_light.mp4` and `intro_dark.mp4`.
The app never runs anything here; it only plays the two MP4s.

- `privacy_lens_intro.blend` / `privacy_lens_intro_dark.blend`: scene
  `PrivacyLensIntro`, 1080×1350, 30 fps, frames 0–419 (14 s loop).
- `animate.py`: bakes the four beats. Re-run it inside Blender after moving
  objects, then save both .blend files.

Render both videos (Blender 5.2):

```bash
blender -b tool/intro_3d/privacy_lens_intro.blend -S PrivacyLensIntro -a
blender -b tool/intro_3d/privacy_lens_intro_dark.blend -S PrivacyLensIntro -a
```

Timing must match the beat windows in
`lib/features/onboarding/presentation/onboarding_screen.dart`.
`tool/intro_video/` (Remotion) is the older 2D version of the same story.
