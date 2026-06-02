import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:freescreenrecord/main.dart';
import 'package:freescreenrecord/widgets.dart';

void main() {
  const channel = MethodChannel('freescreenrecord/recorder');

  setUp(() {
    // Stub the native side so the widget can build under test.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'hasOverlayPermission':
          return true;
        case 'listRecordings':
          return <Object?>[];
        case 'getStatus':
          return <Object?, Object?>{
            'recording': false,
            'elapsedMs': 0,
            'lastError': null,
            'lastPath': null,
          };
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('formatTimestamp pads to millisecond precision', () {
    final t = DateTime(2026, 6, 2, 9, 5, 7, 42);
    expect(formatTimestamp(t), '2026-06-02 09:05:07.042');
  });

  test('formatStamp honours the chosen format', () {
    final t = DateTime(2026, 6, 2, 14, 5, 7, 42);
    expect(formatStamp(t, timeFormat: 'time24'), '14:05:07.042');
    expect(
      formatStamp(t, timeFormat: 'datetime12'),
      '2026-06-02 02:05:07.042 PM',
    );
    expect(
      formatStamp(t, timeFormat: 'unix'),
      t.millisecondsSinceEpoch.toString(),
    );
  });

  testWidgets('home screen shows the app title and record button',
      (tester) async {
    await tester.pumpWidget(const FreeScreenRecordApp());
    await tester.pump();

    // Default test locale is English (first supported locale).
    expect(find.text('Free Screen Record'), findsOneWidget);
    expect(find.text('Start recording'), findsOneWidget);
  });
}
