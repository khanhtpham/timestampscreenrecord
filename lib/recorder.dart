import 'package:flutter/services.dart';

/// Capture options sent to the native ScreenRecordService.
class RecordConfig {
  const RecordConfig({
    this.showTimestamp = true,
    this.position = 'top_left',
    this.scalePercent = 50,
    this.bitrateKbps = 2500,
    this.fontSp = 16,
    this.timeFormat = 'datetime24',
    this.useUtc = false,
    this.showElapsed = false,
    this.recordAudio = false,
    this.showFps = false,
    this.floatingButton = true,
  });

  final bool showTimestamp;
  final String position;
  final int scalePercent;
  final int bitrateKbps;
  final int fontSp;
  final String timeFormat;
  final bool useUtc;
  final bool showElapsed;
  final bool recordAudio;
  final bool showFps;
  final bool floatingButton;

  RecordConfig copyWith({
    bool? showTimestamp,
    String? position,
    int? scalePercent,
    int? bitrateKbps,
    int? fontSp,
    String? timeFormat,
    bool? useUtc,
    bool? showElapsed,
    bool? recordAudio,
    bool? showFps,
    bool? floatingButton,
  }) {
    return RecordConfig(
      showTimestamp: showTimestamp ?? this.showTimestamp,
      position: position ?? this.position,
      scalePercent: scalePercent ?? this.scalePercent,
      bitrateKbps: bitrateKbps ?? this.bitrateKbps,
      fontSp: fontSp ?? this.fontSp,
      timeFormat: timeFormat ?? this.timeFormat,
      useUtc: useUtc ?? this.useUtc,
      showElapsed: showElapsed ?? this.showElapsed,
      recordAudio: recordAudio ?? this.recordAudio,
      showFps: showFps ?? this.showFps,
      floatingButton: floatingButton ?? this.floatingButton,
    );
  }

  Map<String, dynamic> toMap() => {
        'showTimestamp': showTimestamp,
        'position': position,
        'scalePercent': scalePercent,
        'bitrateKbps': bitrateKbps,
        'fontSp': fontSp,
        'timeFormat': timeFormat,
        'useUtc': useUtc,
        'showElapsed': showElapsed,
        'recordAudio': recordAudio,
        'showFps': showFps,
        'floatingButton': floatingButton,
      };
}

/// Live status reported by the native service.
class RecStatus {
  const RecStatus({
    required this.recording,
    required this.elapsedMs,
    this.lastError,
    this.lastPath,
  });

  final bool recording;
  final int elapsedMs;
  final String? lastError;
  final String? lastPath;

  static const idle = RecStatus(recording: false, elapsedMs: 0);

  factory RecStatus.fromMap(Map<Object?, Object?> map) => RecStatus(
        recording: (map['recording'] as bool?) ?? false,
        elapsedMs: (map['elapsedMs'] as num?)?.toInt() ?? 0,
        lastError: map['lastError'] as String?,
        lastPath: map['lastPath'] as String?,
      );
}

/// A finished recording on disk / in the media store.
class Recording {
  const Recording({
    required this.name,
    required this.uri,
    required this.sizeBytes,
    required this.dateMillis,
  });

  final String name;
  final String uri;
  final int sizeBytes;
  final int dateMillis;

  factory Recording.fromMap(Map<Object?, Object?> map) => Recording(
        name: (map['name'] as String?) ?? 'unknown.mp4',
        uri: (map['uri'] as String?) ?? '',
        sizeBytes: (map['sizeBytes'] as num?)?.toInt() ?? 0,
        dateMillis: (map['dateMillis'] as num?)?.toInt() ?? 0,
      );
}

/// Thin wrapper over the platform MethodChannel.
class RecorderChannel {
  static const MethodChannel _channel =
      MethodChannel('freescreenrecord/recorder');

  Future<bool> hasOverlayPermission() async =>
      (await _channel.invokeMethod<bool>('hasOverlayPermission')) ?? false;

  Future<void> requestOverlayPermission() =>
      _channel.invokeMethod<void>('requestOverlayPermission');

  Future<void> startRecording(RecordConfig config) =>
      _channel.invokeMethod<void>('startRecording', config.toMap());

  Future<void> stopRecording() => _channel.invokeMethod<void>('stopRecording');

  Future<RecStatus> getStatus() async {
    final map = await _channel.invokeMethod<Map<Object?, Object?>>('getStatus');
    return map == null ? RecStatus.idle : RecStatus.fromMap(map);
  }

  Future<List<Recording>> listRecordings() async {
    final list =
        await _channel.invokeMethod<List<Object?>>('listRecordings') ?? const [];
    return list
        .whereType<Map<Object?, Object?>>()
        .map(Recording.fromMap)
        .toList();
  }

  Future<bool> deleteRecording(String uri) async =>
      (await _channel.invokeMethod<bool>('deleteRecording', {'uri': uri})) ??
      false;

  Future<bool> openRecording(String uri) async =>
      (await _channel.invokeMethod<bool>('openRecording', {'uri': uri})) ??
      false;

  /// Native pushes "onError" when a consent/capture step fails.
  void setErrorHandler(void Function(String message) onError) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onError') {
        onError((call.arguments as String?) ?? 'Đã xảy ra lỗi.');
      }
    });
  }
}
