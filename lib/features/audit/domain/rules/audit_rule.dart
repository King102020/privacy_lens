import '../entities/app_snapshot.dart';
import '../entities/finding.dart';

class AuditContext {
  const AuditContext({required this.now});

  final DateTime now;
}

/// Turns observed facts about one app into at most one finding.
abstract interface class AuditRule {
  Finding? evaluate(AppSnapshot app, AuditContext context);
}
