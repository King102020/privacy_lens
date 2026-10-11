import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

abstract interface class AppLogger {
  void debug(String message);

  void warning(String message, {Object? error, StackTrace? stackTrace});

  void error(String message, {Object? error, StackTrace? stackTrace});
}

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
