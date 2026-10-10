import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../audit/domain/entities/tracker_sdk.dart';
import '../domain/tracker_shield_entities.dart';
import '../domain/tracker_shield_repository.dart';

sealed class TrackerShieldState extends Equatable {
  const TrackerShieldState();

  @override
  List<Object?> get props => [];
}

final class TrackerShieldLoading extends TrackerShieldState {
  const TrackerShieldLoading();
}

final class TrackerShieldReady extends TrackerShieldState {
  const TrackerShieldReady({
    required this.status,
    required this.activity,
    this.query = '',
    this.category,
    this.busy = false,
    this.notice,
  });

  final TrackerShieldStatus status;
  final ShieldActivity activity;
  final String query;
  final TrackerCategory? category;
  final bool busy;
  final ShieldNotice? notice;

  List<BlockedDomainSummary> get visible {
    final needle = query.trim().toLowerCase();
    return [
      for (final item in activity.summaries)
        if ((category == null || item.category == category) &&
            (needle.isEmpty ||
                item.domain.contains(needle) ||
                (item.packageName?.contains(needle) ?? false)))
          item,
    ];
  }

  TrackerShieldReady copyWith({
    TrackerShieldStatus? status,
    ShieldActivity? activity,
    String? query,
    TrackerCategory? category,
    bool clearCategory = false,
    bool? busy,
    ShieldNotice? notice,
    bool clearNotice = false,
  }) => TrackerShieldReady(
    status: status ?? this.status,
    activity: activity ?? this.activity,
    query: query ?? this.query,
    category: clearCategory ? null : category ?? this.category,
    busy: busy ?? this.busy,
    notice: clearNotice ? null : notice ?? this.notice,
  );

  @override
  List<Object?> get props => [status, activity, query, category, busy, notice];
}

enum ShieldNotice { consentDenied }

final class TrackerShieldFailure extends TrackerShieldState {
  const TrackerShieldFailure(this.failure);

  final AppFailure failure;

  @override
  List<Object?> get props => [failure];
}

class TrackerShieldCubit extends Cubit<TrackerShieldState> {
  TrackerShieldCubit(this._repository) : super(const TrackerShieldLoading());

  static const Duration _refreshInterval = Duration(seconds: 15);

  final TrackerShieldRepository _repository;
  Timer? _timer;
  bool _refreshing = false;

  Future<void> refresh() async {
    if (_refreshing) return;
    _refreshing = true;
    try {
      await _repository.importBlockedEvents();
      final status = await _repository.getStatus();
      final activity = await _repository.loadActivity();
      if (isClosed) return;
      if (status case Err(:final failure)) {
        emit(TrackerShieldFailure(failure));
        return;
      }
      if (activity case Err(:final failure)) {
        emit(TrackerShieldFailure(failure));
        return;
      }
      final ready = TrackerShieldStatusReady(
        (status as Ok<TrackerShieldStatus>).value,
        (activity as Ok<ShieldActivity>).value,
      );
      final current = state;
      emit(
        current is TrackerShieldReady
            ? current.copyWith(
                status: ready.status,
                activity: ready.activity,
                busy: false,
                clearNotice: true,
              )
            : TrackerShieldReady(
                status: ready.status,
                activity: ready.activity,
              ),
      );
      _syncTimer();
    } finally {
      _refreshing = false;
    }
  }

  Future<void> start() async {
    final current = state;
    if (current is TrackerShieldReady) {
      emit(current.copyWith(busy: true, clearNotice: true));
    }
    final result = await _repository.start();
    if (isClosed) return;
    switch (result) {
      case Ok(:final value):
        if (!value) {
          if (state case TrackerShieldReady(
            :final status,
            :final activity,
            :final query,
            :final category,
          )) {
            emit(
              TrackerShieldReady(
                status: status,
                activity: activity,
                query: query,
                category: category,
                notice: ShieldNotice.consentDenied,
              ),
            );
          }
          return;
        }
        await refresh();
      case Err(:final failure):
        emit(TrackerShieldFailure(failure));
    }
  }

  Future<void> stop() async {
    final current = state;
    if (current is TrackerShieldReady) {
      emit(current.copyWith(busy: true, clearNotice: true));
    }
    final result = await _repository.stop();
    if (isClosed) return;
    switch (result) {
      case Ok():
        await refresh();
      case Err(:final failure):
        emit(TrackerShieldFailure(failure));
    }
  }

  void setQuery(String query) {
    final current = state;
    if (current is TrackerShieldReady) {
      emit(current.copyWith(query: query));
    }
  }

  void setCategory(TrackerCategory? category) {
    final current = state;
    if (current is TrackerShieldReady) {
      emit(
        current.copyWith(category: category, clearCategory: category == null),
      );
    }
  }

  void _syncTimer() {
    _timer?.cancel();
    final current = state;
    if (current is TrackerShieldReady && current.status.isRunning) {
      _timer = Timer.periodic(_refreshInterval, (_) => refresh());
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

class TrackerShieldStatusReady {
  const TrackerShieldStatusReady(this.status, this.activity);

  final TrackerShieldStatus status;
  final ShieldActivity activity;
}
