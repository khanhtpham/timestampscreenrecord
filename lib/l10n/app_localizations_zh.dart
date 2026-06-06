// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Timestamp';

  @override
  String get tagline => '屏幕录制 • 毫秒级时间戳';

  @override
  String get heroLabelRecording => '正在写入视频';

  @override
  String get heroLabelPreview => '时间戳预览';

  @override
  String get heroDescription => 'yyyy-MM-dd HH:mm:ss.SSS 格式会显示在所有界面上，并直接录入视频。';

  @override
  String get startRecording => '开始录制';

  @override
  String stopWithTime(String time) {
    return '停止 • $time';
  }

  @override
  String get overlayMissing => '没有悬浮窗权限 — 时间戳将不会显示。';

  @override
  String get grant => '授予';

  @override
  String get settingTimestampTitle => '写入毫秒时间戳';

  @override
  String get settingTimestampSubtitle => '将 HH:mm:ss.SSS 悬浮层录入视频';

  @override
  String get settingPosition => '位置';

  @override
  String get settingResolution => '分辨率';

  @override
  String get settingFontSize => '字号';

  @override
  String get settingBitrate => '码率';

  @override
  String get posTop => '上';

  @override
  String get posBottom => '下';

  @override
  String get posLeft => '左';

  @override
  String get posCenter => '中';

  @override
  String get posRight => '右';

  @override
  String positionLabel(String vertical, String horizontal) {
    return '$vertical • $horizontal';
  }

  @override
  String get scaleVeryLow => '极低';

  @override
  String get scaleLow => '低';

  @override
  String get scaleMedium => '中';

  @override
  String get scaleOriginal => '原始';

  @override
  String scaleLabel(String name, int percent) {
    return '$name（$percent%）';
  }

  @override
  String get recordingsTitle => '已录制视频';

  @override
  String get noRecordings => '暂无视频';

  @override
  String get deleteTitle => '删除视频？';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get later => '稍后';

  @override
  String get openSettings => '打开设置';

  @override
  String get permissionTitle => '需要悬浮窗权限';

  @override
  String get permissionBody => '若要将毫秒时间戳写入视频，应用需要“显示在其他应用上层”权限。请打开设置以启用。';

  @override
  String get settingTimeFormat => '时间戳格式';

  @override
  String get settingUtc => '使用 UTC 时间';

  @override
  String get settingElapsed => '显示已用时间计时器';

  @override
  String get settingAudio => '录制麦克风';

  @override
  String get settingAudioSubtitle => '将麦克风旁白录入视频';

  @override
  String get settingFps => '显示 FPS 计数';

  @override
  String get settingBubble => '悬浮停止按钮';

  @override
  String get settingBubbleSubtitle => '可在任意应用上拖动的停止按钮';

  @override
  String get errorConsentDenied => '您拒绝了屏幕录制权限。';

  @override
  String errorGeneric(String detail) {
    return '无法开始录制：$detail';
  }
}
