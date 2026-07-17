import 'dart:math';
import 'package:flutter/material.dart';

class PortalVisualPainter extends CustomPainter {
  final double time;
  final double depth;
  final int seed;

  PortalVisualPainter({
    required this.time,
    required this.depth,
    this.seed = 0,
  });

  static const List<List<Color>> _zonePalettes = [
    [Color(0xFF0a0a2e), Color(0xFF3FD2FF), Color(0xFF22C55E)],
    [Color(0xFF0d1117), Color(0xFF58A6FF), Color(0xFF79C0FF)],
    [Color(0xFF0b0e14), Color(0xFF3FB950), Color(0xFF56D364)],
    [Color(0xFF161b22), Color(0xFFD2A8FF), Color(0xFFBC8CFF)],
    [Color(0xFF0d1117), Color(0xFFF78166), Color(0xFFFFA657)],
    [Color(0xFF010409), Color(0xFF3FD2FF), Color(0xFFF0F6FC)],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(seed);
    final zone = depth.clamp(0.0, 5.0);
    final zoneIndex = zone.floor().clamp(0, 5);
    final zoneProgress = zone - zoneIndex;
    final palette = _zonePalettes[zoneIndex];
    final nextPalette = _zonePalettes[(zoneIndex + 1).clamp(0, 5)];

    _drawBackground(canvas, size, palette, nextPalette, zoneProgress);
    _drawZoneContent(canvas, size, zoneIndex, zoneProgress, rng);
    _drawAmbientParticles(canvas, size, rng, zoneIndex);
  }

