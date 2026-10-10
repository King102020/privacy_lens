import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/preferences/app_preferences.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.onboardingCompleted,
    required this.themeMode,
    required this.retentionDays,
    required this.dnsRetentionDays,
    required this.includeSystemApps,
  });

  factory SettingsState.from(AppPreferences preferences) => SettingsState(
    onboardingCompleted: preferences.onboardingCompleted,
    themeMode: preferences.themeMode,
    retentionDays: preferences.retentionDays,
    dnsRetentionDays: preferences.dnsRetentionDays,
    includeSystemApps: preferences.includeSystemApps,
  );

  final bool onboardingCompleted;
  final ThemeMode themeMode;
  final int retentionDays;
  final int dnsRetentionDays;
  final bool includeSystemApps;

  SettingsState copyWith({
    bool? onboardingCompleted,
    ThemeMode? themeMode,
    int? retentionDays,
    int? dnsRetentionDays,
    bool? includeSystemApps,
  }) => SettingsState(
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    themeMode: themeMode ?? this.themeMode,
    retentionDays: retentionDays ?? this.retentionDays,
    dnsRetentionDays: dnsRetentionDays ?? this.dnsRetentionDays,
    includeSystemApps: includeSystemApps ?? this.includeSystemApps,
  );

  @override
  List<Object?> get props => [
    onboardingCompleted,
    themeMode,
    retentionDays,
    dnsRetentionDays,
    includeSystemApps,
  ];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._preferences) : super(SettingsState.from(_preferences));

  final AppPreferences _preferences;

  Future<void> completeOnboarding() async {
    await _preferences.setOnboardingCompleted(true);
    emit(state.copyWith(onboardingCompleted: true));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _preferences.setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setRetentionDays(int days) async {
    await _preferences.setRetentionDays(days);
    emit(state.copyWith(retentionDays: days));
  }

  Future<void> setDnsRetentionDays(int days) async {
    await _preferences.setDnsRetentionDays(days);
    emit(state.copyWith(dnsRetentionDays: days));
  }

  Future<void> setIncludeSystemApps(bool value) async {
    await _preferences.setIncludeSystemApps(value);
    emit(state.copyWith(includeSystemApps: value));
  }
}
