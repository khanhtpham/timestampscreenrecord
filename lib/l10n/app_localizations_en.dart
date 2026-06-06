// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Timestamp';

  @override
  String get tagline => 'Screen recorder • millisecond timestamp';

  @override
  String get heroLabelRecording => 'BURNING INTO VIDEO';

  @override
  String get heroLabelPreview => 'TIMESTAMP PREVIEW';

  @override
  String get heroDescription =>
      'The yyyy-MM-dd HH:mm:ss.SSS format shows across every screen and is captured straight into the video.';

  @override
  String get startRecording => 'Start recording';

  @override
  String stopWithTime(String time) {
    return 'Stop • $time';
  }

  @override
  String get overlayMissing =>
      'No overlay permission — the timestamp won\'t appear.';

  @override
  String get grant => 'Grant';

  @override
  String get settingTimestampTitle => 'Burn millisecond timestamp';

  @override
  String get settingTimestampSubtitle =>
      'HH:mm:ss.SSS overlay captured into the video';

  @override
  String get settingPosition => 'Position';

  @override
  String get settingResolution => 'Resolution';

  @override
  String get settingFontSize => 'Font size';

  @override
  String get settingBitrate => 'Bitrate';

  @override
  String get posTop => 'Top';

  @override
  String get posBottom => 'Bottom';

  @override
  String get posLeft => 'left';

  @override
  String get posCenter => 'center';

  @override
  String get posRight => 'right';

  @override
  String positionLabel(String vertical, String horizontal) {
    return '$vertical • $horizontal';
  }

  @override
  String get scaleVeryLow => 'Very low';

  @override
  String get scaleLow => 'Low';

  @override
  String get scaleMedium => 'Medium';

  @override
  String get scaleOriginal => 'Original';

  @override
  String scaleLabel(String name, int percent) {
    return '$name ($percent%)';
  }

  @override
  String get recordingsTitle => 'Recordings';

  @override
  String get noRecordings => 'No recordings yet';

  @override
  String get deleteTitle => 'Delete video?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get later => 'Later';

  @override
  String get openSettings => 'Open settings';

  @override
  String get permissionTitle => 'Overlay permission needed';

  @override
  String get permissionBody =>
      'To burn the millisecond timestamp onto the video, the app needs the \"Display over other apps\" permission. Open settings to enable it.';

  @override
  String get settingTimeFormat => 'Timestamp format';

  @override
  String get settingUtc => 'Use UTC time';

  @override
  String get settingElapsed => 'Show elapsed timer';

  @override
  String get settingAudio => 'Record microphone';

  @override
  String get settingAudioSubtitle => 'Add mic narration to the video';

  @override
  String get settingFps => 'Show FPS counter';

  @override
  String get settingBubble => 'Floating stop button';

  @override
  String get settingBubbleSubtitle => 'Draggable stop control over any app';

  @override
  String get errorConsentDenied =>
      'You declined the screen recording permission.';

  @override
  String errorGeneric(String detail) {
    return 'Could not start recording: $detail';
  }
}
