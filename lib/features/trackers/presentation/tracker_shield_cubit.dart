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
    required this.policy,
    this.query = '',
    this.category,
    this.sort = ShieldSort.hits,
    this.busy = false,
    this.notice,
  });

  final TrackerShieldStatus status;
  final ShieldActivity activity;
  final ShieldPolicy policy;
  final String query;
  final TrackerCategory? category;
  final ShieldSort sort;
  final bool busy;
  final ShieldNotice? notice;

  List<BlockedDomainSummary> get visible {
    final needle = query.trim().toLowerCase();
    final matches = [
      for (final item in activity.summaries)
        if ((category == null || item.category == category) &&
            (needle.isEmpty ||
                item.domain.contains(needle) ||
                (item.packageName?.contains(needle) ?? false) ||
                (item.category?.name.contains(needle) ?? false)))
          item,
    ];
    matches.sort(
      (a, b) => switch (sort) {
        ShieldSort.hits => b.count.compareTo(a.count),
        ShieldSort.recent => b.lastBlockedAt.compareTo(a.lastBlockedAt),
        ShieldSort.name => a.domain.compareTo(b.domain),
      },
    );
    return matches;
  }

  TrackerShieldReady copyWith({
    TrackerShieldStatus? status,
    ShieldActivity? activity,
    ShieldPolicy? policy,
    String? query,
    TrackerCategory? category,
    bool clearCategory = false,
    ShieldSort? sort,
    bool? busy,
    ShieldNotice? notice,
    bool clearNotice = false,
  }) => TrackerShieldReady(
    status: status ?? this.status,
    activity: activity ?? this.activity,
    policy: policy ?? this.policy,
    query: query ?? this.query,
    category: clearCategory ? null : category ?? this.category,
    sort: sort ?? this.sort,
    busy: busy ?? this.busy,
    notice: clearNotice ? null : notice ?? this.notice,
  );

  @override
  List<Object?> get props => [
    status,
    activity,
    policy,
    query,
    category,
    sort,
    busy,
    notice,
  ];
}

enum ShieldSort { hits, recent, name }

enum ShieldNotice { consentDenied, invalidDomain }

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
      await _repository.applyPolicy();
      await _repository.importBlockedEvents();
      final status = await _repository.getStatus();
      final activity = await _repository.loadActivity();
      final policy = _repository.currentPolicy();
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
        policy,
      );
      final current = state;
      emit(
        current is TrackerShieldReady
            ? current.copyWith(
                status: ready.status,
                activity: ready.activity,
                policy: ready.policy,
                busy: false,
                clearNotice: true,
              )
            : TrackerShieldReady(
                status: ready.status,
                activity: ready.activity,
                policy: ready.policy,
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
            :final policy,
            :final query,
            :final category,
            :final sort,
          )) {
            emit(
              TrackerShieldReady(
                status: status,
                activity: activity,
                policy: policy,
                query: query,
                category: category,
                sort: sort,
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

  void setSort(ShieldSort sort) {
    final current = state;
    if (current is TrackerShieldReady) {
      emit(current.copyWith(sort: sort));
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

  Future<void> setCategoryEnabled(
    TrackerCategory category,
    bool enabled,
  ) async {
    final current = state;
    if (current is TrackerShieldReady) {
      emit(current.copyWith(busy: true, clearNotice: true));
    }
    final result = await _repository.setCategoryEnabled(category, enabled);
    if (isClosed) return;
    switch (result) {
      case Ok():
        await refresh();
      case Err(:final failure):
        emit(TrackerShieldFailure(failure));
    }
  }

  Future<void> addCustomDomain(String raw, {required bool allow}) async {
    final current = state;
    if (current is TrackerShieldReady) {
      emit(current.copyWith(busy: true, clearNotice: true));
    }
    final result = await _repository.addCustomDomain(raw, allow: allow);
    if (isClosed) return;
    switch (result) {
      case Ok(:final value):
        if (!value) {
          if (state case final TrackerShieldReady ready) {
            emit(
              ready.copyWith(busy: false, notice: ShieldNotice.invalidDomain),
            );
          }
          return;
        }
        await refresh();
      case Err(:final failure):
        emit(TrackerShieldFailure(failure));
    }
  }

  Future<void> removeCustomDomain(String domain) async {
    final result = await _repository.removeCustomDomain(domain);
    if (isClosed) return;
    switch (result) {
      case Ok():
        await refresh();
      case Err(:final failure):
        emit(TrackerShieldFailure(failure));
    }
  }

  Future<void> allowDomain(String domain) async {
    final result = await _repository.allowDomain(domain);
    if (isClosed) return;
    switch (result) {
      case Ok():
        await refresh();
      case Err(:final failure):
        emit(TrackerShieldFailure(failure));
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
  const TrackerShieldStatusReady(this.status, this.activity, this.policy);

  final TrackerShieldStatus status;
  final ShieldActivity activity;
  final ShieldPolicy policy;
}
