import 'package:equatable/equatable.dart';

import '../../../core/errors/result.dart';
import 'entities/audit_report.dart';

enum ScanPhase { collecting, scanningPackages, analyzing }

class ScanProgress extends Equatable {
  const ScanProgress({required this.phase, this.scanned = 0, this.total = 0});

  final ScanPhase phase;
  final int scanned;
  final int total;

  /// Null while the total is unknown.
  double? get fraction => total == 0 ? null : scanned / total;

  @override
  List<Object?> get props => [phase, scanned, total];
}

abstract interface class AuditRepository {
  /// Rebuilds the report from the last completed scan, or returns null when
  /// no scan has finished yet.
  Future<Result<AuditReport?>> loadLatestReport();

  /// Collects fresh facts from the device and evaluates them. Concurrent
  /// calls share the scan already in flight.
  Future<Result<AuditReport>> runScan({
    void Function(ScanProgress progress)? onProgress,
  });
}
