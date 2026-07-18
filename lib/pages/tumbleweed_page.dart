import 'dart:math';
import 'package:flutter/material.dart';
import '../components.dart';

class TumbleweedPage extends StatefulWidget {
  final VoidCallback onBack;
  const TumbleweedPage({super.key, required this.onBack});

  @override
  State<TumbleweedPage> createState() => _TumbleweedPageState();
}

class _TumbleweedPageState extends State<TumbleweedPage>
    with TickerProviderStateMixin {
  late final AnimationController _driftCtrl;
  late final AnimationController _rotateCtrl;
  late final AnimationController _fadeInCtrl;
  late final AnimationController _wahCtrl;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _dustCtrl;

  @override
  void initState() {
    super.initState();
    _driftCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _fadeInCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
    _wahCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..forward();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _dustCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _driftCtrl.dispose();
    _rotateCtrl.dispose();
    _fadeInCtrl.dispose();
    _wahCtrl.dispose();
    _shimmerCtrl.dispose();
    _dustCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: Stack(
        children: [
          // Desert sky gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A0E05),
                    Color(0xFF2D1810),
                    Color(0xFF4A2A15),
                    Color(0xFF6B3A1A),
                    Color(0xFF8B5A2B),
                  ],
                ),
              ),
            ),
          ),

          // Heat shimmer effect
          AnimatedBuilder(
            animation: _shimmerCtrl,
            builder: (_, __) => Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, 0.3 + sin(_shimmerCtrl.value * pi) * 0.1),
                    radius: 1.5,
                    colors: [
                      const Color(0xFFD4A050).withValues(alpha: 0.08 + sin(_shimmerCtrl.value * pi) * 0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Sand dunes
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.4,
            child: CustomPaint(
              painter: _SandDunePainter(
                color1: const Color(0xFF8B5A2B),
                color2: const Color(0xFF6B3A1A),
              ),
            ),
          ),

          // Dust particles
          AnimatedBuilder(
            animation: _dustCtrl,
            builder: (_, __) => Positioned.fill(
              child: CustomPaint(
                painter: _DustPainter(time: _dustCtrl.value * 10),
              ),
            ),
          ),

          // Tumbleweed
          AnimatedBuilder(
            animation: _driftCtrl,
            builder: (_, __) {
              final t = _driftCtrl.value;
              final x = size.width + 100 - (t * (size.width + 300));
              final y = size.height * 0.68 + sin(t * pi * 4) * 12;
              return Positioned(
                left: x,
                top: y,
                child: AnimatedBuilder(
                  animation: _rotateCtrl,
                  builder: (_, __) => Transform.rotate(
                    angle: _rotateCtrl.value * pi * 2,
                    child: CustomPaint(
                      size: const Size(70, 70),
                      painter: _TumbleweedPainter(
                        opacity: 0.9,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Second tumbleweed (smaller, background)
          AnimatedBuilder(
            animation: _driftCtrl,
            builder: (_, __) {
              final t = (_driftCtrl.value + 0.4) % 1.0;
              final x = size.width + 60 - (t * (size.width + 200));
              final y = size.height * 0.62 + sin(t * pi * 3) * 8;
              return Positioned(
                left: x,
                top: y,
                child: AnimatedBuilder(
                  animation: _rotateCtrl,
                  builder: (_, __) => Transform.rotate(
                    angle: -_rotateCtrl.value * pi * 2,
                    child: Opacity(
                      opacity: 0.4,
                      child: CustomPaint(
                        size: const Size(40, 40),
                        painter: _TumbleweedPainter(opacity: 0.5),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Sun/heat orb
          Positioned(
            top: size.height * 0.08,
            right: size.width * 0.15,
            child: AnimatedBuilder(
              animation: _shimmerCtrl,
              builder: (_, __) => Container(
                width: 80 + sin(_shimmerCtrl.value * pi) * 8,
                height: 80 + sin(_shimmerCtrl.value * pi) * 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFFD080).withValues(alpha: 0.4),
                      const Color(0xFFD4A050).withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // WAH WAH WAH text
          Positioned(
            top: size.height * 0.12,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: CurvedAnimation(parent: _fadeInCtrl, curve: Curves.easeOut),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _wahCtrl,
                    builder: (_, __) {
                      final v = _wahCtrl.value;
                      return Column(
                        children: [
                          Opacity(
                            opacity: (v * 4).clamp(0.0, 1.0),
                            child: Text(
                              'وا',
                              style: TextStyle(
                                fontSize: isMobile ? 52 : 72,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFFFFD080),
                                shadows: const [
                                  Shadow(color: Color(0xFF000000), blurRadius: 20, offset: Offset(0, 4)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Opacity(
                            opacity: ((v - 0.2) * 4).clamp(0.0, 1.0),
                            child: Text(
                              'وا وا وا',
                              style: TextStyle(
                                fontSize: isMobile ? 42 : 60,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFFD4A050),
                                shadows: const [
                                  Shadow(color: Color(0xFF000000), blurRadius: 20, offset: Offset(0, 4)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Opacity(
                            opacity: ((v - 0.4) * 4).clamp(0.0, 1.0),
                            child: Text(
                              'وااااااااا',
                              style: TextStyle(
                                fontSize: isMobile ? 34 : 48,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF8B5A2B),
                                shadows: const [
                                  Shadow(color: Color(0xFF000000), blurRadius: 20, offset: Offset(0, 4)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Title
          Positioned(
            top: size.height * 0.38,
            left: 24,
            right: 24,
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _fadeInCtrl,
                curve: const Interval(0.3, 1.0),
              ),
              child: Column(
                children: [
                  Text(
                    tr('المشاريع التي لا نستطيع تنفيذها', 'Projects We Cannot Execute'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 22 : 32,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFFD080),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tr(
                      'عندما يطلب العميل شيئاً...',
                      'When the client asks for something...',
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 15 : 18,
                      color: const Color(0xFFD4A050).withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Funny "impossible projects" list
          Positioned(
            bottom: size.height * 0.45,
            left: 24,
            right: 24,
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _fadeInCtrl,
                curve: const Interval(0.6, 1.0),
              ),
              child: Column(
                children: [
                  _ImpossibleItem(
                    icon: Icons.rocket_launch,
                    text: tr(
                      'تطبيق يخلي الناس تطق الباب بدل الاتصال',
                      'An app that makes people knock instead of calling',
                    ),
                    delay: 0,
                  ),
                  _ImpossibleItem(
                    icon: Icons.psychology,
                    text: tr(
                      'نظام ذكاء اصطناعي يخلي القهوة تسوي نفسها',
                      'AI system that makes coffee by itself',
                    ),
                    delay: 200,
                  ),
                  _ImpossibleItem(
                    icon: Icons.flight,
                    text: tr(
                      'تطبيق يشحنك للoffice كل صباح',
                      'App that teleports you to office every morning',
                    ),
                    delay: 400,
                  ),
                  _ImpossibleItem(
                    icon: Icons.attach_money,
                    text: tr(
                      'موقع يطبع فلوس من الطابعة',
                      'Website that prints money from a printer',
                    ),
                    delay: 600,
                  ),
                  _ImpossibleItem(
                    icon: Icons.timer_off,
                    text: tr(
                      'برنامج يوقف الزمن قبل تسليم المشروع',
                      'Program that stops time before project deadline',
                    ),
                    delay: 800,
                  ),
                ],
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A0E05).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD4A050).withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.arrow_back, color: Color(0xFFD4A050), size: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpossibleItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final int delay;
  const _ImpossibleItem({required this.icon, required this.text, required this.delay});

  @override
  State<_ImpossibleItem> createState() => _ImpossibleItemState();
}

class _ImpossibleItemState extends State<_ImpossibleItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    Future.delayed(Duration(milliseconds: 1500 + widget.delay), () {
      if (mounted) {
        setState(() => _visible = true);
        _ctrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      child: Transform.translate(
        offset: Offset(0, _visible ? 0 : 20),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0E05).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFD4A050).withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: const Color(0xFFD4A050), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width < 600 ? 13 : 15,
                    color: const Color(0xFFD4A050).withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TumbleweedPainter extends CustomPainter {
  final double opacity;
  _TumbleweedPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final rng = Random(42);

    // Main circle
    final circlePaint = Paint()
      ..color = Color.fromRGBO(139, 90, 43, opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, circlePaint);

    // Inner tangled lines (like a tumbleweed)
    final tanglePaint = Paint()
      ..color = Color.fromRGBO(139, 90, 43, opacity * 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 24; i++) {
      final angle = (i / 24) * pi * 2;
      final r1 = radius * (0.3 + rng.nextDouble() * 0.5);
      final r2 = radius * (0.4 + rng.nextDouble() * 0.5);
      final a1 = angle + rng.nextDouble() * 0.5;
      final a2 = angle + 0.3 + rng.nextDouble() * 0.5;

      final p1 = Offset(center.dx + cos(a1) * r1, center.dy + sin(a1) * r1);
      final p2 = Offset(center.dx + cos(a2) * r2, center.dy + sin(a2) * r2);
      canvas.drawLine(p1, p2, tanglePaint);
    }

    // Spikes (thin branches sticking out)
    final spikePaint = Paint()
      ..color = Color.fromRGBO(139, 90, 43, opacity * 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < 16; i++) {
      final angle = (i / 16) * pi * 2;
      final inner = Offset(
        center.dx + cos(angle) * (radius * 0.7),
        center.dy + sin(angle) * (radius * 0.7),
      );
      final outer = Offset(
        center.dx + cos(angle) * (radius + 5 + rng.nextDouble() * 6),
        center.dy + sin(angle) * (radius + 5 + rng.nextDouble() * 6),
      );
      canvas.drawLine(inner, outer, spikePaint);
    }

    // Center fill
    final fillPaint = Paint()
      ..color = Color.fromRGBO(107, 58, 26, opacity * 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.5, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _TumbleweedPainter old) => old.opacity != opacity;
}

class _SandDunePainter extends CustomPainter {
  final Color color1;
  final Color color2;
  _SandDunePainter({required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    final path1 = Path();
    path1.moveTo(0, size.height * 0.3);
    path1.quadraticBezierTo(size.width * 0.2, size.height * 0.1, size.width * 0.4, size.height * 0.25);
    path1.quadraticBezierTo(size.width * 0.6, size.height * 0.4, size.width * 0.8, size.height * 0.15);
    path1.quadraticBezierTo(size.width * 0.95, size.height * 0.05, size.width, size.height * 0.2);
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    canvas.drawPath(path1, Paint()..color = color1);

    final path2 = Path();
    path2.moveTo(0, size.height * 0.5);
    path2.quadraticBezierTo(size.width * 0.3, size.height * 0.3, size.width * 0.5, size.height * 0.45);
    path2.quadraticBezierTo(size.width * 0.7, size.height * 0.6, size.width, size.height * 0.4);
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, Paint()..color = color2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DustPainter extends CustomPainter {
  final double time;
  _DustPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(77);
    final p = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 30; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final dx = sin(time * 0.2 + i * 1.3) * 40;
      final dy = cos(time * 0.15 + i * 0.9) * 20;
      final r = 1.0 + rng.nextDouble() * 2.5;
      p.color = Color.fromRGBO(212, 160, 80, 0.06 + sin(time * 0.3 + i) * 0.03);
      canvas.drawCircle(Offset(baseX + dx, baseY + dy), r, p);
    }
  }

  @override
  bool shouldRepaint(covariant _DustPainter old) => old.time != time;
}
