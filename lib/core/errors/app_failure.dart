/// Access the user grants in system Settings. A missing grant is a normal,
/// recoverable state, not a crash.
enum RequiredAccess { usageAccess, vpnConsent }

/// Typed failures exposed above the data layer. Low-level exceptions are
/// converted at the data boundary so the UI can offer the right recovery.
sealed class AppFailure {
  const AppFailure();
}

final class PermissionMissingFailure extends AppFailure {
  const PermissionMissingFailure(this.access);

  final RequiredAccess access;
}

/// The Android side rejected or failed a request.
final class PlatformFailure extends AppFailure {
  const PlatformFailure(this.code);

  final String code;
}

final class StorageFailure extends AppFailure {
  const StorageFailure();
}

final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure();
}
