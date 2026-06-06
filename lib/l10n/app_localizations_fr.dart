// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Timestamp';

  @override
  String get tagline => 'Enregistreur d\'écran • horodatage à la milliseconde';

  @override
  String get heroLabelRecording => 'INCRUSTÉ DANS LA VIDÉO';

  @override
  String get heroLabelPreview => 'APERÇU DE L\'HORODATAGE';

  @override
  String get heroDescription =>
      'Le format yyyy-MM-dd HH:mm:ss.SSS s\'affiche sur tous les écrans et est capturé directement dans la vidéo.';

  @override
  String get startRecording => 'Démarrer l\'enregistrement';

  @override
  String stopWithTime(String time) {
    return 'Arrêter • $time';
  }

  @override
  String get overlayMissing =>
      'Pas d\'autorisation de superposition — l\'horodatage n\'apparaîtra pas.';

  @override
  String get grant => 'Autoriser';

  @override
  String get settingTimestampTitle =>
      'Incruster l\'horodatage à la milliseconde';

  @override
  String get settingTimestampSubtitle =>
      'Superposition HH:mm:ss.SSS capturée dans la vidéo';

  @override
  String get settingPosition => 'Position';

  @override
  String get settingResolution => 'Résolution';

  @override
  String get settingFontSize => 'Taille du texte';

  @override
  String get settingBitrate => 'Débit';

  @override
  String get posTop => 'Haut';

  @override
  String get posBottom => 'Bas';

  @override
  String get posLeft => 'gauche';

  @override
  String get posCenter => 'centre';

  @override
  String get posRight => 'droite';

  @override
  String positionLabel(String vertical, String horizontal) {
    return '$vertical • $horizontal';
  }

  @override
  String get scaleVeryLow => 'Très basse';

  @override
  String get scaleLow => 'Basse';

  @override
  String get scaleMedium => 'Moyenne';

  @override
  String get scaleOriginal => 'D\'origine';

  @override
  String scaleLabel(String name, int percent) {
    return '$name ($percent%)';
  }

  @override
  String get recordingsTitle => 'Enregistrements';

  @override
  String get noRecordings => 'Aucun enregistrement';

  @override
  String get deleteTitle => 'Supprimer la vidéo ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get later => 'Plus tard';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String get permissionTitle => 'Autorisation de superposition requise';

  @override
  String get permissionBody =>
      'Pour incruster l\'horodatage à la milliseconde sur la vidéo, l\'application a besoin de l\'autorisation « Affichage par-dessus les autres applications ». Ouvrez les paramètres pour l\'activer.';

  @override
  String get settingTimeFormat => 'Format de l\'horodatage';

  @override
  String get settingUtc => 'Utiliser l\'heure UTC';

  @override
  String get settingElapsed => 'Afficher le minuteur écoulé';

  @override
  String get settingAudio => 'Enregistrer le micro';

  @override
  String get settingAudioSubtitle => 'Ajouter la narration micro à la vidéo';

  @override
  String get settingFps => 'Afficher le compteur FPS';

  @override
  String get settingBubble => 'Bouton d\'arrêt flottant';

  @override
  String get settingBubbleSubtitle =>
      'Contrôle d\'arrêt déplaçable sur toutes les apps';

  @override
  String get errorConsentDenied =>
      'Vous avez refusé l\'autorisation d\'enregistrement de l\'écran.';

  @override
  String errorGeneric(String detail) {
    return 'Impossible de démarrer l\'enregistrement : $detail';
  }
}
