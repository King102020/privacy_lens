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
}
