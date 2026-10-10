import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:privacy_lens/core/errors/app_failure.dart';
import 'package:privacy_lens/core/errors/result.dart';
import 'package:privacy_lens/features/audit/domain/audit_repository.dart';
import 'package:privacy_lens/features/audit/domain/risk_engine.dart';
import 'package:privacy_lens/features/audit/presentation/audit_cubit.dart';

import '../../../helpers/fixtures.dart';

class MockAuditRepository extends Mock implements AuditRepository {}

void main() {
  late MockAuditRepository repository;
  final report = const RiskEngine().evaluate(
    apps: [snapshot()],
    completedAt: testNow,
    hadUsageAccess: true,
    now: testNow,
  );

  setUp(() {
    repository = MockAuditRepository();
  });

  blocTest<AuditCubit, AuditState>(
    'loadLatest emits empty when no scan exists',
    build: () {
      when(repository.loadLatestReport).thenAnswer((_) async => const Ok(null));
      return AuditCubit(repository);
    },
    act: (cubit) => cubit.loadLatest(),
    expect: () => [const AuditLoading(), const AuditEmpty()],
  );

  blocTest<AuditCubit, AuditState>(
    'scan emits ready',
    build: () {
      when(
        () => repository.runScan(onProgress: any(named: 'onProgress')),
      ).thenAnswer((_) async => Ok(report));
      return AuditCubit(repository);
    },
    act: (cubit) => cubit.scan(),
    expect: () => [isA<AuditScanning>(), AuditReady(report)],
  );

  blocTest<AuditCubit, AuditState>(
    'scan emits failure',
    build: () {
      when(
        () => repository.runScan(onProgress: any(named: 'onProgress')),
      ).thenAnswer((_) async => const Err(StorageFailure()));
      return AuditCubit(repository);
    },
    act: (cubit) => cubit.scan(),
    expect: () => [isA<AuditScanning>(), isA<AuditFailure>()],
  );
}
