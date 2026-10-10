import '../../core/errors/app_failure.dart';
import '../../l10n/gen/app_localizations.dart';

extension AppFailureText on AppFailure {
  String message(AppLocalizations l10n) => switch (this) {
    PermissionMissingFailure(access: RequiredAccess.usageAccess) =>
      l10n.failureUsageAccess,
    PermissionMissingFailure(access: RequiredAccess.vpnConsent) =>
      l10n.failureVpnConsent,
    PlatformFailure() => l10n.failurePlatform,
    StorageFailure() => l10n.failureStorage,
    UnexpectedFailure() => l10n.failureUnexpected,
  };
}
