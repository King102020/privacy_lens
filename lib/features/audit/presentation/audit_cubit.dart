import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/audit_repository.dart';
import '../domain/entities/audit_report.dart';

sealed class AuditState extends Equatable {
  const AuditState();

  AuditReport? get report => null;

  @override
  List<Object?> get props => [];
}

final class AuditLoading extends AuditState {
  const AuditLoading();
}

final class AuditEmpty extends AuditState {
  const AuditEmpty();
}

final class AuditScanning extends AuditState {
  const AuditScanning({required this.progress, this.previous});

  final ScanProgress progress;
  final AuditReport? previous;

  @override
  AuditReport? get report => previous;

  @override
  List<Object?> get props => [progress, previous];
}

final class AuditReady extends AuditState {
  const AuditReady(this.current);

  final AuditReport current;

  @override
  AuditReport? get report => current;

  @override
  List<Object?> get props => [current];
}

final class AuditFailure extends AuditState {
  const AuditFailure(this.failure, {this.previous});

  final AppFailure failure;
  final AuditReport? previous;

  @override
  AuditReport? get report => previous;

  @override
  List<Object?> get props => [failure, previous];
}

class AuditCubit extends Cubit<AuditState> {
  AuditCubit(this._repository) : super(const AuditLoading());

  final AuditRepository _repository;

  Future<void> loadLatest() async {
    emit(const AuditLoading());
    final result = await _repository.loadLatestReport();
    if (isClosed) return;
    emit(switch (result) {
      Ok(:final value) =>
        value == null ? const AuditEmpty() : AuditReady(value),
      Err(:final failure) => AuditFailure(failure),
    });
  }

  Future<void> scan() async {
    if (state is AuditScanning) return;
    emit(
      AuditScanning(
        progress: const ScanProgress(phase: ScanPhase.collecting),
        previous: state.report,
      ),
    );
    final result = await _repository.runScan(
      onProgress: (progress) {
        if (!isClosed) {
          emit(AuditScanning(progress: progress, previous: state.report));
        }
      },
    );
    if (isClosed) return;
    emit(switch (result) {
      Ok(:final value) => AuditReady(value),
      Err(:final failure) => AuditFailure(failure, previous: state.report),
    });
  }
}
