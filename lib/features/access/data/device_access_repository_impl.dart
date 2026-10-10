import '../../../core/errors/result.dart';
import '../../../core/platform/device_data_source.dart';
import '../domain/device_access_repository.dart';

class DeviceAccessRepositoryImpl implements DeviceAccessRepository {
  DeviceAccessRepositoryImpl(this._device);

  final DeviceDataSource _device;

  @override
  Future<Result<AccessStatus>> getStatus() async {
    final result = await _device.getAccessStatus();
    return switch (result) {
      Ok(:final value) => Ok(
        AccessStatus(
          hasUsageAccess: value.hasUsageAccess,
          isRestrictedSettingsLikely: value.isRestrictedSettingsLikely,
        ),
      ),
      Err(:final failure) => Err(failure),
    };
  }

  @override
  Future<Result<bool>> openUsageAccessSettings() =>
      _device.openUsageAccessSettings();

  @override
  Future<Result<bool>> openOwnAppDetails() =>
      _device.openOwnAppDetailsSettings();

  @override
  Future<Result<bool>> openAppDetails(String packageName) =>
      _device.openAppDetailsSettings(packageName);
}
