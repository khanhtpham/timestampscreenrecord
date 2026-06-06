// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Timestamp';

  @override
  String get tagline =>
      'Grabador de pantalla • marca de tiempo en milisegundos';

  @override
  String get heroLabelRecording => 'INCRUSTANDO EN EL VÍDEO';

  @override
  String get heroLabelPreview => 'VISTA PREVIA DE LA MARCA DE TIEMPO';

  @override
  String get heroDescription =>
      'El formato yyyy-MM-dd HH:mm:ss.SSS se muestra en todas las pantallas y se captura directamente en el vídeo.';

  @override
  String get startRecording => 'Iniciar grabación';

  @override
  String stopWithTime(String time) {
    return 'Detener • $time';
  }

  @override
  String get overlayMissing =>
      'Sin permiso de superposición: la marca de tiempo no aparecerá.';

  @override
  String get grant => 'Conceder';

  @override
  String get settingTimestampTitle =>
      'Incrustar marca de tiempo en milisegundos';

  @override
  String get settingTimestampSubtitle =>
      'Superposición HH:mm:ss.SSS capturada en el vídeo';

  @override
  String get settingPosition => 'Posición';

  @override
  String get settingResolution => 'Resolución';

  @override
  String get settingFontSize => 'Tamaño de letra';

  @override
  String get settingBitrate => 'Tasa de bits';

  @override
  String get posTop => 'Arriba';

  @override
  String get posBottom => 'Abajo';

  @override
  String get posLeft => 'izquierda';

  @override
  String get posCenter => 'centro';

  @override
  String get posRight => 'derecha';

  @override
  String positionLabel(String vertical, String horizontal) {
    return '$vertical • $horizontal';
  }

  @override
  String get scaleVeryLow => 'Muy baja';

  @override
  String get scaleLow => 'Baja';

  @override
  String get scaleMedium => 'Media';

  @override
  String get scaleOriginal => 'Original';

  @override
  String scaleLabel(String name, int percent) {
    return '$name ($percent%)';
  }

  @override
  String get recordingsTitle => 'Grabaciones';

  @override
  String get noRecordings => 'Aún no hay grabaciones';

  @override
  String get deleteTitle => '¿Eliminar vídeo?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get later => 'Más tarde';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get permissionTitle => 'Se necesita permiso de superposición';

  @override
  String get permissionBody =>
      'Para incrustar la marca de tiempo en milisegundos en el vídeo, la aplicación necesita el permiso «Mostrar sobre otras aplicaciones». Abre los ajustes para activarlo.';

  @override
  String get settingTimeFormat => 'Formato de marca de tiempo';

  @override
  String get settingUtc => 'Usar hora UTC';

  @override
  String get settingElapsed => 'Mostrar cronómetro transcurrido';

  @override
  String get settingAudio => 'Grabar micrófono';

  @override
  String get settingAudioSubtitle => 'Añadir narración del micrófono al vídeo';

  @override
  String get settingFps => 'Mostrar contador de FPS';

  @override
  String get settingBubble => 'Botón de parada flotante';

  @override
  String get settingBubbleSubtitle =>
      'Control de parada arrastrable sobre cualquier app';

  @override
  String get errorConsentDenied =>
      'Has rechazado el permiso de grabación de pantalla.';

  @override
  String errorGeneric(String detail) {
    return 'No se pudo iniciar la grabación: $detail';
  }
}
