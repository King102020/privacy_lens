import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../audit/domain/entities/audit_report.dart';
import '../../audit/domain/entities/capability.dart';
import '../../audit/domain/entities/severity.dart';

enum AppsFilter { all, highRisk, camera, microphone }

class AppsFilterState extends Equatable {
  const AppsFilterState({this.query = '', this.filter = AppsFilter.all});

  final String query;
  final AppsFilter filter;

  List<AppAudit> apply(List<AppAudit> apps) {
    final needle = query.trim().toLowerCase();
    return [
      for (final audit in apps)
        if (_matches(audit, needle)) audit,
    ];
  }

  int count(List<AppAudit> apps, AppsFilter filter) {
    return AppsFilterState(query: query, filter: filter).apply(apps).length;
  }

  bool _matches(AppAudit audit, String needle) {
    final app = audit.app;
    if (needle.isNotEmpty &&
        !app.label.toLowerCase().contains(needle) &&
        !app.packageName.toLowerCase().contains(needle)) {
      return false;
    }
    return switch (filter) {
      AppsFilter.all => true,
      AppsFilter.highRisk => audit.riskLevel == RiskLevel.high,
      AppsFilter.camera => app.has(Capability.camera),
      AppsFilter.microphone => app.has(Capability.microphone),
    };
  }

  AppsFilterState copyWith({String? query, AppsFilter? filter}) =>
      AppsFilterState(
        query: query ?? this.query,
        filter: filter ?? this.filter,
      );

  @override
  List<Object?> get props => [query, filter];
}

class AppsFilterCubit extends Cubit<AppsFilterState> {
  AppsFilterCubit() : super(const AppsFilterState());

  void setQuery(String query) => emit(state.copyWith(query: query));

  void setFilter(AppsFilter filter) => emit(state.copyWith(filter: filter));
}
