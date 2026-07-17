import 'dart:math' as math;
import 'package:flutter/material.dart';

class CosmicPainter extends CustomPainter {
  final double time;
  final double scrollDepth;

  CosmicPainter({required this.time, required this.scrollDepth});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(scrollDepth.floor() * 31337);
    final center = Offset(size.width / 2, size.height / 2);

    _drawNebula(canvas, size);
    _drawStars(canvas, size, rng);
    _drawMainPlanet(canvas, size, center, rng);
    _drawOrbitingMoons(canvas, size, center, rng);
    _drawAsteroidBelt(canvas, size, center, rng);
    _drawNebulaClouds(canvas, size, rng);
    _drawLightRays(canvas, size, center);
    _drawFloatingRocks(canvas, size, rng);
  }

  void _drawNebula(Canvas canvas, Size size) {
    final d = scrollDepth;
    final t = time;

    final bgColors = _getDepthColors(d);
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = bgColors[0],
    );

    final cx = 0.3 + math.sin(d * 0.8) * 0.3;
    final cy = -0.2 + math.cos(d * 0.5) * 0.3;
    final glow = Paint()
      ..shader = RadialGradient(
        center: Alignment(cx, cy),
        radius: 1.5,
        colors: [
          bgColors[1].withValues(alpha: 0.12 + math.sin(t * 0.3) * 0.04),
          bgColors[2].withValues(alpha: 0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, glow);

    final glow2 = Paint()
      ..shader = RadialGradient(
        center: Alignment(-cx * 0.5, cy * 1.2),
        radius: 1.2,
        colors: [
          bgColors[2].withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, glow2);
  }

  void _drawStars(Canvas canvas, Size size, math.Random rng) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 150; i++) {
      final bx = rng.nextDouble() * size.width;
      final by = rng.nextDouble() * size.height;
      final drift = math.sin(time * 0.2 + i * 0.3) * 5;
      final x = bx + drift;
      final y = by + math.cos(time * 0.15 + i * 0.5) * 3;
      final r = 0.3 + rng.nextDouble() * 1.8;
      final twinkle = (0.15 + math.sin(time * (1 + rng.nextDouble() * 3) + i) * 0.15).clamp(0.05, 0.4);

      final isBright = rng.nextInt(5) == 0;
      paint.color = isBright
          ? Colors.white.withValues(alpha: twinkle * 1.5)
          : const Color(0xFF3FD2FF).withValues(alpha: twinkle);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  void _drawMainPlanet(Canvas canvas, Size size, Offset center, math.Random rng) {
    final t = time;
    final d = scrollDepth;

    final planetRadius = math.min(size.width, size.height) * (0.12 + math.sin(d * 1.5) * 0.04);
    final px = center.dx + math.sin(t * 0.1 + d * 2) * size.width * 0.15;
    final py = center.dy + math.cos(t * 0.08 + d * 1.5) * size.height * 0.1;

    final colors = _getPlanetColors(d);
    final bodyColor = colors[0];
    final wireColor = colors[1];
    final glowColor = colors[2];

    // Atmosphere glow
    canvas.drawCircle(
      Offset(px, py),
      planetRadius * 1.6,
      Paint()
        ..shader = RadialGradient(
          colors: [
            glowColor.withValues(alpha: 0.15),
            glowColor.withValues(alpha: 0.05),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(px, py), radius: planetRadius * 1.6)),
    );

    // Planet body (filled sphere)
    canvas.drawCircle(
      Offset(px, py),
      planetRadius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 1.0,
          colors: [
            bodyColor.withValues(alpha: 0.4),
            bodyColor.withValues(alpha: 0.15),
            const Color(0xFF010409).withValues(alpha: 0.6),
          ],
        ).createShader(Rect.fromCircle(center: Offset(px, py), radius: planetRadius)),
    );

    // Wireframe latitude lines
    final wirePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (int i = 1; i < 6; i++) {
      final ratio = i / 6.0;
      final latR = planetRadius * math.sin(ratio * math.pi);
      final latY = planetRadius * math.cos(ratio * math.pi);
      final wireAlpha = (0.25 - i * 0.03).clamp(0.05, 0.25);
      wirePaint.color = wireColor.withValues(alpha: wireAlpha);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(px, py - latY * 0.3),
          width: latR * 2,
          height: latR * 0.5,
        ),
        wirePaint,
      );
    }

    // Wireframe longitude lines
    for (int i = 0; i < 4; i++) {
      final angle = (i / 4.0) * math.pi + t * 0.15;
      final wireAlpha = 0.15 + math.sin(t * 0.5 + i) * 0.05;
      wirePaint.color = wireColor.withValues(alpha: wireAlpha);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(px, py),
          width: planetRadius * 2 * math.cos(angle).abs() + 2,
          height: planetRadius * 2,
        ),
        wirePaint,
      );
    }

    // Surface detail dots
    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 20; i++) {
      final angle = rng.nextDouble() * math.pi * 2;
      final dist = rng.nextDouble() * planetRadius * 0.85;
      final dx = px + math.cos(angle + t * 0.1) * dist;
      final dy = py + math.sin(angle + t * 0.1) * dist;
      final distFromCenter = (Offset(dx, dy) - Offset(px, py)).distance;
      if (distFromCenter < planetRadius * 0.95) {
        dotPaint.color = bodyColor.withValues(alpha: 0.3 + rng.nextDouble() * 0.3);
        canvas.drawCircle(Offset(dx, dy), 1 + rng.nextDouble() * 2, dotPaint);
      }
    }
  }

  void _drawOrbitingMoons(Canvas canvas, Size size, Offset center, math.Random rng) {
    final t = time;
    final d = scrollDepth;
    final planetRadius = math.min(size.width, size.height) * (0.12 + math.sin(d * 1.5) * 0.04);
    final px = center.dx + math.sin(t * 0.1 + d * 2) * size.width * 0.15;
    final py = center.dy + math.cos(t * 0.08 + d * 1.5) * size.height * 0.1;

    final moonConfigs = [
      _MoonConfig(orbit: 2.2, size: 0.15, speed: 0.6, color: const Color(0xFF22C55E), hasRing: false),
      _MoonConfig(orbit: 3.0, size: 0.08, speed: -0.4, color: const Color(0xFF3FD2FF), hasRing: true),
      _MoonConfig(orbit: 1.6, size: 0.06, speed: 1.2, color: const Color(0xFFFF6B6B), hasRing: false),
      _MoonConfig(orbit: 3.8, size: 0.1, speed: -0.25, color: const Color(0xFF3FB950), hasRing: false),
    ];

    for (final mc in moonConfigs) {
      final moonAngle = t * mc.speed;
      final orbitW = planetRadius * mc.orbit;
      final moonX = px + orbitW * math.cos(moonAngle);
      final moonY = py + orbitW * 0.4 * math.sin(moonAngle);
      final moonR = planetRadius * mc.size;
      final depth3d = math.sin(moonAngle);

      if (depth3d < -0.3) continue;

      // Orbit path (faint ellipse)
      final orbitPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.4
        ..color = mc.color.withValues(alpha: 0.06);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(px, py), width: orbitW * 2, height: orbitW * 0.8),
        orbitPaint,
      );

      final moonAlpha = (0.3 + depth3d * 0.3).clamp(0.1, 0.6);

      // Moon glow
      canvas.drawCircle(
        Offset(moonX, moonY),
        moonR * 2,
        Paint()
          ..shader = RadialGradient(
            colors: [
              mc.color.withValues(alpha: 0.08 * moonAlpha),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCircle(center: Offset(moonX, moonY), radius: moonR * 2)),
      );

      // Moon body
      canvas.drawCircle(
        Offset(moonX, moonY),
        moonR,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.3, -0.3),
            colors: [
              mc.color.withValues(alpha: 0.5 * moonAlpha),
              mc.color.withValues(alpha: 0.15 * moonAlpha),
            ],
          ).createShader(Rect.fromCircle(center: Offset(moonX, moonY), radius: moonR)),
      );

      // Moon wireframe
      canvas.drawCircle(
        Offset(moonX, moonY),
        moonR,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.6
          ..color = mc.color.withValues(alpha: 0.3 * moonAlpha),
      );

      // Moon latitude line
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(moonX, moonY),
          width: moonR * 2,
          height: moonR * 0.4,
        ),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..color = mc.color.withValues(alpha: 0.2 * moonAlpha),
      );

      // Saturn-like rings for one moon
      if (mc.hasRing) {
        canvas.save();
        canvas.translate(moonX, moonY);
        canvas.rotate(0.3);
        final ringPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..color = mc.color.withValues(alpha: 0.35 * moonAlpha);
        canvas.drawOval(
          Rect.fromCenter(center: Offset.zero, width: moonR * 4, height: moonR * 0.8),
          ringPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(center: Offset.zero, width: moonR * 3.2, height: moonR * 0.6),
          ringPaint..color = mc.color.withValues(alpha: 0.2 * moonAlpha),
        );
        canvas.restore();
      }

      // Tiny orbiting satellite for closest moon
      if (mc.orbit < 2.0) {
        final satAngle = t * 4;
        final satX = moonX + moonR * 2.5 * math.cos(satAngle);
        final satY = moonY + moonR * 0.8 * math.sin(satAngle);
        canvas.drawCircle(
          Offset(satX, satY),
          1.5,
          Paint()..color = Colors.white.withValues(alpha: 0.6),
        );
      }
    }
  }

  void _drawAsteroidBelt(Canvas canvas, Size size, Offset center, math.Random rng) {
    final t = time;
    final d = scrollDepth;

    final beltY = center.dy + math.sin(d * 0.7) * size.height * 0.15;
    final beltPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 40; i++) {
      final angle = (i / 40.0) * math.pi * 2 + t * 0.05;
      final radiusX = size.width * (0.3 + rng.nextDouble() * 0.15);
      final radiusY = radiusX * 0.15;
      final x = center.dx + math.cos(angle) * radiusX;
      final y = beltY + math.sin(angle) * radiusY;

      final depth = math.sin(angle);
      if (depth < -0.2) continue;

      final rockSize = (1 + rng.nextDouble() * 3) * (0.5 + depth * 0.5);
      final rockAlpha = (0.15 + depth * 0.15).clamp(0.05, 0.3);

      beltPaint.color = const Color(0xFF6B7280).withValues(alpha: rockAlpha);
      canvas.drawCircle(Offset(x, y), rockSize, beltPaint);

      if (rng.nextBool()) {
        beltPaint.color = const Color(0xFFA6ABB6).withValues(alpha: rockAlpha * 0.5);
        canvas.drawCircle(Offset(x + 1, y - 0.5), rockSize * 0.3, beltPaint);
      }
    }
  }

  void _drawNebulaClouds(Canvas canvas, Size size, math.Random rng) {
    final t = time;
    final d = scrollDepth;
    final cloudColors = _getDepthColors(d);

    for (int i = 0; i < 5; i++) {
      final cx = size.width * (rng.nextDouble() * 0.8 + 0.1) + math.sin(t * 0.1 + i) * 30;
      final cy = size.height * (rng.nextDouble() * 0.8 + 0.1) + math.cos(t * 0.08 + i * 0.7) * 20;
      final r = 80 + rng.nextDouble() * 120;
      final alpha = 0.02 + math.sin(t * 0.2 + i * 1.5) * 0.01;

      final colorIndex = i % 3;
      final cloudColor = colorIndex == 0
          ? cloudColors[1]
          : colorIndex == 1
              ? cloudColors[2]
               : const Color(0xFF22C55E);

      canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [
              cloudColor.withValues(alpha: alpha),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
      );
    }
  }

  void _drawLightRays(Canvas canvas, Size size, Offset center) {
    final t = time;
    final d = scrollDepth;
    final colors = _getDepthColors(d);

    final rayPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int i = 0; i < 8; i++) {
      final angle = (i / 8.0) * math.pi * 2 + t * 0.05;
      final len = 100 + math.sin(t * 0.5 + i * 2) * 50;
      final alpha = 0.03 + math.sin(t * 0.3 + i) * 0.02;

      rayPaint.color = colors[1].withValues(alpha: alpha);
      canvas.drawLine(
        center,
        Offset(
          center.dx + math.cos(angle) * len,
          center.dy + math.sin(angle) * len,
        ),
        rayPaint,
      );
    }
  }

  void _drawFloatingRocks(Canvas canvas, Size size, math.Random rng) {
    final t = time;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final x = baseX + math.sin(t * 0.3 + i * 1.1) * 40;
      final y = baseY + math.cos(t * 0.25 + i * 0.8) * 30;
      final r = 2 + rng.nextDouble() * 6;
      final alpha = (0.06 + math.sin(t * 0.4 + i) * 0.04).clamp(0.02, 0.12);

      paint.color = const Color(0xFF6B7280).withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), r, paint);

      paint.color = const Color(0xFF3FD2FF).withValues(alpha: alpha * 0.3);
      canvas.drawCircle(Offset(x, y), r + 3, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5
        ..color = const Color(0xFF3FD2FF).withValues(alpha: alpha * 0.3));
    }
  }

  List<Color> _getDepthColors(double d) {
    if (d < 1.0) {
      return [const Color(0xFF0a0a2e), const Color(0xFF3FD2FF), const Color(0xFF22C55E)];
    } else if (d < 2.0) {
      return [const Color(0xFF0d0822), const Color(0xFFAD00FF), const Color(0xFF58A6FF)];
    } else if (d < 3.0) {
      return [const Color(0xFF0b0514), const Color(0xFFF78166), const Color(0xFFFFB020)];
    } else if (d < 4.0) {
      return [const Color(0xFF05100a), const Color(0xFF3FB950), const Color(0xFF3FD2FF)];
    } else {
      return [const Color(0xFF010409), const Color(0xFFD2A8FF), const Color(0xFFFF6B6B)];
    }
  }

  List<Color> _getPlanetColors(double d) {
    if (d < 1.0) {
      return [const Color(0xFF3FD2FF), const Color(0xFF8FF2FF), const Color(0xFF3FD2FF)];
    } else if (d < 2.0) {
      return [const Color(0xFFAD00FF), const Color(0xFFD2A8FF), const Color(0xFFAD00FF)];
    } else if (d < 3.0) {
      return [const Color(0xFFF78166), const Color(0xFFFFA657), const Color(0xFFFFB020)];
    } else if (d < 4.0) {
      return [const Color(0xFF3FB950), const Color(0xFF56D364), const Color(0xFF3FD2FF)];
    } else {
      return [const Color(0xFFFF6B6B), const Color(0xFFFF2A85), const Color(0xFFD2A8FF)];
    }
  }

  @override
  bool shouldRepaint(covariant CosmicPainter old) =>
      old.time != time || old.scrollDepth != scrollDepth;
}

class _MoonConfig {
  final double orbit;
  final double size;
  final double speed;
  final Color color;
  final bool hasRing;

  const _MoonConfig({
    required this.orbit,
    required this.size,
    required this.speed,
    required this.color,
    required this.hasRing,
  });
}
