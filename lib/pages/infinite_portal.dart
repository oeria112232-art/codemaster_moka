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
        // Linear scroll mapping to depth range [0.0, 60.0]
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
      backgroundColor: const Color(0xFF040814), // Dark Navy matching logo bg
      body: Stack(
        children: [
          // The main master cosmic painter with continuous scale-down zoom
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
          
          // Smooth scroll area
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
          
          // Back Button
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
          
          // Scroll Indicator / HUD (Desktop right side)
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
          
          // Interactive Status Card
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

  _CosmicZoomUniverse? _universe;

  _CosmicContinuousZoomPainter({required this.time, required this.depth}) {
    // Universe structure is statically seeded so stars and planets stay consistent
    _universe = _CosmicZoomUniverse(42);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height);

    // Deep cosmic space background
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF081426), // Logo blue-navy glow center
          const Color(0xFF040814), // Pitch black navy edge
        ],
        radius: 1.5,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Continuous camera zoom factor (exponential decay representing smooth treading back)
    // At depth 0: zoom = 1.0 (very close)
    // At depth 60: zoom = 0.003 (infinitely zoomed out)
    final double zoom = math.pow(0.91, depth).toDouble();

    // Draw ambient stardust/nebula glow
    final nebulaPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF1080E0).withValues(alpha: 0.12),
          const Color(0xFF2090FF).withValues(alpha: 0.03),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius * 0.8));
    canvas.drawRect(Offset.zero & size, nebulaPaint);

    if (_universe == null) return;

    // Draw Background Stars (these don't zoom out as fast, simulating infinity background)
    _drawInfiniteStars(canvas, size, zoom);

    // --- ZOOM-OUT STAGE 1: Single Planet (Starts at 100% size, shrinks down) ---
    // Smooth opacity: starts fully visible, fades out as we transition into Stage 2
    final double stage1Opacity = (1.0 - (depth / 12.0)).clamp(0.0, 1.0);
    if (stage1Opacity > 0.0) {
      final double planetR = maxRadius * 0.22 * zoom;
      _drawMotherPlanet(canvas, center, planetR, time, stage1Opacity);
    }

    // --- ZOOM-OUT STAGE 2: The Solar System (Fades in, shrinks down) ---
    // Fades in smoothly as Stage 1 fades out, shrinks continuously
    final double stage2Opacity = _getStageOpacity(depth, 8.0, 14.0, 24.0);
    if (stage2Opacity > 0.0) {
      // The Solar System is centered. At depth 12, its radius should look natural.
      // We scale its layout size with the global zoom.
      final double systemScale = zoom * 3.5; // multiplier keeps it large when appearing
      _drawCompleteSolarSystem(canvas, center, systemScale, time, stage2Opacity);
    }

    // --- ZOOM-OUT STAGE 3: Multiple Solar Systems / Stellar Cluster ---
    final double stage3Opacity = _getStageOpacity(depth, 20.0, 26.0, 38.0);
    if (stage3Opacity > 0.0) {
      final double clusterScale = zoom * 25.0; // scale multiplier for stage 3
      _drawStellarCluster(canvas, center, clusterScale, time, stage3Opacity);
    }

    // --- ZOOM-OUT STAGE 4: Spiral Galaxy (Milky Way) ---
    final double stage4Opacity = _getStageOpacity(depth, 32.0, 38.0, 50.0);
    if (stage4Opacity > 0.0) {
      final double galaxyScale = zoom * 180.0;
      _drawSpiralGalaxy(canvas, center, galaxyScale, time, stage4Opacity);
    }

    // --- ZOOM-OUT STAGE 5: Infinite Galaxy Field ---
    final double stage5Opacity = (depth - 44.0).clamp(0.0, 16.0) / 16.0;
    if (stage5Opacity > 0.0) {
      final double fieldScale = zoom * 1200.0;
      _drawGalaxyField(canvas, size, center, fieldScale, time, stage5Opacity);
    }

    // Draw nice scroll hint at the very top of depth
    if (depth < 6.0) {
      final double hintOpacity = (1.0 - depth / 6.0).clamp(0.0, 1.0);
      _drawScrollHint(canvas, center, maxRadius * 0.25, hintOpacity);
    }
  }

  // Beautiful bell-curve opacity for transitions between zoomed-out states
  double _getStageOpacity(double d, double startFadeIn, double fullyIn, double endFadeOut) {
    if (d < startFadeIn) return 0.0;
    if (d < fullyIn) return (d - startFadeIn) / (fullyIn - startFadeIn);
    if (d < endFadeOut) return 1.0 - (d - fullyIn) / (endFadeOut - fullyIn);
    return 0.0;
  }

  void _drawInfiniteStars(Canvas canvas, Size size, double zoom) {
    final rng = math.Random(1337);
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Background stars drift very slowly with zoom to create parallax
    for (int i = 0; i < 150; i++) {
      final bx = rng.nextDouble() * size.width;
      final by = rng.nextDouble() * size.height;
      // Parallax effect: stars move slowly towards center as we zoom out
      final dx = (bx - size.width / 2) * (0.95 + zoom * 0.05) + size.width / 2;
      final dy = (by - size.height / 2) * (0.95 + zoom * 0.05) + size.height / 2;
      
      final r = 0.4 + rng.nextDouble() * 1.0;
      final twinkle = (0.2 + math.sin(time * 0.5 + i) * 0.15).clamp(0.05, 0.5);
      
      paint.color = Colors.white.withValues(alpha: twinkle);
      canvas.drawCircle(Offset(dx, dy), r, paint);
    }
  }

  // Stage 1: Ultra-Professional Mother Planet
  void _drawMotherPlanet(Canvas canvas, Offset center, double r, double t, double opacity) {
    if (r < 1.0) return;

    // 1. Double layer atmosphere glow
    final glowPaint1 = Paint()
      ..shader = RadialGradient(colors: [
        const Color(0xFF1080E0).withValues(alpha: opacity * 0.25),
        const Color(0xFF2090FF).withValues(alpha: opacity * 0.08),
        Colors.transparent,
      ], stops: const [0.0, 0.6, 1.0]).createShader(Rect.fromCircle(center: center, radius: r * 1.6));
    canvas.drawCircle(center, r * 1.6, glowPaint1);

    // 2. Solid spherical body with realistic 3D shadow gradient
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.35), // light source from top-left
        colors: [
          const Color(0xFF2090FF).withValues(alpha: opacity * 0.8), // Bright lit area
          const Color(0xFF1080E0).withValues(alpha: opacity * 0.5), // Midtone
          const Color(0xFF040814).withValues(alpha: opacity * 0.95), // Deep shadow
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawCircle(center, r, bodyPaint);

    // 3. Super elegant wireframe grid representing high-tech digital structure
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = (r > 50) ? 1.0 : 0.5
      ..color = const Color(0xFF40A0FF).withValues(alpha: opacity * 0.25);

    // Latitudes (Horizontal rings)
    for (int i = 1; i < 8; i++) {
      final latRatio = i / 8.0;
      final latR = r * math.sin(latRatio * math.pi);
      final latY = r * math.cos(latRatio * math.pi);
      // Flat projection
      canvas.drawOval(
        Rect.fromCenter(center: Offset(center.dx, center.dy + latY * 0.2), width: latR * 2, height: latR * 0.35),
        gridPaint,
      );
    }

    // Longitudes (Vertical rotating lines)
    for (int i = 0; i < 4; i++) {
      final angle = (i / 4.0) * math.pi + t * 0.15;
      final widthFactor = math.cos(angle).abs();
      canvas.drawOval(
        Rect.fromCenter(center: center, width: r * 2 * widthFactor, height: r * 2),
        gridPaint..color = const Color(0xFF40A0FF).withValues(alpha: opacity * (0.12 + 0.1 * widthFactor)),
      );
    }

    // 4. Planet Ring (Saturn-like futuristic circuit ring)
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
  }

  // Stage 2: Realistic Solar System (Centred Sun, 8 orbiting planets at real-scale proportions)
  void _drawCompleteSolarSystem(Canvas canvas, Offset center, double scale, double t, double opacity) {
    if (scale < 0.05) return;

    // 1. The Sun (The central massive light source)
    final sunR = 24.0 * scale;
    if (sunR > 0.5) {
      canvas.drawCircle(center, sunR * 2.5, Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFFFF9000).withValues(alpha: opacity * 0.35),
          const Color(0xFFFFD000).withValues(alpha: 0.05),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(center: center, radius: sunR * 2.5)));
      canvas.drawCircle(center, sunR, Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFFFFE000).withValues(alpha: opacity * 0.95),
          const Color(0xFFFF5000).withValues(alpha: opacity * 0.6),
        ]).createShader(Rect.fromCircle(center: center, radius: sunR)));
    }

    // Planet configs: [orbitRadius, speedScale, planetRadius, color, hasRings]
    final planets = [
      _SolarPlanet(orbitR: 45.0, speed: 2.2, r: 2.2, color: const Color(0xFFA6ABB6)), // Mercury
      _SolarPlanet(orbitR: 65.0, speed: 1.6, r: 4.5, color: const Color(0xFFFFD8A8)), // Venus
      _SolarPlanet(orbitR: 90.0, speed: 1.2, r: 5.0, color: const Color(0xFF1080E0)), // Earth (Our Planet!)
      _SolarPlanet(orbitR: 115.0, speed: 0.9, r: 3.5, color: const Color(0xFFE8590C)), // Mars
      _SolarPlanet(orbitR: 155.0, speed: 0.6, r: 12.0, color: const Color(0xFFF1B070)), // Jupiter
      _SolarPlanet(orbitR: 205.0, speed: 0.4, r: 9.5, color: const Color(0xFFFCC419), hasRings: true), // Saturn
      _SolarPlanet(orbitR: 245.0, speed: 0.3, r: 7.0, color: const Color(0xFF74C0FC)), // Uranus
      _SolarPlanet(orbitR: 280.0, speed: 0.2, r: 6.5, color: const Color(0xFF3b5bdb)), // Neptune
    ];

    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = const Color(0xFF1080E0).withValues(alpha: opacity * 0.08);

    for (final p in planets) {
      final double r = p.orbitR * scale;
      if (r < 1.0) continue;

      // Draw oval orbit to give 3D perspective
      canvas.drawOval(
        Rect.fromCenter(center: center, width: r * 2, height: r * 0.5),
        orbitPaint,
      );

      // Planet position calculation
      final angle = t * p.speed * 0.4;
      final px = center.dx + r * math.cos(angle);
      final py = center.dy + r * 0.25 * math.sin(angle); // Squashed Y for perspective
      final pr = p.r * scale;

      if (pr > 0.2) {
        // Body
        canvas.drawCircle(Offset(px, py), pr, Paint()
          ..shader = RadialGradient(colors: [
            p.color.withValues(alpha: opacity * 0.95),
            const Color(0xFF040814).withValues(alpha: opacity * 0.9),
          ], center: const Alignment(-0.3, -0.3)).createShader(Rect.fromCircle(center: Offset(px, py), radius: pr)));

        // Rings for Saturn
        if (p.hasRings) {
          canvas.drawOval(
            Rect.fromCenter(center: Offset(px, py), width: pr * 2.4, height: pr * 0.6),
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.2 * scale
              ..color = p.color.withValues(alpha: opacity * 0.5),
          );
        }
      }
    }
  }

  // Stage 3: Stellar Cluster (Thousands of suns/solar systems shrinking into star dust)
  void _drawStellarCluster(Canvas canvas, Offset center, double scale, double t, double opacity) {
    if (scale < 0.02) return;
    final rng = math.Random(101);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 180; i++) {
      final double angle = rng.nextDouble() * 2 * math.pi;
      final double distance = (30.0 + rng.nextDouble() * 220.0) * scale;
      if (distance < 1.0) continue;

      final double px = center.dx + distance * math.cos(angle);
      final double py = center.dy + distance * math.sin(angle) * 0.6; // flat cluster
      final double r = (1.5 + rng.nextDouble() * 3.5) * scale;

      if (r > 0.1) {
        final color = rng.nextInt(3) == 0
            ? const Color(0xFF1080E0)
            : (rng.nextBool() ? const Color(0xFF2090FF) : const Color(0xFFFFD000));
        
        paint.color = color.withValues(alpha: opacity * (0.3 + rng.nextDouble() * 0.6));
        canvas.drawCircle(Offset(px, py), r, paint);
        
        // Small orbit indicator for some stars in the cluster
        if (rng.nextDouble() * scale > 0.15) {
          canvas.drawCircle(Offset(px, py), r * 2.5, Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.3
            ..color = const Color(0xFF1080E0).withValues(alpha: opacity * 0.12));
        }
      }
    }
  }

  // Stage 4: Majestic Spiral Galaxy (Beautiful glowing core and detailed dust lane arms)
  void _drawSpiralGalaxy(Canvas canvas, Offset center, double scale, double t, double opacity) {
    if (scale < 0.02) return;
    
    // Core glow
    final double coreR = 40 * scale;
    if (coreR > 0.5) {
      canvas.drawCircle(center, coreR * 3, Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFF2090FF).withValues(alpha: opacity * 0.25),
          const Color(0xFF1080E0).withValues(alpha: opacity * 0.05),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(center: center, radius: coreR * 3)));
      canvas.drawCircle(center, coreR, Paint()
        ..shader = RadialGradient(colors: [
          Colors.white.withValues(alpha: opacity * 0.95),
          const Color(0xFF1080E0).withValues(alpha: opacity * 0.7),
        ]).createShader(Rect.fromCircle(center: center, radius: coreR)));
    }

    final arms = 4;
    final rng = math.Random(888);
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw spiral arms with logarithmic math
    for (int arm = 0; arm < arms; arm++) {
      final double armOffset = (arm / arms) * math.pi * 2;
      for (int i = 0; i < 280; i++) {
        final double factor = i / 280.0;
        final double dist = factor * 220.0 * scale;
        if (dist < 1.0) continue;

        // Spiral spiral formula (theta = a + b * ln(r))
        final double theta = armOffset + factor * 5.5 + t * 0.03;
        final double wobble = (rng.nextDouble() - 0.5) * 14 * scale;
        
        final double px = center.dx + dist * math.cos(theta) + wobble;
        final double py = center.dy + dist * math.sin(theta) * 0.45 + wobble * 0.3; // inclined view
        final double r = (0.6 + rng.nextDouble() * 2.2) * scale;

        if (r > 0.1) {
          final color = i % 4 == 0
              ? const Color(0xFF1080E0)
              : (i % 4 == 1 ? const Color(0xFF2090FF) : (i % 4 == 2 ? const Color(0xFF40A0FF) : Colors.white));
          paint.color = color.withValues(alpha: opacity * (0.2 + rng.nextDouble() * 0.6) * (1.0 - factor * 0.5));
          canvas.drawCircle(Offset(px, py), r, paint);
        }
      }
    }
  }

  // Stage 5: Receding Galaxy Field (Billions of distant galaxies floating and shrinking)
  void _drawGalaxyField(Canvas canvas, Size size, Offset center, double scale, double t, double opacity) {
    if (scale < 0.005) return;
    final rng = math.Random(999);
    final paint = Paint()..style = PaintingStyle.fill;

    // Seeded coordinates of other galaxies
    for (int i = 0; i < 40; i++) {
      final double gx = rng.nextDouble() * size.width;
      final double gy = rng.nextDouble() * size.height;
      // Shrink towards center to represent moving away
      final double dx = (gx - center.dx) * (scale * 0.02) + center.dx;
      final double dy = (gy - center.dy) * (scale * 0.02) + center.dy;
      
      final double gr = (12 + rng.nextDouble() * 25) * scale * 0.05;
      if (gr < 0.5) continue;

      final color = rng.nextBool() ? const Color(0xFF1080E0) : const Color(0xFF2090FF);

      // Radial galaxy envelope glow
      canvas.drawCircle(Offset(dx, dy), gr * 1.8, Paint()
        ..shader = RadialGradient(colors: [
          color.withValues(alpha: opacity * 0.15),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(center: Offset(dx, dy), radius: gr * 1.8)));

      // Tiny rotating spiral structure inside each galaxy
      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(t * 0.05 + i);
      
      final armCount = 2 + rng.nextInt(2);
      for (int arm = 0; arm < armCount; arm++) {
        final double armAngle = (arm / armCount) * math.pi * 2;
        final path = Path();
        for (int j = 0; j < 15; j++) {
          final double dist = (j / 15.0) * gr;
          final double angle = armAngle + dist * 0.12;
          final px = math.cos(angle) * dist;
          final py = math.sin(angle) * dist * 0.4;
          if (j == 0) path.moveTo(px, py);
          else path.lineTo(px, py);
        }
        canvas.drawPath(path, Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.4
          ..color = color.withValues(alpha: opacity * 0.3));
      }
      canvas.drawCircle(Offset.zero, gr * 0.15, paint..color = Colors.white.withValues(alpha: opacity * 0.8));
      canvas.restore();
    }
  }

  void _drawScrollHint(Canvas canvas, Offset center, double offset, double opacity) {
    if (opacity <= 0.0) return;
    
    // Draw an elegant pulsing scroll down arrow/indicator
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
  const _SolarPlanet({required this.orbitR, required this.speed, required this.r, required this.color, this.hasRings = false});
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
    // Elegant particle layer adds texture to empty space
    final rng = math.Random(index * 7919 + depth.floor() * 13);
    final t = time;
    final paint = Paint()..style = PaintingStyle.fill;
    
    final double zoom = math.pow(0.91, depth).toDouble();
    if (zoom < 0.02) return;

    for (int i = 0; i < 5; i++) {
      final x = size.width * (0.1 + rng.nextDouble() * 0.8) + math.sin(t * 0.3 + i * 1.5) * 8 * zoom;
      final y = size.height * (0.1 + rng.nextDouble() * 0.8) + math.cos(t * 0.25 + i * 1.2) * 5 * zoom;
      final r = (1.0 + rng.nextDouble() * 2.5) * zoom;
      final alpha = (0.02 + math.sin(t * 0.4 + i) * 0.01).clamp(0.005, 0.05);
      
      paint.color = const Color(0xFF2090FF).withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SectionParticles old) =>
      old.time != time || old.index != index || old.depth != depth;
}

// Statically seeded universe items to ensure smooth, non-glitchy visual continuity
class _CosmicZoomUniverse {
  final int seed;
  _CosmicZoomUniverse(this.seed);
}
