import 'package:equatable/equatable.dart';

import '../../../core/errors/result.dart';

class AccessStatus extends Equatable {
  const AccessStatus({
    required this.hasUsageAccess,
    required this.isRestrictedSettingsLikely,
  });

  final bool hasUsageAccess;

  /// Android 13+ sideloaded installs must "Allow restricted settings" in App
  /// info before Usage Access can be turned on.
  final bool isRestrictedSettingsLikely;

  @override
  List<Object?> get props => [hasUsageAccess, isRestrictedSettingsLikely];
}

/// Reads access the user grants in system Settings and opens those screens.
abstract interface class DeviceAccessRepository {
  Future<Result<AccessStatus>> getStatus();

  Future<Result<bool>> openUsageAccessSettings();

  Future<Result<bool>> openOwnAppDetails();

  Future<Result<bool>> openAppDetails(String packageName);
}