  void _drawBackground(Canvas canvas, Size size, List<Color> c1,
      List<Color> c2, double t) {
    final bg = _lerpColor(c1[0], c2[0], t);
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = bg,
    );

    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(0, -0.3 + sin(time * 0.3) * 0.2),
        radius: 1.5,
        colors: [
          _lerpColor(c1[1], c2[1], t).withValues(alpha: 0.06 + sin(time * 0.5) * 0.02),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, glowPaint);
  }

  void _drawZoneContent(Canvas canvas, Size size, int zone, double t, Random rng) {
    switch (zone) {
      case 0:
        _drawCosmicZone(canvas, size, rng, t);
        break;
      case 1:
        _drawWireframeZone(canvas, size, rng, t);
        break;
      case 2:
        _drawWaveZone(canvas, size, rng, t);
        break;
      case 3:
        _drawNeuralZone(canvas, size, rng, t);
        break;
      case 4:
        _drawCellularZone(canvas, size, rng, t);
        break;
      case 5:
        _drawVoidZone(canvas, size, rng, t);
        break;
    }
  }

  void _drawCosmicZone(Canvas canvas, Size size, Random rng, double t) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 60; i++) {
      final x = (rng.nextDouble() * size.width + time * (10 + rng.nextDouble() * 20)) % size.width;
      final y = (rng.nextDouble() * size.height - time * (5 + rng.nextDouble() * 10)) % size.height;
      final r = 0.5 + rng.nextDouble() * 2.5;
      final alpha = (0.3 + sin(time * 2 + i) * 0.3).clamp(0.0, 1.0);

      paint.color = (rng.nextBool() ? const Color(0xFF3FD2FF) : const Color(0xFF22C55E))
          .withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0xFF3FD2FF).withValues(alpha: 0.15 + sin(time) * 0.05);

    final cx = size.width * 0.5;
    final cy = size.height * 0.4;
    final baseR = 80 + sin(time * 0.7) * 20;
    canvas.drawCircle(Offset(cx, cy), baseR, ringPaint);
    canvas.drawCircle(
        Offset(cx, cy), baseR * 1.5, ringPaint..color = const Color(0xFF22C55E).withValues(alpha: 0.08));
    canvas.drawCircle(
        Offset(cx, cy), baseR * 2.2, ringPaint..color = const Color(0xFF3FD2FF).withValues(alpha: 0.05));
  }

  void _drawWireframeZone(Canvas canvas, Size size, Random rng, double t) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final sides = 6;
    final baseR = 60.0;

    for (int ring = 0; ring < 5; ring++) {
      final r = baseR + ring * 50.0;
      final rot = t * 0.5 + ring * 0.3;
      final alpha = (0.2 - ring * 0.03).clamp(0.05, 0.2);
      paint.color = const Color(0xFF58A6FF).withValues(alpha: alpha);

      final path = Path();
      for (int i = 0; i <= sides; i++) {
        final angle = (i / sides) * 2 * pi + rot;
        final px = cx + cos(angle) * r;
        final py = cy + sin(angle) * r;
        if (i == 0) {
          path.moveTo(px, py);
        } else {
          path.lineTo(px, py);
        }
      }
      canvas.drawPath(path, paint);
    }

    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < sides; i++) {
      final angle = (i / sides) * 2 * pi + t * 0.5;
      final r = baseR;
      final px = cx + cos(angle) * r;
      final py = cy + sin(angle) * r;
      dotPaint.color = const Color(0xFF58A6FF).withValues(alpha: 0.6);
      canvas.drawCircle(Offset(px, py), 3, dotPaint);
    }
  }

  void _drawWaveZone(Canvas canvas, Size size, Random rng, double t) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int w = 0; w < 8; w++) {
      final baseY = size.height * 0.2 + w * (size.height * 0.08);
      final alpha = (0.15 - w * 0.015).clamp(0.03, 0.15);
      paint.color = Color.lerp(
        const Color(0xFF3FB950),
        const Color(0xFF22C55E),
        w / 8.0,
      )!.withValues(alpha: alpha);

      final path = Path();
      for (double x = 0; x <= size.width; x += 3) {
        final y = baseY +
            sin(x * 0.01 + t * 2 + w * 0.5) * (20 + w * 5) +
            cos(x * 0.007 - t * 1.3) * 10;
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  void _drawNeuralZone(Canvas canvas, Size size, Random rng, double t) {
    final nodes = <Offset>[];
    for (int i = 0; i < 25; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      nodes.add(Offset(
        x + sin(t * 0.5 + i) * 15,
        y + cos(t * 0.7 + i * 0.3) * 15,
      ));
    }

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final dist = (nodes[i] - nodes[j]).distance;
        if (dist < 180) {
          final alpha = (1 - dist / 180) * 0.15;
          linePaint.color = const Color(0xFFD2A8FF).withValues(alpha: alpha);
          canvas.drawLine(nodes[i], nodes[j], linePaint);
        }
      }
    }

    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (final node in nodes) {
      final pulse = 2 + sin(t * 3 + node.dx * 0.01) * 1.5;
      dotPaint.color = const Color(0xFFD2A8FF).withValues(alpha: 0.5);
      canvas.drawCircle(node, pulse, dotPaint);
      dotPaint.color = const Color(0xFFFFFFFF).withValues(alpha: 0.8);
      canvas.drawCircle(node, pulse * 0.4, dotPaint);
    }
  }

  void _drawCellularZone(Canvas canvas, Size size, Random rng, double t) {
    final paint = Paint()..style = PaintingStyle.fill;
    final cellSize = 40.0;
    final cols = (size.width / cellSize).ceil();
    final rows = (size.height / cellSize).ceil();

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final val = sin(c * 0.5 + t) * cos(r * 0.5 + t * 0.7);
        if (val > 0.3) {
          final alpha = ((val - 0.3) * 1.4).clamp(0.0, 0.3);
          paint.color = const Color(0xFFF78166).withValues(alpha: alpha);
          final rect = RRect.fromRectAndRadius(
            Rect.fromLTWH(c * cellSize + 2, r * cellSize + 2, cellSize - 4, cellSize - 4),
            Radius.circular(4),
          );
          canvas.drawRRect(rect, paint);
        }
      }
    }
  }

  void _drawVoidZone(Canvas canvas, Size size, Random rng, double t) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 15; i++) {
      final x = size.width * 0.5 + sin(t * 0.3 + i * 0.7) * size.width * 0.3;
      final y = size.height * 0.5 + cos(t * 0.2 + i * 0.5) * size.height * 0.3;
      final r = 1 + sin(t + i) * 0.5;
      paint.color = const Color(0xFF3FD2FF).withValues(alpha: 0.15 + sin(t * 2 + i) * 0.1);
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = const Color(0xFF3FD2FF).withValues(alpha: 0.05);

    final cx = size.width / 2;
    final cy = size.height / 2;
    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * pi + t * 0.1;
      final r1 = 50 + sin(t + i) * 20;
      final r2 = 150 + cos(t * 0.5 + i) * 30;
      canvas.drawLine(
        Offset(cx + cos(angle) * r1, cy + sin(angle) * r1),
        Offset(cx + cos(angle) * r2, cy + sin(angle) * r2),
        linePaint,
      );
    }
  }

  void _drawAmbientParticles(Canvas canvas, Size size, Random rng, int zone) {
    final paint = Paint()..style = PaintingStyle.fill;
    final colors = [
      const Color(0xFF3FD2FF),
      const Color(0xFF22C55E),
      const Color(0xFF3FB950),
    ];

    for (int i = 0; i < 30; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final x = baseX + sin(time * 0.3 + i * 0.5) * 30;
      final y = baseY + cos(time * 0.2 + i * 0.7) * 30;
      final alpha = (0.05 + sin(time + i) * 0.04).clamp(0.0, 0.1);
      paint.color = colors[i % colors.length].withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), 1, paint);
    }
  }

  Color _lerpColor(Color a, Color b, double t) {
    return Color.lerp(a, b, t.clamp(0.0, 1.0))!;
  }

  @override
  bool shouldRepaint(covariant PortalVisualPainter old) =>
      old.time != time || old.depth != depth || old.seed != seed;
}
