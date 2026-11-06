import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Application name shown in the launcher, task switcher, and top bar.
  ///
  /// In en, this message translates to:
  /// **'Privacy Lens'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Stays on this phone'**
  String get appTagline;

  /// No description provided for @localOnlyBanner.
  ///
  /// In en, this message translates to:
  /// **'Zero telemetry · 100% on-device'**
  String get localOnlyBanner;

  /// No description provided for @guideGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get guideGotIt;

  /// No description provided for @guideHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get guideHomeTitle;

  /// No description provided for @guideHomeBody.
  ///
  /// In en, this message translates to:
  /// **'Run a scan to see permissions and tracker libraries. Nothing leaves this phone.'**
  String get guideHomeBody;

  /// No description provided for @guideAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get guideAppsTitle;

  /// No description provided for @guideAppsBody.
  ///
  /// In en, this message translates to:
  /// **'Each app’s grants, usage, and known libraries. Open one to review it.'**
  String get guideAppsBody;

  /// No description provided for @guideFindingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Findings'**
  String get guideFindingsTitle;

  /// No description provided for @guideFindingsBody.
  ///
  /// In en, this message translates to:
  /// **'Issues from the latest scan, grouped by how serious they are.'**
  String get guideFindingsBody;

  /// No description provided for @guideTrackersTitle.
  ///
  /// In en, this message translates to:
  /// **'Tracker Shield'**
  String get guideTrackersTitle;

  /// No description provided for @guideTrackersBody.
  ///
  /// In en, this message translates to:
  /// **'This switch filters tracker hostnames on the phone. It cannot hide ads already drawn in a page.'**
  String get guideTrackersBody;

  /// No description provided for @guideSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get guideSettingsTitle;

  /// No description provided for @guideSettingsBody.
  ///
  /// In en, this message translates to:
  /// **'Retention, export, and wipe stay on this phone. Replay these tips anytime.'**
  String get guideSettingsBody;

  /// No description provided for @settingsReplayTips.
  ///
  /// In en, this message translates to:
  /// **'Replay tips'**
  String get settingsReplayTips;

  /// No description provided for @settingsReplayTipsBody.
  ///
  /// In en, this message translates to:
  /// **'Show the first-visit guide on each tab again.'**
  String get settingsReplayTipsBody;

  /// No description provided for @aboutTooltip.
  ///
  /// In en, this message translates to:
  /// **'How Privacy Lens works'**
  String get aboutTooltip;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'How Privacy Lens works'**
  String get aboutTitle;

  /// No description provided for @aboutIntro.
  ///
  /// In en, this message translates to:
  /// **'Everything stays on this phone. There is no account and no network call of our own. Here is what a scan can and cannot see.'**
  String get aboutIntro;

  /// No description provided for @aboutPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Granted permissions'**
  String get aboutPermissionsTitle;

  /// No description provided for @aboutPermissionsBody.
  ///
  /// In en, this message translates to:
  /// **'We read which sensitive permissions each app is currently allowed to use, not a history of each use.'**
  String get aboutPermissionsBody;

  /// No description provided for @aboutUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Foreground time'**
  String get aboutUsageTitle;

  /// No description provided for @aboutUsageBody.
  ///
  /// In en, this message translates to:
  /// **'With Usage Access, we show how long an app was on screen and when it was last opened. Background sensor use is not visible.'**
  String get aboutUsageBody;

  /// No description provided for @aboutTrackersTitle.
  ///
  /// In en, this message translates to:
  /// **'Embedded libraries'**
  String get aboutTrackersTitle;

  /// No description provided for @aboutTrackersBody.
  ///
  /// In en, this message translates to:
  /// **'A local scan of each app package looks for known advertising and analytics SDKs.'**
  String get aboutTrackersBody;

  /// No description provided for @aboutShieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Tracker Shield'**
  String get aboutShieldTitle;

  /// No description provided for @aboutShieldBody.
  ///
  /// In en, this message translates to:
  /// **'Optional DNS filter that blocks known tracker domains. Lookups that get through encrypted DNS or another VPN will not appear.'**
  String get aboutShieldBody;

  /// No description provided for @aboutLimitsTitle.
  ///
  /// In en, this message translates to:
  /// **'What we cannot see'**
  String get aboutLimitsTitle;

  /// No description provided for @aboutLimitsBody.
  ///
  /// In en, this message translates to:
  /// **'We cannot watch a permission being used in the background, read the clipboard of other apps, or see data leaving over HTTPS.'**
  String get aboutLimitsBody;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navApps.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get navApps;

  /// No description provided for @navFindings.
  ///
  /// In en, this message translates to:
  /// **'Findings'**
  String get navFindings;

  /// No description provided for @navTrackers.
  ///
  /// In en, this message translates to:
  /// **'Trackers'**
  String get navTrackers;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip intro'**
  String get skip;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @failureUsageAccess.
  ///
  /// In en, this message translates to:
  /// **'Usage Access is off, so foreground time is hidden. You can still scan permissions and trackers.'**
  String get failureUsageAccess;

  /// No description provided for @failureVpnConsent.
  ///
  /// In en, this message translates to:
  /// **'Tracker Shield needs the Android VPN consent dialog. Nothing is sent off the phone.'**
  String get failureVpnConsent;

  /// No description provided for @failurePlatform.
  ///
  /// In en, this message translates to:
  /// **'Android could not complete that request. Try again.'**
  String get failurePlatform;

  /// No description provided for @failureStorage.
  ///
  /// In en, this message translates to:
  /// **'The local vault could not be read. Try again, or wipe the vault from Settings if this keeps happening.'**
  String get failureStorage;

  /// No description provided for @failureUnexpected.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error stopped this action.'**
  String get failureUnexpected;

  /// No description provided for @unknownRouteTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get unknownRouteTitle;

  /// No description provided for @unknownRouteBody.
  ///
  /// In en, this message translates to:
  /// **'That link does not match a screen in Privacy Lens.'**
  String get unknownRouteBody;

  /// No description provided for @unknownRouteHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get unknownRouteHome;

  /// No description provided for @severityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get severityLow;

  /// No description provided for @severityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get severityMedium;

  /// No description provided for @severityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get severityHigh;

  /// No description provided for @riskMinimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal risk'**
  String get riskMinimal;

  /// No description provided for @riskLow.
  ///
  /// In en, this message translates to:
  /// **'Low risk'**
  String get riskLow;

  /// No description provided for @riskMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium risk'**
  String get riskMedium;

  /// No description provided for @riskHigh.
  ///
  /// In en, this message translates to:
  /// **'High risk'**
  String get riskHigh;

  /// No description provided for @postureCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get postureCalm;

  /// No description provided for @postureObservant.
  ///
  /// In en, this message translates to:
  /// **'Guarded and observant'**
  String get postureObservant;

  /// No description provided for @postureNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get postureNeedsAttention;

  /// No description provided for @postureCalmHint.
  ///
  /// In en, this message translates to:
  /// **'No high-severity findings on this scan.'**
  String get postureCalmHint;

  /// No description provided for @postureObservantHint.
  ///
  /// In en, this message translates to:
  /// **'A few items are worth a look.'**
  String get postureObservantHint;

  /// No description provided for @postureNeedsAttentionHint.
  ///
  /// In en, this message translates to:
  /// **'Several high-severity items showed up on this scan.'**
  String get postureNeedsAttentionHint;

  /// No description provided for @capabilityCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get capabilityCamera;

  /// No description provided for @capabilityMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get capabilityMicrophone;

  /// No description provided for @capabilityPreciseLocation.
  ///
  /// In en, this message translates to:
  /// **'Precise location'**
  String get capabilityPreciseLocation;

  /// No description provided for @capabilityApproximateLocation.
  ///
  /// In en, this message translates to:
  /// **'Approximate location'**
  String get capabilityApproximateLocation;

  /// No description provided for @capabilityBackgroundLocation.
  ///
  /// In en, this message translates to:
  /// **'Background location'**
  String get capabilityBackgroundLocation;

  /// No description provided for @capabilityContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get capabilityContacts;

  /// No description provided for @capabilitySms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get capabilitySms;

  /// No description provided for @capabilityCallLog.
  ///
  /// In en, this message translates to:
  /// **'Call log'**
  String get capabilityCallLog;

  /// No description provided for @capabilityPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get capabilityPhone;

  /// No description provided for @capabilityCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get capabilityCalendar;

  /// No description provided for @capabilityBodySensors.
  ///
  /// In en, this message translates to:
  /// **'Body sensors'**
  String get capabilityBodySensors;

  /// No description provided for @capabilityPhysicalActivity.
  ///
  /// In en, this message translates to:
  /// **'Physical activity'**
  String get capabilityPhysicalActivity;

  /// No description provided for @capabilityMediaAndFiles.
  ///
  /// In en, this message translates to:
  /// **'Media and files'**
  String get capabilityMediaAndFiles;

  /// No description provided for @capabilityNearbyDevices.
  ///
  /// In en, this message translates to:
  /// **'Nearby devices'**
  String get capabilityNearbyDevices;

  /// No description provided for @specialAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility service'**
  String get specialAccessibility;

  /// No description provided for @specialNotificationListener.
  ///
  /// In en, this message translates to:
  /// **'Notification listener'**
  String get specialNotificationListener;

  /// No description provided for @specialDeviceAdmin.
  ///
  /// In en, this message translates to:
  /// **'Device admin'**
  String get specialDeviceAdmin;

  /// No description provided for @specialOverlay.
  ///
  /// In en, this message translates to:
  /// **'Display over other apps'**
  String get specialOverlay;

  /// No description provided for @categoryAdvertising.
  ///
  /// In en, this message translates to:
  /// **'Advertising'**
  String get categoryAdvertising;

  /// No description provided for @categoryAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get categoryAnalytics;

  /// No description provided for @categoryAttribution.
  ///
  /// In en, this message translates to:
  /// **'Attribution'**
  String get categoryAttribution;

  /// No description provided for @categoryProfiling.
  ///
  /// In en, this message translates to:
  /// **'Profiling'**
  String get categoryProfiling;

  /// No description provided for @categoryCrashReporting.
  ///
  /// In en, this message translates to:
  /// **'Crash reporting'**
  String get categoryCrashReporting;

  /// No description provided for @findingSensorTrioTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera, microphone, and location together'**
  String get findingSensorTrioTitle;

  /// No description provided for @findingSensorTrioBody.
  ///
  /// In en, this message translates to:
  /// **'This app is allowed to use the camera, microphone, and location. That combination can record a lot about where you are and what is around you.'**
  String get findingSensorTrioBody;

  /// No description provided for @findingAccessibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Accessibility service is on'**
  String get findingAccessibilityTitle;

  /// No description provided for @findingAccessibilityBody.
  ///
  /// In en, this message translates to:
  /// **'An accessibility service can read what is on the screen. Review this if you did not turn it on yourself.'**
  String get findingAccessibilityBody;

  /// No description provided for @findingNotificationListenerTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification listener is on'**
  String get findingNotificationListenerTitle;

  /// No description provided for @findingNotificationListenerBody.
  ///
  /// In en, this message translates to:
  /// **'This app can read the text of your notifications, including one-time codes and message previews.'**
  String get findingNotificationListenerBody;

  /// No description provided for @findingDeviceAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Device administrator is on'**
  String get findingDeviceAdminTitle;

  /// No description provided for @findingDeviceAdminBody.
  ///
  /// In en, this message translates to:
  /// **'A device admin can lock the phone or erase data. Keep this only if you trust the app.'**
  String get findingDeviceAdminBody;

  /// No description provided for @findingOverlayTitle.
  ///
  /// In en, this message translates to:
  /// **'Overlay plus accessibility'**
  String get findingOverlayTitle;

  /// No description provided for @findingOverlayBody.
  ///
  /// In en, this message translates to:
  /// **'This app can draw over other apps and also use accessibility. That pairing can hide or mimic system prompts.'**
  String get findingOverlayBody;

  /// No description provided for @findingBackgroundLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Background location is allowed'**
  String get findingBackgroundLocationTitle;

  /// No description provided for @findingBackgroundLocationBody.
  ///
  /// In en, this message translates to:
  /// **'This app can keep reading location when it is not on screen. Android settings can limit it to while in use.'**
  String get findingBackgroundLocationBody;

  /// No description provided for @findingMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages or call logs are allowed'**
  String get findingMessagesTitle;

  /// No description provided for @findingMessagesBody.
  ///
  /// In en, this message translates to:
  /// **'This app can read SMS or call history. That is private communication, not just a contact list.'**
  String get findingMessagesBody;

  /// No description provided for @findingEmbeddedTrackersTitle.
  ///
  /// In en, this message translates to:
  /// **'Known tracker libraries inside the app'**
  String get findingEmbeddedTrackersTitle;

  /// No description provided for @findingEmbeddedTrackersBody.
  ///
  /// In en, this message translates to:
  /// **'The app package contains advertising or analytics SDKs. Those libraries can send usage signals when the app has a network path.'**
  String get findingEmbeddedTrackersBody;

  /// No description provided for @findingTrackerDomainsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contacts with tracker domains'**
  String get findingTrackerDomainsTitle;

  /// No description provided for @findingTrackerDomainsBody.
  ///
  /// In en, this message translates to:
  /// **'Tracker Shield blocked DNS lookups to known advertising or analytics hosts from this app.'**
  String get findingTrackerDomainsBody;

  /// No description provided for @findingUnusedTitle.
  ///
  /// In en, this message translates to:
  /// **'Unused app still holds sensitive access'**
  String get findingUnusedTitle;

  /// No description provided for @findingUnusedBody.
  ///
  /// In en, this message translates to:
  /// **'This app has not been opened in about 90 days and still holds sensitive permissions. Android can reset unused permissions from App info.'**
  String get findingUnusedBody;

  /// No description provided for @actionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Android app settings'**
  String get actionOpenSettings;

  /// No description provided for @actionEnableShield.
  ///
  /// In en, this message translates to:
  /// **'Turn on Tracker Shield'**
  String get actionEnableShield;

  /// No description provided for @findingWhy.
  ///
  /// In en, this message translates to:
  /// **'Why this matters'**
  String get findingWhy;

  /// No description provided for @onboardingBeatApps.
  ///
  /// In en, this message translates to:
  /// **'Your apps hide ad and tracking code'**
  String get onboardingBeatApps;

  /// No description provided for @onboardingBeatSensors.
  ///
  /// In en, this message translates to:
  /// **'It sends your activity to ad companies'**
  String get onboardingBeatSensors;

  /// No description provided for @onboardingBeatTime.
  ///
  /// In en, this message translates to:
  /// **'They build a profile to target you'**
  String get onboardingBeatTime;

  /// No description provided for @onboardingBeatShield.
  ///
  /// In en, this message translates to:
  /// **'See it, block it, take back permissions'**
  String get onboardingBeatShield;

  /// No description provided for @onboardingPage1Eyebrow.
  ///
  /// In en, this message translates to:
  /// **'On-device audit'**
  String get onboardingPage1Eyebrow;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In en, this message translates to:
  /// **'See what apps are allowed to use.'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Body.
  ///
  /// In en, this message translates to:
  /// **'Permissions, unused apps, and tracker libraries. Stays on this phone.'**
  String get onboardingPage1Body;

  /// No description provided for @onboardingPage1Item1Title.
  ///
  /// In en, this message translates to:
  /// **'Permission inventory'**
  String get onboardingPage1Item1Title;

  /// No description provided for @onboardingPage1Item1Body.
  ///
  /// In en, this message translates to:
  /// **'Groups camera, microphone, location, and other sensitive grants.'**
  String get onboardingPage1Item1Body;

  /// No description provided for @onboardingPage1Item2Title.
  ///
  /// In en, this message translates to:
  /// **'Embedded trackers'**
  String get onboardingPage1Item2Title;

  /// No description provided for @onboardingPage1Item2Body.
  ///
  /// In en, this message translates to:
  /// **'Finds known commercial tracking SDKs inside each app package.'**
  String get onboardingPage1Item2Body;

  /// No description provided for @onboardingPage2Eyebrow.
  ///
  /// In en, this message translates to:
  /// **'Usage Access'**
  String get onboardingPage2Eyebrow;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In en, this message translates to:
  /// **'Foreground time needs a system grant.'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Body.
  ///
  /// In en, this message translates to:
  /// **'Needed for time on screen. You can skip it and still scan.'**
  String get onboardingPage2Body;

  /// No description provided for @onboardingRestrictedTitle.
  ///
  /// In en, this message translates to:
  /// **'Sideloaded installs may need an extra step'**
  String get onboardingRestrictedTitle;

  /// No description provided for @onboardingRestrictedBody.
  ///
  /// In en, this message translates to:
  /// **'On Android 13 and later, open App info, tap the menu, and choose Allow restricted settings. Then you can enable Usage Access.'**
  String get onboardingRestrictedBody;

  /// No description provided for @onboardingGrantUsage.
  ///
  /// In en, this message translates to:
  /// **'Open Usage Access'**
  String get onboardingGrantUsage;

  /// No description provided for @onboardingOpenAppInfo.
  ///
  /// In en, this message translates to:
  /// **'Open App info first'**
  String get onboardingOpenAppInfo;

  /// No description provided for @onboardingUsageGranted.
  ///
  /// In en, this message translates to:
  /// **'Usage Access is on'**
  String get onboardingUsageGranted;

  /// No description provided for @onboardingPage3Eyebrow.
  ///
  /// In en, this message translates to:
  /// **'Optional filter'**
  String get onboardingPage3Eyebrow;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In en, this message translates to:
  /// **'Block tracker domains on this phone.'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Body.
  ///
  /// In en, this message translates to:
  /// **'A local DNS filter. Android will ask for VPN consent.'**
  String get onboardingPage3Body;

  /// No description provided for @onboardingStartShield.
  ///
  /// In en, this message translates to:
  /// **'Turn on Tracker Shield'**
  String get onboardingStartShield;

  /// No description provided for @onboardingSkipShield.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get onboardingSkipShield;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Start using Privacy Lens'**
  String get onboardingFinish;

  /// No description provided for @homeSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get homeSectionLabel;

  /// No description provided for @homeDevicePosture.
  ///
  /// In en, this message translates to:
  /// **'Device posture'**
  String get homeDevicePosture;

  /// No description provided for @homeAppsAudited.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 app audited} other{{count} apps audited}}'**
  String homeAppsAudited(int count);

  /// No description provided for @homePostureSummary.
  ///
  /// In en, this message translates to:
  /// **'{apps} apps · {micCamera} with mic or camera · {trackers} with trackers'**
  String homePostureSummary(int apps, int micCamera, int trackers);

  /// No description provided for @homeRunAudit.
  ///
  /// In en, this message translates to:
  /// **'Run full audit'**
  String get homeRunAudit;

  /// No description provided for @homeLastScanned.
  ///
  /// In en, this message translates to:
  /// **'Last scanned {when}'**
  String homeLastScanned(String when);

  /// No description provided for @homeNeverScanned.
  ///
  /// In en, this message translates to:
  /// **'No scan yet'**
  String get homeNeverScanned;

  /// No description provided for @homeScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning…'**
  String get homeScanning;

  /// No description provided for @homeTelemetryGlimpse.
  ///
  /// In en, this message translates to:
  /// **'Capability glimpse'**
  String get homeTelemetryGlimpse;

  /// No description provided for @homeAppsWithLocation.
  ///
  /// In en, this message translates to:
  /// **'Apps with location'**
  String get homeAppsWithLocation;

  /// No description provided for @homeAppsWithMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Apps with microphone'**
  String get homeAppsWithMicrophone;

  /// No description provided for @homeTrackersBlocked.
  ///
  /// In en, this message translates to:
  /// **'Lookups blocked'**
  String get homeTrackersBlocked;

  /// No description provided for @homeKeyDiscoveries.
  ///
  /// In en, this message translates to:
  /// **'Key discoveries'**
  String get homeKeyDiscoveries;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get homeViewAll;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Run your first audit'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Scan apps on this phone.'**
  String get homeEmptyBody;

  /// No description provided for @homeUsageAccessRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage Access is off'**
  String get homeUsageAccessRequiredTitle;

  /// No description provided for @homeUsageAccessRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'Foreground time and unused-app findings need Usage Access. Permissions and tracker libraries still scan without it.'**
  String get homeUsageAccessRequiredBody;

  /// No description provided for @homeLocalFooter.
  ///
  /// In en, this message translates to:
  /// **'Every audit runs locally on your processor.'**
  String get homeLocalFooter;

  /// No description provided for @homeReviewPermissions.
  ///
  /// In en, this message translates to:
  /// **'Review permissions'**
  String get homeReviewPermissions;

  /// No description provided for @homeViewLog.
  ///
  /// In en, this message translates to:
  /// **'View log'**
  String get homeViewLog;

  /// No description provided for @homeCleanup.
  ///
  /// In en, this message translates to:
  /// **'Review unused'**
  String get homeCleanup;

  /// No description provided for @homeDiscoveryNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get homeDiscoveryNeedsAttention;

  /// No description provided for @homeDiscoveryTracker.
  ///
  /// In en, this message translates to:
  /// **'Tracker alert'**
  String get homeDiscoveryTracker;

  /// No description provided for @homeDiscoveryHygiene.
  ///
  /// In en, this message translates to:
  /// **'Low severity'**
  String get homeDiscoveryHygiene;

  /// No description provided for @homeInstalledDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Installed {count, plural, =1{1 day} other{{count} days}} ago'**
  String homeInstalledDaysAgo(int count);

  /// No description provided for @homeActiveMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'Active {count, plural, =1{1 minute} other{{count} minutes}} ago'**
  String homeActiveMinutesAgo(int count);

  /// No description provided for @homeUnusedAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 unused app} other{{count} unused apps}}'**
  String homeUnusedAppsTitle(int count);

  /// No description provided for @homeNoUsageDays.
  ///
  /// In en, this message translates to:
  /// **'No opens in 90+ days'**
  String get homeNoUsageDays;

  /// No description provided for @homeRequestsNeutralized.
  ///
  /// In en, this message translates to:
  /// **'Blocked by the local filter'**
  String get homeRequestsNeutralized;

  /// No description provided for @homeRiskyPermissions.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 risky permission} other{{count} risky permissions}}'**
  String homeRiskyPermissions(int count);

  /// No description provided for @appsSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'App audit'**
  String get appsSectionLabel;

  /// No description provided for @appsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search installed apps'**
  String get appsSearchHint;

  /// No description provided for @appsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String appsFilterAll(int count);

  /// No description provided for @appsFilterHighRisk.
  ///
  /// In en, this message translates to:
  /// **'High risk ({count})'**
  String appsFilterHighRisk(int count);

  /// No description provided for @appsFilterCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera ({count})'**
  String appsFilterCamera(int count);

  /// No description provided for @appsFilterMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Microphone ({count})'**
  String appsFilterMicrophone(int count);

  /// No description provided for @appsMonitored.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 app} other{{count} apps}}'**
  String appsMonitored(int count);

  /// No description provided for @appsRescan.
  ///
  /// In en, this message translates to:
  /// **'Re-scan'**
  String get appsRescan;

  /// No description provided for @appsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No apps in this view'**
  String get appsEmptyTitle;

  /// No description provided for @appsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Run an audit from Home, or change the system-app toggle in Settings.'**
  String get appsEmptyBody;

  /// No description provided for @appsNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching apps'**
  String get appsNoMatchTitle;

  /// No description provided for @appsNoMatchBody.
  ///
  /// In en, this message translates to:
  /// **'Try another search or filter.'**
  String get appsNoMatchBody;

  /// No description provided for @appsTrackersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No trackers} =1{1 embedded tracker} other{{count} embedded trackers}}'**
  String appsTrackersCount(int count);

  /// No description provided for @appsNoNetwork.
  ///
  /// In en, this message translates to:
  /// **'No network permission'**
  String get appsNoNetwork;

  /// No description provided for @appsSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Choose an app to see permissions, usage, and libraries.'**
  String get appsSelectHint;

  /// No description provided for @detailTitle.
  ///
  /// In en, this message translates to:
  /// **'App details'**
  String get detailTitle;

  /// No description provided for @detailElevatedAttention.
  ///
  /// In en, this message translates to:
  /// **'Elevated attention'**
  String get detailElevatedAttention;

  /// No description provided for @detailUsage.
  ///
  /// In en, this message translates to:
  /// **'Screen time'**
  String get detailUsage;

  /// No description provided for @detailScanDay.
  ///
  /// In en, this message translates to:
  /// **'On the day of the last scan'**
  String get detailScanDay;

  /// No description provided for @detailForeground.
  ///
  /// In en, this message translates to:
  /// **'{time} foreground'**
  String detailForeground(String time);

  /// No description provided for @detailTrackers.
  ///
  /// In en, this message translates to:
  /// **'Embedded analytics and trackers'**
  String get detailTrackers;

  /// No description provided for @detailLibraries.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 library} other{{count} libraries}}'**
  String detailLibraries(int count);

  /// No description provided for @detailPermissions.
  ///
  /// In en, this message translates to:
  /// **'Declared hardware and data access'**
  String get detailPermissions;

  /// No description provided for @detailGranted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 granted} other{{count} granted}}'**
  String detailGranted(int count);

  /// No description provided for @detailOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Android app settings'**
  String get detailOpenSettings;

  /// No description provided for @detailOpenSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'Revoke permissions or restrict background access in Android.'**
  String get detailOpenSettingsHint;

  /// No description provided for @detailNotFound.
  ///
  /// In en, this message translates to:
  /// **'That app is not in the latest scan.'**
  String get detailNotFound;

  /// No description provided for @detailVersion.
  ///
  /// In en, this message translates to:
  /// **'v{version}'**
  String detailVersion(String version);

  /// No description provided for @detailSystemApp.
  ///
  /// In en, this message translates to:
  /// **'System app'**
  String get detailSystemApp;

  /// No description provided for @detailNoTrackers.
  ///
  /// In en, this message translates to:
  /// **'No known tracker libraries in this package.'**
  String get detailNoTrackers;

  /// No description provided for @detailNoPermissions.
  ///
  /// In en, this message translates to:
  /// **'No sensitive permissions granted.'**
  String get detailNoPermissions;

  /// No description provided for @detailLastUsed.
  ///
  /// In en, this message translates to:
  /// **'Last opened {when}'**
  String detailLastUsed(String when);

  /// No description provided for @detailNeverUsed.
  ///
  /// In en, this message translates to:
  /// **'Not opened in the last 120 days'**
  String get detailNeverUsed;

  /// No description provided for @detailUsageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Foreground time needs Usage Access.'**
  String get detailUsageUnavailable;

  /// No description provided for @findingsSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Audit report'**
  String get findingsSectionLabel;

  /// No description provided for @findingsIdentified.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item identified} other{{count} items identified}} across installed applications.'**
  String findingsIdentified(int count);

  /// No description provided for @findingsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String findingsFilterAll(int count);

  /// No description provided for @findingsFilterHigh.
  ///
  /// In en, this message translates to:
  /// **'High priority ({count})'**
  String findingsFilterHigh(int count);

  /// No description provided for @findingsFilterTrackers.
  ///
  /// In en, this message translates to:
  /// **'Trackers ({count})'**
  String findingsFilterTrackers(int count);

  /// No description provided for @findingsFilterPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions ({count})'**
  String findingsFilterPermissions(int count);

  /// No description provided for @findingsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Audit is clear'**
  String get findingsEmptyTitle;

  /// No description provided for @findingsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'No findings from the latest scan. Run another audit after you install or update apps.'**
  String get findingsEmptyBody;

  /// No description provided for @findingsHighPriority.
  ///
  /// In en, this message translates to:
  /// **'High priority'**
  String get findingsHighPriority;

  /// No description provided for @findingsMediumPriority.
  ///
  /// In en, this message translates to:
  /// **'Medium priority'**
  String get findingsMediumPriority;

  /// No description provided for @findingsHygiene.
  ///
  /// In en, this message translates to:
  /// **'Digital hygiene'**
  String get findingsHygiene;

  /// No description provided for @findingsAppCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 app} other{{count} apps}}'**
  String findingsAppCount(int count);

  /// No description provided for @trackersSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Network trackers'**
  String get trackersSectionLabel;

  /// No description provided for @shieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Tracker Shield'**
  String get shieldTitle;

  /// No description provided for @shieldActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get shieldActive;

  /// No description provided for @shieldOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get shieldOff;

  /// No description provided for @shieldDescription.
  ///
  /// In en, this message translates to:
  /// **'A local DNS filter on this phone. Android shows it as a VPN because that is the only hook for filtering lookups. No packets of ours leave the device.'**
  String get shieldDescription;

  /// No description provided for @shieldLimitsAction.
  ///
  /// In en, this message translates to:
  /// **'Limits'**
  String get shieldLimitsAction;

  /// No description provided for @shieldSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search domain, app, or tracker'**
  String get shieldSearchHint;

  /// No description provided for @shieldSortHits.
  ///
  /// In en, this message translates to:
  /// **'Most blocked'**
  String get shieldSortHits;

  /// No description provided for @shieldSortRecent.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get shieldSortRecent;

  /// No description provided for @shieldSortName.
  ///
  /// In en, this message translates to:
  /// **'A–Z'**
  String get shieldSortName;

  /// No description provided for @shieldDomainsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Domains blocked'**
  String get shieldDomainsBlocked;

  /// No description provided for @shieldAppsMonitored.
  ///
  /// In en, this message translates to:
  /// **'Apps attributed'**
  String get shieldAppsMonitored;

  /// No description provided for @shieldNoDataSent.
  ///
  /// In en, this message translates to:
  /// **'Sent by us'**
  String get shieldNoDataSent;

  /// No description provided for @shieldNoDataSentValue.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get shieldNoDataSentValue;

  /// No description provided for @shieldHourlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Blocked lookups today'**
  String get shieldHourlyTitle;

  /// No description provided for @shieldFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String shieldFilterAll(int count);

  /// No description provided for @shieldBlockedTimes.
  ///
  /// In en, this message translates to:
  /// **'Blocked {count}×'**
  String shieldBlockedTimes(int count);

  /// No description provided for @shieldUnknownApp.
  ///
  /// In en, this message translates to:
  /// **'App not attributed'**
  String get shieldUnknownApp;

  /// No description provided for @shieldBlocklistVersion.
  ///
  /// In en, this message translates to:
  /// **'Blocklist {version}'**
  String shieldBlocklistVersion(String version);

  /// No description provided for @shieldRulesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 rule} other{{count} rules}} shipped with this version'**
  String shieldRulesCount(int count);

  /// No description provided for @shieldLimitsTitle.
  ///
  /// In en, this message translates to:
  /// **'What can slip past'**
  String get shieldLimitsTitle;

  /// No description provided for @shieldLimitPrivateDns.
  ///
  /// In en, this message translates to:
  /// **'Strict Private DNS in Android settings bypasses this filter.'**
  String get shieldLimitPrivateDns;

  /// No description provided for @shieldLimitDoh.
  ///
  /// In en, this message translates to:
  /// **'Apps that resolve names over their own encrypted DNS will not appear here.'**
  String get shieldLimitDoh;

  /// No description provided for @shieldLimitOtherVpn.
  ///
  /// In en, this message translates to:
  /// **'Another active VPN takes over the tunnel, so this shield pauses.'**
  String get shieldLimitOtherVpn;

  /// No description provided for @shieldEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No blocked lookups yet'**
  String get shieldEmptyTitle;

  /// No description provided for @shieldEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Turn the shield on, then use other apps as usual. Only blocked tracker domains are stored.'**
  String get shieldEmptyBody;

  /// No description provided for @shieldStartFailed.
  ///
  /// In en, this message translates to:
  /// **'Tracker Shield could not start.'**
  String get shieldStartFailed;

  /// No description provided for @shieldConsentDenied.
  ///
  /// In en, this message translates to:
  /// **'VPN consent was declined. The shield stayed off.'**
  String get shieldConsentDenied;

  /// No description provided for @shieldCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'What to block'**
  String get shieldCategoriesTitle;

  /// No description provided for @shieldCategoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 host} other{{count} hosts}}'**
  String shieldCategoryCount(int count);

  /// No description provided for @shieldCustomRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your domains'**
  String get shieldCustomRulesTitle;

  /// No description provided for @shieldAddDomain.
  ///
  /// In en, this message translates to:
  /// **'Add domain'**
  String get shieldAddDomain;

  /// No description provided for @shieldAddDomainTitle.
  ///
  /// In en, this message translates to:
  /// **'Block or allow a hostname'**
  String get shieldAddDomainTitle;

  /// No description provided for @shieldAddDomainHint.
  ///
  /// In en, this message translates to:
  /// **'ads.example.com'**
  String get shieldAddDomainHint;

  /// No description provided for @shieldBlockDomain.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get shieldBlockDomain;

  /// No description provided for @shieldAllowDomain.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get shieldAllowDomain;

  /// No description provided for @shieldAllowAction.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get shieldAllowAction;

  /// No description provided for @shieldRemoveRule.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get shieldRemoveRule;

  /// No description provided for @shieldCustomBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get shieldCustomBlocked;

  /// No description provided for @shieldCustomAllowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get shieldCustomAllowed;

  /// No description provided for @shieldNoCustomRules.
  ///
  /// In en, this message translates to:
  /// **'No custom domains yet. Add one to block or allow it on this phone.'**
  String get shieldNoCustomRules;

  /// No description provided for @shieldInvalidDomain.
  ///
  /// In en, this message translates to:
  /// **'Enter a hostname such as ads.example.com, not a URL.'**
  String get shieldInvalidDomain;

  /// No description provided for @shieldLimitInPage.
  ///
  /// In en, this message translates to:
  /// **'This cannot hide ads drawn inside a page the way a browser can. It only refuses DNS lookups for listed hostnames.'**
  String get shieldLimitInPage;

  /// No description provided for @settingsSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy settings'**
  String get settingsSectionLabel;

  /// No description provided for @settingsDataControl.
  ///
  /// In en, this message translates to:
  /// **'Data and autonomy'**
  String get settingsDataControl;

  /// No description provided for @settingsVaultSecure.
  ///
  /// In en, this message translates to:
  /// **'Sandbox vault'**
  String get settingsVaultSecure;

  /// No description provided for @settingsEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Encrypted with SQLCipher'**
  String get settingsEncrypted;

  /// No description provided for @settingsVaultSize.
  ///
  /// In en, this message translates to:
  /// **'{size} used'**
  String settingsVaultSize(String size);

  /// No description provided for @settingsRetentionTitle.
  ///
  /// In en, this message translates to:
  /// **'Audit history retention'**
  String get settingsRetentionTitle;

  /// No description provided for @settingsRetentionBody.
  ///
  /// In en, this message translates to:
  /// **'Older scans are deleted. Latest is kept.'**
  String get settingsRetentionBody;

  /// No description provided for @settingsRetentionDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String settingsRetentionDays(int count);

  /// No description provided for @settingsDnsRetentionTitle.
  ///
  /// In en, this message translates to:
  /// **'Tracker log auto-cleanup'**
  String get settingsDnsRetentionTitle;

  /// No description provided for @settingsDnsRetentionBody.
  ///
  /// In en, this message translates to:
  /// **'Older blocked lookups are deleted.'**
  String get settingsDnsRetentionBody;

  /// No description provided for @settingsDnsDaily.
  ///
  /// In en, this message translates to:
  /// **'1 day'**
  String get settingsDnsDaily;

  /// No description provided for @settingsDnsWeekly.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get settingsDnsWeekly;

  /// No description provided for @settingsIncludeSystemTitle.
  ///
  /// In en, this message translates to:
  /// **'Include system apps'**
  String get settingsIncludeSystemTitle;

  /// No description provided for @settingsIncludeSystemBody.
  ///
  /// In en, this message translates to:
  /// **'Add preinstalled apps to the next scan.'**
  String get settingsIncludeSystemBody;

  /// No description provided for @settingsExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export audit report'**
  String get settingsExportTitle;

  /// No description provided for @settingsExportBody.
  ///
  /// In en, this message translates to:
  /// **'Save a file on this phone.'**
  String get settingsExportBody;

  /// No description provided for @settingsExportJson.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get settingsExportJson;

  /// No description provided for @settingsExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get settingsExportCsv;

  /// No description provided for @settingsExportEmpty.
  ///
  /// In en, this message translates to:
  /// **'Run an audit before exporting.'**
  String get settingsExportEmpty;

  /// No description provided for @settingsExportSaved.
  ///
  /// In en, this message translates to:
  /// **'Report saved.'**
  String get settingsExportSaved;

  /// No description provided for @settingsExportCanceled.
  ///
  /// In en, this message translates to:
  /// **'Export canceled.'**
  String get settingsExportCanceled;

  /// No description provided for @settingsWipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all stored audit data'**
  String get settingsWipeTitle;

  /// No description provided for @settingsWipeBody.
  ///
  /// In en, this message translates to:
  /// **'Purges scans, findings, usage, and blocked lookup logs, then re-encrypts the vault.'**
  String get settingsWipeBody;

  /// No description provided for @settingsWipeAction.
  ///
  /// In en, this message translates to:
  /// **'Wipe data vault'**
  String get settingsWipeAction;

  /// No description provided for @settingsWipeConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Wipe the vault?'**
  String get settingsWipeConfirmTitle;

  /// No description provided for @settingsWipeConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. You will need to run a new audit.'**
  String get settingsWipeConfirmBody;

  /// No description provided for @settingsTransparency.
  ///
  /// In en, this message translates to:
  /// **'Transparency and architecture'**
  String get settingsTransparency;

  /// No description provided for @settingsInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'INTERNET is used only for DNS'**
  String get settingsInternetTitle;

  /// No description provided for @settingsInternetBody.
  ///
  /// In en, this message translates to:
  /// **'Only used to forward allowed DNS.'**
  String get settingsInternetBody;

  /// No description provided for @settingsHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How Privacy Lens works'**
  String get settingsHowItWorks;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Privacy Lens {version} · 100% local'**
  String settingsVersion(String version);

  /// No description provided for @settingsPowerModeLocked.
  ///
  /// In en, this message translates to:
  /// **'Power mode'**
  String get settingsPowerModeLocked;

  /// No description provided for @settingsPowerModeHint.
  ///
  /// In en, this message translates to:
  /// **'Deeper inspection is planned. It is locked in this version.'**
  String get settingsPowerModeHint;

  /// No description provided for @settingsComingLater.
  ///
  /// In en, this message translates to:
  /// **'Coming later'**
  String get settingsComingLater;

  /// No description provided for @scanCollecting.
  ///
  /// In en, this message translates to:
  /// **'Reading installed apps…'**
  String get scanCollecting;

  /// No description provided for @scanScanningPackages.
  ///
  /// In en, this message translates to:
  /// **'Scanning packages {scanned} of {total}'**
  String scanScanningPackages(int scanned, int total);

  /// No description provided for @scanAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Evaluating findings…'**
  String get scanAnalyzing;

  /// No description provided for @relativeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get relativeJustNow;

  /// No description provided for @relativeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String relativeMinutesAgo(int count);

  /// No description provided for @relativeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String relativeHoursAgo(int count);

  /// No description provided for @relativeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String relativeDaysAgo(int count);

  /// No description provided for @relativeToday.
  ///
  /// In en, this message translates to:
  /// **'today at {time}'**
  String relativeToday(String time);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count}m'**
  String durationMinutes(int count);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @sizeBytes.
  ///
  /// In en, this message translates to:
  /// **'{count} B'**
  String sizeBytes(int count);

  /// No description provided for @sizeKilobytes.
  ///
  /// In en, this message translates to:
  /// **'{count} KB'**
  String sizeKilobytes(String count);

  /// No description provided for @sizeMegabytes.
  ///
  /// In en, this message translates to:
  /// **'{count} MB'**
  String sizeMegabytes(String count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
