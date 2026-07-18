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
    if (mounted) {
      setState(() {
        _scrollDepth = (_scrollCtrl.offset / 150).clamp(0.0, 60.0);
      });
    }
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
      backgroundColor: const Color(0xFF040814),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _timeCtrl,
              builder: (context, _) {
                return CustomPaint(
                  painter: _CosmicContinuousZoomPainter(
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
              itemCount: 500,
              itemBuilder: (context, index) {
                return const SizedBox(height: 100);
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
                    color: const Color(0xFF081018).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF1080E0).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back, color: Color(0xFF1080E0), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        tr('خروج', 'Exit'),
                        style: const TextStyle(
                          color: Color(0xFF1080E0),
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
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0xFF081018).withValues(alpha: 0.5),
                ),
                child: Align(
                  alignment: Alignment(0, (_scrollDepth / 60.0 * 2 - 1).clamp(-1.0, 1.0)),
                  child: Container(
                    width: 3,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: const Color(0xFF1080E0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1080E0).withValues(alpha: 0.5),
                          blurRadius: 10,
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF081018).withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF1080E0).withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getScaleLabel(_scrollDepth, isAr),
                    style: const TextStyle(
                      color: Color(0xFF1080E0),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getZoneLabel(_scrollDepth, isAr),
                    style: const TextStyle(
                      color: Color(0xFFA6ABB6),
                      fontSize: 11,
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

  String _getScaleLabel(double d, bool isAr) {
    if (d < 10) return isAr ? 'موطننا (كوكب كود ماستر)' : 'Our Home (Code Master Planet)';
    if (d < 22) return isAr ? 'المجموعة الشمسية' : 'The Solar System';
    if (d < 35) return isAr ? 'العناقيد النجمية والأنظمة' : 'Stellar Clusters & Systems';
    if (d < 48) return isAr ? 'مجرتنا (درب التبانة)' : 'Our Galaxy (Milky Way)';
    return isAr ? 'الكون اللانهائي' : 'The Infinite Universe';
  }

  String _getZoneLabel(double d, bool isAr) {
    if (d < 10) return isAr ? 'البعد: الكوكب الأم' : 'Scale: Mother Planet';
    if (d < 22) return isAr ? 'البعد: مجموعة الكواكب الثمانية' : 'Scale: Complete Solar System';
    if (d < 35) return isAr ? 'البعد: تجمعات الشموس' : 'Scale: Thousands of Solar Systems';
    if (d < 48) return isAr ? 'البعد: بنية المجرة الحلزونية' : 'Scale: Spiral Galaxy Structure';
    return isAr ? 'البعد: مليارات المجرات المتباعدة' : 'Scale: Receding Galaxies Field';
  }
}

class _CosmicContinuousZoomPainter extends CustomPainter {
  final double time;
  final double depth;

  _CosmicContinuousZoomPainter({required this.time, required this.depth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height);

    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF081426),
          const Color(0xFF040814),
        ],
        radius: 1.5,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final double zoom = math.pow(0.91, depth).toDouble();

    _drawNebulaClouds(canvas, size, center, zoom);
    _drawInfiniteStars(canvas, size, center, zoom);

    final double stage1Opacity = (1.0 - (depth / 12.0)).clamp(0.0, 1.0);
    if (stage1Opacity > 0.0) {
      final double planetR = maxRadius * 0.22 * zoom;
      _drawMotherPlanet(canvas, center, planetR, time, stage1Opacity);
    }

    final double stage2Opacity = _getStageOpacity(depth, 8.0, 14.0, 24.0);
    if (stage2Opacity > 0.0) {
      final double systemScale = zoom * 3.5;
      _drawCompleteSolarSystem(canvas, center, systemScale, time, stage2Opacity);
    }

    final double stage3Opacity = _getStageOpacity(depth, 20.0, 26.0, 38.0);
    if (stage3Opacity > 0.0) {
      final double clusterScale = zoom * 25.0;
      _drawStellarCluster(canvas, center, clusterScale, time, stage3Opacity);
    }

    final double stage4Opacity = _getStageOpacity(depth, 32.0, 38.0, 50.0);
    if (stage4Opacity > 0.0) {
      final double galaxyScale = zoom * 180.0;
      _drawSpiralGalaxy(canvas, center, galaxyScale, time, stage4Opacity);
    }

    final double stage5Opacity = (depth - 44.0).clamp(0.0, 16.0) / 16.0;
    if (stage5Opacity > 0.0) {
      final double fieldScale = zoom * 1200.0;
      _drawGalaxyField(canvas, size, center, fieldScale, time, stage5Opacity);
    }

    _drawShootingStars(canvas, size, time);

    if (depth < 6.0) {
      final double hintOpacity = (1.0 - depth / 6.0).clamp(0.0, 1.0);
      _drawScrollHint(canvas, center, maxRadius * 0.25, hintOpacity);
    }
  }

  double _getStageOpacity(double d, double startFadeIn, double fullyIn, double endFadeOut) {
    if (d < startFadeIn) return 0.0;
    if (d < fullyIn) return (d - startFadeIn) / (fullyIn - startFadeIn);
    if (d < endFadeOut) return 1.0 - (d - fullyIn) / (endFadeOut - fullyIn);
    return 0.0;
  }

  void _drawNebulaClouds(Canvas canvas, Size size, Offset center, double zoom) {
    final rng = math.Random(42);
    final paint = Paint();
    for (int i = 0; i < 8; i++) {
      final double nx = rng.nextDouble() * size.width;
      final double ny = rng.nextDouble() * size.height;
      final double nr = (80 + rng.nextDouble() * 200) * zoom;
      if (nr < 2) continue;
      final colors = [
        [const Color(0xFF1080E0), const Color(0xFF081426)],
        [const Color(0xFF2090FF), const Color(0xFF081426)],
        [const Color(0xFF0060B0), const Color(0xFF040814)],
      ];
      final c = colors[i % colors.length];
      paint.shader = RadialGradient(
        colors: [
          c[0].withValues(alpha: 0.06),
          c[1].withValues(alpha: 0.01),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(nx, ny), radius: nr));
      canvas.drawCircle(Offset(nx, ny), nr, paint);
    }
  }

  void _drawInfiniteStars(Canvas canvas, Size size, Offset center, double zoom) {
    final rng = math.Random(1337);
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 250; i++) {
      final bx = rng.nextDouble() * size.width;
      final by = rng.nextDouble() * size.height;
      final dx = (bx - size.width / 2) * (0.95 + zoom * 0.05) + size.width / 2;
      final dy = (by - size.height / 2) * (0.95 + zoom * 0.05) + size.height / 2;
      final r = 0.3 + rng.nextDouble() * 1.2;
      final twinkle = (0.15 + math.sin(time * (0.3 + rng.nextDouble() * 0.8) + i * 1.7) * 0.2).clamp(0.05, 0.55);
      final colors = [Colors.white, const Color(0xFFB0C4DE), const Color(0xFF87CEEB), const Color(0xFFFFE4B5)];
      paint.color = colors[rng.nextInt(colors.length)].withValues(alpha: twinkle);
      canvas.drawCircle(Offset(dx, dy), r, paint);
    }
  }

  void _drawShootingStars(Canvas canvas, Size size, double t) {
    final rng = math.Random(7777);
    final paint = Paint()..strokeCap = StrokeCap.round;
    for (int i = 0; i < 4; i++) {
      final double cycle = (t * 0.15 + i * 31.7) % 30.0;
      if (cycle > 2.0) continue;
      final double progress = cycle / 2.0;
      final double sx = rng.nextDouble() * size.width * 0.8;
      final double sy = rng.nextDouble() * size.height * 0.5;
      final double angle = -0.4 - rng.nextDouble() * 0.3;
      final double len = 60 + rng.nextDouble() * 100;
      final double ex = sx + math.cos(angle) * len * progress;
      final double ey = sy + math.sin(angle) * len * progress;
      final double alpha = (1.0 - progress) * 0.7;
      final rect = Rect.fromPoints(Offset(sx, sy), Offset(ex, ey));
      paint
        ..shader = LinearGradient(
          colors: [
            Colors.white.withValues(alpha: alpha),
            const Color(0xFF1080E0).withValues(alpha: alpha * 0.4),
            Colors.transparent,
          ],
        ).createShader(rect)
        ..strokeWidth = 1.5;
      canvas.drawLine(Offset(sx, sy), Offset(ex, ey), paint);
    }
  }

  void _drawMotherPlanet(Canvas canvas, Offset center, double r, double t, double opacity) {
    if (r < 1.0) return;

    final glowPaint1 = Paint()
      ..shader = RadialGradient(colors: [
        const Color(0xFF1080E0).withValues(alpha: opacity * 0.3),
        const Color(0xFF2090FF).withValues(alpha: opacity * 0.1),
        Colors.transparent,
      ], stops: const [0.0, 0.55, 1.0]).createShader(Rect.fromCircle(center: center, radius: r * 1.8));
    canvas.drawCircle(center, r * 1.8, glowPaint1);

    final bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.35),
        colors: [
          const Color(0xFF2090FF).withValues(alpha: opacity * 0.85),
          const Color(0xFF1080E0).withValues(alpha: opacity * 0.5),
          const Color(0xFF0060B0).withValues(alpha: opacity * 0.7),
          const Color(0xFF040814).withValues(alpha: opacity * 0.95),
        ],
        stops: const [0.0, 0.3, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawCircle(center, r, bodyPaint);

    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = (r > 50) ? 1.0 : 0.5
      ..color = const Color(0xFF40A0FF).withValues(alpha: opacity * 0.25);

    for (int i = 1; i < 8; i++) {
      final latRatio = i / 8.0;
      final latR = r * math.sin(latRatio * math.pi);
      final latY = r * math.cos(latRatio * math.pi);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(center.dx, center.dy + latY * 0.2), width: latR * 2, height: latR * 0.35),
        gridPaint,
      );
    }

    for (int i = 0; i < 4; i++) {
      final angle = (i / 4.0) * math.pi + t * 0.15;
      final widthFactor = math.cos(angle).abs();
      canvas.drawOval(
        Rect.fromCenter(center: center, width: r * 2 * widthFactor, height: r * 2),
        gridPaint..color = const Color(0xFF40A0FF).withValues(alpha: opacity * (0.12 + 0.1 * widthFactor)),
      );
    }

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = (r > 60) ? 3.0 : 1.0
      ..color = const Color(0xFF1080E0).withValues(alpha: opacity * 0.4);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: r * 2.8, height: r * 0.6),
      ringPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: center, width: r * 2.6, height: r * 0.56),
      ringPaint..strokeWidth = 0.5..color = const Color(0xFF40A0FF).withValues(alpha: opacity * 0.2),
    );

    final rng = math.Random(555);
    final starPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 12; i++) {
      final double sa = rng.nextDouble() * 2 * math.pi;
      final double sd = r * 1.9 + rng.nextDouble() * r * 0.8;
      final double sx = center.dx + math.cos(sa) * sd;
      final double sy = center.dy + math.sin(sa) * sd * 0.3;
      final double sr = 0.5 + rng.nextDouble() * 1.0;
      starPaint.color = Colors.white.withValues(alpha: opacity * (0.3 + rng.nextDouble() * 0.4));
      canvas.drawCircle(Offset(sx, sy), sr, starPaint);
    }
  }

  void _drawCompleteSolarSystem(Canvas canvas, Offset center, double scale, double t, double opacity) {
    if (scale < 0.05) return;

    final double sunR = 24.0 * scale;
    if (sunR > 0.5) {
      canvas.drawCircle(center, sunR * 3.0, Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFFFF9000).withValues(alpha: opacity * 0.4),
          const Color(0xFFFFD000).withValues(alpha: opacity * 0.08),
          Colors.transparent,
        ], stops: const [0.0, 0.4, 1.0]).createShader(Rect.fromCircle(center: center, radius: sunR * 3.0)));

      final coronaPaint = Paint();
      for (int i = 0; i < 6; i++) {
        final double ca = (i / 6.0) * 2 * math.pi + t * 0.08;
        final double cl = sunR * (2.0 + 0.8 * math.sin(t * 2.0 + i));
        final double cw = sunR * 0.15;
        coronaPaint
          ..shader = LinearGradient(
            colors: [
              const Color(0xFFFFE000).withValues(alpha: opacity * 0.12),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCenter(
            center: Offset(center.dx + math.cos(ca) * sunR * 1.2, center.dy + math.sin(ca) * sunR * 1.2),
            width: cw,
            height: cl,
          ));
        canvas.save();
        canvas.translate(center.dx + math.cos(ca) * sunR * 1.2, center.dy + math.sin(ca) * sunR * 1.2);
        canvas.rotate(ca);
        canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: cw, height: cl), coronaPaint);
        canvas.restore();
      }

      canvas.drawCircle(center, sunR, Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.2, -0.2),
          colors: [
            const Color(0xFFFFFFFF).withValues(alpha: opacity * 0.95),
            const Color(0xFFFFE000).withValues(alpha: opacity * 0.9),
            const Color(0xFFFF5000).withValues(alpha: opacity * 0.6),
          ],
          stops: const [0.0, 0.4, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: sunR)));
    }

    final planets = [
      _SolarPlanet(orbitR: 45.0, speed: 2.2, r: 2.2, color: const Color(0xFFA6ABB6)),
      _SolarPlanet(orbitR: 65.0, speed: 1.6, r: 4.5, color: const Color(0xFFFFD8A8)),
      _SolarPlanet(orbitR: 90.0, speed: 1.2, r: 5.0, color: const Color(0xFF1080E0), hasMoon: true),
      _SolarPlanet(orbitR: 115.0, speed: 0.9, r: 3.5, color: const Color(0xFFE8590C)),
      _SolarPlanet(orbitR: 155.0, speed: 0.6, r: 12.0, color: const Color(0xFFF1B070), hasBands: true),
      _SolarPlanet(orbitR: 205.0, speed: 0.4, r: 9.5, color: const Color(0xFFFCC419), hasRings: true),
      _SolarPlanet(orbitR: 245.0, speed: 0.3, r: 7.0, color: const Color(0xFF74C0FC)),
      _SolarPlanet(orbitR: 280.0, speed: 0.2, r: 6.5, color: const Color(0xFF3b5bdb)),
    ];

    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = const Color(0xFF1080E0).withValues(alpha: opacity * 0.1);

    for (final p in planets) {
      final double r = p.orbitR * scale;
      if (r < 1.0) continue;

      canvas.drawOval(
        Rect.fromCenter(center: center, width: r * 2, height: r * 0.5),
        orbitPaint,
      );

      final angle = t * p.speed * 0.4;
      final px = center.dx + r * math.cos(angle);
      final py = center.dy + r * 0.25 * math.sin(angle);
      final pr = p.r * scale;

      if (pr > 0.2) {
        canvas.drawCircle(Offset(px, py), pr, Paint()
          ..shader = RadialGradient(
            colors: [
              p.color.withValues(alpha: opacity * 0.95),
              p.color.withValues(alpha: opacity * 0.5),
              const Color(0xFF040814).withValues(alpha: opacity * 0.9),
            ],
            stops: const [0.0, 0.5, 1.0],
            center: const Alignment(-0.3, -0.3),
          ).createShader(Rect.fromCircle(center: Offset(px, py), radius: pr)));

        if (p.hasRings) {
          for (int ring = 0; ring < 3; ring++) {
            final rw = pr * (2.2 + ring * 0.3);
            canvas.drawOval(
              Rect.fromCenter(center: Offset(px, py), width: rw, height: pr * (0.55 + ring * 0.05)),
              Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = (1.2 - ring * 0.3) * scale
                ..color = p.color.withValues(alpha: opacity * (0.5 - ring * 0.12)),
            );
          }
        }

        if (p.hasBands) {
          final bandPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 0.4 * scale;
          for (int b = 0; b < 4; b++) {
            final by = py - pr * 0.5 + b * pr * 0.33;
            bandPaint.color = const Color(0xFFE8590C).withValues(alpha: opacity * 0.3);
            canvas.drawArc(
              Rect.fromCenter(center: Offset(px, by), width: pr * 2, height: pr * 0.3),
              0, math.pi, false, bandPaint,
            );
          }
        }

        if (p.hasMoon) {
          final moonAngle = t * 4.0;
          final moonDist = pr * 3.0;
          final mx = px + math.cos(moonAngle) * moonDist;
          final my = py + math.sin(moonAngle) * moonDist * 0.3;
          final moonR = pr * 0.25;
          canvas.drawCircle(Offset(mx, my), moonR, Paint()
            ..shader = RadialGradient(
              colors: [const Color(0xFFB0B0B0).withValues(alpha: opacity * 0.8), const Color(0xFF404040).withValues(alpha: opacity * 0.6)],
              center: const Alignment(-0.3, -0.3),
            ).createShader(Rect.fromCircle(center: Offset(mx, my), radius: moonR)));
        }
      }
    }
  }

  void _drawStellarCluster(Canvas canvas, Offset center, double scale, double t, double opacity) {
    if (scale < 0.02) return;
    final rng = math.Random(101);
    final paint = Paint()..style = PaintingStyle.fill;

    final gasPaint = Paint();
    for (int i = 0; i < 6; i++) {
      final double ga = rng.nextDouble() * 2 * math.pi;
      final double gd = (50 + rng.nextDouble() * 180) * scale;
      if (gd < 1) continue;
      final double gx = center.dx + math.cos(ga) * gd;
      final double gy = center.dy + math.sin(ga) * gd * 0.6;
      final double gr = (15 + rng.nextDouble() * 35) * scale;
      if (gr < 0.5) continue;
      final gasColors = [
        [const Color(0xFF1080E0), const Color(0xFF081426)],
        [const Color(0xFF0060B0), const Color(0xFF040814)],
        [const Color(0xFF2090FF), const Color(0xFF081426)],
      ];
      final gc = gasColors[i % gasColors.length];
      gasPaint.shader = RadialGradient(
        colors: [
          gc[0].withValues(alpha: opacity * 0.08),
          gc[1].withValues(alpha: opacity * 0.01),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(gx, gy), radius: gr));
      canvas.drawCircle(Offset(gx, gy), gr, gasPaint);
    }

    for (int i = 0; i < 500; i++) {
      final double sa = rng.nextDouble() * 2 * math.pi;
      final double sd = (10 + rng.nextDouble() * 250.0) * scale;
      if (sd < 0.5) continue;

      final double scatter = (rng.nextDouble() - 0.5) * 20 * scale;
      final double px = center.dx + sd * math.cos(sa) + scatter;
      final double py = center.dy + sd * math.sin(sa) * 0.55 + scatter * 0.3;
      final double pr = (0.4 + rng.nextDouble() * 3.0) * scale;

      if (pr > 0.08) {
        final temp = rng.nextDouble();
        Color starColor;
        if (temp < 0.15) {
          starColor = const Color(0xFF9BB0FF);
        } else if (temp < 0.35) {
          starColor = const Color(0xFFAACCFF);
        } else if (temp < 0.6) {
          starColor = Colors.white;
        } else if (temp < 0.8) {
          starColor = const Color(0xFFFFF4E0);
        } else {
          starColor = const Color(0xFFFFCC6F);
        }

        final twinkle = (0.4 + math.sin(t * (1.0 + rng.nextDouble() * 2.0) + i * 0.7) * 0.3).clamp(0.1, 0.9);
        paint.color = starColor.withValues(alpha: opacity * twinkle);

        if (pr > 0.5 * scale) {
          canvas.drawCircle(Offset(px, py), pr * 2.5, Paint()
            ..shader = RadialGradient(colors: [
              starColor.withValues(alpha: opacity * 0.15),
              Colors.transparent,
            ]).createShader(Rect.fromCircle(center: Offset(px, py), radius: pr * 2.5)));
        }

        canvas.drawCircle(Offset(px, py), pr, paint);

        if (rng.nextDouble() < 0.04 && sd < 120 * scale) {
          final br = pr * 0.6;
          final ba = sa + 0.3;
          final bx = px + math.cos(ba) * br * 3;
          final by = py + math.sin(ba) * br * 3 * 0.55;
          paint.color = starColor.withValues(alpha: opacity * twinkle * 0.7);
          canvas.drawCircle(Offset(bx, by), br, paint);
        }
      }
    }
  }

  void _drawSpiralGalaxy(Canvas canvas, Offset center, double scale, double t, double opacity) {
    if (scale < 0.02) return;

    final double galaxyRotation = t * 0.012;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(galaxyRotation);

    final tiltScaleY = 0.42;
    canvas.scale(1.0, tiltScaleY);

    final double bulgeR = 50 * scale;
    if (bulgeR > 0.3) {
      canvas.drawCircle(Offset.zero, bulgeR * 4.0, Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFFFFE8C0).withValues(alpha: opacity * 0.08),
          const Color(0xFF1080E0).withValues(alpha: opacity * 0.03),
          Colors.transparent,
        ], stops: const [0.0, 0.4, 1.0]).createShader(Rect.fromCircle(center: Offset.zero, radius: bulgeR * 4.0)));

      canvas.drawCircle(Offset.zero, bulgeR * 2.0, Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFFFFFFFF).withValues(alpha: opacity * 0.3),
          const Color(0xFFFFE8C0).withValues(alpha: opacity * 0.15),
          Colors.transparent,
        ], stops: const [0.0, 0.3, 1.0]).createShader(Rect.fromCircle(center: Offset.zero, radius: bulgeR * 2.0)));

      canvas.drawCircle(Offset.zero, bulgeR * 0.6, Paint()
        ..shader = RadialGradient(colors: [
          Colors.white.withValues(alpha: opacity * 0.95),
          const Color(0xFFFFE8C0).withValues(alpha: opacity * 0.8),
          const Color(0xFF1080E0).withValues(alpha: opacity * 0.4),
        ], stops: const [0.0, 0.4, 1.0]).createShader(Rect.fromCircle(center: Offset.zero, radius: bulgeR * 0.6)));
    }

    final armCount = 4;
    final rng = math.Random(888);
    final paint = Paint()..style = PaintingStyle.fill;

    final dustPaint = Paint()..style = PaintingStyle.fill;

    for (int arm = 0; arm < armCount; arm++) {
      final double armBaseAngle = (arm / armCount) * 2 * math.pi;

      for (int layer = 0; layer < 3; layer++) {
        final double layerWidth = (3.0 + layer * 2.5) * scale;
        final int starCount = 350 - layer * 80;

        for (int i = 0; i < starCount; i++) {
          final double factor = (i + layer * 50.0) / starCount;
          final double dist = (15 + factor * 200) * scale;
          if (dist < 1.0) continue;

          final double spiralAngle = armBaseAngle + factor * 6.5 + layer * 0.08;
          final double scatter = (rng.nextDouble() - 0.5) * layerWidth * (1.0 + factor * 0.5);

          final double px = dist * math.cos(spiralAngle) + scatter * math.cos(spiralAngle + 1.5);
          final double py = dist * math.sin(spiralAngle) + scatter * math.sin(spiralAngle + 1.5);
          final double pr = (0.3 + rng.nextDouble() * (2.5 - layer * 0.5)) * scale;

          if (pr > 0.08) {
            final distFade = (1.0 - factor * 0.6).clamp(0.2, 1.0);
            final layerFade = [1.0, 0.7, 0.4][layer];

            final tempRoll = rng.nextDouble();
            Color starColor;
            if (tempRoll < 0.08) {
              starColor = const Color(0xFF6699FF);
            } else if (tempRoll < 0.2) {
              starColor = const Color(0xFF99CCFF);
            } else if (tempRoll < 0.5) {
              starColor = Colors.white;
            } else if (tempRoll < 0.75) {
              starColor = const Color(0xFFFFF0D0);
            } else if (tempRoll < 0.9) {
              starColor = const Color(0xFFFFD070);
            } else {
              starColor = const Color(0xFFFF8844);
            }

            final twinkle = (0.5 + math.sin(t * 0.5 + i * 0.3 + arm * 2.1) * 0.3).clamp(0.15, 0.85);
            paint.color = starColor.withValues(alpha: opacity * twinkle * distFade * layerFade);

            if (pr > 0.6 * scale && layer == 0) {
              canvas.drawCircle(Offset(px, py), pr * 3.0, Paint()
                ..shader = RadialGradient(colors: [
                  starColor.withValues(alpha: opacity * 0.12 * distFade),
                  Colors.transparent,
                ]).createShader(Rect.fromCircle(center: Offset(px, py), radius: pr * 3.0)));
            }

            canvas.drawCircle(Offset(px, py), pr, paint);
          }
        }
      }

      final int dustCount = 120;
      for (int i = 0; i < dustCount; i++) {
        final double factor = i / dustCount;
        final double dist = (20 + factor * 180) * scale;
        if (dist < 1) continue;

        final double spiralAngle = armBaseAngle + factor * 6.5 - 0.15;
        final double scatter = (rng.nextDouble() - 0.5) * 6 * scale * (1.0 + factor * 0.3);

        final double dx = dist * math.cos(spiralAngle) + scatter * math.cos(spiralAngle + 1.5);
        final double dy = dist * math.sin(spiralAngle) + scatter * math.sin(spiralAngle + 1.5);
        final double dr = (3 + rng.nextDouble() * 8) * scale;

        if (dr > 0.3) {
          final dustAlpha = opacity * 0.06 * (1.0 - factor * 0.5);
          dustPaint.shader = RadialGradient(colors: [
            const Color(0xFF8B6914).withValues(alpha: dustAlpha),
            const Color(0xFF4A3000).withValues(alpha: dustAlpha * 0.5),
            Colors.transparent,
          ], stops: const [0.0, 0.5, 1.0]).createShader(Rect.fromCircle(center: Offset(dx, dy), radius: dr));
          canvas.drawCircle(Offset(dx, dy), dr, dustPaint);
        }
      }

      final int hiiCount = 15;
      for (int i = 0; i < hiiCount; i++) {
        final double factor = 0.15 + rng.nextDouble() * 0.6;
        final double dist = (30 + factor * 150) * scale;
        if (dist < 1) continue;

        final double spiralAngle = armBaseAngle + factor * 6.5;
        final double hx = dist * math.cos(spiralAngle);
        final double hy = dist * math.sin(spiralAngle);
        final double hr = (2 + rng.nextDouble() * 5) * scale;

        if (hr > 0.2) {
          final hAlpha = opacity * 0.15 * (1.0 - factor * 0.4);
          canvas.drawCircle(Offset(hx, hy), hr, Paint()
            ..shader = RadialGradient(colors: [
              const Color(0xFFFF6B8A).withValues(alpha: hAlpha),
              const Color(0xFFFF4060).withValues(alpha: hAlpha * 0.5),
              Colors.transparent,
            ]).createShader(Rect.fromCircle(center: Offset(hx, hy), radius: hr)));
        }
      }
    }

    final int coreStars = 60;
    for (int i = 0; i < coreStars; i++) {
      final double sa = rng.nextDouble() * 2 * math.pi;
      final double sd = rng.nextDouble() * bulgeR * 0.8;
      final double sx = sd * math.cos(sa);
      final double sy = sd * math.sin(sa);
      final double sr = (0.3 + rng.nextDouble() * 1.5) * scale;

      final tempRoll = rng.nextDouble();
      Color sc;
      if (tempRoll < 0.3) {
        sc = const Color(0xFFFFF0D0);
      } else if (tempRoll < 0.6) {
        sc = const Color(0xFFFFD070);
      } else {
        sc = Colors.white;
      }

      paint.color = sc.withValues(alpha: opacity * (0.5 + rng.nextDouble() * 0.4));
      canvas.drawCircle(Offset(sx, sy), sr, paint);
    }

    final ringPaint = Paint()..style = PaintingStyle.stroke;
    for (int i = 0; i < 3; i++) {
      final ringR = bulgeR * (3.5 + i * 0.6);
      ringPaint
        ..strokeWidth = (1.5 - i * 0.3) * scale
        ..color = const Color(0xFF1080E0).withValues(alpha: opacity * (0.08 - i * 0.02));
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: ringR * 2, height: ringR * 2 * 0.05),
        ringPaint,
      );
    }

    canvas.restore();
  }

  void _drawGalaxyField(Canvas canvas, Size size, Offset center, double scale, double t, double opacity) {
    if (scale < 0.005) return;
    final rng = math.Random(999);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 70; i++) {
      final double gx = rng.nextDouble() * size.width;
      final double gy = rng.nextDouble() * size.height;
      final double dx = (gx - center.dx) * (scale * 0.02) + center.dx;
      final double dy = (gy - center.dy) * (scale * 0.02) + center.dy;

      final int type = rng.nextInt(3);
      final double gr = (8 + rng.nextDouble() * 30) * scale * 0.05;
      if (gr < 0.3) continue;

      final double galT = t * 0.03 + i * 1.7;
      final color1 = rng.nextBool() ? const Color(0xFF1080E0) : const Color(0xFF2090FF);
      final color2 = rng.nextBool() ? const Color(0xFFFFE8C0) : const Color(0xFF40A0FF);

      canvas.drawCircle(Offset(dx, dy), gr * 2.0, Paint()
        ..shader = RadialGradient(colors: [
          color1.withValues(alpha: opacity * 0.12),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(center: Offset(dx, dy), radius: gr * 2.0)));

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(galT);

      if (type == 0) {
        final int arms = 2 + rng.nextInt(2);
        for (int arm = 0; arm < arms; arm++) {
          final path = Path();
          final double armAngle = (arm / arms) * math.pi * 2;
          for (int j = 0; j < 25; j++) {
            final double dist = (j / 25.0) * gr;
            final double angle = armAngle + dist * 0.15 + galT * 0.05;
            final px = math.cos(angle) * dist;
            final py = math.sin(angle) * dist * 0.4;
            if (j == 0) path.moveTo(px, py);
            else path.lineTo(px, py);
          }
          canvas.drawPath(path, Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = gr * 0.08
            ..strokeCap = StrokeCap.round
            ..color = color1.withValues(alpha: opacity * 0.35));

          final int miniStars = 8;
          for (int s = 0; s < miniStars; s++) {
            final double sf = (s + 1) / miniStars;
            final double sd = sf * gr;
            final double sa = armAngle + sf * 1.2;
            final double mx = math.cos(sa) * sd + (rng.nextDouble() - 0.5) * gr * 0.15;
            final double my = math.sin(sa) * sd * 0.4 + (rng.nextDouble() - 0.5) * gr * 0.08;
            paint.color = color2.withValues(alpha: opacity * (0.3 + rng.nextDouble() * 0.3));
            canvas.drawCircle(Offset(mx, my), gr * 0.03, paint);
          }
        }
      } else if (type == 1) {
        for (int j = 0; j < 20; j++) {
          final double ea = rng.nextDouble() * 2 * math.pi;
          final double ed = rng.nextDouble() * gr * 0.8;
          final double ex = math.cos(ea) * ed;
          final double ey = math.sin(ea) * ed * 0.6;
          paint.color = color2.withValues(alpha: opacity * (0.2 + rng.nextDouble() * 0.3));
          canvas.drawCircle(Offset(ex, ey), gr * 0.04, paint);
        }
      } else {
        final path = Path();
        for (int j = 0; j < 15; j++) {
          final double ir = (j / 15.0) * gr;
          final double ia = rng.nextDouble() * 2 * math.pi;
          final double ix = math.cos(ia) * ir * (0.5 + rng.nextDouble() * 0.5);
          final double iy = math.sin(ia) * ir * (0.3 + rng.nextDouble() * 0.4);
          if (j == 0) path.moveTo(ix, iy);
          else path.lineTo(ix, iy);
        }
        path.close();
        canvas.drawPath(path, paint
          ..color = color1.withValues(alpha: opacity * 0.15));
      }

      paint.color = Colors.white.withValues(alpha: opacity * 0.85);
      canvas.drawCircle(Offset.zero, gr * 0.12, paint);

      final nucleusPaint = Paint()
        ..shader = RadialGradient(colors: [
          color2.withValues(alpha: opacity * 0.4),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(center: Offset.zero, radius: gr * 0.3));
      canvas.drawCircle(Offset.zero, gr * 0.3, nucleusPaint);

      canvas.restore();
    }
  }

  void _drawScrollHint(Canvas canvas, Offset center, double offset, double opacity) {
    if (opacity <= 0.0) return;

    final double pulse = 5.0 * math.sin(time * 3.0);
    final hintPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF1080E0).withValues(alpha: opacity * 0.8);

    final double y = center.dy + offset + pulse;
    final path = Path()
      ..moveTo(center.dx - 12, y - 8)
      ..lineTo(center.dx, y)
      ..lineTo(center.dx + 12, y - 8);
    canvas.drawPath(path, hintPaint);

    final tp = TextPainter(
      text: TextSpan(
        text: tr('انزل للأسفل لاستكشاف أبعادنا', 'Scroll down to explore our bounds'),
        style: TextStyle(
          color: const Color(0xFF1080E0).withValues(alpha: opacity * 0.7),
          fontSize: 13,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, y - 30));
  }

  @override
  bool shouldRepaint(covariant _CosmicContinuousZoomPainter old) =>
      old.time != time || old.depth != depth;
}

class _SolarPlanet {
  final double orbitR;
  final double speed;
  final double r;
  final Color color;
  final bool hasRings;
  final bool hasMoon;
  final bool hasBands;
  const _SolarPlanet({
    required this.orbitR,
    required this.speed,
    required this.r,
    required this.color,
    this.hasRings = false,
    this.hasMoon = false,
    this.hasBands = false,
  });
}
