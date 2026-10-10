import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../audit/domain/entities/finding.dart';
import '../../audit/domain/entities/severity.dart';

enum FindingsFilter { all, high, trackers, permissions }

class FindingsFilterState extends Equatable {
  const FindingsFilterState({this.filter = FindingsFilter.all});

  final FindingsFilter filter;

  List<Finding> apply(List<Finding> findings) => [
    for (final finding in findings)
      if (_matches(finding)) finding,
  ];

  int count(List<Finding> findings, FindingsFilter filter) =>
      FindingsFilterState(filter: filter).apply(findings).length;

  bool _matches(Finding finding) => switch (filter) {
    FindingsFilter.all => true,
    FindingsFilter.high => finding.severity == Severity.high,
    FindingsFilter.trackers => finding.category == FindingCategory.trackers,
    FindingsFilter.permissions =>
      finding.category == FindingCategory.permissions,
  };

  @override
  List<Object?> get props => [filter];
}

class FindingsFilterCubit extends Cubit<FindingsFilterState> {
  FindingsFilterCubit() : super(const FindingsFilterState());

  void setFilter(FindingsFilter filter) =>
      emit(FindingsFilterState(filter: filter));
}
