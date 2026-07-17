import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../components.dart';
import '../portal/cosmic_painter.dart';

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
    final offset = _scrollCtrl.offset;
    setState(() {
      _scrollDepth = (offset / 600).clamp(0.0, 20.0);
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
                  painter: CosmicPainter(
                    time: _timeCtrl.value * 120,
                    scrollDepth: _scrollDepth,
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: EdgeInsets.zero,
              itemCount: 200,
              itemBuilder: (context, index) {
                return _CosmicSection(
                  index: index,
                  time: _timeCtrl,
                  scrollDepth: _scrollDepth,
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
                  alignment: Alignment(0, (_scrollDepth / 20.0 * 2 - 1).clamp(-1.0, 1.0)),
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
                    '${(_scrollDepth * 100 / 20).toInt()}%',
                    style: const TextStyle(
                      color: Color(0xFF3FD2FF),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace',
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

  String _getZoneLabel(int zone, bool isAr) {
    const labelsAr = ['البوابة', 'الكون', 'الأعماق', 'السديم', 'النجمي', 'اللانهاية'];
    const labelsEn = ['Gate', 'Cosmos', 'Depths', 'Nebula', 'Stellar', 'Infinite'];
    return isAr
        ? labelsAr[(zone ~/ 4).clamp(0, labelsAr.length - 1)]
        : labelsEn[(zone ~/ 4).clamp(0, labelsEn.length - 1)];
  }
}

class _CosmicSection extends StatelessWidget {
  final int index;
  final AnimationController time;
  final double scrollDepth;

  const _CosmicSection({
    required this.index,
    required this.time,
    required this.scrollDepth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: time,
              builder: (context, _) {
                return CustomPaint(
                  painter: _SectionDecorPainter(
                    time: time.value * 120,
                    index: index,
                    scrollDepth: scrollDepth,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionDecorPainter extends CustomPainter {
  final double time;
  final int index;
  final double scrollDepth;

  _SectionDecorPainter({
    required this.time,
    required this.index,
    required this.scrollDepth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(index * 7919 + scrollDepth.floor() * 13);
    final t = time;
    final center = Offset(size.width / 2, size.height / 2);
    final colors = _getColors();

    // Floating geometric shapes per section
    for (int i = 0; i < 8; i++) {
      final x = size.width * (0.1 + rng.nextDouble() * 0.8);
      final y = size.height * (0.1 + rng.nextDouble() * 0.8);
      final drift = math.sin(t * 0.3 + i * 1.5 + index * 0.5) * 20;
      final driftY = math.cos(t * 0.25 + i * 1.2) * 15;
      final r = 15 + rng.nextDouble() * 40;
      final alpha = (0.04 + math.sin(t * 0.4 + i + index * 0.3) * 0.03).clamp(0.01, 0.08);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = colors[i % colors.length].withValues(alpha: alpha);

      final shapeX = x + drift;
      final shapeY = y + driftY;

      switch (i % 5) {
        case 0: // Circle
          canvas.drawCircle(Offset(shapeX, shapeY), r, paint);
          break;
        case 1: // Hexagon
          final path = Path();
          for (int j = 0; j <= 6; j++) {
            final angle = (j / 6) * 2 * math.pi + t * 0.1;
            final px = shapeX + math.cos(angle) * r;
            final py = shapeY + math.sin(angle) * r;
            if (j == 0) path.moveTo(px, py);
            else path.lineTo(px, py);
          }
          canvas.drawPath(path, paint);
          break;
        case 2: // Triangle
          final path = Path();
          for (int j = 0; j < 3; j++) {
            final angle = (j / 3) * 2 * math.pi + t * 0.15;
            final px = shapeX + math.cos(angle) * r;
            final py = shapeY + math.sin(angle) * r;
            if (j == 0) path.moveTo(px, py);
            else path.lineTo(px, py);
          }
          path.close();
          canvas.drawPath(path, paint);
          break;
        case 3: // Diamond
          final path = Path()
            ..moveTo(shapeX, shapeY - r)
            ..lineTo(shapeX + r * 0.6, shapeY)
            ..lineTo(shapeX, shapeY + r)
            ..lineTo(shapeX - r * 0.6, shapeY)
            ..close();
          canvas.drawPath(path, paint);
          break;
        case 4: // Small planet with ring
          canvas.drawCircle(Offset(shapeX, shapeY), r * 0.3, paint);
          canvas.save();
          canvas.translate(shapeX, shapeY);
          canvas.rotate(0.3 + t * 0.05);
          canvas.drawOval(
            Rect.fromCenter(center: Offset.zero, width: r * 0.8, height: r * 0.2),
            paint,
          );
          canvas.restore();
          break;
      }
    }

    // Connection lines between nearby shapes (subtle network)
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3;

    final points = <Offset>[];
    for (int i = 0; i < 8; i++) {
      final x = size.width * (0.1 + rng.nextDouble() * 0.8) + math.sin(t * 0.3 + i * 1.5) * 20;
      final y = size.height * (0.1 + rng.nextDouble() * 0.8) + math.cos(t * 0.25 + i * 1.2) * 15;
      points.add(Offset(x, y));
    }

    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final dist = (points[i] - points[j]).distance;
        if (dist < 200) {
          final alpha = (1 - dist / 200) * 0.04;
          linePaint.color = colors[0].withValues(alpha: alpha);
          canvas.drawLine(points[i], points[j], linePaint);
        }
      }
    }
  }

  List<Color> _getColors() {
    final d = scrollDepth;
    if (d < 4) return [const Color(0xFF3FD2FF), const Color(0xFFA78BFA), const Color(0xFF8FF2FF)];
    if (d < 8) return [const Color(0xFFAD00FF), const Color(0xFF58A6FF), const Color(0xFFD2A8FF)];
    if (d < 12) return [const Color(0xFFF78166), const Color(0xFFFFB020), const Color(0xFFFFA657)];
    if (d < 16) return [const Color(0xFF3FB950), const Color(0xFF3FD2FF), const Color(0xFF56D364)];
    return [const Color(0xFFFF6B6B), const Color(0xFFD2A8FF), const Color(0xFFFF2A85)];
  }

  @override
  bool shouldRepaint(covariant _SectionDecorPainter old) =>
      old.time != time || old.index != index || old.scrollDepth != scrollDepth;
}
