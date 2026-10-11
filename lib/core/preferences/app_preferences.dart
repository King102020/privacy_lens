import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static const String _shieldCategories = 'shield_categories';
  static const String _customBlocked = 'shield_custom_blocked';
  static const String _customAllowed = 'shield_custom_allowed';
  static const String _seenTabGuides = 'seen_tab_guides';

  static const List<String> defaultShieldCategories = [
    'advertising',
    'analytics',
    'attribution',
    'profiling',
  ];

  static final RegExp hostnamePattern = RegExp(
    r'^(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z]{2,24}$',
  );

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
          _shieldCategories,
          _customBlocked,
          _customAllowed,
          _seenTabGuides,
        },
      ),
    ),
  );

  static String? tryParseHostname(String raw) {
    var host = raw.trim().toLowerCase();
    if (host.contains('://') ||
        host.contains('/') ||
        host.contains(':') ||
        host.contains(' ')) {
      return null;
    }
    host = host.replaceAll(RegExp(r'\.$'), '');
    if (!hostnamePattern.hasMatch(host)) return null;
    return host;
  }

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

  List<String> get enabledShieldCategories =>
      _preferences.getStringList(_shieldCategories) ?? defaultShieldCategories;

  Future<void> setEnabledShieldCategories(Iterable<String> values) {
    final names = values.toSet().toList()..sort();
    return _preferences.setStringList(_shieldCategories, names);
  }

  List<String> get customBlockedDomains =>
      _preferences.getStringList(_customBlocked) ?? const [];

  Future<void> setCustomBlockedDomains(Iterable<String> values) {
    final hosts = values.toSet().toList()..sort();
    return _preferences.setStringList(_customBlocked, hosts);
  }

  List<String> get customAllowedDomains =>
      _preferences.getStringList(_customAllowed) ?? const [];

  Future<void> setCustomAllowedDomains(Iterable<String> values) {
    final hosts = values.toSet().toList()..sort();
    return _preferences.setStringList(_customAllowed, hosts);
  }

  List<String> get seenTabGuides =>
      _preferences.getStringList(_seenTabGuides) ?? const [];

  Future<void> markTabGuideSeen(String tab) {
    final next = {...seenTabGuides, tab}.toList()..sort();
    return _preferences.setStringList(_seenTabGuides, next);
  }

  Future<void> clearSeenTabGuides() =>
      _preferences.setStringList(_seenTabGuides, const []);
}
