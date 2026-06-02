import 'dart:async';

import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'recorder.dart';
import 'theme.dart';
import 'widgets.dart';

void main() {
  runApp(const FreeScreenRecordApp());
}

class FreeScreenRecordApp extends StatelessWidget {
  const FreeScreenRecordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final RecorderChannel _recorder = RecorderChannel();

  RecordConfig _config = const RecordConfig();
  RecStatus _status = RecStatus.idle;
  List<Recording> _recordings = const [];
  bool _hasOverlay = false;
  Timer? _statusTimer;

  AppColors get _c => Theme.of(context).extension<AppColors>()!;
  AppLocalizations get _t => AppLocalizations.of(context);

  /// Any feature that draws a system overlay needs the overlay permission.
  bool get _needsOverlay =>
      _config.showTimestamp || _config.showFps || _config.floatingButton;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _recorder.setErrorHandler(_onNativeError);
    _refreshPermission();
    _refreshRecordings();
    _statusTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => _pollStatus(),
    );
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshPermission();
      _refreshRecordings();
    }
  }

  // --- Position / resolution option labels (localized at build time) ---

  Map<String, String> _positionOptions() => {
        'top_left': _t.positionLabel(_t.posTop, _t.posLeft),
        'top_center': _t.positionLabel(_t.posTop, _t.posCenter),
        'top_right': _t.positionLabel(_t.posTop, _t.posRight),
        'bottom_left': _t.positionLabel(_t.posBottom, _t.posLeft),
        'bottom_center': _t.positionLabel(_t.posBottom, _t.posCenter),
        'bottom_right': _t.positionLabel(_t.posBottom, _t.posRight),
      };

  Map<int, String> _scaleOptions() => {
        30: _t.scaleLabel(_t.scaleVeryLow, 30),
        50: _t.scaleLabel(_t.scaleLow, 50),
        75: _t.scaleLabel(_t.scaleMedium, 75),
        100: _t.scaleLabel(_t.scaleOriginal, 100),
      };

  // --- Channel interactions ---

  Future<void> _refreshPermission() async {
    final granted = await _recorder.hasOverlayPermission();
    if (mounted) setState(() => _hasOverlay = granted);
  }

  Future<void> _refreshRecordings() async {
    final list = await _recorder.listRecordings();
    if (mounted) setState(() => _recordings = list);
  }

  Future<void> _pollStatus() async {
    final next = await _recorder.getStatus();
    if (!mounted) return;
    final stopped = _status.recording && !next.recording;
    setState(() => _status = next);
    if (stopped && next.lastError != null) {
      _showError(next.lastError!);
    }
    if (stopped) _refreshRecordings();
  }

  Future<void> _toggleRecording() async {
    if (_status.recording) {
      await _recorder.stopRecording();
      return;
    }
    if (_needsOverlay && !_hasOverlay) {
      await _promptOverlayPermission();
      return;
    }
    await _recorder.startRecording(_config);
  }

  Future<void> _promptOverlayPermission() async {
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _c.surfaceHigh,
        title: Text(_t.permissionTitle),
        content: Text(_t.permissionBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(_t.later),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(_t.openSettings),
          ),
        ],
      ),
    );
    if (go == true) await _recorder.requestOverlayPermission();
  }

  void _onNativeError(String code) {
    final message = code == 'consent_denied' ? _t.errorConsentDenied : code;
    _showError(message);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _c.accent,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    final recording = _status.recording;
    return Scaffold(
      body: GlowBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            children: [
              _header(),
              const SizedBox(height: 24),
              _heroCard(recording),
              const SizedBox(height: 20),
              _recordButton(recording),
              const SizedBox(height: 24),
              if (!_hasOverlay && _needsOverlay) _overlayWarning(),
              _settingsCard(recording),
              const SizedBox(height: 24),
              _recordingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const AppLogo(size: 56),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _t.appTitle,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _c.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                _t.tagline,
                style: TextStyle(fontSize: 13, color: _c.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _heroCard(bool recording) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_c.surfaceHigh, _c.surface],
        ),
        border: Border.all(color: _c.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: _c.cyan),
              const SizedBox(width: 6),
              Text(
                recording ? _t.heroLabelRecording : _t.heroLabelPreview,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: _c.cyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: LiveClock(
              timeFormat: _config.timeFormat,
              useUtc: _config.useUtc,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: _c.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _t.heroDescription,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: _c.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recordButton(bool recording) {
    final label = recording
        ? _t.stopWithTime(_formatDuration(_status.elapsedMs))
        : _t.startRecording;
    return SizedBox(
      height: 64,
      child: FilledButton(
        onPressed: _toggleRecording,
        style: FilledButton.styleFrom(
          backgroundColor: recording ? _c.surfaceHigh : _c.accent,
          foregroundColor: recording ? _c.textPrimary : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: recording
                ? BorderSide(color: _c.accent, width: 1.5)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (recording)
              PulsingDot(size: 14, color: _c.accent)
            else
              const Icon(Icons.fiber_manual_record, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overlayWarning() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _c.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _c.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: _c.accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _t.overlayMissing,
              style: TextStyle(fontSize: 12.5, color: _c.textPrimary),
            ),
          ),
          TextButton(
            onPressed: _promptOverlayPermission,
            child: Text(_t.grant),
          ),
        ],
      ),
    );
  }

  Widget _settingsCard(bool recording) {
    final tsEnabled = !recording && _config.showTimestamp;
    final divider = Divider(height: 1, color: _c.hairline);
    return Container(
      decoration: BoxDecoration(
        color: _c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _c.hairline),
      ),
      child: Column(
        children: [
          _switchTile(
            icon: Icons.schedule,
            label: _t.settingTimestampTitle,
            subtitle: _t.settingTimestampSubtitle,
            value: _config.showTimestamp,
            enabled: !recording,
            onChanged: (v) =>
                setState(() => _config = _config.copyWith(showTimestamp: v)),
          ),
          divider,
          _formatSelector(tsEnabled),
          divider,
          _dropdownRow<String>(
            icon: Icons.place_outlined,
            label: _t.settingPosition,
            value: _config.position,
            items: _positionOptions(),
            enabled: tsEnabled,
            onChanged: (v) =>
                setState(() => _config = _config.copyWith(position: v)),
          ),
          divider,
          _sliderRow(
            icon: Icons.format_size,
            label: _t.settingFontSize,
            value: _config.fontSp.toDouble(),
            min: 10,
            max: 32,
            display: '${_config.fontSp}sp',
            enabled: tsEnabled,
            onChanged: (v) =>
                setState(() => _config = _config.copyWith(fontSp: v.round())),
          ),
          divider,
          _switchTile(
            icon: Icons.public,
            label: _t.settingUtc,
            value: _config.useUtc,
            enabled: tsEnabled,
            onChanged: (v) =>
                setState(() => _config = _config.copyWith(useUtc: v)),
          ),
          divider,
          _switchTile(
            icon: Icons.timer_outlined,
            label: _t.settingElapsed,
            value: _config.showElapsed,
            enabled: tsEnabled,
            onChanged: (v) =>
                setState(() => _config = _config.copyWith(showElapsed: v)),
          ),
          divider,
          _switchTile(
            icon: Icons.speed,
            label: _t.settingFps,
            value: _config.showFps,
            enabled: !recording,
            onChanged: (v) =>
                setState(() => _config = _config.copyWith(showFps: v)),
          ),
          divider,
          _dropdownRow<int>(
            icon: Icons.aspect_ratio,
            label: _t.settingResolution,
            value: _config.scalePercent,
            items: _scaleOptions(),
            enabled: !recording,
            onChanged: (v) =>
                setState(() => _config = _config.copyWith(scalePercent: v)),
          ),
          divider,
          _sliderRow(
            icon: Icons.high_quality_outlined,
            label: _t.settingBitrate,
            value: _config.bitrateKbps.toDouble(),
            min: 500,
            max: 8000,
            display: '${(_config.bitrateKbps / 1000).toStringAsFixed(1)} Mbps',
            enabled: !recording,
            onChanged: (v) => setState(
              () => _config =
                  _config.copyWith(bitrateKbps: (v / 250).round() * 250),
            ),
          ),
          divider,
          _switchTile(
            icon: Icons.drag_indicator,
            label: _t.settingBubble,
            subtitle: _t.settingBubbleSubtitle,
            value: _config.floatingButton,
            enabled: !recording,
            onChanged: (v) =>
                setState(() => _config = _config.copyWith(floatingButton: v)),
          ),
          divider,
          _switchTile(
            icon: Icons.mic_none,
            label: _t.settingAudio,
            subtitle: _t.settingAudioSubtitle,
            value: _config.recordAudio,
            enabled: !recording,
            onChanged: (v) =>
                setState(() => _config = _config.copyWith(recordAudio: v)),
          ),
        ],
      ),
    );
  }

  static const Map<String, String> _formats = {
    'datetime24': 'yyyy-MM-dd HH:mm:ss.SSS',
    'time24': 'HH:mm:ss.SSS',
    'datetime12': 'yyyy-MM-dd hh:mm:ss.SSS a',
    'time12': 'hh:mm:ss.SSS a',
    'unix': 'Unix epoch (ms)',
  };

  Widget _switchTile({
    required IconData icon,
    required String label,
    String? subtitle,
    required bool value,
    required bool enabled,
    required ValueChanged<bool> onChanged,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: SwitchListTile(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeColor: _c.cyan,
        secondary: Icon(icon, color: _c.cyan, size: 20),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: _c.textSecondary),
              ),
      ),
    );
  }

  Widget _formatSelector(bool enabled) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tag, color: _c.cyan, size: 20),
                const SizedBox(width: 14),
                Text(
                  _t.settingTimeFormat,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _formats.entries.map((e) {
                  final selected = _config.timeFormat == e.key;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        e.value,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                        ),
                      ),
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: _c.cyan.withValues(alpha: 0.22),
                      onSelected: enabled
                          ? (_) => setState(
                                () =>
                                    _config = _config.copyWith(timeFormat: e.key),
                              )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdownRow<T>({
    required IconData icon,
    required String label,
    required T value,
    required Map<T, String> items,
    required bool enabled,
    required ValueChanged<T> onChanged,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: ListTile(
        leading: Icon(icon, color: _c.cyan, size: 20),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: DropdownButton<T>(
          value: value,
          underline: const SizedBox.shrink(),
          dropdownColor: _c.surfaceHigh,
          borderRadius: BorderRadius.circular(14),
          onChanged: enabled
              ? (v) {
                  if (v != null) onChanged(v);
                }
              : null,
          items: items.entries
              .map(
                (e) => DropdownMenuItem<T>(value: e.key, child: Text(e.value)),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _sliderRow({
    required IconData icon,
    required String label,
    required double value,
    required double min,
    required double max,
    required String display,
    required bool enabled,
    required ValueChanged<double> onChanged,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
        child: Row(
          children: [
            Icon(icon, color: _c.cyan, size: 20),
            const SizedBox(width: 14),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Expanded(
              child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                activeColor: _c.cyan,
                onChanged: enabled ? onChanged : null,
              ),
            ),
            SizedBox(
              width: 64,
              child: Text(
                display,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12.5,
                  color: _c.textSecondary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recordingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              _t.recordingsTitle,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _c.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _c.surfaceHigh,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${_recordings.length}',
                style: TextStyle(fontSize: 12, color: _c.textPrimary),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: _refreshRecordings,
              icon: Icon(Icons.refresh, color: _c.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_recordings.isEmpty)
          _emptyState()
        else
          ..._recordings.map(_recordingTile),
      ],
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36),
      decoration: BoxDecoration(
        color: _c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _c.hairline),
      ),
      child: Column(
        children: [
          Icon(
            Icons.movie_creation_outlined,
            size: 40,
            color: _c.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(_t.noRecordings, style: TextStyle(color: _c.textSecondary)),
        ],
      ),
    );
  }

  Widget _recordingTile(Recording rec) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _c.hairline),
      ),
      child: ListTile(
        onTap: () => _recorder.openRecording(rec.uri),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _c.accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.play_arrow_rounded, color: _c.accent),
        ),
        title: Text(
          rec.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          '${_formatSize(rec.sizeBytes)} • ${_formatDate(rec.dateMillis)}',
          style: TextStyle(fontSize: 12, color: _c.textSecondary),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: _c.textSecondary),
          onPressed: () => _confirmDelete(rec),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(Recording rec) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _c.surfaceHigh,
        title: Text(_t.deleteTitle),
        content: Text(rec.name),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(_t.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _c.accent),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(_t.delete),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _recorder.deleteRecording(rec.uri);
      _refreshRecordings();
    }
  }

  String _formatDuration(int ms) {
    final totalSeconds = ms ~/ 1000;
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _formatSize(int bytes) {
    if (bytes <= 0) return '0 MB';
    final mb = bytes / (1024 * 1024);
    if (mb < 1) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${mb.toStringAsFixed(1)} MB';
  }

  String _formatDate(int millis) {
    if (millis <= 0) return '—';
    final d = DateTime.fromMillisecondsSinceEpoch(millis);
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} '
        '${two(d.hour)}:${two(d.minute)}';
  }
}
