import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Formats a [DateTime] in the chosen [timeFormat], mirroring exactly what the
/// native overlay burns into the recording. Supported formats:
/// `datetime24`, `time24`, `datetime12`, `time12`, `unix`.
String formatStamp(
  DateTime t, {
  String timeFormat = 'datetime24',
  bool useUtc = false,
}) {
  if (timeFormat == 'unix') return t.millisecondsSinceEpoch.toString();

  final d = useUtc ? t.toUtc() : t;
  String two(int n) => n.toString().padLeft(2, '0');
  String three(int n) => n.toString().padLeft(3, '0');

  final date = '${d.year}-${two(d.month)}-${two(d.day)}';
  final ms = three(d.millisecond);

  String body;
  switch (timeFormat) {
    case 'time24':
      body = '${two(d.hour)}:${two(d.minute)}:${two(d.second)}.$ms';
      break;
    case 'datetime12':
      body = '$date ${_time12(d, two, ms)}';
      break;
    case 'time12':
      body = _time12(d, two, ms);
      break;
    default: // datetime24
      body = '$date ${two(d.hour)}:${two(d.minute)}:${two(d.second)}.$ms';
  }
  return useUtc ? '$body UTC' : body;
}

String _time12(DateTime d, String Function(int) two, String ms) {
  final isPm = d.hour >= 12;
  final h12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
  return '${two(h12)}:${two(d.minute)}:${two(d.second)}.$ms ${isPm ? 'PM' : 'AM'}';
}

/// `yyyy-MM-dd HH:mm:ss.SSS` — kept for callers/tests that want the default.
String formatTimestamp(DateTime t) => formatStamp(t);

/// A live, millisecond-resolution clock that repaints every frame.
class LiveClock extends StatefulWidget {
  const LiveClock({
    super.key,
    this.style,
    this.timeFormat = 'datetime24',
    this.useUtc = false,
  });

  final TextStyle? style;
  final String timeFormat;
  final bool useUtc;

  @override
  State<LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      setState(() => _now = DateTime.now());
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatStamp(_now, timeFormat: widget.timeFormat, useUtc: widget.useUtc),
      style: widget.style ??
          const TextStyle(
            fontFeatures: [FontFeature.tabularFigures()],
            fontFamily: 'monospace',
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
    );
  }
}

/// The app badge: a record ring + red clock face + millisecond ticks, drawn to
/// match the launcher icon. Self-contained, no image assets.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final c = Offset(size.width / 2, size.height / 2);

    // Rounded gradient badge background.
    final bgRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(s * 0.24),
    );
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2A1A4A), Color(0xFF120A24)],
      ).createShader(Offset.zero & size);
    canvas.drawRRect(bgRect, bgPaint);

    // Outer record ring.
    final ringRadius = s * 0.30;
    canvas.drawCircle(
      c,
      ringRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.05
        ..color = Colors.white,
    );

    // Inner red clock face.
    final faceRadius = s * 0.185;
    canvas.drawCircle(c, faceRadius, Paint()..color = const Color(0xFFFF3B5C));

    // Clock hands.
    final handPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = s * 0.035
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(c, c + Offset(0, -faceRadius * 0.72), handPaint);
    canvas.drawLine(
        c, c + Offset(faceRadius * 0.62, faceRadius * 0.28), handPaint);
    canvas.drawCircle(c, s * 0.025, Paint()..color = Colors.white);

    // Millisecond tick marks below the ring.
    final tickPaint = Paint()..color = const Color(0xFF2DE0FF);
    final tickY = c.dy + ringRadius + s * 0.10;
    for (final dx in [-s * 0.12, 0.0, s * 0.12]) {
      final dy = dx == 0 ? tickY + s * 0.02 : tickY;
      canvas.drawCircle(Offset(c.dx + dx, dy), s * 0.025, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Subtle animated record dot used on the Stop button while recording.
class PulsingDot extends StatefulWidget {
  const PulsingDot({super.key, this.size = 14, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}

/// Decorative corner glows used behind the hero section.
class GlowBackdrop extends StatelessWidget {
  const GlowBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -120,
          right: -80,
          child: _blob(const Color(0xFFFF3B5C), 260),
        ),
        Positioned(
          bottom: -140,
          left: -100,
          child: _blob(const Color(0xFF2DE0FF), 300),
        ),
        child,
      ],
    );
  }

  Widget _blob(Color color, double size) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.22),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
