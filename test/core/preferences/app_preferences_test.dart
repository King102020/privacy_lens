import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_lens/core/preferences/app_preferences.dart';

void main() {
  test('rejects URLs and accepts hostnames', () {
    expect(
      AppPreferences.tryParseHostname('ads.example.com'),
      'ads.example.com',
    );
    expect(
      AppPreferences.tryParseHostname('Ads.Example.COM.'),
      'ads.example.com',
    );
    expect(AppPreferences.tryParseHostname('https://ads.example.com'), isNull);
    expect(AppPreferences.tryParseHostname('ads.example.com/pixel'), isNull);
    expect(AppPreferences.tryParseHostname('localhost'), isNull);
    expect(AppPreferences.tryParseHostname('not a host'), isNull);
  });
}
