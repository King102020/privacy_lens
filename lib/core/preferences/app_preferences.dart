import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Non-sensitive app settings. Audit data lives in the encrypted database.
class AppPreferences {
  AppPreferences(this._preferences);

  static const List<int> retentionChoicesDays = [7, 30, 90];
  static const List<int> dnsRetentionChoicesDays = [1, 7];
  static const int defaultRetentionDays = 30;
  static const int defaultDnsRetentionDays = 7;

  static const String _onboardingCompleted = 'onboarding_completed';
  static const String _themeMode = 'theme_mode';
  static const String _retentionDays = 'retention_days';
  static const String _dnsRetentionDays = 'dns_retention_days';
  static const String _includeSystemApps = 'include_system_apps';

  final SharedPreferencesWithCache _preferences;

  static Future<AppPreferences> create() async => AppPreferences(
    await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {
          _onboardingCompleted,
          _themeMode,
          _retentionDays,
          _dnsRetentionDays,
          _includeSystemApps,
        },
      ),
    ),
  );

  bool get onboardingCompleted =>
      _preferences.getBool(_onboardingCompleted) ?? false;

  Future<void> setOnboardingCompleted(bool value) =>
      _preferences.setBool(_onboardingCompleted, value);

  ThemeMode get themeMode {
    final stored = _preferences.getString(_themeMode);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      _preferences.setString(_themeMode, mode.name);

  int get retentionDays {
    final stored = _preferences.getInt(_retentionDays);
    return retentionChoicesDays.contains(stored)
        ? stored!
        : defaultRetentionDays;
  }

  Future<void> setRetentionDays(int days) {
    assert(retentionChoicesDays.contains(days), 'Unsupported retention');
    return _preferences.setInt(_retentionDays, days);
  }

  int get dnsRetentionDays {
    final stored = _preferences.getInt(_dnsRetentionDays);
    return dnsRetentionChoicesDays.contains(stored)
        ? stored!
        : defaultDnsRetentionDays;
  }

  Future<void> setDnsRetentionDays(int days) {
    assert(dnsRetentionChoicesDays.contains(days), 'Unsupported retention');
    return _preferences.setInt(_dnsRetentionDays, days);
  }

  bool get includeSystemApps =>
      _preferences.getBool(_includeSystemApps) ?? false;

  Future<void> setIncludeSystemApps(bool value) =>
      _preferences.setBool(_includeSystemApps, value);
}
