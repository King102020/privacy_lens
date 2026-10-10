import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_lens/features/audit/data/tracker_rule_pack_loader.dart';
import 'package:privacy_lens/features/audit/domain/entities/tracker_sdk.dart';

void main() {
  test('parses valid entries and skips broken ones', () {
    const source = '''
{
  "version": "2026.10.1",
  "trackers": [
    {
      "id": "ads",
      "name": "Ads",
      "category": "advertising",
      "classPrefixes": ["com.ads.sdk"]
    },
    {
      "id": "bad",
      "name": "Bad",
      "category": "unknown",
      "classPrefixes": ["com.bad"]
    },
    {
      "id": "empty",
      "name": "Empty",
      "category": "analytics",
      "classPrefixes": []
    }
  ]
}
''';
    final pack = TrackerRulePackLoader.parse(source);
    expect(pack.version, '2026.10.1');
    expect(pack.sdks, hasLength(1));
    expect(pack.byId('ads')?.category, TrackerCategory.advertising);
  });

  test('rejects a non-object pack', () {
    expect(
      () => TrackerRulePackLoader.parse('[]'),
      throwsA(isA<FormatException>()),
    );
  });
}
