import 'dart:typed_data';

import '../errors/result.dart';
import '../logging/app_logger.dart';
import 'device_api.g.dart';
import 'platform_call.dart';

typedef ScanProgressCallback = void Function(int scanned, int total);

/// Typed access to the Kotlin collectors. Every call returns a [Result].
class DeviceDataSource {
  DeviceDataSource({required AppLogger logger, DeviceHostApi? api})
    : _logger = logger,
      _api = api ?? DeviceHostApi() {
    ScanProgressFlutterApi.setUp(_progressRelay);
  }

  final AppLogger _logger;
  final DeviceHostApi _api;
  final _ScanProgressRelay _progressRelay = _ScanProgressRelay();

  Future<Result<AccessStatusDto>> getAccessStatus() =>
      guardPlatformCall(_logger, 'Read access status', _api.getAccessStatus);

  Future<Result<List<InstalledAppDto>>> getInstalledApps({
    required bool includeSystemApps,
  }) => guardPlatformCall(
    _logger,
    'List installed apps',
    () => _api.getInstalledApps(includeSystemApps),
  );

  Future<Result<List<SpecialAccessDto>>> getSpecialAccess() =>
      guardPlatformCall(_logger, 'Read special access', _api.getSpecialAccess);

  Future<Result<List<UsageStatDto>>> getUsageStats({
    required DateTime since,
    required DateTime until,
  }) => guardPlatformCall(
    _logger,
    'Read usage stats',
    () => _api.getUsageStats(
      since.millisecondsSinceEpoch,
      until.millisecondsSinceEpoch,
    ),
  );

  Future<Result<List<TrackerMatchDto>>> scanTrackerSdks({
    required List<String> packageNames,
    required List<TrackerSignatureDto> signatures,
    ScanProgressCallback? onProgress,
  }) async {
    _progressRelay.listener = onProgress;
    try {
      return await guardPlatformCall(
        _logger,
        'Scan tracker SDKs',
        () => _api.scanTrackerSdks(packageNames, signatures),
      );
    } finally {
      _progressRelay.listener = null;
    }
  }

  Future<Result<bool>> openAppDetailsSettings(String packageName) =>
      guardPlatformCall(
        _logger,
        'Open app settings',
        () => _api.openAppDetailsSettings(packageName),
      );

  Future<Result<bool>> openUsageAccessSettings() => guardPlatformCall(
    _logger,
    'Open Usage Access settings',
    _api.openUsageAccessSettings,
  );

  Future<Result<bool>> openOwnAppDetailsSettings() => guardPlatformCall(
    _logger,
    'Open own app settings',
    _api.openOwnAppDetailsSettings,
  );

  Future<Result<bool>> saveDocument({
    required String suggestedName,
    required String mimeType,
    required Uint8List bytes,
  }) => guardPlatformCall(
    _logger,
    'Save document',
    () => _api.saveDocument(suggestedName, mimeType, bytes),
  );

  Future<Result<void>> clearNativeData() =>
      guardPlatformCall(_logger, 'Clear native data', _api.clearNativeData);
}

class _ScanProgressRelay implements ScanProgressFlutterApi {
  ScanProgressCallback? listener;

  @override
  void onTrackerScanProgress(int scanned, int total) =>
      listener?.call(scanned, total);
}
