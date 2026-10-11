enum RequiredAccess { usageAccess, vpnConsent }

sealed class AppFailure {
  const AppFailure();
}

final class PermissionMissingFailure extends AppFailure {
  const PermissionMissingFailure(this.access);

  final RequiredAccess access;
}

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
