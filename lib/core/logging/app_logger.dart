import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Central logging interface. Messages must never contain package names,
/// domains, or other user data: describe the operation, not the subject.
abstract interface class AppLogger {
  void debug(String message);

  void warning(String message, {Object? error, StackTrace? stackTrace});

  void error(String message, {Object? error, StackTrace? stackTrace});
}

/// Writes to the debug console in debug builds and drops everything in
/// release builds. Privacy Lens has no crash upload by design.
class ConsoleAppLogger implements AppLogger {
  const ConsoleAppLogger();

  static const String _name = 'PrivacyLens';

  @override
  void debug(String message) {
    if (!kDebugMode) return;
    developer.log(message, name: _name, level: 500);
  }

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;
    developer.log(
      message,
      name: _name,
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;
    developer.log(
      message,
      name: _name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
