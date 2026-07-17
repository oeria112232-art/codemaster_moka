import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../components.dart';

class InfinitePortalPage extends StatefulWidget {
  final VoidCallback onBack;
  const InfinitePortalPage({super.key, required this.onBack});

  @override
  State<InfinitePortalPage> createState() => _InfinitePortalPageState();
}

class _InfinitePortalPageState extends State<InfinitePortalPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _timeCtrl;
  final ScrollController _scrollCtrl = ScrollController();
  double _scrollDepth = 0.0;

  @override
  void initState() {
    super.initState();
    _timeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120),
    )..repeat();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _scrollDepth = (_scrollCtrl.offset / 300).clamp(0.0, 50.0);
    });
  }

  @override
  void dispose() {
    _timeCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = LanguageManager.instance.isArabic;

    return Scaffold(
      backgroundColor: const Color(0xFF010409),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _timeCtrl,
              builder: (context, _) {
                return CustomPaint(
                  painter: _CosmicZoomPainter(
                    time: _timeCtrl.value * 120,
                    depth: _scrollDepth,
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: EdgeInsets.zero,
              itemCount: 300,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 400,
                  child: AnimatedBuilder(
                    animation: _timeCtrl,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _SectionParticles(
                          time: _timeCtrl.value * 120,
                          index: index,
                          depth: _scrollDepth,
                        ),
                        size: Size.infinite,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 24,
            left: 24,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141A29).withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF3FD2FF).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back, color: Color(0xFF3FD2FF), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        tr('خروج', 'Exit'),
                        style: const TextStyle(
                          color: Color(0xFF3FD2FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 24,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 3,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0xFF141A29).withValues(alpha: 0.5),
                ),
                child: Align(
                  alignment: Alignment(0, (_scrollDepth / 50.0 * 2 - 1).clamp(-1.0, 1.0)),
                  child: Container(
                    width: 3,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: const Color(0xFF3FD2FF).withValues(alpha: 0.8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3FD2FF).withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 24,
            top: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF141A29).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF3FD2FF).withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getScaleLabel(_scrollDepth.floor(), isAr),
                    style: const TextStyle(
                      color: Color(0xFF3FD2FF),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getZoneLabel(_scrollDepth.floor(), isAr),
                    style: const TextStyle(
                      color: Color(0xFFA6ABB6),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getScaleLabel(int d, bool isAr) {
    if (d < 5) return isAr ? 'كوكب واحد' : 'One Planet';
    if (d < 12) return isAr ? 'كواكب' : 'Planets';
    if (d < 22) return isAr ? 'نظام شمسي' : 'Solar System';
    if (d < 35) return isAr ? 'مجرة' : 'Galaxy';
    return isAr ? 'مجرات' : 'Galaxies';
  }

  String _getZoneLabel(int d, bool isAr) {
    if (d < 5) return isAr ? 'البوابة' : 'Gate';
    if (d < 12) return isAr ? 'الكوكب' : 'Planet';
    if (d < 22) return isAr ? 'المجموعة' : 'System';
    if (d < 35) return isAr ? 'المجرة' : 'Galaxy';
    return isAr ? 'اللانهاية' : 'Infinite';
  }
}

class _CosmicZoomPainter extends CustomPainter {
  final double time;
  final double depth;

  _CosmicZoomPainter({required this.time, required this.depth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final t = time;
    final d = depth;

    _drawBackground(canvas, size, d, t);
    _drawStars(canvas, size, d, t);

    if (d < 5) {
      _drawSinglePlanet(canvas, size, center, d, t);
    } else if (d < 12) {
      _drawPlanets(canvas, size, center, d, t);
    } else if (d < 22) {
      _drawSolarSystem(canvas, size, center, d, t);
    } else if (d < 35) {
      _drawGalaxy(canvas, size, center, d, t);
    } else {
      _drawGalaxies(canvas, size, center, d, t);
    }
  }

  void _drawBackground(Canvas canvas, Size size, double d, double t) {
    final bg = _getBgColor(d);
    canvas.drawRect(Offset.zero & size, Paint()..color = bg);

    final glowCx = math.sin(d * 0.3) * 0.3;
    final glowCy = math.cos(d * 0.2) * 0.3;
    final glow = Paint()
      ..shader = RadialGradient(
        center: Alignment(glowCx, glowCy),
        radius: 1.5,
        colors: [
          _getAccentColor(d).withValues(alpha: 0.08 + math.sin(t * 0.3) * 0.03),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, glow);
  }

  void _drawStars(Canvas canvas, Size size, double d, double t) {
    final rng = math.Random(d.floor() * 7);
    final paint = Paint()..style = PaintingStyle.fill;
    final count = (100 + d * 5).toInt().clamp(100, 400);

    for (int i = 0; i < count; i++) {
      final bx = rng.nextDouble() * size.width;
      final by = rng.nextDouble() * size.height;
      final x = bx + math.sin(t * 0.2 + i * 0.3) * (3 + rng.nextDouble() * 5);
      final y = by + math.cos(t * 0.15 + i * 0.5) * (2 + rng.nextDouble() * 3);
      final r = 0.3 + rng.nextDouble() * (1.5 - d * 0.01).clamp(0.3, 1.5);
      final twinkle = (0.15 + math.sin(t * (1 + rng.nextDouble() * 3) + i) * 0.15).clamp(0.05, 0.4);

      paint.color = Colors.white.withValues(alpha: twinkle);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  void _drawSinglePlanet(Canvas canvas, Size size, Offset center, double d, double t) {
    final shrink = (1.0 - d / 5.0).clamp(0.2, 1.0);
    final planetR = math.min(size.width, size.height) * 0.18 * shrink;

    _drawPlanet(canvas, center, planetR, t,
      bodyColor: const Color(0xFF3FD2FF),
      wireColor: const Color(0xFF8FF2FF),
      glowColor: const Color(0xFF3FD2FF),
    );
  }

  void _drawPlanets(Canvas canvas, Size size, Offset center, double d, double t) {
    final spread = ((d - 5) / 7.0).clamp(0.0, 1.0);
    final planetConfigs = [
      _PCfg(offset: const Offset(-0.3, -0.15), radius: 0.12, body: const Color(0xFF3FD2FF), wire: const Color(0xFF8FF2FF), speed: 0.3),
      _PCfg(offset: const Offset(0.25, -0.2), radius: 0.08, body: const Color(0xFF22C55E), wire: const Color(0xFF56D364), speed: -0.5),
      _PCfg(offset: const Offset(-0.1, 0.2), radius: 0.06, body: const Color(0xFF3FB950), wire: const Color(0xFF56D364), speed: 0.7),
      _PCfg(offset: const Offset(0.3, 0.15), radius: 0.09, body: const Color(0xFFF78166), wire: const Color(0xFFFFA657), speed: -0.4),
      _PCfg(offset: const Offset(-0.25, 0.25), radius: 0.05, body: const Color(0xFFFF6B6B), wire: const Color(0xFFFF8A8A), speed: 0.9),
    ];

    for (final pc in planetConfigs) {
      final px = center.dx + pc.offset.dx * size.width * (0.5 + spread * 1.5);
      final py = center.dy + pc.offset.dy * size.height * (0.5 + spread * 1.5);
      final r = size.width * pc.radius * (0.4 + spread * 0.6);
      _drawPlanet(canvas, Offset(px, py), r, t + pc.speed * 10,
        bodyColor: pc.body, wireColor: pc.wire, glowColor: pc.body,
      );
    }
  }

  void _drawSolarSystem(Canvas canvas, Size size, Offset center, double d, double t) {
    final spread = ((d - 12) / 10.0).clamp(0.0, 1.0);

    // Sun
    final sunR = 15.0 + spread * 10;
    canvas.drawCircle(center, sunR * 2, Paint()
      ..shader = RadialGradient(colors: [
        const Color(0xFFFFD700).withValues(alpha: 0.2),
        Colors.transparent,
      ]).createShader(Rect.fromCircle(center: center, radius: sunR * 2)));
    canvas.drawCircle(center, sunR, Paint()
      ..shader = RadialGradient(colors: [
        const Color(0xFFFFD700).withValues(alpha: 0.6),
        const Color(0xFFFF8C00).withValues(alpha: 0.3),
      ]).createShader(Rect.fromCircle(center: center, radius: sunR)));

    // Orbit rings + planets
    final orbits = [
      _OrbitCfg(radius: 0.08, speed: 1.5, planetR: 3.0, color: const Color(0xFFA6ABB6)),
      _OrbitCfg(radius: 0.13, speed: 1.0, planetR: 5.0, color: const Color(0xFFFFB020)),
      _OrbitCfg(radius: 0.19, speed: 0.7, planetR: 6.0, color: const Color(0xFF3FD2FF)),
      _OrbitCfg(radius: 0.26, speed: 0.45, planetR: 10.0, color: const Color(0xFFF78166)),
      _OrbitCfg(radius: 0.34, speed: 0.25, planetR: 8.0, color: const Color(0xFF22C55E)),
      _OrbitCfg(radius: 0.42, speed: 0.15, planetR: 4.0, color: const Color(0xFF3FB950)),
    ];

    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (final o in orbits) {
      final r = size.width * o.radius * (0.5 + spread * 0.5);
      orbitPaint.color = const Color(0xFF3FD2FF).withValues(alpha: 0.06);
      canvas.drawOval(
        Rect.fromCenter(center: center, width: r * 2, height: r * 0.7),
        orbitPaint,
      );

      final angle = t * o.speed;
      final px = center.dx + r * math.cos(angle);
      final py = center.dy + r * 0.35 * math.sin(angle);

      canvas.drawCircle(Offset(px, py), o.planetR, Paint()
        ..shader = RadialGradient(colors: [
          o.color.withValues(alpha: 0.6),
          o.color.withValues(alpha: 0.2),
        ]).createShader(Rect.fromCircle(center: Offset(px, py), radius: o.planetR)));
      canvas.drawCircle(Offset(px, py), o.planetR, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5
        ..color = o.color.withValues(alpha: 0.3));
    }
  }

  void _drawGalaxy(Canvas canvas, Size size, Offset center, double d, double t) {
    final spread = ((d - 22) / 13.0).clamp(0.0, 1.0);
    final arms = 4;
    final rng = math.Random(42);
    final paint = Paint()..style = PaintingStyle.fill;

    // Galaxy core glow
    canvas.drawCircle(center, 30 + spread * 20, Paint()
      ..shader = RadialGradient(colors: [
        const Color(0xFF22C55E).withValues(alpha: 0.15),
        const Color(0xFF3FD2FF).withValues(alpha: 0.05),
        Colors.transparent,
      ]).createShader(Rect.fromCircle(center: center, radius: 50)));

    // Spiral arms with stars
    for (int arm = 0; arm < arms; arm++) {
      final armOffset = (arm / arms) * math.pi * 2;
      for (int i = 0; i < 200; i++) {
        final dist = (i / 200.0) * (150 + spread * 150);
        final angle = armOffset + dist * 0.008 + t * 0.02;
        final wobble = math.sin(dist * 0.02 + t * 0.5) * 8;
        final x = center.dx + math.cos(angle) * dist + wobble;
        final y = center.dy + math.sin(angle) * dist * 0.3 + wobble * 0.3;

        final sizeFactor = (1.0 - dist / (300 + spread * 150)).clamp(0.1, 1.0);
        final r = (0.5 + rng.nextDouble() * 1.5) * sizeFactor;
        final alpha = (0.1 + rng.nextDouble() * 0.3) * sizeFactor;

        final colors = [const Color(0xFF3FD2FF), const Color(0xFF22C55E), const Color(0xFF8FF2FF), Colors.white];
        paint.color = colors[rng.nextInt(colors.length)].withValues(alpha: alpha);
        canvas.drawCircle(Offset(x, y), r, paint);
      }
    }
  }

  void _drawGalaxies(Canvas canvas, Size size, Offset center, double d, double t) {
    final rng = math.Random(d.floor() * 31);
    final paint = Paint()..style = PaintingStyle.fill;
    final count = 15 + ((d - 35) * 2).toInt().clamp(0, 30);

    for (int i = 0; i < count; i++) {
      final gx = rng.nextDouble() * size.width;
      final gy = rng.nextDouble() * size.height;
      final drift = math.sin(t * 0.1 + i * 0.7) * 5;
      final x = gx + drift;
      final y = gy + math.cos(t * 0.08 + i * 0.5) * 3;
      final r = 8 + rng.nextDouble() * 25;
      final rot = t * 0.03 + i * 0.5;

      final colors = [
        const Color(0xFF3FD2FF),
        const Color(0xFF22C55E),
        const Color(0xFF3FB950),
        const Color(0xFFF78166),
      ];
      final color = colors[rng.nextInt(colors.length)];

      // Galaxy glow
      canvas.drawCircle(Offset(x, y), r * 1.5, Paint()
        ..shader = RadialGradient(colors: [
          color.withValues(alpha: 0.06),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(center: Offset(x, y), radius: r * 1.5)));

      // Mini spiral
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot);
      for (int arm = 0; arm < 3; arm++) {
        final armAngle = (arm / 3) * math.pi * 2;
        final path = Path();
        for (int j = 0; j < 30; j++) {
          final dist = (j / 30.0) * r;
          final angle = armAngle + dist * 0.08;
          final px = math.cos(angle) * dist;
          final py = math.sin(angle) * dist * 0.3;
          if (j == 0) path.moveTo(px, py);
          else path.lineTo(px, py);
        }
        canvas.drawPath(path, Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..color = color.withValues(alpha: 0.2 + rng.nextDouble() * 0.2));
      }
      canvas.drawCircle(Offset.zero, r * 0.1, paint..color = color.withValues(alpha: 0.3));
      canvas.restore();
    }
  }

  void _drawPlanet(Canvas canvas, Offset center, double r, double t,
      {required Color bodyColor, required Color wireColor, required Color glowColor}) {

    // Atmosphere
    canvas.drawCircle(center, r * 1.5, Paint()
      ..shader = RadialGradient(colors: [
        glowColor.withValues(alpha: 0.12),
        glowColor.withValues(alpha: 0.04),
        Colors.transparent,
      ], stops: const [0.0, 0.5, 1.0]).createShader(Rect.fromCircle(center: center, radius: r * 1.5)));

    // Body
    canvas.drawCircle(center, r, Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [
          bodyColor.withValues(alpha: 0.35),
          bodyColor.withValues(alpha: 0.12),
          const Color(0xFF010409).withValues(alpha: 0.5),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: r)));

    // Wireframe lines
    final wirePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (int i = 1; i < 5; i++) {
      final ratio = i / 5.0;
      final latR = r * math.sin(ratio * math.pi);
      final latY = r * math.cos(ratio * math.pi);
      wirePaint.color = wireColor.withValues(alpha: (0.2 - i * 0.03).clamp(0.05, 0.2));
      canvas.drawOval(
        Rect.fromCenter(center: Offset(center.dx, center.dy - latY * 0.3), width: latR * 2, height: latR * 0.4),
        wirePaint,
      );
    }

    for (int i = 0; i < 3; i++) {
      final angle = (i / 3.0) * math.pi + t * 0.1;
      wirePaint.color = wireColor.withValues(alpha: 0.12 + math.sin(t * 0.3 + i) * 0.05);
      canvas.drawOval(
        Rect.fromCenter(center: center, width: r * 2 * math.cos(angle).abs() + 2, height: r * 2),
        wirePaint,
      );
    }
  }

  Color _getBgColor(double d) {
    if (d < 5) return const Color(0xFF0a0a2e);
    if (d < 12) return const Color(0xFF0d0822);
    if (d < 22) return const Color(0xFF0b0514);
    if (d < 35) return const Color(0xFF05100a);
    return const Color(0xFF010409);
  }

  Color _getAccentColor(double d) {
    if (d < 5) return const Color(0xFF3FD2FF);
    if (d < 12) return const Color(0xFF22C55E);
    if (d < 22) return const Color(0xFFFFB020);
    if (d < 35) return const Color(0xFF3FB950);
    return const Color(0xFFD2A8FF);
  }

  @override
  bool shouldRepaint(covariant _CosmicZoomPainter old) =>
      old.time != time || old.depth != depth;
}

class _PCfg {
  final Offset offset;
  final double radius;
  final Color body;
  final Color wire;
  final double speed;
  const _PCfg({required this.offset, required this.radius, required this.body, required this.wire, required this.speed});
}

class _OrbitCfg {
  final double radius;
  final double speed;
  final double planetR;
  final Color color;
  const _OrbitCfg({required this.radius, required this.speed, required this.planetR, required this.color});
}

class _SectionParticles extends CustomPainter {
  final double time;
  final int index;
  final double depth;

  _SectionParticles({required this.time, required this.index, required this.depth});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(index * 7919 + depth.floor() * 13);
    final t = time;
    final paint = Paint()..style = PaintingStyle.fill;
    final colors = _getColors();

    for (int i = 0; i < 10; i++) {
      final x = size.width * (0.1 + rng.nextDouble() * 0.8) + math.sin(t * 0.3 + i * 1.5) * 15;
      final y = size.height * (0.1 + rng.nextDouble() * 0.8) + math.cos(t * 0.25 + i * 1.2) * 10;
      final r = 1 + rng.nextDouble() * 4;
      final alpha = (0.03 + math.sin(t * 0.4 + i + index * 0.3) * 0.02).clamp(0.01, 0.06);
      paint.color = colors[i % colors.length].withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  List<Color> _getColors() {
    if (depth < 5) return [const Color(0xFF3FD2FF), const Color(0xFF22C55E)];
    if (depth < 12) return [const Color(0xFF22C55E), const Color(0xFF58A6FF)];
    if (depth < 22) return [const Color(0xFFFFB020), const Color(0xFFF78166)];
    if (depth < 35) return [const Color(0xFF3FB950), const Color(0xFF3FD2FF)];
    return [const Color(0xFFD2A8FF), const Color(0xFFFF6B6B)];
  }

  @override
  bool shouldRepaint(covariant _SectionParticles old) =>
      old.time != time || old.index != index || old.depth != depth;
}
