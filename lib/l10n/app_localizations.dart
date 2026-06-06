import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_th.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('th'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Screen recorder • millisecond timestamp'**
  String get tagline;

  /// No description provided for @heroLabelRecording.
  ///
  /// In en, this message translates to:
  /// **'BURNING INTO VIDEO'**
  String get heroLabelRecording;

  /// No description provided for @heroLabelPreview.
  ///
  /// In en, this message translates to:
  /// **'TIMESTAMP PREVIEW'**
  String get heroLabelPreview;

  /// No description provided for @heroDescription.
  ///
  /// In en, this message translates to:
  /// **'The yyyy-MM-dd HH:mm:ss.SSS format shows across every screen and is captured straight into the video.'**
  String get heroDescription;

  /// No description provided for @startRecording.
  ///
  /// In en, this message translates to:
  /// **'Start recording'**
  String get startRecording;

  /// No description provided for @stopWithTime.
  ///
  /// In en, this message translates to:
  /// **'Stop • {time}'**
  String stopWithTime(String time);

  /// No description provided for @overlayMissing.
  ///
  /// In en, this message translates to:
  /// **'No overlay permission — the timestamp won\'t appear.'**
  String get overlayMissing;

  /// No description provided for @grant.
  ///
  /// In en, this message translates to:
  /// **'Grant'**
  String get grant;

  /// No description provided for @settingTimestampTitle.
  ///
  /// In en, this message translates to:
  /// **'Burn millisecond timestamp'**
  String get settingTimestampTitle;

  /// No description provided for @settingTimestampSubtitle.
  ///
  /// In en, this message translates to:
  /// **'HH:mm:ss.SSS overlay captured into the video'**
  String get settingTimestampSubtitle;

  /// No description provided for @settingPosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get settingPosition;

  /// No description provided for @settingResolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get settingResolution;

  /// No description provided for @settingFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get settingFontSize;

  /// No description provided for @settingBitrate.
  ///
  /// In en, this message translates to:
  /// **'Bitrate'**
  String get settingBitrate;

  /// No description provided for @posTop.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get posTop;

  /// No description provided for @posBottom.
  ///
  /// In en, this message translates to:
  /// **'Bottom'**
  String get posBottom;

  /// No description provided for @posLeft.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get posLeft;

  /// No description provided for @posCenter.
  ///
  /// In en, this message translates to:
  /// **'center'**
  String get posCenter;

  /// No description provided for @posRight.
  ///
  /// In en, this message translates to:
  /// **'right'**
  String get posRight;

  /// No description provided for @positionLabel.
  ///
  /// In en, this message translates to:
  /// **'{vertical} • {horizontal}'**
  String positionLabel(String vertical, String horizontal);

  /// No description provided for @scaleVeryLow.
  ///
  /// In en, this message translates to:
  /// **'Very low'**
  String get scaleVeryLow;

  /// No description provided for @scaleLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get scaleLow;

  /// No description provided for @scaleMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get scaleMedium;

  /// No description provided for @scaleOriginal.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get scaleOriginal;

  /// No description provided for @scaleLabel.
  ///
  /// In en, this message translates to:
  /// **'{name} ({percent}%)'**
  String scaleLabel(String name, int percent);

  /// No description provided for @recordingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recordings'**
  String get recordingsTitle;

  /// No description provided for @noRecordings.
  ///
  /// In en, this message translates to:
  /// **'No recordings yet'**
  String get noRecordings;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete video?'**
  String get deleteTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @permissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Overlay permission needed'**
  String get permissionTitle;

  /// No description provided for @permissionBody.
  ///
  /// In en, this message translates to:
  /// **'To burn the millisecond timestamp onto the video, the app needs the \"Display over other apps\" permission. Open settings to enable it.'**
  String get permissionBody;

  /// No description provided for @settingTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'Timestamp format'**
  String get settingTimeFormat;

  /// No description provided for @settingUtc.
  ///
  /// In en, this message translates to:
  /// **'Use UTC time'**
  String get settingUtc;

  /// No description provided for @settingElapsed.
  ///
  /// In en, this message translates to:
  /// **'Show elapsed timer'**
  String get settingElapsed;

  /// No description provided for @settingAudio.
  ///
  /// In en, this message translates to:
  /// **'Record microphone'**
  String get settingAudio;

  /// No description provided for @settingAudioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add mic narration to the video'**
  String get settingAudioSubtitle;

  /// No description provided for @settingFps.
  ///
  /// In en, this message translates to:
  /// **'Show FPS counter'**
  String get settingFps;

  /// No description provided for @settingBubble.
  ///
  /// In en, this message translates to:
  /// **'Floating stop button'**
  String get settingBubble;

  /// No description provided for @settingBubbleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Draggable stop control over any app'**
  String get settingBubbleSubtitle;

  /// No description provided for @errorConsentDenied.
  ///
  /// In en, this message translates to:
  /// **'You declined the screen recording permission.'**
  String get errorConsentDenied;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Could not start recording: {detail}'**
  String errorGeneric(String detail);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'ja',
    'th',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'th':
      return AppLocalizationsTh();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
