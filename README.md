# Privacy Lens

An on-device Android privacy auditor. It reads granted permissions, special
access, foreground time (when Usage Access is on), known tracker SDKs inside
app packages, and optional DNS blocks from Tracker Shield. Nothing is
uploaded. There is no account.

## Requirements

- Flutter 3.35 (Dart 3.9) — this repo was built with the SDK at `D:\flutter`
- Android SDK, minSdk 29
- A phone or emulator for a full scan (collectors talk to Android APIs)

## Run

```powershell
cd C:\Users\ad\AndroidStudioProjects\privacy_lens
flutter pub get
flutter run --flavor dev
```

Product flavor: `flutter run --flavor prod`.

Dev adds the `.dev` application id suffix and the label "Privacy Lens Dev".

## Quality gate

```powershell
.\tool\check.ps1
```

That script formats, analyzes, runs Dart tests, and runs Kotlin unit tests.

## Architecture

Feature-first folders under `lib/features`. Shared tokens live in
`lib/core/design_system` and `lib/core/theme`. Composition root is
`lib/app/bootstrap.dart`.

- **State:** Cubits (`flutter_bloc`). One approach only.
- **Storage:** Drift + SQLCipher. Key in Android Keystore.
- **Native:** Pigeon `DeviceHostApi` and `TrackerShieldHostApi`.
- **Copy:** all UI strings in `lib/l10n/app_en.arb`.

Architecture decisions: [`docs/adr/`](docs/adr/).

## What a scan can and cannot see

**Can:** current permission grants, accessibility / notification listener /
device admin / overlay, on-screen time with Usage Access, tracker libraries
inside APKs, DNS lookups that Tracker Shield blocked.

**Cannot:** a history of each permission use, background mic or camera,
another app's clipboard, or HTTPS payloads.

Sideloaded installs on Android 13+ may need **Allow restricted settings** in
App info before Usage Access can be turned on.

Tracker Shield is a DNS-only VPN. Strict Private DNS, in-app DNS-over-HTTPS,
and another VPN can bypass it.

## Permissions

| Permission | Why |
| --- | --- |
| `QUERY_ALL_PACKAGES` | List user apps and their grants |
| `PACKAGE_USAGE_STATS` | Foreground time (user must enable Usage Access) |
| `INTERNET` | Forward allowed DNS for Tracker Shield only |
| `FOREGROUND_SERVICE` / `SPECIAL_USE` | Persistent shield notification |
| `POST_NOTIFICATIONS` | That notification on Android 13+ |

Backup is off. Data extraction rules exclude the vault.

## Release signing

1. Create a keystore.
2. Copy `android/key.properties.example` to `android/key.properties`.
3. Fill `storeFile`, `storePassword`, `keyAlias`, `keyPassword`.
4. `flutter build apk --flavor prod --release`

Without `key.properties` a release build still compiles, signed with the
debug key. Do not distribute that APK.

## Tests

- Dart: `flutter test` (rules, engine, repositories, cubits, widgets)
- Kotlin: `cd android; .\gradlew.bat test`
- Integration (needs a device or the fake harness):
  `flutter test integration_test/app_flow_test.dart`

Drift schema snapshots: `dart run drift_dev make-migrations`
