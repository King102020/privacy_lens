import '../../../core/errors/result.dart';
import '../../audit/domain/entities/tracker_sdk.dart';
import 'tracker_shield_entities.dart';

abstract interface class TrackerShieldRepository {
  Future<Result<TrackerShieldStatus>> getStatus();

  /// Returns false when the user declined the VPN consent dialog.
  Future<Result<bool>> start();

  Future<Result<void>> stop();

  /// Moves blocked lookups recorded by the VPN service into the encrypted
  /// database. Returns how many were imported.
  Future<Result<int>> importBlockedEvents();

  Future<Result<ShieldActivity>> loadActivity();

  ShieldPolicy currentPolicy();

  Future<Result<void>> applyPolicy();

  Future<Result<void>> setCategoryEnabled(
    TrackerCategory category,
    bool enabled,
  );

  /// Returns false when [raw] is not a hostname.
  Future<Result<bool>> addCustomDomain(String raw, {required bool allow});

  Future<Result<void>> removeCustomDomain(String domain);

  Future<Result<void>> allowDomain(String domain);
}
