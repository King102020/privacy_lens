// Source of truth for the Dart <-> Kotlin boundary.
// Regenerate with: dart run pigeon --input pigeons/device_api.dart
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/core/platform/device_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/app/privacylens/bridge/DeviceApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'app.privacylens.bridge'),
    dartPackageName: 'privacy_lens',
  ),
)
enum SpecialAccessKindDto {
  accessibilityService,
  notificationListener,
  deviceAdmin,
  overlay,
}

class AccessStatusDto {
  AccessStatusDto({
    required this.hasUsageAccess,
    required this.isRestrictedSettingsLikely,
    required this.sdkInt,
  });

  bool hasUsageAccess;

  /// True on Android 13+ when this app was installed outside an app store,
  /// so the user must first "Allow restricted settings" in App info.
  bool isRestrictedSettingsLikely;
  int sdkInt;
}

class InstalledAppDto {
  InstalledAppDto({
    required this.packageName,
    required this.label,
    required this.versionName,
    required this.versionCode,
    required this.isSystemApp,
    required this.installerPackage,
    required this.firstInstallTimeMs,
    required this.lastUpdateTimeMs,
    required this.iconPath,
    required this.requestedPermissions,
    required this.grantedPermissions,
  });

  String packageName;
  String label;
  String? versionName;
  int versionCode;
  bool isSystemApp;
  String? installerPackage;
  int firstInstallTimeMs;
  int lastUpdateTimeMs;
  String? iconPath;
  List<String> requestedPermissions;
  List<String> grantedPermissions;
}

class SpecialAccessDto {
  SpecialAccessDto({required this.packageName, required this.kind});

  String packageName;
  SpecialAccessKindDto kind;
}

class UsageStatDto {
  UsageStatDto({
    required this.packageName,
    required this.foregroundMs,
    required this.lastUsedMs,
  });

  String packageName;
  int foregroundMs;
  int lastUsedMs;
}

class TrackerSignatureDto {
  TrackerSignatureDto({required this.trackerId, required this.classPrefixes});

  String trackerId;

  /// Java package prefixes, for example `com.facebook.ads`.
  List<String> classPrefixes;
}

class TrackerMatchDto {
  TrackerMatchDto({required this.packageName, required this.trackerIds});

  String packageName;
  List<String> trackerIds;
}

class ShieldStatusDto {
  ShieldStatusDto({
    required this.isRunning,
    required this.blocklistVersion,
    required this.blocklistSize,
  });

  bool isRunning;
  String blocklistVersion;
  int blocklistSize;
}

class DnsEventDto {
  DnsEventDto({
    required this.id,
    required this.timestampMs,
    required this.domain,
    required this.packageName,
  });

  int id;
  int timestampMs;
  String domain;
  String? packageName;
}

@HostApi()
abstract class DeviceHostApi {
  AccessStatusDto getAccessStatus();

  @async
  List<InstalledAppDto> getInstalledApps(bool includeSystemApps);

  @async
  List<SpecialAccessDto> getSpecialAccess();

  /// Foreground time is computed from usage events inside the window, so it
  /// is only complete for recent windows. Last-used time comes from the
  /// aggregated history and stays valid for long windows.
  @async
  List<UsageStatDto> getUsageStats(int sinceMs, int untilMs);

  /// Scans app packages for known tracker SDK classes. Progress is reported
  /// through [ScanProgressFlutterApi].
  @async
  List<TrackerMatchDto> scanTrackerSdks(
    List<String> packageNames,
    List<TrackerSignatureDto> signatures,
  );

  bool openAppDetailsSettings(String packageName);

  bool openUsageAccessSettings();

  bool openOwnAppDetailsSettings();

  /// Opens the system "Save as" picker and writes [bytes] to the chosen file.
  /// Returns false when the user cancels.
  @async
  bool saveDocument(String suggestedName, String mimeType, Uint8List bytes);

  /// Removes native caches: app icons and pending DNS events.
  void clearNativeData();
}

@FlutterApi()
abstract class ScanProgressFlutterApi {
  void onTrackerScanProgress(int scanned, int total);
}

@HostApi()
abstract class TrackerShieldHostApi {
  ShieldStatusDto getStatus();

  /// Asks for VPN consent when needed, then starts the service.
  /// Returns false when the user declines consent.
  @async
  bool start();

  void stop();

  List<DnsEventDto> fetchBlockedEvents(int afterId, int limit);

  void deleteBlockedEventsUpTo(int id);

  /// Updates the running DNS filter. Allow-list wins, then enabled
  /// categories plus extra blocked hosts.
  void applyPolicy(
    List<String> enabledCategories,
    List<String> extraBlocked,
    List<String> allowed,
  );
}
