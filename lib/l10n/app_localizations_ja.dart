// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Free Screen Record';

  @override
  String get tagline => '画面録画 • ミリ秒タイムスタンプ';

  @override
  String get heroLabelRecording => '動画に焼き込み中';

  @override
  String get heroLabelPreview => 'タイムスタンプのプレビュー';

  @override
  String get heroDescription =>
      'yyyy-MM-dd HH:mm:ss.SSS 形式がすべての画面に表示され、そのまま動画に記録されます。';

  @override
  String get startRecording => '録画を開始';

  @override
  String stopWithTime(String time) {
    return '停止 • $time';
  }

  @override
  String get overlayMissing => 'オーバーレイ権限がありません — タイムスタンプは表示されません。';

  @override
  String get grant => '許可';

  @override
  String get settingTimestampTitle => 'ミリ秒タイムスタンプを焼き込む';

  @override
  String get settingTimestampSubtitle => 'HH:mm:ss.SSS のオーバーレイを動画に記録';

  @override
  String get settingPosition => '位置';

  @override
  String get settingResolution => '解像度';

  @override
  String get settingFontSize => '文字サイズ';

  @override
  String get settingBitrate => 'ビットレート';

  @override
  String get posTop => '上';

  @override
  String get posBottom => '下';

  @override
  String get posLeft => '左';

  @override
  String get posCenter => '中央';

  @override
  String get posRight => '右';

  @override
  String positionLabel(String vertical, String horizontal) {
    return '$vertical • $horizontal';
  }

  @override
  String get scaleVeryLow => '最低';

  @override
  String get scaleLow => '低';

  @override
  String get scaleMedium => '中';

  @override
  String get scaleOriginal => '元のまま';

  @override
  String scaleLabel(String name, int percent) {
    return '$name（$percent%）';
  }

  @override
  String get recordingsTitle => '録画した動画';

  @override
  String get noRecordings => '録画はまだありません';

  @override
  String get deleteTitle => '動画を削除しますか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get later => '後で';

  @override
  String get openSettings => '設定を開く';

  @override
  String get permissionTitle => 'オーバーレイ権限が必要です';

  @override
  String get permissionBody =>
      'ミリ秒タイムスタンプを動画に焼き込むには、「他のアプリの上に重ねて表示」権限が必要です。設定を開いて有効にしてください。';

  @override
  String get settingTimeFormat => 'タイムスタンプ形式';

  @override
  String get settingUtc => 'UTC時刻を使う';

  @override
  String get settingElapsed => '経過タイマーを表示';

  @override
  String get settingAudio => 'マイクを録音';

  @override
  String get settingAudioSubtitle => 'マイクのナレーションを動画に追加';

  @override
  String get settingFps => 'FPSカウンターを表示';

  @override
  String get settingBubble => 'フローティング停止ボタン';

  @override
  String get settingBubbleSubtitle => 'どのアプリ上でも動かせる停止ボタン';

  @override
  String get errorConsentDenied => '画面録画の権限が拒否されました。';

  @override
  String errorGeneric(String detail) {
    return '録画を開始できませんでした: $detail';
  }
}
