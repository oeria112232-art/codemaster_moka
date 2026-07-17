import 'dart:math' as math;
import 'package:flutter/material.dart';

class CleanHeroBg extends StatefulWidget {
  const CleanHeroBg({super.key});

  @override
  State<CleanHeroBg> createState() => _CleanHeroBgState();
}

class _CleanHeroBgState extends State<CleanHeroBg>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  double _pointerX = 0;
  double _pointerY = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) {
        final size = MediaQuery.of(context).size;
        if (size.width > 0 && size.height > 0) {
          setState(() {
            _pointerX = (e.position.dx / size.width) * 2 - 1;
            _pointerY = (e.position.dy / size.height) * 2 - 1;
          });
        }
      },
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return CustomPaint(
            painter: _CleanBgPainter(
              time: _ctrl.value * 60,
              pointerX: _pointerX,
              pointerY: _pointerY,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _CleanBgPainter extends CustomPainter {
  final double time;
  final double pointerX;
  final double pointerY;

  const _CleanBgPainter({
    required this.time,
    required this.pointerX,
    required this.pointerY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Deep gradient background
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF090D16),
          const Color(0xFF0c1020),
          const Color(0xFF090D16),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Subtle animated radial glow (follows pointer slightly)
    final glowCx = center.dx + pointerX * 40;
    final glowCy = center.dy * 0.6 + pointerY * 30;
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          (glowCx / size.width) * 2 - 1,
          (glowCy / size.height) * 2 - 1,
        ),
        radius: 1.2,
        colors: [
          const Color(0xFF1080E0).withValues(alpha: 0.06 + math.sin(time * 0.4) * 0.02),
          const Color(0xFF2090FF).withValues(alpha: 0.03),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glowPaint);

    // 3. Subtle secondary green glow bottom-right
    final glow2 = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.6, 0.4),
        radius: 0.8,
        colors: [
          const Color(0xFF2090FF).withValues(alpha: 0.04),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glow2);

    // 4. Floating stars (subtle, small)
    final rng = math.Random(42);
    final starPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 80; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final driftX = math.sin(time * 0.15 + i * 0.7) * (8 + rng.nextDouble() * 12);
      final driftY = math.cos(time * 0.12 + i * 0.5) * (6 + rng.nextDouble() * 10);
      final x = baseX + driftX + pointerX * (rng.nextDouble() * 6 - 3);
      final y = baseY + driftY + pointerY * (rng.nextDouble() * 6 - 3);
      final r = 0.5 + rng.nextDouble() * 1.2;
      final twinkle = (0.2 + math.sin(time * (1.5 + rng.nextDouble() * 2) + i * 1.3) * 0.2)
          .clamp(0.05, 0.45);

      final color = rng.nextInt(3) == 0
          ? const Color(0xFF2090FF)
          : const Color(0xFF1080E0);
      starPaint.color = color.withValues(alpha: twinkle);
      canvas.drawCircle(Offset(x, y), r, starPaint);
    }

    // 5. Very subtle grid lines (barely visible, professional)
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3;

    final gridSpacing = 120.0;
    final gridAlpha = 0.03 + math.sin(time * 0.2) * 0.01;
    gridPaint.color = const Color(0xFF1080E0).withValues(alpha: gridAlpha);

    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // 6. Bottom gradient fade to section color
    final fadePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFF090D16),
        ],
        stops: const [0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4));
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4),
      fadePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CleanBgPainter old) =>
      old.time != time || old.pointerX != pointerX || old.pointerY != pointerY;
}
