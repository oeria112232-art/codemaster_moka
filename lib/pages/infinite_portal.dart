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
      backgroundColor: const Color(0xFF030610),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _timeCtrl,
              builder: (context, _) {
                return CustomPaint(
                  painter: _UltraCosmicPainter(
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
              itemBuilder: (context, index) => const SizedBox(height: 100),
            ),
          ),
          Positioned(
            top: 24, left: 24,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF060C1A).withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back, color: Color(0xFF1080E0), size: 20),
                      const SizedBox(width: 8),
                      Text(tr('خروج', 'Exit'), style: const TextStyle(color: Color(0xFF1080E0), fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 24, top: 0, bottom: 0,
            child: Center(
              child: Container(
                width: 3, height: 240,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: const Color(0xFF060C1A).withValues(alpha: 0.5)),
                child: Align(
                  alignment: Alignment(0, (_scrollDepth / 60.0 * 2 - 1).clamp(-1.0, 1.0)),
                  child: Container(
                    width: 3, height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: const Color(0xFF1080E0),
                      boxShadow: [BoxShadow(color: const Color(0xFF1080E0).withValues(alpha: 0.5), blurRadius: 10)],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 24, top: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF060C1A).withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_getScaleLabel(_scrollDepth, isAr), style: const TextStyle(color: Color(0xFF1080E0), fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(_getZoneLabel(_scrollDepth, isAr), style: const TextStyle(color: Color(0xFFA6ABB6), fontSize: 11)),
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
    if (d < 35) return isAr ? 'العناقيد النجمية' : 'Stellar Clusters';
    if (d < 48) return isAr ? 'مجرتنا الحلزونية' : 'Our Spiral Galaxy';
    return isAr ? 'الكون اللانهائي' : 'The Infinite Universe';
  }

  String _getZoneLabel(double d, bool isAr) {
    if (d < 10) return isAr ? 'البعد: الكوكب الأم' : 'Scale: Mother Planet';
    if (d < 22) return isAr ? 'البعد: مجموعة كواكب ثمانية' : 'Scale: Eight-Planet System';
    if (d < 35) return isAr ? 'البعد: آلاف الأنظمة الشمسية' : 'Scale: Thousands of Systems';
    if (d < 48) return isAr ? 'البعد: بنية المجرة الحلزونية' : 'Scale: Spiral Galaxy Structure';
    return isAr ? 'البعد: مليارات المجرات' : 'Scale: Billions of Galaxies';
  }
}

// ═══════════════════════════════════════════════════════════════════
// Ultra Cosmic Painter — Maximum detail, maximum beauty
// ═══════════════════════════════════════════════════════════════════
class _UltraCosmicPainter extends CustomPainter {
  final double time;
  final double depth;
  _UltraCosmicPainter({required this.time, required this.depth});

  static const _deepBg = Color(0xFF030610);
  static const _blue = Color(0xFF1080E0);
  static const _lightBlue = Color(0xFF2090FF);
  static const _brightBlue = Color(0xFF40A0FF);
  static const _paleBlue = Color(0xFF80C0FF);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final maxR = math.min(size.width, size.height);

    _paintBackground(canvas, size, c);
    final zoom = math.pow(0.91, depth).toDouble();
    _paintDeepStars(canvas, size, c, zoom);

    final s1 = (1.0 - depth / 12.0).clamp(0.0, 1.0);
    if (s1 > 0) _paintMotherPlanet(canvas, c, maxR * 0.22 * zoom, time, s1);

    final s2 = _stageOpacity(depth, 8, 14, 24);
    if (s2 > 0) _paintSolarSystem(canvas, c, zoom * 3.5, time, s2);

    final s3 = _stageOpacity(depth, 20, 26, 38);
    if (s3 > 0) _paintStellarCluster(canvas, c, zoom * 25, time, s3);

    final s4 = _stageOpacity(depth, 32, 38, 50);
    if (s4 > 0) _paintOurGalaxy(canvas, c, zoom * 180, time, s4);

    final s5 = (depth - 44).clamp(0.0, 16.0) / 16.0;
    if (s5 > 0) _paintUniverseField(canvas, size, c, zoom * 1200, time, s5);

    _paintShootingStars(canvas, size, time);

    if (depth < 6) {
      _paintScrollHint(canvas, c, maxR * 0.25, (1 - depth / 6).clamp(0.0, 1.0));
    }
  }

  double _stageOpacity(double d, double a, double b, double e) {
    if (d < a) return 0;
    if (d < b) return (d - a) / (b - a);
    if (d < e) return 1 - (d - b) / (e - b);
    return 0;
  }

  // ──────────── BACKGROUND ────────────
  void _paintBackground(Canvas canvas, Size size, Offset c) {
    canvas.drawRect(Offset.zero & size, Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF0A1628), _deepBg],
        radius: 1.6,
      ).createShader(Offset.zero & size));
  }

  // ──────────── DEEP SPACE NEBULAE (always visible) ────────────
  void _paintDeepStars(Canvas canvas, Size size, Offset c, double zoom) {
    final rng = math.Random(1337);
    final p = Paint()..style = PaintingStyle.fill;

    // Massive star field — 400 stars
    for (int i = 0; i < 400; i++) {
      final bx = rng.nextDouble() * size.width;
      final by = rng.nextDouble() * size.height;
      final dx = (bx - c.dx) * (0.96 + zoom * 0.04) + c.dx;
      final dy = (by - c.dy) * (0.96 + zoom * 0.04) + c.dy;
      final r = 0.2 + rng.nextDouble() * 1.3;
      final freq = 0.2 + rng.nextDouble() * 1.2;
      final tw = (0.12 + math.sin(time * freq + i * 1.7) * 0.2).clamp(0.04, 0.55);

      final t = rng.nextDouble();
      Color sc;
      if (t < 0.1) sc = const Color(0xFF88AAFF);
      else if (t < 0.25) sc = const Color(0xFFAACCFF);
      else if (t < 0.5) sc = Colors.white;
      else if (t < 0.7) sc = const Color(0xFFFFF0D0);
      else if (t < 0.85) sc = const Color(0xFFFFD080);
      else sc = const Color(0xFFFF8855);

      p.color = sc.withValues(alpha: tw);
      canvas.drawCircle(Offset(dx, dy), r, p);

      // Glow for bright stars
      if (r > 0.9) {
        canvas.drawCircle(Offset(dx, dy), r * 3.5, Paint()
          ..shader = RadialGradient(colors: [
            sc.withValues(alpha: tw * 0.18),
            Colors.transparent,
          ]).createShader(Rect.fromCircle(center: Offset(dx, dy), radius: r * 3.5)));
      }
    }

    // Floating nebulae in background — 12 clouds
    for (int i = 0; i < 12; i++) {
      final nx = rng.nextDouble() * size.width;
      final ny = rng.nextDouble() * size.height;
      final nr = (60 + rng.nextDouble() * 250) * zoom;
      if (nr < 2) continue;
      final cols = [
        [const Color(0xFF1080E0), const Color(0xFF0A1628)],
        [const Color(0xFF0060B0), const Color(0xFF060C1A)],
        [const Color(0xFF2090FF), const Color(0xFF0A1628)],
        [const Color(0xFF003060), const Color(0xFF030610)],
      ];
      final pair = cols[i % cols.length];
      p.shader = RadialGradient(
        colors: [pair[0].withValues(alpha: 0.05), pair[1].withValues(alpha: 0.01), Colors.transparent],
        stops: const [0, 0.45, 1],
      ).createShader(Rect.fromCircle(center: Offset(nx, ny), radius: nr));
      canvas.drawCircle(Offset(nx, ny), nr, p);
    }
  }

  // ──────────── STAGE 1: MOTHER PLANET ────────────
  void _paintMotherPlanet(Canvas canvas, Offset c, double r, double t, double op) {
    if (r < 1) return;
    final p = Paint();

    // Outer atmosphere layers (3 layers)
    for (int i = 0; i < 3; i++) {
      final lr = r * (2.0 - i * 0.3);
      p.shader = RadialGradient(colors: [
        _blue.withValues(alpha: op * (0.18 - i * 0.05)),
        Colors.transparent,
      ], stops: const [0, 1]).createShader(Rect.fromCircle(center: c, radius: lr));
      canvas.drawCircle(c, lr, p);
    }

    // Planet body with 4-gradient 3D shading
    p.shader = RadialGradient(
      center: const Alignment(-0.38, -0.38),
      colors: [
        _brightBlue.withValues(alpha: op * 0.9),
        _blue.withValues(alpha: op * 0.6),
        const Color(0xFF0060B0).withValues(alpha: op * 0.7),
        _deepBg.withValues(alpha: op * 0.98),
      ],
      stops: const [0, 0.28, 0.6, 1],
    ).createShader(Rect.fromCircle(center: c, radius: r));
    canvas.drawCircle(c, r, p);

    // Surface texture: scattered bright spots (cities / terrain)
    final rng = math.Random(333);
    final tp = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 40; i++) {
      final sa = rng.nextDouble() * 2 * math.pi;
      final sd = rng.nextDouble() * r * 0.85;
      final sx = c.dx + math.cos(sa) * sd;
      final sy = c.dy + math.sin(sa) * sd;
      final sr = (0.5 + rng.nextDouble() * 1.8);
      tp.color = _brightBlue.withValues(alpha: op * (0.08 + rng.nextDouble() * 0.12));
      canvas.drawCircle(Offset(sx, sy), sr, tp);
    }

    // Wireframe grid
    final gp = Paint()..style = PaintingStyle.stroke..strokeWidth = (r > 50) ? 0.8 : 0.4
      ..color = _brightBlue.withValues(alpha: op * 0.22);
    for (int i = 1; i < 9; i++) {
      final lr = i / 9.0;
      final latR = r * math.sin(lr * math.pi);
      final latY = r * math.cos(lr * math.pi);
      canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + latY * 0.2), width: latR * 2, height: latR * 0.32), gp);
    }
    for (int i = 0; i < 5; i++) {
      final a = (i / 5) * math.pi + t * 0.12;
      canvas.drawOval(Rect.fromCenter(center: c, width: r * 2 * math.cos(a).abs(), height: r * 2),
        gp..color = _brightBlue.withValues(alpha: op * (0.08 + 0.08 * math.cos(a).abs())));
    }

    // Saturn-like rings (3 rings)
    for (int i = 0; i < 3; i++) {
      final rw = r * (2.8 - i * 0.15);
      final rh = r * (0.55 - i * 0.04);
      canvas.drawOval(Rect.fromCenter(center: c, width: rw, height: rh), Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = (2.5 - i * 0.6)
        ..color = _blue.withValues(alpha: op * (0.35 - i * 0.08)));
    }

    // Aurora borealis at the poles
    final auroraPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 6; i++) {
      final aa = -0.8 + i * 0.3;
      final ax = c.dx + math.cos(aa) * r * 0.8;
      final ay = c.dy - r * 0.85 + math.sin(t * 0.5 + i) * r * 0.06;
      final ah = r * (0.15 + 0.05 * math.sin(t * 0.8 + i * 1.3));
      auroraPaint.shader = LinearGradient(
        colors: [const Color(0xFF00FFAA).withValues(alpha: op * 0.2), _blue.withValues(alpha: op * 0.05), Colors.transparent],
      ).createShader(Rect.fromLTWH(ax - 2, ay - ah, 4, ah * 2));
      canvas.drawLine(Offset(ax, ay - ah), Offset(ax, ay + ah), auroraPaint);
    }
  }

  // ──────────── STAGE 2: SOLAR SYSTEM ────────────
  void _paintSolarSystem(Canvas canvas, Offset c, double scale, double t, double op) {
    if (scale < 0.05) return;
    final sunR = 24 * scale;
    final p = Paint();

    if (sunR > 0.5) {
      // Solar corona (6 rays)
      for (int i = 0; i < 8; i++) {
        final a = (i / 8) * 2 * math.pi + t * 0.06;
        final len = sunR * (2.2 + 0.8 * math.sin(t * 1.5 + i * 0.9));
        final w = sunR * 0.12;
        canvas.save();
        canvas.translate(c.dx + math.cos(a) * sunR * 1.1, c.dy + math.sin(a) * sunR * 1.1);
        canvas.rotate(a);
        p.shader = LinearGradient(colors: [
          const Color(0xFFFFE000).withValues(alpha: op * 0.15),
          Colors.transparent,
        ]).createShader(Rect.fromCenter(center: Offset.zero, width: w, height: len));
        canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: w, height: len), p);
        canvas.restore();
      }

      // Sun outer glow
      p.shader = RadialGradient(colors: [
        const Color(0xFFFF9000).withValues(alpha: op * 0.35),
        const Color(0xFFFFD000).withValues(alpha: op * 0.06),
        Colors.transparent,
      ], stops: const [0, 0.4, 1]).createShader(Rect.fromCircle(center: c, radius: sunR * 3));
      canvas.drawCircle(c, sunR * 3, p);

      // Sun body
      p.shader = RadialGradient(
        center: const Alignment(-0.2, -0.2),
        colors: [
          Colors.white.withValues(alpha: op * 0.95),
          const Color(0xFFFFE000).withValues(alpha: op * 0.9),
          const Color(0xFFFF8000).withValues(alpha: op * 0.7),
          const Color(0xFFFF4000).withValues(alpha: op * 0.4),
        ],
        stops: const [0, 0.3, 0.65, 1],
      ).createShader(Rect.fromCircle(center: c, radius: sunR));
      canvas.drawCircle(c, sunR, p);

      // Sun spots
      final spr = math.Random(200);
      for (int i = 0; i < 4; i++) {
        final sa = spr.nextDouble() * 2 * math.pi;
        final sd = spr.nextDouble() * sunR * 0.6;
        final spotR = sunR * (0.05 + spr.nextDouble() * 0.08);
        canvas.drawCircle(Offset(c.dx + math.cos(sa) * sd, c.dy + math.sin(sa) * sd), spotR, Paint()
          ..color = const Color(0xFFCC6600).withValues(alpha: op * 0.4));
      }
    }

    // Asteroid belt between Mars and Jupiter
    final abRng = math.Random(500);
    final abPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 60; i++) {
      final a = abRng.nextDouble() * 2 * math.pi + t * 0.02;
      final dist = (130 + abRng.nextDouble() * 20) * scale;
      if (dist < 0.5) continue;
      final ax = c.dx + dist * math.cos(a);
      final ay = c.dy + dist * math.sin(a) * 0.25;
      final ar = (0.3 + abRng.nextDouble() * 0.8) * scale;
      abPaint.color = const Color(0xFF888888).withValues(alpha: op * 0.3);
      canvas.drawCircle(Offset(ax, ay), ar, abPaint);
    }

    final planets = [
      _Planet(45, 2.2, 2.2, const Color(0xFFA6ABB6)),
      _Planet(65, 1.6, 4.5, const Color(0xFFFFD8A8)),
      _Planet(90, 1.2, 5.0, _blue, hasMoon: true),
      _Planet(115, 0.9, 3.5, const Color(0xFFE8590C)),
      _Planet(155, 0.6, 12.0, const Color(0xFFF1B070), hasBands: true),
      _Planet(205, 0.4, 9.5, const Color(0xFFFCC419), rings: 3),
      _Planet(245, 0.3, 7.0, const Color(0xFF74C0FC)),
      _Planet(280, 0.2, 6.5, const Color(0xFF3b5bdb)),
    ];

    final orbitP = Paint()..style = PaintingStyle.stroke..strokeWidth = 0.4
      ..color = _blue.withValues(alpha: op * 0.08);

    for (final pl in planets) {
      final orbitScreenR = pl.orbitR * scale;
      if (orbitScreenR < 1) continue;

      // Orbit path
      canvas.drawOval(Rect.fromCenter(center: c, width: orbitScreenR * 2, height: orbitScreenR * 0.5), orbitP);

      final a = t * pl.speed * 0.4;
      final px = c.dx + orbitScreenR * math.cos(a);
      final py = c.dy + orbitScreenR * 0.25 * math.sin(a);
      final pr = pl.r * scale;
      if (pr < 0.15) continue;

      // Planet body with 3D shading
      p.shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [
          pl.color.withValues(alpha: op * 0.95),
          pl.color.withValues(alpha: op * 0.5),
          _deepBg.withValues(alpha: op * 0.9),
        ],
        stops: const [0, 0.5, 1],
      ).createShader(Rect.fromCircle(center: Offset(px, py), radius: pr));
      canvas.drawCircle(Offset(px, py), pr, p);

      // Planet glow
      canvas.drawCircle(Offset(px, py), pr * 2, Paint()
        ..shader = RadialGradient(colors: [
          pl.color.withValues(alpha: op * 0.08),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(center: Offset(px, py), radius: pr * 2)));

      // Saturn rings
      if (pl.rings > 0) {
        for (int ri = 0; ri < pl.rings; ri++) {
          final rw = pr * (2.3 + ri * 0.25);
          canvas.drawOval(Rect.fromCenter(center: Offset(px, py), width: rw, height: pr * (0.5 + ri * 0.04)),
            Paint()..style = PaintingStyle.stroke..strokeWidth = (1.0 - ri * 0.2) * scale
              ..color = pl.color.withValues(alpha: op * (0.45 - ri * 0.1)));
        }
      }

      // Jupiter bands
      if (pl.hasBands) {
        for (int b = 0; b < 5; b++) {
          final by2 = py - pr * 0.6 + b * pr * 0.3;
          canvas.drawArc(
            Rect.fromCenter(center: Offset(px, by2), width: pr * 1.8, height: pr * 0.2),
            0, math.pi, false,
            Paint()..style = PaintingStyle.stroke..strokeWidth = 0.4 * scale
              ..color = const Color(0xFFCC8844).withValues(alpha: op * 0.3));
        }
      }

      // Moon
      if (pl.hasMoon) {
        final ma = t * 4;
        final md = pr * 3;
        final mx = px + math.cos(ma) * md;
        final my = py + math.sin(ma) * md * 0.3;
        final mr = pr * 0.22;
        p.shader = RadialGradient(colors: [
          const Color(0xFFB0B0B0).withValues(alpha: op * 0.8),
          const Color(0xFF505050).withValues(alpha: op * 0.5),
        ], center: const Alignment(-0.3, -0.3)).createShader(Rect.fromCircle(center: Offset(mx, my), radius: mr));
        canvas.drawCircle(Offset(mx, my), mr, p);
      }
    }

    // Comets with tails
    for (int ci = 0; ci < 2; ci++) {
      final ca = t * (0.3 + ci * 0.2) + ci * 3.5;
      final cd = (180 + ci * 60) * scale;
      if (cd < 0.5) continue;
      final cx = c.dx + cd * math.cos(ca);
      final cy = c.dy + cd * math.sin(ca) * 0.25;
      final headR = (1.5 + ci) * scale;

      // Comet tail (curved, fading)
      final tailPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = headR * 0.8..strokeCap = StrokeCap.round;
      final tailPath = Path();
      tailPath.moveTo(cx, cy);
      for (int tj = 1; tj <= 15; tj++) {
        final tf = tj / 15.0;
        final tx = cx + math.cos(ca + math.pi) * headR * 8 * tf + math.sin(t * 0.5 + tj) * headR * tf;
        final ty = cy + math.sin(ca + math.pi) * headR * 8 * tf * 0.25;
        tailPath.lineTo(tx, ty);
      }
      tailPaint.shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: op * 0.6),
          _lightBlue.withValues(alpha: op * 0.2),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCenter(center: Offset(cx, cy), width: headR * 16, height: headR * 8));
      canvas.drawPath(tailPath, tailPaint);

      // Comet head glow
      canvas.drawCircle(Offset(cx, cy), headR * 3, Paint()
        ..shader = RadialGradient(colors: [
          Colors.white.withValues(alpha: op * 0.3),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: headR * 3)));
      canvas.drawCircle(Offset(cx, cy), headR, Paint()
        ..color = Colors.white.withValues(alpha: op * 0.9));
    }
  }

  // ──────────── STAGE 3: STELLAR CLUSTER ────────────
  void _paintStellarCluster(Canvas canvas, Offset c, double scale, double t, double op) {
    if (scale < 0.02) return;
    final rng = math.Random(101);
    final p = Paint()..style = PaintingStyle.fill;

    // Interstellar gas clouds — 10
    for (int i = 0; i < 10; i++) {
      final ga = rng.nextDouble() * 2 * math.pi;
      final gd = (40 + rng.nextDouble() * 200) * scale;
      if (gd < 0.5) continue;
      final gx = c.dx + math.cos(ga) * gd;
      final gy = c.dy + math.sin(ga) * gd * 0.6;
      final gr = (12 + rng.nextDouble() * 40) * scale;
      if (gr < 0.3) continue;
      final gCols = [
        const Color(0xFF1080E0), const Color(0xFF0060B0), const Color(0xFF2090FF),
        const Color(0xFF003060), const Color(0xFF40A0FF),
      ];
      p.shader = RadialGradient(colors: [
        gCols[i % gCols.length].withValues(alpha: op * 0.07),
        Colors.transparent,
      ], stops: const [0, 1]).createShader(Rect.fromCircle(center: Offset(gx, gy), radius: gr));
      canvas.drawCircle(Offset(gx, gy), gr, p);
    }

    // Massive star field — 700 stars
    for (int i = 0; i < 700; i++) {
      final sa = rng.nextDouble() * 2 * math.pi;
      final sd = (8 + rng.nextDouble() * 260) * scale;
      if (sd < 0.3) continue;

      final scatter = (rng.nextDouble() - 0.5) * 18 * scale;
      final px = c.dx + sd * math.cos(sa) + scatter;
      final py = c.dy + sd * math.sin(sa) * 0.55 + scatter * 0.3;
      final pr = (0.3 + rng.nextDouble() * 2.8) * scale;
      if (pr < 0.06) continue;

      // Star color by temperature
      final tmp = rng.nextDouble();
      Color sc;
      if (tmp < 0.1) sc = const Color(0xFF6688FF);       // O-type (blue supergiant)
      else if (tmp < 0.2) sc = const Color(0xFF88AAFF);   // B-type
      else if (tmp < 0.35) sc = const Color(0xFFAACCFF);  // A-type
      else if (tmp < 0.55) sc = Colors.white;              // F/G-type
      else if (tmp < 0.7) sc = const Color(0xFFFFF0D0);   // K-type
      else if (tmp < 0.85) sc = const Color(0xFFFFCC70);  // M-type (red dwarf)
      else sc = const Color(0xFFFF8844);                   // M-type (bright)

      final twinkle = (0.35 + math.sin(t * (0.8 + rng.nextDouble() * 2.5) + i * 0.5) * 0.3).clamp(0.1, 0.9);
      p.color = sc.withValues(alpha: op * twinkle);

      // Glow for large stars
      if (pr > 0.4 * scale) {
        canvas.drawCircle(Offset(px, py), pr * 3, Paint()
          ..shader = RadialGradient(colors: [
            sc.withValues(alpha: op * twinkle * 0.12),
            Colors.transparent,
          ]).createShader(Rect.fromCircle(center: Offset(px, py), radius: pr * 3)));
      }
      canvas.drawCircle(Offset(px, py), pr, p);

      // Pulsars (bright stars with cross-shaped rays)
      if (rng.nextDouble() < 0.008 && sd < 100 * scale && pr > 0.5 * scale) {
        final pulseA = (0.3 + math.sin(t * 4 + i) * 0.2).clamp(0.1, 0.6);
        final rayLen = pr * 6;
        final rayP = Paint()..style = PaintingStyle.stroke..strokeWidth = 0.3 * scale
          ..color = sc.withValues(alpha: op * pulseA)..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(px, py - rayLen), Offset(px, py + rayLen), rayP);
        canvas.drawLine(Offset(px - rayLen, py), Offset(px + rayLen, py), rayP);
      }

      // Binary stars
      if (rng.nextDouble() < 0.04 && sd < 120 * scale) {
        final ba = rng.nextDouble() * 2 * math.pi;
        final bd = pr * 2.5;
        final bx = px + math.cos(ba) * bd;
        final by = py + math.sin(ba) * bd * 0.55;
        final br = pr * 0.5;
        p.color = sc.withValues(alpha: op * twinkle * 0.6);
        canvas.drawCircle(Offset(bx, by), br, p);
        // Faint line connecting binary pair
        canvas.drawLine(Offset(px, py), Offset(bx, by), Paint()
          ..style = PaintingStyle.stroke..strokeWidth = 0.15 * scale
          ..color = sc.withValues(alpha: op * 0.05));
      }
    }
  }

  // ──────────── STAGE 4: OUR SPIRAL GALAXY ────────────
  void _paintOurGalaxy(Canvas canvas, Offset c, double scale, double t, double op) {
    if (scale < 0.02) return;
    final rot = t * 0.01;

    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(rot);
    canvas.scale(1.0, 0.42);

    final rng = math.Random(888);
    final p = Paint()..style = PaintingStyle.fill;
    final bulgeR = 50 * scale;

    // === GALACTIC HALO (faint outer glow) ===
    canvas.drawCircle(Offset.zero, bulgeR * 6, Paint()
      ..shader = RadialGradient(colors: [
        _blue.withValues(alpha: op * 0.04),
        Colors.transparent,
      ], stops: const [0, 1]).createShader(Rect.fromCircle(center: Offset.zero, radius: bulgeR * 6)));

    // === GALACTIC BULGE — 3 layers of warm glow ===
    canvas.drawCircle(Offset.zero, bulgeR * 3, Paint()
      ..shader = RadialGradient(colors: [
        const Color(0xFFFFE8C0).withValues(alpha: op * 0.1),
        const Color(0xFF1080E0).withValues(alpha: op * 0.02),
        Colors.transparent,
      ], stops: const [0, 0.35, 1]).createShader(Rect.fromCircle(center: Offset.zero, radius: bulgeR * 3)));

    canvas.drawCircle(Offset.zero, bulgeR * 1.5, Paint()
      ..shader = RadialGradient(colors: [
        const Color(0xFFFFF5E0).withValues(alpha: op * 0.25),
        const Color(0xFFFFE0A0).withValues(alpha: op * 0.08),
        Colors.transparent,
      ], stops: const [0, 0.3, 1]).createShader(Rect.fromCircle(center: Offset.zero, radius: bulgeR * 1.5)));

    // Core — blazing white-gold
    canvas.drawCircle(Offset.zero, bulgeR * 0.5, Paint()
      ..shader = RadialGradient(colors: [
        Colors.white.withValues(alpha: op * 0.95),
        const Color(0xFFFFF0C0).withValues(alpha: op * 0.8),
        const Color(0xFFFFD060).withValues(alpha: op * 0.5),
        _blue.withValues(alpha: op * 0.2),
      ], stops: const [0, 0.25, 0.55, 1]).createShader(Rect.fromCircle(center: Offset.zero, radius: bulgeR * 0.5)));

    // Core stars — dense population
    final cp = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 120; i++) {
      final sa = rng.nextDouble() * 2 * math.pi;
      final sd = rng.nextDouble() * bulgeR * 0.7;
      final sx = math.cos(sa) * sd;
      final sy = math.sin(sa) * sd;
      final sr = (0.2 + rng.nextDouble() * 1.2) * scale;
      final t2 = rng.nextDouble();
      Color sc;
      if (t2 < 0.3) sc = const Color(0xFFFFF0D0);
      else if (t2 < 0.6) sc = const Color(0xFFFFD070);
      else sc = Colors.white;
      cp.color = sc.withValues(alpha: op * (0.4 + rng.nextDouble() * 0.4));
      canvas.drawCircle(Offset(sx, sy), sr, cp);
    }

    // === SPIRAL ARMS — 4 arms, each with 3 layers ===
    final armCount = 4;
    for (int arm = 0; arm < armCount; arm++) {
      final baseAngle = (arm / armCount) * 2 * math.pi;

      // Layer 0: Dense star backbone
      _paintArmLayer(canvas, baseAngle, 400, scale, bulgeR, rng, t, op, 3.5, 1.0, true);

      // Layer 1: Diffuse stars + dust
      _paintArmLayer(canvas, baseAngle + 0.12, 250, scale, bulgeR, rng, t, op, 6.0, 0.65, false);

      // Layer 2: Outer wisps
      _paintArmLayer(canvas, baseAngle + 0.25, 150, scale, bulgeR, rng, t, op, 10.0, 0.35, false);

      // Dark dust lane (inside each arm)
      _paintDustLane(canvas, baseAngle, scale, bulgeR, rng, t, op);

      // H-II regions (pink nebulae in arms)
      for (int hi = 0; hi < 20; hi++) {
        final hf = 0.12 + rng.nextDouble() * 0.65;
        final hd = (25 + hf * 180) * scale;
        if (hd < 0.5) continue;
        final hAngle = baseAngle + hf * 6.5 + rng.nextDouble() * 0.3 - 0.15;
        final hx = math.cos(hAngle) * hd + (rng.nextDouble() - 0.5) * 5 * scale;
        final hy = math.sin(hAngle) * hd + (rng.nextDouble() - 0.5) * 3 * scale;
        final hr = (3 + rng.nextDouble() * 7) * scale;
        if (hr < 0.2) continue;
        final hAlpha = op * 0.12 * (1 - hf * 0.4);
        canvas.drawCircle(Offset(hx, hy), hr, Paint()
          ..shader = RadialGradient(colors: [
            const Color(0xFFFF6B8A).withValues(alpha: hAlpha),
            const Color(0xFFFF3060).withValues(alpha: hAlpha * 0.4),
            Colors.transparent,
          ], stops: const [0, 0.4, 1]).createShader(Rect.fromCircle(center: Offset(hx, hy), radius: hr)));

        // Bright newborn stars inside H-II
        for (int ns = 0; ns < 3; ns++) {
          final na = rng.nextDouble() * 2 * math.pi;
          final nd = rng.nextDouble() * hr * 0.5;
          cp.color = const Color(0xFFAADDFF).withValues(alpha: op * 0.7);
          canvas.drawCircle(Offset(hx + math.cos(na) * nd, hy + math.sin(na) * nd), (0.3 + rng.nextDouble() * 0.5) * scale, cp);
        }
      }
    }

    // === GALACTIC RING / BAR STRUCTURE ===
    for (int i = 0; i < 3; i++) {
      final rr = bulgeR * (3.8 + i * 0.5);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: rr * 2, height: rr * 2 * 0.04),
        Paint()..style = PaintingStyle.stroke..strokeWidth = (1.5 - i * 0.3) * scale
          ..color = _blue.withValues(alpha: op * (0.06 - i * 0.015)));
    }

    // === MASSIVE BACKGROUND STAR FIELD INSIDE GALAXY ===
    for (int i = 0; i < 300; i++) {
      final sa = rng.nextDouble() * 2 * math.pi;
      final sd = (bulgeR * 0.5 + rng.nextDouble() * bulgeR * 4.5);
      final sx = math.cos(sa) * sd;
      final sy = math.sin(sa) * sd;
      final sr = (0.15 + rng.nextDouble() * 0.6) * scale;
      if (sr < 0.04) continue;
      final distFade = (1 - sd / (bulgeR * 5)).clamp(0.1, 1.0);
      cp.color = Colors.white.withValues(alpha: op * 0.15 * distFade);
      canvas.drawCircle(Offset(sx, sy), sr, cp);
    }

    canvas.restore();
  }

  void _paintArmLayer(Canvas canvas, double baseAngle, int count, double scale,
      double bulgeR, math.Random rng, double t, double op, double width, double alphaMult, bool hasGlow) {
    final p = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final factor = (i + rng.nextDouble() * 0.5) / count;
      final dist = (15 + factor * 210) * scale;
      if (dist < 0.5) continue;

      final spiralAngle = baseAngle + factor * 6.5;
      final scatter = (rng.nextDouble() - 0.5) * width * scale * (1 + factor * 0.4);
      final px = dist * math.cos(spiralAngle) + scatter * math.cos(spiralAngle + 1.5);
      final py = dist * math.sin(spiralAngle) + scatter * math.sin(spiralAngle + 1.5);
      final pr = (0.2 + rng.nextDouble() * 2.0) * scale;
      if (pr < 0.05) continue;

      final distFade = (1 - factor * 0.55).clamp(0.2, 1.0);
      final twinkle = (0.4 + math.sin(t * 0.4 + i * 0.25 + baseAngle) * 0.3).clamp(0.1, 0.85);

      final tmp = rng.nextDouble();
      Color sc;
      if (tmp < 0.08) sc = const Color(0xFF6699FF);
      else if (tmp < 0.2) sc = const Color(0xFF99CCFF);
      else if (tmp < 0.5) sc = Colors.white;
      else if (tmp < 0.72) sc = const Color(0xFFFFF0D0);
      else if (tmp < 0.88) sc = const Color(0xFFFFD070);
      else sc = const Color(0xFFFF8844);

      final finalAlpha = op * twinkle * distFade * alphaMult;
      p.color = sc.withValues(alpha: finalAlpha);

      if (hasGlow && pr > 0.5 * scale) {
        canvas.drawCircle(Offset(px, py), pr * 3.5, Paint()
          ..shader = RadialGradient(colors: [
            sc.withValues(alpha: finalAlpha * 0.1),
            Colors.transparent,
          ]).createShader(Rect.fromCircle(center: Offset(px, py), radius: pr * 3.5)));
      }

      canvas.drawCircle(Offset(px, py), pr, p);
    }
  }

  void _paintDustLane(Canvas canvas, double baseAngle, double scale,
      double bulgeR, math.Random rng, double t, double op) {
    final dustP = Paint()..style = PaintingStyle.fill;
    final count = 80;
    for (int i = 0; i < count; i++) {
      final factor = (i + 0.5) / count;
      final dist = (20 + factor * 190) * scale;
      if (dist < 0.5) continue;
      final angle = baseAngle + factor * 6.5 - 0.2;
      final dx = math.cos(angle) * dist;
      final dy = math.sin(angle) * dist;
      final dr = (2 + rng.nextDouble() * 6) * scale * (0.5 + factor * 0.5);
      if (dr < 0.2) continue;
      final a = op * 0.06 * (1 - factor * 0.3);
      dustP.shader = RadialGradient(colors: [
        const Color(0xFF2A1A00).withValues(alpha: a),
        Colors.transparent,
      ], stops: const [0, 1]).createShader(Rect.fromCircle(center: Offset(dx, dy), radius: dr));
      canvas.drawCircle(Offset(dx, dy), dr, dustP);
    }
  }

  // ──────────── STAGE 5: INFINITE UNIVERSE ────────────
  void _paintUniverseField(Canvas canvas, Size size, Offset c, double scale, double t, double op) {
    if (scale < 0.003) return;
    final rng = math.Random(999);
    final p = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 100; i++) {
      final gx = rng.nextDouble() * size.width;
      final gy = rng.nextDouble() * size.height;
      final dx = (gx - c.dx) * (scale * 0.018) + c.dx;
      final dy = (gy - c.dy) * (scale * 0.018) + c.dy;

      final int type = rng.nextInt(4); // 0=spiral, 1=elliptical, 2=irregular, 3=interacting pair
      final gr = (6 + rng.nextDouble() * 35) * scale * 0.05;
      if (gr < 0.2) continue;

      final galT = t * 0.02 + i * 1.3;
      final c1 = rng.nextBool() ? _blue : _lightBlue;
      final c2 = rng.nextBool() ? const Color(0xFFFFE8C0) : _brightBlue;

      // Galaxy envelope glow
      canvas.drawCircle(Offset(dx, dy), gr * 2.5, Paint()
        ..shader = RadialGradient(colors: [
          c1.withValues(alpha: op * 0.1),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(center: Offset(dx, dy), radius: gr * 2.5)));

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(galT);

      if (type == 0) {
        // ═══ SPIRAL GALAXY ═══
        final arms = 2 + rng.nextInt(2);
        for (int arm = 0; arm < arms; arm++) {
          final armA = (arm / arms) * math.pi * 2;
          for (int j = 0; j < 30; j++) {
            final f = (j + 0.5) / 30;
            final d2 = f * gr;
            final sa = armA + f * 1.8 + galT * 0.04;
            final mx = math.cos(sa) * d2 + (rng.nextDouble() - 0.5) * gr * 0.12;
            final my = math.sin(sa) * d2 * 0.38 + (rng.nextDouble() - 0.5) * gr * 0.06;
            p.color = c2.withValues(alpha: op * (0.25 + rng.nextDouble() * 0.25) * (1 - f * 0.5));
            canvas.drawCircle(Offset(mx, my), gr * (0.02 + rng.nextDouble() * 0.03), p);
          }
        }
        // Dust lane
        for (int j = 0; j < 10; j++) {
          final f = (j + 0.5) / 10;
          final d2 = f * gr * 0.8;
          final sa = f * 1.2;
          p.color = const Color(0xFF1A0D00).withValues(alpha: op * 0.12);
          canvas.drawCircle(Offset(math.cos(sa) * d2, math.sin(sa) * d2 * 0.38), gr * 0.04, p);
        }
      } else if (type == 1) {
        // ═══ ELLIPTICAL GALAXY ═══
        for (int j = 0; j < 40; j++) {
          final ea = rng.nextDouble() * 2 * math.pi;
          final ed = rng.nextDouble() * gr * 0.85;
          final ex = math.cos(ea) * ed;
          final ey = math.sin(ea) * ed * (0.5 + rng.nextDouble() * 0.3);
          final warmT = rng.nextDouble();
          Color ec;
          if (warmT < 0.3) ec = const Color(0xFFFFF0D0);
          else if (warmT < 0.6) ec = const Color(0xFFFFD070);
          else ec = Colors.white;
          p.color = ec.withValues(alpha: op * (0.15 + rng.nextDouble() * 0.25));
          canvas.drawCircle(Offset(ex, ey), gr * (0.015 + rng.nextDouble() * 0.025), p);
        }
      } else if (type == 2) {
        // ═══ IRREGULAR GALAXY ═══
        final verts = 8 + rng.nextInt(6);
        final path = Path();
        for (int j = 0; j < verts; j++) {
          final ia = (j / verts) * 2 * math.pi;
          final ir = gr * (0.3 + rng.nextDouble() * 0.6);
          final ix = math.cos(ia) * ir;
          final iy = math.sin(ia) * ir * (0.4 + rng.nextDouble() * 0.3);
          if (j == 0) path.moveTo(ix, iy);
          else path.lineTo(ix, iy);
        }
        path.close();
        p.color = c1.withValues(alpha: op * 0.12);
        canvas.drawPath(path, p);
        for (int j = 0; j < 15; j++) {
          final ia = rng.nextDouble() * 2 * math.pi;
          final ir = rng.nextDouble() * gr * 0.7;
          p.color = c2.withValues(alpha: op * (0.2 + rng.nextDouble() * 0.2));
          canvas.drawCircle(Offset(math.cos(ia) * ir, math.sin(ia) * ir * 0.5), gr * 0.025, p);
        }
      } else {
        // ═══ INTERACTING PAIR ═══
        final offset2 = gr * 0.5;
        for (int g = 0; g < 2; g++) {
          final gx2 = g == 0 ? -offset2 : offset2;
          for (int j = 0; j < 20; j++) {
            final ja = rng.nextDouble() * 2 * math.pi;
            final jd = rng.nextDouble() * gr * 0.4;
            p.color = c2.withValues(alpha: op * (0.2 + rng.nextDouble() * 0.2));
            canvas.drawCircle(Offset(gx2 + math.cos(ja) * jd, math.sin(ja) * jd * 0.4), gr * 0.02, p);
          }
          canvas.drawCircle(Offset(gx2, 0), gr * 0.08, p..color = Colors.white.withValues(alpha: op * 0.7));
        }
        // Tidal tail / bridge
        final bridgeP = Paint()..style = PaintingStyle.stroke..strokeWidth = 0.3 * scale
          ..color = c1.withValues(alpha: op * 0.15);
        canvas.drawLine(Offset(-offset2, 0), Offset(offset2, 0), bridgeP);
      }

      // Core nucleus for all galaxy types
      p.color = Colors.white.withValues(alpha: op * 0.85);
      canvas.drawCircle(Offset.zero, gr * 0.1, p);
      canvas.drawCircle(Offset.zero, gr * 0.25, Paint()
        ..shader = RadialGradient(colors: [
          c2.withValues(alpha: op * 0.3),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(center: Offset.zero, radius: gr * 0.25)));

      canvas.restore();
    }
  }

  // ──────────── SHOOTING STARS ────────────
  void _paintShootingStars(Canvas canvas, Size size, double t) {
    final rng = math.Random(7777);
    final p = Paint()..strokeCap = StrokeCap.round;
    for (int i = 0; i < 5; i++) {
      final cycle = (t * 0.12 + i * 27.3) % 25.0;
      if (cycle > 1.8) continue;
      final progress = cycle / 1.8;
      final sx = rng.nextDouble() * size.width * 0.8 + size.width * 0.1;
      final sy = rng.nextDouble() * size.height * 0.4;
      final angle = -0.35 - rng.nextDouble() * 0.35;
      final len = 80 + rng.nextDouble() * 150;
      final ex = sx + math.cos(angle) * len * progress;
      final ey = sy + math.sin(angle) * len * progress;
      final alpha = (1 - progress) * 0.75;

      final rect = Rect.fromPoints(Offset(sx, sy), Offset(ex, ey));
      p..shader = LinearGradient(colors: [
        Colors.white.withValues(alpha: alpha),
        _lightBlue.withValues(alpha: alpha * 0.3),
        Colors.transparent,
      ]).createShader(rect)..strokeWidth = 1.5;
      canvas.drawLine(Offset(sx, sy), Offset(ex, ey), p);

      // Head glow
      canvas.drawCircle(Offset(ex, ey), 2.5, Paint()
        ..shader = RadialGradient(colors: [
          Colors.white.withValues(alpha: alpha * 0.8),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(center: Offset(ex, ey), radius: 2.5)));
    }
  }

  void _paintScrollHint(Canvas canvas, Offset c, double offset, double op) {
    if (op <= 0) return;
    final pulse = 5 * math.sin(time * 3);
    final y = c.dy + offset + pulse;

    canvas.drawPath(Path()
      ..moveTo(c.dx - 12, y - 8)
      ..lineTo(c.dx, y)
      ..lineTo(c.dx + 12, y - 8),
      Paint()..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round
        ..color = _blue.withValues(alpha: op * 0.8));

    TextPainter(
      text: TextSpan(
        text: tr('انزل للأسفل لاستكشاف أبعادنا', 'Scroll down to explore our bounds'),
        style: TextStyle(color: _blue.withValues(alpha: op * 0.7), fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
      ),
      textDirection: TextDirection.ltr,
    )..layout()..paint(canvas, Offset(c.dx - 60, y - 30));
  }

  @override
  bool shouldRepaint(covariant _UltraCosmicPainter old) => old.time != time || old.depth != depth;
}

class _Planet {
  final double orbitR, speed, r;
  final Color color;
  final int rings;
  final bool hasMoon, hasBands;
  const _Planet(this.orbitR, this.speed, this.r, this.color,
      {this.rings = 0, this.hasMoon = false, this.hasBands = false});
}
