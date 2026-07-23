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
      duration: const Duration(seconds: 120),
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
            _pointerX = e.position.dx / size.width;
            _pointerY = e.position.dy / size.height;
          });
        }
      },
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return CustomPaint(
            painter: _CodeRainPainter(
              time: _ctrl.value * 120,
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

const _codeTokens = [
  '{', '}', '<', '>', '/', '=', '+', '-', '*', ';', ':', '(', ')',
  'const', 'void', 'int', 'return', 'async', 'await', 'class',
  'if', 'for', 'map', 'true', 'null', '0x10', 'E0', 'FF',
  'pub', 'dart', 'flutter', 'import', 'final', 'var', 'bool',
  'widget', 'state', 'build', 'context', 'theme', 'render',
  '0', '1', '/', '*', '&&', '||', '==', '!=', '=>',
];

class _CodeRainPainter extends CustomPainter {
  final double time;
  final double pointerX;
  final double pointerY;

  _CodeRainPainter({
    required this.time,
    required this.pointerX,
    required this.pointerY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);

    // 1. Deep gradient background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF04060C),
          Color(0xFF080C18),
          Color(0xFF04060C),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Mouse-following spotlight
    final spotCx = pointerX * size.width;
    final spotCy = pointerY * size.height;
    final spotPaint = Paint()
      ..shader = RadialGradient(
        radius: 0.5,
        colors: [
          const Color(0xFF1080E0).withValues(alpha: 0.08),
          const Color(0xFF0060B0).withValues(alpha: 0.03),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(spotCx, spotCy), radius: size.width * 0.5));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), spotPaint);

    // 3. Central ambient glow
    final centerGlow = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.2),
        radius: 0.8,
        colors: [
          const Color(0xFF1080E0).withValues(alpha: 0.04 + math.sin(time * 0.3) * 0.015),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), centerGlow);

    // 4. Code rain columns
    final colSpacing = 28.0;
    final cols = (size.width / colSpacing).ceil();
    final speed = 35.0;

    for (int col = 0; col < cols; col++) {
      final x = col * colSpacing + 4;
      final colSeed = col * 137;
      final colRng = math.Random(colSeed);

      // Each column has a different speed offset
      final speedMult = 0.6 + colRng.nextDouble() * 0.8;
      final startOffset = colRng.nextDouble() * size.height * 2;

      final rowCount = (size.height / 20).ceil() + 4;

      for (int row = 0; row < rowCount; row++) {
        final baseY = (startOffset + time * speed * speedMult + row * 20) % (size.height + 200) - 100;

        // Distance from mouse pointer for interaction
        final dx = (x - spotCx) / size.width;
        final dy = (baseY - spotCy) / size.height;
        final distFromMouse = math.sqrt(dx * dx + dy * dy);
        final mouseInfluence = (1.0 - (distFromMouse * 3).clamp(0.0, 1.0));

        // Token selection
        final tokenIdx = (colSeed + row * 7 + (time * 0.1).toInt()) % _codeTokens.length;
        final token = _codeTokens[tokenIdx];

        // Head of column is brightest
        final isHead = row == 0;
        final fadePosition = (baseY / size.height).clamp(0.0, 1.0);
        final positionFade = fadePosition < 0.1
            ? fadePosition / 0.1
            : fadePosition > 0.85
                ? (1.0 - fadePosition) / 0.15
                : 1.0;

        double alpha = positionFade * (isHead ? 0.5 : 0.12 + colRng.nextDouble() * 0.12);
        alpha += mouseInfluence * 0.4;
        alpha = alpha.clamp(0.0, 0.65);

        if (alpha < 0.01) continue;

        // Color: head is white-blue, body is blue
        final Color charColor;
        if (isHead) {
          charColor = const Color(0xFFE0F0FF).withValues(alpha: alpha);
        } else if (mouseInfluence > 0.2) {
          charColor = Color.lerp(
            const Color(0xFF1080E0),
            const Color(0xFF40A0FF),
            mouseInfluence,
          )!.withValues(alpha: alpha);
        } else {
          charColor = const Color(0xFF1080E0).withValues(alpha: alpha);
        }

        final textPainter = TextPainter(
          text: TextSpan(
            text: token,
            style: TextStyle(
              fontSize: isHead ? 13 : 11,
              fontFamily: 'monospace',
              fontWeight: isHead ? FontWeight.w700 : FontWeight.w400,
              color: charColor,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(canvas, Offset(x, baseY));

        // Head glow effect
        if (isHead || mouseInfluence > 0.3) {
          final glowPaint = Paint()
            ..color = const Color(0xFF1080E0).withValues(alpha: alpha * 0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
          canvas.drawCircle(
            Offset(x + textPainter.width / 2, baseY + textPainter.height / 2),
            8,
            glowPaint,
          );
        }
      }
    }

    // 5. Subtle horizontal scan lines (CRT / retro feel)
    final scanPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final scanY = (time * 40) % (size.height + 400) - 200;
    scanPaint.color = const Color(0xFF1080E0).withValues(alpha: 0.06);
    canvas.drawLine(
      Offset(0, scanY),
      Offset(size.width, scanY),
      scanPaint,
    );
    // Second scan line offset
    canvas.drawLine(
      Offset(0, (scanY + size.height * 0.4) % size.height),
      Offset(size.width, (scanY + size.height * 0.4) % size.height),
      scanPaint,
    );

    // 6. Bottom gradient fade
    final fadePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Color(0xFF090D16),
        ],
        stops: [0.65, 1.0],
      ).createShader(Rect.fromLTWH(0, size.height * 0.55, size.width, size.height * 0.45));
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.55, size.width, size.height * 0.45),
      fadePaint,
    );

    // 7. Top subtle gradient fade (for navbar blending)
    final topFade = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF090D16),
          Colors.transparent,
        ],
        stops: [0.0, 0.12],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.15));
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.15),
      topFade,
    );
  }

  @override
  bool shouldRepaint(covariant _CodeRainPainter old) =>
      old.time != time || old.pointerX != pointerX || old.pointerY != pointerY;
}
