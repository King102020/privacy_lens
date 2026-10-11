import '../errors/result.dart';
import '../logging/app_logger.dart';
import 'device_api.g.dart';
import 'platform_call.dart';

class TrackerShieldDataSource {
  TrackerShieldDataSource({
    required AppLogger logger,
    TrackerShieldHostApi? api,
  }) : _logger = logger,
       _api = api ?? TrackerShieldHostApi();

  final AppLogger _logger;
  final TrackerShieldHostApi _api;

  Future<Result<ShieldStatusDto>> getStatus() =>
      guardPlatformCall(_logger, 'Read shield status', _api.getStatus);

  Future<Result<bool>> start() =>
      guardPlatformCall(_logger, 'Start shield', _api.start);

  Future<Result<void>> stop() =>
      guardPlatformCall(_logger, 'Stop shield', _api.stop);

  Future<Result<List<DnsEventDto>>> fetchBlockedEvents({
    required int afterId,
    required int limit,
  }) => guardPlatformCall(
    _logger,
    'Fetch blocked events',
    () => _api.fetchBlockedEvents(afterId, limit),
  );

  Future<Result<void>> deleteBlockedEventsUpTo(int id) => guardPlatformCall(
    _logger,
    'Delete imported events',
    () => _api.deleteBlockedEventsUpTo(id),
  );

  Future<Result<void>> applyPolicy({
    required List<String> enabledCategories,
    required List<String> extraBlocked,
    required List<String> allowed,
  }) => guardPlatformCall(
    _logger,
    'Apply shield policy',
    () => _api.applyPolicy(enabledCategories, extraBlocked, allowed),
  );
}
