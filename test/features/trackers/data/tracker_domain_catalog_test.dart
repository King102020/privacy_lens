import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_lens/features/audit/domain/entities/tracker_sdk.dart';
import 'package:privacy_lens/features/trackers/data/tracker_domain_catalog.dart';

void main() {
  test('matches a domain or its parent', () {
    final catalog = TrackerDomainCatalog.parse('''
# version: 2026.10.1
ads.example.com advertising
tracker.io analytics
''');
    expect(catalog.version, '2026.10.1');
    expect(
      catalog.categoryFor('pixel.ads.example.com'),
      TrackerCategory.advertising,
    );
    expect(catalog.categoryFor('TRACKER.IO'), TrackerCategory.analytics);
    expect(catalog.categoryFor('honest.app'), isNull);
  });

  test('shipped list is versioned, large, and excludes login hosts', () {
    final catalog = TrackerDomainCatalog.parse(
      File('assets/rules/tracker_domains.txt').readAsStringSync(),
    );
    expect(catalog.version, '2026.10.2');
    expect(catalog.size, greaterThan(1000));
    expect(catalog.size, lessThanOrEqualTo(15000));
    expect(catalog.categoryFor('doubleclick.net'), TrackerCategory.advertising);
    expect(catalog.categoryFor('accounts.google.com'), isNull);
    expect(catalog.categoryFor('graph.facebook.com'), isNull);

    final exclusions = File('assets/rules/blocklist_exclusions.txt')
        .readAsLinesSync()
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty && !line.startsWith('#'));
    for (final host in exclusions) {
      expect(
        catalog.categoryFor(host),
        isNull,
        reason: '$host must stay off the shipped list',
      );
    }
  });
}
