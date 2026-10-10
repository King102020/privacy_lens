import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/data_vault_repository.dart';

enum VaultNotice { exportSaved, exportCanceled, exportEmpty }

sealed class DataVaultState extends Equatable {
  const DataVaultState();

  @override
  List<Object?> get props => [];
}

final class DataVaultLoading extends DataVaultState {
  const DataVaultLoading();
}

final class DataVaultReady extends DataVaultState {
  const DataVaultReady({required this.info, this.busy = false, this.notice});

  final VaultInfo info;
  final bool busy;
  final VaultNotice? notice;

  DataVaultReady copyWith({
    VaultInfo? info,
    bool? busy,
    VaultNotice? notice,
    bool clearNotice = false,
  }) => DataVaultReady(
    info: info ?? this.info,
    busy: busy ?? this.busy,
    notice: clearNotice ? null : notice ?? this.notice,
  );

  @override
  List<Object?> get props => [info, busy, notice];
}

final class DataVaultFailure extends DataVaultState {
  const DataVaultFailure(this.failure);

  final AppFailure failure;

  @override
  List<Object?> get props => [failure];
}

class DataVaultCubit extends Cubit<DataVaultState> {
  DataVaultCubit(this._repository) : super(const DataVaultLoading());

  final DataVaultRepository _repository;

  Future<void> load() async {
    final result = await _repository.info();
    if (isClosed) return;
    emit(switch (result) {
      Ok(:final value) => DataVaultReady(info: value),
      Err(:final failure) => DataVaultFailure(failure),
    });
  }

  Future<void> export(ExportFormat format) async {
    final current = state;
    if (current is! DataVaultReady || current.busy) return;
    emit(current.copyWith(busy: true, clearNotice: true));
    final result = await _repository.exportLatestReport(format);
    if (isClosed) return;
    switch (result) {
      case Ok(:final value):
        emit(
          current.copyWith(
            busy: false,
            notice: switch (value) {
              ExportOutcome.saved => VaultNotice.exportSaved,
              ExportOutcome.canceled => VaultNotice.exportCanceled,
              ExportOutcome.empty => VaultNotice.exportEmpty,
            },
          ),
        );
      case Err(:final failure):
        emit(DataVaultFailure(failure));
    }
  }

  Future<bool> wipe() async {
    final current = state;
    if (current is! DataVaultReady || current.busy) return false;
    emit(current.copyWith(busy: true, clearNotice: true));
    final result = await _repository.wipeAll();
    if (isClosed) return false;
    switch (result) {
      case Ok():
        await load();
        return true;
      case Err(:final failure):
        emit(DataVaultFailure(failure));
        return false;
    }
  }
}
