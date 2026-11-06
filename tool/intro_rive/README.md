# Onboarding story (Rive)

Dev-only scripts that built `assets/rive/onboarding.riv`. The app never runs
them. Story and rules: `docs/onboarding_story.md`.

They drive the Rive desktop editor (Early Access) through its MCP server at
`http://127.0.0.1:9791/mcp`. Keep the editor open with the story file active.

| Script | Does |
|---|---|
| `rive.py` | Tiny MCP client: `python rive.py --list`, `python rive.py <tool> '<json>'` |
| `rv.py` | Helpers shared by the build scripts |
| `build_scene.py` | Deletes every artboard, then draws the `Story` artboard (360×450) |
| `animate.py` | Keys the timelines `Start`, `Beat1`–`Beat4` (one-shot, 3.4 s) |
| `machine.py` | View model `Story.beat` (0–3) and the state machine transitions |

Run them in that order from this folder. `machine.py` and `animate.py` hold a
few object ids from the current file (view model, trim path, switch color);
re-read them with `query_objects` if you rebuild the scene.

Export: `python rive.py export_file '{"format":"riv","destination":"<abs path to assets/rive>"}'`,
then rename `untitled.riv` to `onboarding.riv`.

Flutter sets `beat` from the 14 s clock in `onboarding_screen.dart`
(`_beatStarts`). Keep the two in step.
