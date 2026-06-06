// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Timestamp';

  @override
  String get tagline => 'Bildschirmrekorder • Zeitstempel in Millisekunden';

  @override
  String get heroLabelRecording => 'WIRD INS VIDEO EINGEBRANNT';

  @override
  String get heroLabelPreview => 'ZEITSTEMPEL-VORSCHAU';

  @override
  String get heroDescription =>
      'Das Format yyyy-MM-dd HH:mm:ss.SSS wird auf allen Bildschirmen angezeigt und direkt ins Video aufgenommen.';

  @override
  String get startRecording => 'Aufnahme starten';

  @override
  String stopWithTime(String time) {
    return 'Stopp • $time';
  }

  @override
  String get overlayMissing =>
      'Keine Overlay-Berechtigung – der Zeitstempel erscheint nicht.';

  @override
  String get grant => 'Zulassen';

  @override
  String get settingTimestampTitle => 'Millisekunden-Zeitstempel einbrennen';

  @override
  String get settingTimestampSubtitle =>
      'HH:mm:ss.SSS-Overlay wird ins Video aufgenommen';

  @override
  String get settingPosition => 'Position';

  @override
  String get settingResolution => 'Auflösung';

  @override
  String get settingFontSize => 'Schriftgröße';

  @override
  String get settingBitrate => 'Bitrate';

  @override
  String get posTop => 'Oben';

  @override
  String get posBottom => 'Unten';

  @override
  String get posLeft => 'links';

  @override
  String get posCenter => 'mittig';

  @override
  String get posRight => 'rechts';

  @override
  String positionLabel(String vertical, String horizontal) {
    return '$vertical • $horizontal';
  }

  @override
  String get scaleVeryLow => 'Sehr niedrig';

  @override
  String get scaleLow => 'Niedrig';

  @override
  String get scaleMedium => 'Mittel';

  @override
  String get scaleOriginal => 'Original';

  @override
  String scaleLabel(String name, int percent) {
    return '$name ($percent%)';
  }

  @override
  String get recordingsTitle => 'Aufnahmen';

  @override
  String get noRecordings => 'Noch keine Aufnahmen';

  @override
  String get deleteTitle => 'Video löschen?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get later => 'Später';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get permissionTitle => 'Overlay-Berechtigung erforderlich';

  @override
  String get permissionBody =>
      'Um den Millisekunden-Zeitstempel ins Video einzubrennen, benötigt die App die Berechtigung „Über anderen Apps anzeigen“. Öffne die Einstellungen, um sie zu aktivieren.';

  @override
  String get settingTimeFormat => 'Zeitstempelformat';

  @override
  String get settingUtc => 'UTC-Zeit verwenden';

  @override
  String get settingElapsed => 'Verstrichene Zeit anzeigen';

  @override
  String get settingAudio => 'Mikrofon aufnehmen';

  @override
  String get settingAudioSubtitle => 'Mikrofon-Kommentar ins Video aufnehmen';

  @override
  String get settingFps => 'FPS-Zähler anzeigen';

  @override
  String get settingBubble => 'Schwebende Stopptaste';

  @override
  String get settingBubbleSubtitle => 'Verschiebbare Stopptaste über jeder App';

  @override
  String get errorConsentDenied =>
      'Du hast die Berechtigung zur Bildschirmaufnahme abgelehnt.';

  @override
  String errorGeneric(String detail) {
    return 'Aufnahme konnte nicht gestartet werden: $detail';
  }
}
