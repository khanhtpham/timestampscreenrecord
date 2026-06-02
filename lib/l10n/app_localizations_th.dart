// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Free Screen Record';

  @override
  String get tagline => 'บันทึกหน้าจอ • ประทับเวลาระดับมิลลิวินาที';

  @override
  String get heroLabelRecording => 'กำลังฝังลงในวิดีโอ';

  @override
  String get heroLabelPreview => 'ตัวอย่างการประทับเวลา';

  @override
  String get heroDescription =>
      'รูปแบบ yyyy-MM-dd HH:mm:ss.SSS จะแสดงบนทุกหน้าจอและถูกบันทึกลงในวิดีโอโดยตรง';

  @override
  String get startRecording => 'เริ่มบันทึก';

  @override
  String stopWithTime(String time) {
    return 'หยุด • $time';
  }

  @override
  String get overlayMissing =>
      'ไม่มีสิทธิ์แสดงทับแอป — การประทับเวลาจะไม่ปรากฏ';

  @override
  String get grant => 'อนุญาต';

  @override
  String get settingTimestampTitle => 'ฝังการประทับเวลาระดับมิลลิวินาที';

  @override
  String get settingTimestampSubtitle =>
      'ฝังโอเวอร์เลย์ HH:mm:ss.SSS ลงในวิดีโอ';

  @override
  String get settingPosition => 'ตำแหน่ง';

  @override
  String get settingResolution => 'ความละเอียด';

  @override
  String get settingFontSize => 'ขนาดตัวอักษร';

  @override
  String get settingBitrate => 'บิตเรต';

  @override
  String get posTop => 'บน';

  @override
  String get posBottom => 'ล่าง';

  @override
  String get posLeft => 'ซ้าย';

  @override
  String get posCenter => 'กลาง';

  @override
  String get posRight => 'ขวา';

  @override
  String positionLabel(String vertical, String horizontal) {
    return '$vertical • $horizontal';
  }

  @override
  String get scaleVeryLow => 'ต่ำมาก';

  @override
  String get scaleLow => 'ต่ำ';

  @override
  String get scaleMedium => 'ปานกลาง';

  @override
  String get scaleOriginal => 'ต้นฉบับ';

  @override
  String scaleLabel(String name, int percent) {
    return '$name ($percent%)';
  }

  @override
  String get recordingsTitle => 'วิดีโอที่บันทึก';

  @override
  String get noRecordings => 'ยังไม่มีวิดีโอ';

  @override
  String get deleteTitle => 'ลบวิดีโอหรือไม่?';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get delete => 'ลบ';

  @override
  String get later => 'ภายหลัง';

  @override
  String get openSettings => 'เปิดการตั้งค่า';

  @override
  String get permissionTitle => 'ต้องการสิทธิ์แสดงทับแอป';

  @override
  String get permissionBody =>
      'เพื่อฝังการประทับเวลาระดับมิลลิวินาทีลงในวิดีโอ แอปต้องการสิทธิ์ \"แสดงทับแอปอื่น\" เปิดการตั้งค่าเพื่อเปิดใช้งาน';

  @override
  String get settingTimeFormat => 'รูปแบบการประทับเวลา';

  @override
  String get settingUtc => 'ใช้เวลา UTC';

  @override
  String get settingElapsed => 'แสดงตัวจับเวลาที่ผ่านไป';

  @override
  String get settingAudio => 'บันทึกไมโครโฟน';

  @override
  String get settingAudioSubtitle => 'เพิ่มเสียงบรรยายจากไมค์ลงในวิดีโอ';

  @override
  String get settingFps => 'แสดงตัวนับ FPS';

  @override
  String get settingBubble => 'ปุ่มหยุดแบบลอย';

  @override
  String get settingBubbleSubtitle => 'ปุ่มหยุดแบบลากได้บนทุกแอป';

  @override
  String get errorConsentDenied => 'คุณปฏิเสธสิทธิ์การบันทึกหน้าจอ';

  @override
  String errorGeneric(String detail) {
    return 'ไม่สามารถเริ่มบันทึกได้: $detail';
  }
}
