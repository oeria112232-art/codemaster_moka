import 'dart:math';
import 'dart:js_interop';
import 'package:flutter/material.dart';

@JS('playSadTrombone')
external void _playSadTromboneJS();

class TumbleweedPage extends StatefulWidget {
  final VoidCallback onBack;
  const TumbleweedPage({super.key, required this.onBack});

  @override
  State<TumbleweedPage> createState() => _TumbleweedPageState();
}

class _TumbleweedPageState extends State<TumbleweedPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _driftCtrl;
  late final AnimationController _rotateCtrl;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _dustCtrl;

  @override
  void initState() {
    super.initState();
    _driftCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    _rotateCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _shimmerCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
    _dustCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        try {
          _playSadTromboneJS();
        } catch (_) {}
      }
    });
  }

  @override
  void dispose() {
    _driftCtrl.dispose();
    _rotateCtrl.dispose();
    _shimmerCtrl.dispose();
    _dustCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF050810),
                    Color(0xFF090D16),
                    Color(0xFF0C1220),
                    Color(0xFF101828),
                    Color(0xFF141A29),
                  ],
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _shimmerCtrl,
            builder: (_, __) => Positioned.fill(
              child: CustomPaint(painter: _StarPainter(twinkle: _shimmerCtrl.value)),
            ),
          ),
          AnimatedBuilder(
            animation: _shimmerCtrl,
            builder: (_, __) => Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, 0.3 + sin(_shimmerCtrl.value * pi) * 0.08),
                    radius: 1.4,
                    colors: [
                      const Color(0xFF1080E0).withValues(alpha: 0.06 + sin(_shimmerCtrl.value * pi) * 0.03),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.35,
            child: CustomPaint(painter: _TerrainPainter()),
          ),
          AnimatedBuilder(
            animation: _dustCtrl,
            builder: (_, __) => Positioned.fill(
              child: CustomPaint(painter: _ParticlePainter(time: _dustCtrl.value * 10)),
            ),
          ),
          // Main tumbleweed
          AnimatedBuilder(
            animation: _driftCtrl,
            builder: (_, __) {
              final t = _driftCtrl.value;
              final x = size.width + 100 - (t * (size.width + 300));
              final y = size.height * 0.65 + sin(t * pi * 5) * 10;
              return Positioned(
                left: x,
                top: y,
                child: AnimatedBuilder(
                  animation: _rotateCtrl,
                  builder: (_, __) => Transform.rotate(
                    angle: _rotateCtrl.value * pi * 2,
                    child: CustomPaint(
                      size: const Size(70, 70),
                      painter: _TumbleweedPainter(opacity: 0.85),
                    ),
                  ),
                ),
              );
            },
          ),
          // Second tumbleweed (smaller)
          AnimatedBuilder(
            animation: _driftCtrl,
            builder: (_, __) {
              final t = (_driftCtrl.value + 0.45) % 1.0;
              final x = size.width + 60 - (t * (size.width + 200));
              final y = size.height * 0.58 + sin(t * pi * 3) * 6;
              return Positioned(
                left: x,
                top: y,
                child: AnimatedBuilder(
                  animation: _rotateCtrl,
                  builder: (_, __) => Transform.rotate(
                    angle: -_rotateCtrl.value * pi * 2,
                    child: Opacity(
                      opacity: 0.35,
                      child: CustomPaint(
                        size: const Size(42, 42),
                        painter: _TumbleweedPainter(opacity: 0.5),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Third tiny tumbleweed
          AnimatedBuilder(
            animation: _driftCtrl,
            builder: (_, __) {
              final t = (_driftCtrl.value + 0.7) % 1.0;
              final x = size.width + 40 - (t * (size.width + 150));
              final y = size.height * 0.72 + sin(t * pi * 6) * 5;
              return Positioned(
                left: x,
                top: y,
                child: AnimatedBuilder(
                  animation: _rotateCtrl,
                  builder: (_, __) => Transform.rotate(
                    angle: _rotateCtrl.value * pi * 1.5,
                    child: Opacity(
                      opacity: 0.2,
                      child: CustomPaint(
                        size: const Size(28, 28),
                        painter: _TumbleweedPainter(opacity: 0.4),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Blue glow orb
          Positioned(
            top: size.height * 0.1,
            left: size.width * 0.5 - 60,
            child: AnimatedBuilder(
              animation: _shimmerCtrl,
              builder: (_, __) => Container(
                width: 120 + sin(_shimmerCtrl.value * pi) * 12,
                height: 120 + sin(_shimmerCtrl.value * pi) * 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF1080E0).withValues(alpha: 0.15),
                      const Color(0xFF2090FF).withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141A29).withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF1080E0), size: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final double twinkle;
  _StarPainter({required this.twinkle});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(99);
    final p = Paint()..style = PaintingStyle.fill;

    // ── Twinkling stars ──
    final starSeeds = List.generate(120, (i) => {
      'x': rng.nextDouble() * size.width,
      'y': rng.nextDouble() * size.height * 0.55,
      'r': 0.6 + rng.nextDouble() * 2.0,
      'phase': rng.nextDouble() * pi * 2,
      'bright': 0.2 + rng.nextDouble() * 0.6,
      'cross': rng.nextBool(),
    });

    for (final s in starSeeds) {
      final x = s['x'] as double;
      final y = s['y'] as double;
      final r = s['r'] as double;
      final phase = s['phase'] as double;
      final bright = s['bright'] as double;
      final isCross = s['cross'] as bool;

      final alpha = (bright + sin(twinkle * pi * 2 + phase) * 0.25).clamp(0.1, 1.0);

      if (isCross && r > 1.4) {
        // Draw 4-pointed star (cross / diamond shape)
        final sp = Paint()
          ..color = Color.fromRGBO(220, 235, 255, alpha)
          ..strokeWidth = 0.8
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;
        final len = r * 2.5;
        canvas.drawLine(Offset(x, y - len), Offset(x, y + len), sp);
        canvas.drawLine(Offset(x - len, y), Offset(x + len, y), sp);
        // Center glow dot
        p.color = Color.fromRGBO(255, 255, 255, alpha);
        canvas.drawCircle(Offset(x, y), r * 0.6, p);
      } else {
        // Simple round star
        p.color = Color.fromRGBO(220, 235, 255, alpha);
        canvas.drawCircle(Offset(x, y), r, p);
      }
    }

    // ── Crescent moon (top-right area) ──
    final moonCx = size.width * 0.82;
    final moonCy = size.height * 0.12;
    final moonR = 36.0;

    // Outer glow (3 layers)
    for (int g = 3; g >= 1; g--) {
      final glowR = moonR + g * 18.0;
      final glowAlpha = 0.025 / g;
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            Color.fromRGBO(16, 128, 224, glowAlpha * 2),
            Color.fromRGBO(16, 128, 224, glowAlpha),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: Offset(moonCx, moonCy), radius: glowR));
      canvas.drawCircle(Offset(moonCx, moonCy), glowR, glowPaint);
    }

    // Bright blue halo
    final haloPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Color.fromRGBO(32, 144, 255, 0.12),
          Color.fromRGBO(16, 128, 224, 0.04),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(moonCx, moonCy), radius: moonR + 10));
    canvas.drawCircle(Offset(moonCx, moonCy), moonR + 10, haloPaint);

    // Moon body (bright circle)
    final moonBodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3),
        colors: [
          const Color(0xFFD8E8FF),
          const Color(0xFFB0C8E8),
          const Color(0xFF8AAAD0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(moonCx, moonCy), radius: moonR));
    canvas.drawCircle(Offset(moonCx, moonCy), moonR, moonBodyPaint);

    // Crescent cutout (darker circle overlapping to create crescent shape)
    final cutPaint = Paint()..color = const Color(0xFF050810);
    canvas.drawCircle(Offset(moonCx - moonR * 0.45, moonCy - moonR * 0.15), moonR * 0.88, cutPaint);

    // Re-draw outer edge glow after cutout for clean look
    final edgePaint = Paint()
      ..color = Color.fromRGBO(180, 210, 245, 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final crescentPath = Path();
    crescentPath.arcTo(
      Rect.fromCircle(center: Offset(moonCx, moonCy), radius: moonR),
      -pi * 0.7,
      pi * 1.4,
      true,
    );
    canvas.drawPath(crescentPath, edgePaint);

    // Tiny crater details on visible crescent
    final craterPaint = Paint()
      ..color = Color.fromRGBO(160, 195, 230, 0.25)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(moonCx + moonR * 0.2, moonCy - moonR * 0.35), 2.5, craterPaint);
    canvas.drawCircle(Offset(moonCx + moonR * 0.35, moonCy + moonR * 0.1), 1.8, craterPaint);
    canvas.drawCircle(Offset(moonCx + moonR * 0.1, moonCy + moonR * 0.3), 2.0, craterPaint);
    canvas.drawCircle(Offset(moonCx + moonR * 0.45, moonCy - moonR * 0.1), 1.2, craterPaint);

    // Moon light rays (subtle radial lines)
    final rayPaint = Paint()
      ..color = Color.fromRGBO(16, 128, 224, 0.03)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * pi * 2 + twinkle * 0.3;
      final inner = moonR + 4;
      final outer = moonR + 14.0 + sin(twinkle * pi * 2 + i) * 5;
      canvas.drawLine(
        Offset(moonCx + cos(angle) * inner, moonCy + sin(angle) * inner),
        Offset(moonCx + cos(angle) * outer, moonCy + sin(angle) * outer),
        rayPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter old) => old.twinkle != twinkle;
}

class _TerrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path1 = Path();
    path1.moveTo(0, size.height * 0.25);
    path1.quadraticBezierTo(size.width * 0.15, size.height * 0.05, size.width * 0.35, size.height * 0.2);
    path1.quadraticBezierTo(size.width * 0.55, size.height * 0.35, size.width * 0.75, size.height * 0.12);
    path1.quadraticBezierTo(size.width * 0.9, size.height * 0.02, size.width, size.height * 0.15);
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, Paint()..color = const Color(0xFF0C1220));

    final path2 = Path();
    path2.moveTo(0, size.height * 0.5);
    path2.quadraticBezierTo(size.width * 0.25, size.height * 0.3, size.width * 0.45, size.height * 0.42);
    path2.quadraticBezierTo(size.width * 0.65, size.height * 0.55, size.width, size.height * 0.35);
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, Paint()..color = const Color(0xFF101828));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ParticlePainter extends CustomPainter {
  final double time;
  _ParticlePainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(55);
    final p = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 25; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final dx = sin(time * 0.15 + i * 1.7) * 50;
      final dy = cos(time * 0.12 + i * 1.1) * 25;
      final r = 0.8 + rng.nextDouble() * 2;
      p.color = Color.fromRGBO(16, 128, 224, 0.04 + sin(time * 0.25 + i) * 0.02);
      canvas.drawCircle(Offset(baseX + dx, baseY + dy), r, p);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.time != time;
}

class _TumbleweedPainter extends CustomPainter {
  final double opacity;
  _TumbleweedPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final rng = Random(42);

    final circlePaint = Paint()
      ..color = Color.fromRGBO(120, 160, 200, opacity * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, circlePaint);

    final tanglePaint = Paint()
      ..color = Color.fromRGBO(100, 140, 180, opacity * 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (int i = 0; i < 28; i++) {
      final angle = (i / 28) * pi * 2;
      final r1 = radius * (0.25 + rng.nextDouble() * 0.55);
      final r2 = radius * (0.35 + rng.nextDouble() * 0.5);
      final a1 = angle + rng.nextDouble() * 0.6;
      final a2 = angle + 0.25 + rng.nextDouble() * 0.6;
      final p1 = Offset(center.dx + cos(a1) * r1, center.dy + sin(a1) * r1);
      final p2 = Offset(center.dx + cos(a2) * r2, center.dy + sin(a2) * r2);
      canvas.drawLine(p1, p2, tanglePaint);
    }

    final spikePaint = Paint()
      ..color = Color.fromRGBO(130, 170, 210, opacity * 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (int i = 0; i < 18; i++) {
      final angle = (i / 18) * pi * 2;
      final inner = Offset(
        center.dx + cos(angle) * (radius * 0.65),
        center.dy + sin(angle) * (radius * 0.65),
      );
      final outer = Offset(
        center.dx + cos(angle) * (radius + 4 + rng.nextDouble() * 7),
        center.dy + sin(angle) * (radius + 4 + rng.nextDouble() * 7),
      );
      canvas.drawLine(inner, outer, spikePaint);
    }

    final fillPaint = Paint()
      ..color = Color.fromRGBO(10, 20, 40, opacity * 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.45, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _TumbleweedPainter old) => old.opacity != opacity;
}
