// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Privacy Lens';

  @override
  String get appTagline => 'Local on-device engine';

  @override
  String get localOnlyBanner => 'Zero telemetry · 100% on-device';

  @override
  String get aboutTooltip => 'How Privacy Lens works';

  @override
  String get aboutTitle => 'How Privacy Lens works';

  @override
  String get aboutIntro =>
      'Everything stays on this phone. There is no account and no network call of our own. Here is what a scan can and cannot see.';

  @override
  String get aboutPermissionsTitle => 'Granted permissions';

  @override
  String get aboutPermissionsBody =>
      'We read which sensitive permissions each app is currently allowed to use, not a history of each use.';

  @override
  String get aboutUsageTitle => 'Foreground time';

  @override
  String get aboutUsageBody =>
      'With Usage Access, we show how long an app was on screen and when it was last opened. Background sensor use is not visible.';

  @override
  String get aboutTrackersTitle => 'Embedded libraries';

  @override
  String get aboutTrackersBody =>
      'A local scan of each app package looks for known advertising and analytics SDKs.';

  @override
  String get aboutShieldTitle => 'Tracker Shield';

  @override
  String get aboutShieldBody =>
      'Optional DNS filter that blocks known tracker domains. Lookups that get through encrypted DNS or another VPN will not appear.';

  @override
  String get aboutLimitsTitle => 'What we cannot see';

  @override
  String get aboutLimitsBody =>
      'We cannot watch a permission being used in the background, read the clipboard of other apps, or see data leaving over HTTPS.';

  @override
  String get navHome => 'Home';

  @override
  String get navApps => 'Apps';

  @override
  String get navFindings => 'Findings';

  @override
  String get navTrackers => 'Trackers';

  @override
  String get navSettings => 'Settings';

  @override
  String get loading => 'Loading';

  @override
  String get retry => 'Try again';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get cancel => 'Cancel';

  @override
  String get continueAction => 'Continue';

  @override
  String get skip => 'Skip intro';

  @override
  String get back => 'Back';

  @override
  String get close => 'Close';

  @override
  String get done => 'Done';

  @override
  String get notNow => 'Not now';

  @override
  String get failureUsageAccess =>
      'Usage Access is off, so foreground time is hidden. You can still scan permissions and trackers.';

  @override
  String get failureVpnConsent =>
      'Tracker Shield needs the Android VPN consent dialog. Nothing is sent off the phone.';

  @override
  String get failurePlatform =>
      'Android could not complete that request. Try again.';

  @override
  String get failureStorage =>
      'The local vault could not be read. Try again, or wipe the vault from Settings if this keeps happening.';

  @override
  String get failureUnexpected => 'An unexpected error stopped this action.';

  @override
  String get unknownRouteTitle => 'Page not found';

  @override
  String get unknownRouteBody =>
      'That link does not match a screen in Privacy Lens.';

  @override
  String get unknownRouteHome => 'Go to Home';

  @override
  String get severityLow => 'Low';

  @override
  String get severityMedium => 'Medium';

  @override
  String get severityHigh => 'High';

  @override
  String get riskMinimal => 'Minimal risk';

  @override
  String get riskLow => 'Low risk';

  @override
  String get riskMedium => 'Medium risk';

  @override
  String get riskHigh => 'High risk';

  @override
  String get postureCalm => 'Calm';

  @override
  String get postureObservant => 'Guarded and observant';

  @override
  String get postureNeedsAttention => 'Needs attention';

  @override
  String get postureCalmHint => 'No high-severity findings on this scan.';

  @override
  String get postureObservantHint => 'A few items are worth a look.';

  @override
  String get postureNeedsAttentionHint =>
      'Several high-severity items showed up on this scan.';

  @override
  String get capabilityCamera => 'Camera';

  @override
  String get capabilityMicrophone => 'Microphone';

  @override
  String get capabilityPreciseLocation => 'Precise location';

  @override
  String get capabilityApproximateLocation => 'Approximate location';

  @override
  String get capabilityBackgroundLocation => 'Background location';

  @override
  String get capabilityContacts => 'Contacts';

  @override
  String get capabilitySms => 'SMS';

  @override
  String get capabilityCallLog => 'Call log';

  @override
  String get capabilityPhone => 'Phone';

  @override
  String get capabilityCalendar => 'Calendar';

  @override
  String get capabilityBodySensors => 'Body sensors';

  @override
  String get capabilityPhysicalActivity => 'Physical activity';

  @override
  String get capabilityMediaAndFiles => 'Media and files';

  @override
  String get capabilityNearbyDevices => 'Nearby devices';

  @override
  String get specialAccessibility => 'Accessibility service';

  @override
  String get specialNotificationListener => 'Notification listener';

  @override
  String get specialDeviceAdmin => 'Device admin';

  @override
  String get specialOverlay => 'Display over other apps';

  @override
  String get categoryAdvertising => 'Advertising';

  @override
  String get categoryAnalytics => 'Analytics';

  @override
  String get categoryAttribution => 'Attribution';

  @override
  String get categoryProfiling => 'Profiling';

  @override
  String get categoryCrashReporting => 'Crash reporting';

  @override
  String get findingSensorTrioTitle =>
      'Camera, microphone, and location together';

  @override
  String get findingSensorTrioBody =>
      'This app is allowed to use the camera, microphone, and location. That combination can record a lot about where you are and what is around you.';

  @override
  String get findingAccessibilityTitle => 'Accessibility service is on';

  @override
  String get findingAccessibilityBody =>
      'An accessibility service can read what is on the screen. Review this if you did not turn it on yourself.';

  @override
  String get findingNotificationListenerTitle => 'Notification listener is on';

  @override
  String get findingNotificationListenerBody =>
      'This app can read the text of your notifications, including one-time codes and message previews.';

  @override
  String get findingDeviceAdminTitle => 'Device administrator is on';

  @override
  String get findingDeviceAdminBody =>
      'A device admin can lock the phone or erase data. Keep this only if you trust the app.';

  @override
  String get findingOverlayTitle => 'Overlay plus accessibility';

  @override
  String get findingOverlayBody =>
      'This app can draw over other apps and also use accessibility. That pairing can hide or mimic system prompts.';

  @override
  String get findingBackgroundLocationTitle => 'Background location is allowed';

  @override
  String get findingBackgroundLocationBody =>
      'This app can keep reading location when it is not on screen. Android settings can limit it to while in use.';

  @override
  String get findingMessagesTitle => 'Messages or call logs are allowed';

  @override
  String get findingMessagesBody =>
      'This app can read SMS or call history. That is private communication, not just a contact list.';

  @override
  String get findingEmbeddedTrackersTitle =>
      'Known tracker libraries inside the app';

  @override
  String get findingEmbeddedTrackersBody =>
      'The app package contains advertising or analytics SDKs. Those libraries can send usage signals when the app has a network path.';

  @override
  String get findingTrackerDomainsTitle => 'Contacts with tracker domains';

  @override
  String get findingTrackerDomainsBody =>
      'Tracker Shield blocked DNS lookups to known advertising or analytics hosts from this app.';

  @override
  String get findingUnusedTitle => 'Unused app still holds sensitive access';

  @override
  String get findingUnusedBody =>
      'This app has not been opened in about 90 days and still holds sensitive permissions. Android can reset unused permissions from App info.';

  @override
  String get actionOpenSettings => 'Open Android app settings';

  @override
  String get actionEnableShield => 'Turn on Tracker Shield';

  @override
  String get findingWhy => 'Why this matters';

  @override
  String get onboardingPage1Eyebrow => 'On-device audit';

  @override
  String get onboardingPage1Title => 'See what apps are allowed to use.';

  @override
  String get onboardingPage1Body =>
      'Privacy Lens maps granted permissions, unused apps with sensitive access, and known tracker libraries. The work stays on this phone.';

  @override
  String get onboardingPage1Item1Title => 'Permission inventory';

  @override
  String get onboardingPage1Item1Body =>
      'Groups camera, microphone, location, and other sensitive grants.';

  @override
  String get onboardingPage1Item2Title => 'Embedded trackers';

  @override
  String get onboardingPage1Item2Body =>
      'Finds known commercial tracking SDKs inside each app package.';

  @override
  String get onboardingPage2Eyebrow => 'Usage Access';

  @override
  String get onboardingPage2Title => 'Foreground time needs a system grant.';

  @override
  String get onboardingPage2Body =>
      'Android only shares how long an app was on screen after you turn on Usage Access for Privacy Lens. You can skip this and still scan permissions.';

  @override
  String get onboardingRestrictedTitle =>
      'Sideloaded installs may need an extra step';

  @override
  String get onboardingRestrictedBody =>
      'On Android 13 and later, open App info, tap the menu, and choose Allow restricted settings. Then you can enable Usage Access.';

  @override
  String get onboardingGrantUsage => 'Open Usage Access';

  @override
  String get onboardingOpenAppInfo => 'Open App info first';

  @override
  String get onboardingUsageGranted => 'Usage Access is on';

  @override
  String get onboardingPage3Eyebrow => 'Optional filter';

  @override
  String get onboardingPage3Title => 'Block tracker domains on this phone.';

  @override
  String get onboardingPage3Body =>
      'Tracker Shield is a local DNS filter. Android will show a VPN consent screen. No browsing data is sent to us.';

  @override
  String get onboardingStartShield => 'Turn on Tracker Shield';

  @override
  String get onboardingSkipShield => 'Skip for now';

  @override
  String get onboardingFinish => 'Start using Privacy Lens';

  @override
  String get homeSectionLabel => 'Dashboard';

  @override
  String get homeDevicePosture => 'Device posture';

  @override
  String homeAppsAudited(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps audited',
      one: '1 app audited',
    );
    return '$_temp0';
  }

  @override
  String homePostureSummary(int apps, int micCamera, int trackers) {
    return '$apps apps audited. $micCamera have the microphone or camera allowed, and $trackers contain known tracking libraries.';
  }

  @override
  String get homeRunAudit => 'Run full audit';

  @override
  String homeLastScanned(String when) {
    return 'Last scanned $when';
  }

  @override
  String get homeNeverScanned => 'No scan yet';

  @override
  String get homeScanning => 'Scanning…';

  @override
  String get homeTelemetryGlimpse => 'Capability glimpse';

  @override
  String get homeAppsWithLocation => 'Apps with location';

  @override
  String get homeAppsWithMicrophone => 'Apps with microphone';

  @override
  String get homeTrackersBlocked => 'Lookups blocked';

  @override
  String get homeKeyDiscoveries => 'Key discoveries';

  @override
  String get homeViewAll => 'View all';

  @override
  String get homeEmptyTitle => 'Run your first audit';

  @override
  String get homeEmptyBody =>
      'A scan reads installed apps, granted permissions, and known tracker libraries. Nothing leaves this phone.';

  @override
  String get homeUsageAccessRequiredTitle => 'Usage Access is off';

  @override
  String get homeUsageAccessRequiredBody =>
      'Foreground time and unused-app findings need Usage Access. Permissions and tracker libraries still scan without it.';

  @override
  String get homeLocalFooter => 'Every audit runs locally on your processor.';

  @override
  String get homeReviewPermissions => 'Review permissions';

  @override
  String get homeViewLog => 'View log';

  @override
  String get homeCleanup => 'Review unused';

  @override
  String get homeDiscoveryNeedsAttention => 'Needs attention';

  @override
  String get homeDiscoveryTracker => 'Tracker alert';

  @override
  String get homeDiscoveryHygiene => 'Low severity';

  @override
  String homeInstalledDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return 'Installed $_temp0 ago';
  }

  @override
  String homeActiveMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return 'Active $_temp0 ago';
  }

  @override
  String homeUnusedAppsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unused apps',
      one: '1 unused app',
    );
    return '$_temp0';
  }

  @override
  String get homeNoUsageDays => 'No opens in 90+ days';

  @override
  String get homeRequestsNeutralized => 'Blocked by the local filter';

  @override
  String homeRiskyPermissions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count risky permissions',
      one: '1 risky permission',
    );
    return '$_temp0';
  }

  @override
  String get appsSectionLabel => 'App audit';

  @override
  String get appsSearchHint => 'Search installed apps';

  @override
  String appsFilterAll(int count) {
    return 'All ($count)';
  }

  @override
  String appsFilterHighRisk(int count) {
    return 'High risk ($count)';
  }

  @override
  String appsFilterCamera(int count) {
    return 'Camera ($count)';
  }

  @override
  String appsFilterMicrophone(int count) {
    return 'Microphone ($count)';
  }

  @override
  String appsMonitored(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps',
      one: '1 app',
    );
    return '$_temp0';
  }

  @override
  String get appsRescan => 'Re-scan';

  @override
  String get appsEmptyTitle => 'No apps in this view';

  @override
  String get appsEmptyBody =>
      'Run an audit from Home, or change the system-app toggle in Settings.';

  @override
  String get appsNoMatchTitle => 'No matching apps';

  @override
  String get appsNoMatchBody => 'Try another search or filter.';

  @override
  String appsTrackersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count embedded trackers',
      one: '1 embedded tracker',
      zero: 'No trackers',
    );
    return '$_temp0';
  }

  @override
  String get appsNoNetwork => 'No network permission';

  @override
  String get appsSelectHint =>
      'Choose an app to see permissions, usage, and libraries.';

  @override
  String get detailTitle => 'App details';

  @override
  String get detailElevatedAttention => 'Elevated attention';

  @override
  String get detailUsage => 'Screen time';

  @override
  String get detailScanDay => 'On the day of the last scan';

  @override
  String detailForeground(String time) {
    return '$time foreground';
  }

  @override
  String get detailTrackers => 'Embedded analytics and trackers';

  @override
  String detailLibraries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count libraries',
      one: '1 library',
    );
    return '$_temp0';
  }

  @override
  String get detailPermissions => 'Declared hardware and data access';

  @override
  String detailGranted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count granted',
      one: '1 granted',
    );
    return '$_temp0';
  }

  @override
  String get detailOpenSettings => 'Open Android app settings';

  @override
  String get detailOpenSettingsHint =>
      'Revoke permissions or restrict background access in Android.';

  @override
  String get detailNotFound => 'That app is not in the latest scan.';

  @override
  String detailVersion(String version) {
    return 'v$version';
  }

  @override
  String get detailSystemApp => 'System app';

  @override
  String get detailNoTrackers => 'No known tracker libraries in this package.';

  @override
  String get detailNoPermissions => 'No sensitive permissions granted.';

  @override
  String detailLastUsed(String when) {
    return 'Last opened $when';
  }

  @override
  String get detailNeverUsed => 'Not opened in the last 120 days';

  @override
  String get detailUsageUnavailable => 'Foreground time needs Usage Access.';

  @override
  String get findingsSectionLabel => 'Audit report';

  @override
  String findingsIdentified(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items identified',
      one: '1 item identified',
    );
    return '$_temp0 across installed applications.';
  }

  @override
  String findingsFilterAll(int count) {
    return 'All ($count)';
  }

  @override
  String findingsFilterHigh(int count) {
    return 'High priority ($count)';
  }

  @override
  String findingsFilterTrackers(int count) {
    return 'Trackers ($count)';
  }

  @override
  String findingsFilterPermissions(int count) {
    return 'Permissions ($count)';
  }

  @override
  String get findingsEmptyTitle => 'Audit is clear';

  @override
  String get findingsEmptyBody =>
      'No findings from the latest scan. Run another audit after you install or update apps.';

  @override
  String get findingsHighPriority => 'High priority';

  @override
  String get findingsMediumPriority => 'Medium priority';

  @override
  String get findingsHygiene => 'Digital hygiene';

  @override
  String findingsAppCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps',
      one: '1 app',
    );
    return '$_temp0';
  }

  @override
  String get trackersSectionLabel => 'Network trackers';

  @override
  String get shieldTitle => 'Tracker Shield';

  @override
  String get shieldActive => 'Active';

  @override
  String get shieldOff => 'Off';

  @override
  String get shieldDescription =>
      'A local DNS filter on this phone. Android shows it as a VPN because that is the only hook for filtering lookups. No packets of ours leave the device.';

  @override
  String get shieldDomainsBlocked => 'Domains blocked';

  @override
  String get shieldAppsMonitored => 'Apps attributed';

  @override
  String get shieldNoDataSent => 'Sent by us';

  @override
  String get shieldNoDataSentValue => 'None';

  @override
  String get shieldHourlyTitle => 'Blocked lookups today';

  @override
  String get shieldSearchHint => 'Search blocked domains or apps';

  @override
  String shieldFilterAll(int count) {
    return 'All ($count)';
  }

  @override
  String shieldBlockedTimes(int count) {
    return 'Blocked $count×';
  }

  @override
  String get shieldUnknownApp => 'App not attributed';

  @override
  String shieldBlocklistVersion(String version) {
    return 'Blocklist $version';
  }

  @override
  String shieldRulesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rules',
      one: '1 rule',
    );
    return '$_temp0 shipped with this version';
  }

  @override
  String get shieldLimitsTitle => 'What can slip past';

  @override
  String get shieldLimitPrivateDns =>
      'Strict Private DNS in Android settings bypasses this filter.';

  @override
  String get shieldLimitDoh =>
      'Apps that resolve names over their own encrypted DNS will not appear here.';

  @override
  String get shieldLimitOtherVpn =>
      'Another active VPN takes over the tunnel, so this shield pauses.';

  @override
  String get shieldEmptyTitle => 'No blocked lookups yet';

  @override
  String get shieldEmptyBody =>
      'Turn the shield on, then use other apps as usual. Only blocked tracker domains are stored.';

  @override
  String get shieldStartFailed => 'Tracker Shield could not start.';

  @override
  String get shieldConsentDenied =>
      'VPN consent was declined. The shield stayed off.';

  @override
  String get settingsSectionLabel => 'Privacy settings';

  @override
  String get settingsDataControl => 'Data and autonomy';

  @override
  String get settingsVaultSecure => 'Sandbox vault';

  @override
  String get settingsEncrypted => 'Encrypted with SQLCipher';

  @override
  String settingsVaultSize(String size) {
    return '$size used';
  }

  @override
  String get settingsRetentionTitle => 'Audit history retention';

  @override
  String get settingsRetentionBody =>
      'Scans and usage older than this window are deleted automatically. The latest scan is kept.';

  @override
  String settingsRetentionDays(int count) {
    return '$count days';
  }

  @override
  String get settingsDnsRetentionTitle => 'Tracker log auto-cleanup';

  @override
  String get settingsDnsRetentionBody =>
      'Blocked DNS rows older than this window are deleted.';

  @override
  String get settingsDnsDaily => '1 day';

  @override
  String get settingsDnsWeekly => '7 days';

  @override
  String get settingsIncludeSystemTitle => 'Include system apps';

  @override
  String get settingsIncludeSystemBody =>
      'Adds preinstalled packages to the next scan. Most people can leave this off.';

  @override
  String get settingsExportTitle => 'Export audit report';

  @override
  String get settingsExportBody =>
      'Writes a file you choose. The file never leaves the phone unless you share it.';

  @override
  String get settingsExportJson => 'Export JSON';

  @override
  String get settingsExportCsv => 'Export CSV';

  @override
  String get settingsExportEmpty => 'Run an audit before exporting.';

  @override
  String get settingsExportSaved => 'Report saved.';

  @override
  String get settingsExportCanceled => 'Export canceled.';

  @override
  String get settingsWipeTitle => 'Delete all stored audit data';

  @override
  String get settingsWipeBody =>
      'Purges scans, findings, usage, and blocked lookup logs, then re-encrypts the vault.';

  @override
  String get settingsWipeAction => 'Wipe data vault';

  @override
  String get settingsWipeConfirmTitle => 'Wipe the vault?';

  @override
  String get settingsWipeConfirmBody =>
      'This cannot be undone. You will need to run a new audit.';

  @override
  String get settingsTransparency => 'Transparency and architecture';

  @override
  String get settingsInternetTitle => 'INTERNET is used only for DNS';

  @override
  String get settingsInternetBody =>
      'The INTERNET permission exists so Tracker Shield can forward allowed DNS lookups to your network. Privacy Lens never opens its own connections.';

  @override
  String get settingsHowItWorks => 'How Privacy Lens works';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String settingsVersion(String version) {
    return 'Privacy Lens $version · 100% local';
  }

  @override
  String get settingsPowerModeLocked => 'Power mode';

  @override
  String get settingsPowerModeHint =>
      'Deeper inspection is planned. It is locked in this version.';

  @override
  String get settingsComingLater => 'Coming later';

  @override
  String get scanCollecting => 'Reading installed apps…';

  @override
  String scanScanningPackages(int scanned, int total) {
    return 'Scanning packages $scanned of $total';
  }

  @override
  String get scanAnalyzing => 'Evaluating findings…';

  @override
  String get relativeJustNow => 'just now';

  @override
  String relativeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String relativeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String relativeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String relativeToday(String time) {
    return 'today at $time';
  }

  @override
  String durationMinutes(int count) {
    return '${count}m';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String sizeBytes(int count) {
    return '$count B';
  }

  @override
  String sizeKilobytes(String count) {
    return '$count KB';
  }

  @override
  String sizeMegabytes(String count) {
    return '$count MB';
  }
}
