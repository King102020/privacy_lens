import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_lens/features/audit/domain/entities/tracker_sdk.dart';
import 'package:privacy_lens/features/trackers/domain/tracker_shield_entities.dart';
import 'package:privacy_lens/features/trackers/presentation/tracker_shield_cubit.dart';

void main() {
  final later = DateTime(2026, 10, 10);
  final earlier = DateTime(2026, 10, 1);

  TrackerShieldReady sample({
    String query = '',
    ShieldSort sort = ShieldSort.hits,
  }) => TrackerShieldReady(
    status: const TrackerShieldStatus(
      isRunning: true,
      blocklistVersion: '1',
      blocklistSize: 2,
    ),
    policy: const ShieldPolicy(
      enabledCategories: {},
      extraBlocked: [],
      allowed: [],
      countsByCategory: {},
    ),
    activity: ShieldActivity(
      summaries: [
        BlockedDomainSummary(
          domain: 'zeta.ads',
          category: TrackerCategory.advertising,
          packageName: 'com.a',
          count: 1,
          lastBlockedAt: later,
        ),
        BlockedDomainSummary(
          domain: 'alpha.track',
          category: TrackerCategory.analytics,
          packageName: 'com.b',
          count: 5,
          lastBlockedAt: earlier,
        ),
      ],
      blockedTodayByHour: const [],
      totalBlocked: 6,
      distinctDomains: 2,
      distinctApps: 2,
    ),
    query: query,
    sort: sort,
  );

  test('matches tracker category name', () {
    expect(sample(query: 'advert').visible.map((item) => item.domain), [
      'zeta.ads',
    ]);
  });

  test('sorts by name', () {
    expect(sample(sort: ShieldSort.name).visible.map((item) => item.domain), [
      'alpha.track',
      'zeta.ads',
    ]);
  });

  test('sorts by most recent', () {
    expect(sample(sort: ShieldSort.recent).visible.first.domain, 'zeta.ads');
  });
}
