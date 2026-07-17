import 'package:flutter/material.dart';
import '../components.dart';

class ProjectShowcasePage extends StatelessWidget {
  final String titleAr;
  final String titleEn;
  final String categoryAr;
  final String categoryEn;
  final String descriptionAr;
  final String descriptionEn;
  final List<String> featuresAr;
  final List<String> featuresEn;
  final String metricsLabel;
  final int metricsValue;
  final Color color;
  final Color color2;
  final VoidCallback onBack;
  final VoidCallback onContact;

  const ProjectShowcasePage({
    super.key,
    required this.titleAr,
    required this.titleEn,
    required this.categoryAr,
    required this.categoryEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.featuresAr,
    required this.featuresEn,
    required this.metricsLabel,
    required this.metricsValue,
    required this.color,
    required this.color2,
    required this.onBack,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = LanguageManager.instance.isArabic;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero(size, isAr),
            _buildAbout(isAr),
            _buildFeatures(isAr),
            _buildMetrics(isAr),
            _buildCTA(isAr),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(Size size, bool isAr) {
    return Container(
      height: size.height * 0.7,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.15),
                    const Color(0xFF090D16),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _ProjectHeroPainter(color: color, color2: color2),
            ),
          ),
          Positioned(
            top: 24,
            left: 24,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onBack,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141A29).withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, color: color, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        tr('رجوع', 'Back'),
                        style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                      color: color.withValues(alpha: 0.1),
                    ),
                    child: Text(
                      isAr ? categoryAr : categoryEn,
                      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isAr ? titleAr : titleEn,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width > 600 ? 48 : 32,
                      fontWeight: FontWeight.w900,
                      foreground: Paint()
                        ..shader = LinearGradient(colors: [color, color2])
                            .createShader(const Rect.fromLTWH(0, 0, 400, 60)),
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

  Widget _buildAbout(bool isAr) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color, color2]),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                tr('عن المشروع', 'About the Project'),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                isAr ? descriptionAr : descriptionEn,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17, color: Color(0xFFA6ABB6), height: 1.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatures(bool isAr) {
    final features = isAr ? featuresAr : featuresEn;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFF141A29).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('المميزات الرئيسية', 'Key Features'),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: features.map((f) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.15)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline, color: color, size: 18),
                  const SizedBox(width: 10),
                  Text(f, style: const TextStyle(color: Color(0xFFA6ABB6), fontSize: 14)),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics(bool isAr) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$metricsValue+',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            metricsLabel,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFFA6ABB6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTA(bool isAr) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 60),
      child: Center(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onContact,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color, color2]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 24,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.chat, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    tr('ابدأ مشرو similar', 'Start Your Similar Project'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF141A29))),
      ),
      child: const Center(
        child: Text(
          '© 2025 CodeMaster',
          style: TextStyle(fontSize: 13, color: Color(0xFFA6ABB6)),
        ),
      ),
    );
  }
}

class _ProjectHeroPainter extends CustomPainter {
  final Color color;
  final Color color2;

  _ProjectHeroPainter({required this.color, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.0;
    final rng = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < 40; i++) {
      final x = (i * 37 + rng) % size.width.toInt().toDouble();
      final y = (i * 53 + rng) % size.height.toInt().toDouble();
      final r = 2.0 + (i % 5);
      final alpha = 0.05 + (i % 10) * 0.01;

      paint.color = (i % 2 == 0 ? color : color2).withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    final cx = size.width / 2;
    final cy = size.height / 2;
    for (int ring = 0; ring < 4; ring++) {
      final r = 80.0 + ring * 60;
      paint.color = color.withValues(alpha: 0.06 - ring * 0.012);
      canvas.drawCircle(Offset(cx, cy), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ProjectHeroPainter old) => false;
}
