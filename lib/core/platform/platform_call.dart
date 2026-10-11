import 'package:flutter/services.dart';

import '../errors/app_failure.dart';
import '../errors/result.dart';
import '../logging/app_logger.dart';

abstract final class PlatformErrorCodes {
  static const String usageAccessMissing = 'usage_access_missing';
}

Future<Result<T>> guardPlatformCall<T>(
  AppLogger logger,
  String operation,
  Future<T> Function() call,
) async {
  try {
    return Ok(await call());
  } on PlatformException catch (error, stackTrace) {
    if (error.code == PlatformErrorCodes.usageAccessMissing) {
      return const Err(PermissionMissingFailure(RequiredAccess.usageAccess));
    }
    logger.warning('$operation failed', error: error, stackTrace: stackTrace);
    return Err(PlatformFailure(error.code));
  } on Object catch (error, stackTrace) {
    logger.error('$operation failed', error: error, stackTrace: stackTrace);
    return const Err(UnexpectedFailure());
  }
}
