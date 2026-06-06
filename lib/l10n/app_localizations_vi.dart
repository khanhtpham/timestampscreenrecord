// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Timestamp';

  @override
  String get tagline => 'Quay màn hình • mốc thời gian mili-giây';

  @override
  String get heroLabelRecording => 'ĐANG IN VÀO VIDEO';

  @override
  String get heroLabelPreview => 'MẪU MỐC THỜI GIAN';

  @override
  String get heroDescription =>
      'Định dạng yyyy-MM-dd HH:mm:ss.SSS hiển thị xuyên suốt mọi màn hình và được thu trực tiếp vào video.';

  @override
  String get startRecording => 'Bắt đầu quay';

  @override
  String stopWithTime(String time) {
    return 'Dừng • $time';
  }

  @override
  String get overlayMissing =>
      'Chưa có quyền hiển thị overlay — mốc thời gian sẽ không hiện.';

  @override
  String get grant => 'Cấp quyền';

  @override
  String get settingTimestampTitle => 'In mốc thời gian mili-giây';

  @override
  String get settingTimestampSubtitle =>
      'Overlay HH:mm:ss.SSS thu thẳng vào video';

  @override
  String get settingPosition => 'Vị trí';

  @override
  String get settingResolution => 'Độ phân giải';

  @override
  String get settingFontSize => 'Cỡ chữ';

  @override
  String get settingBitrate => 'Bitrate';

  @override
  String get posTop => 'Trên';

  @override
  String get posBottom => 'Dưới';

  @override
  String get posLeft => 'trái';

  @override
  String get posCenter => 'giữa';

  @override
  String get posRight => 'phải';

  @override
  String positionLabel(String vertical, String horizontal) {
    return '$vertical • $horizontal';
  }

  @override
  String get scaleVeryLow => 'Rất thấp';

  @override
  String get scaleLow => 'Thấp';

  @override
  String get scaleMedium => 'Vừa';

  @override
  String get scaleOriginal => 'Gốc';

  @override
  String scaleLabel(String name, int percent) {
    return '$name ($percent%)';
  }

  @override
  String get recordingsTitle => 'Video đã quay';

  @override
  String get noRecordings => 'Chưa có video nào';

  @override
  String get deleteTitle => 'Xoá video?';

  @override
  String get cancel => 'Huỷ';

  @override
  String get delete => 'Xoá';

  @override
  String get later => 'Để sau';

  @override
  String get openSettings => 'Mở cài đặt';

  @override
  String get permissionTitle => 'Cần quyền hiển thị trên ứng dụng khác';

  @override
  String get permissionBody =>
      'Để in mốc thời gian mili-giây lên video, ứng dụng cần quyền \"Hiển thị trên ứng dụng khác\". Mở cài đặt để bật nhé.';

  @override
  String get settingTimeFormat => 'Định dạng mốc thời gian';

  @override
  String get settingUtc => 'Dùng giờ UTC';

  @override
  String get settingElapsed => 'Hiện bộ đếm thời gian trôi';

  @override
  String get settingAudio => 'Thu âm micro';

  @override
  String get settingAudioSubtitle => 'Thêm lời thuyết minh từ micro vào video';

  @override
  String get settingFps => 'Hiện bộ đếm FPS';

  @override
  String get settingBubble => 'Nút dừng nổi';

  @override
  String get settingBubbleSubtitle => 'Nút dừng kéo-thả trên mọi ứng dụng';

  @override
  String get errorConsentDenied => 'Bạn đã từ chối quyền quay màn hình.';

  @override
  String errorGeneric(String detail) {
    return 'Không thể bắt đầu quay: $detail';
  }
}
