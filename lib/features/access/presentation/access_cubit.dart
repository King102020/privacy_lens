import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/device_access_repository.dart';

sealed class AccessState extends Equatable {
  const AccessState();

  @override
  List<Object?> get props => [];
}

final class AccessLoading extends AccessState {
  const AccessLoading();
}

final class AccessReady extends AccessState {
  const AccessReady(this.status);

  final AccessStatus status;

  @override
  List<Object?> get props => [status];
}

final class AccessFailure extends AccessState {
  const AccessFailure(this.failure);

  final AppFailure failure;

  @override
  List<Object?> get props => [failure];
}

class AccessCubit extends Cubit<AccessState> {
  AccessCubit(this._repository) : super(const AccessLoading());

  final DeviceAccessRepository _repository;

  Future<void> refresh() async {
    final result = await _repository.getStatus();
    if (isClosed) return;
    emit(switch (result) {
      Ok(:final value) => AccessReady(value),
      Err(:final failure) => AccessFailure(failure),
    });
  }

  Future<void> openUsageAccessSettings() async {
    await _repository.openUsageAccessSettings();
  }

  Future<void> openOwnAppDetails() async {
    await _repository.openOwnAppDetails();
  }

  Future<void> openAppDetails(String packageName) async {
    await _repository.openAppDetails(packageName);
  }
}
