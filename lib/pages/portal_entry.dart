import 'package:flutter/material.dart';
import '../components.dart';
import '../portal/generative_painter.dart';

class PortalEntryPage extends StatefulWidget {
  final VoidCallback onEnter;
  final VoidCallback onBack;

  const PortalEntryPage({
    super.key,
    required this.onEnter,
    required this.onBack,
  });

  @override
  State<PortalEntryPage> createState() => _PortalEntryPageState();
}

class _PortalEntryPageState extends State<PortalEntryPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _timeCtrl;
  late final AnimationController _pulseCtrl;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _timeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timeCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isAr = LanguageManager.instance.isArabic;

    return Scaffold(
      backgroundColor: const Color(0xFF010409),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_timeCtrl, _pulseCtrl]),
            builder: (context, _) {
              return CustomPaint(
                painter: PortalVisualPainter(
                  time: _timeCtrl.value * 60,
                  depth: 0.0,
                  seed: 42,
                ),
                size: size,
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.1),
                radius: 1.2,
                colors: [
                  const Color(0xFF3FD2FF).withValues(alpha: 0.04 + _pulseCtrl.value * 0.03),
                  Colors.transparent,
                ],
              ),
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
                    color: const Color(0xFF141A29).withValues(alpha: 0.6),
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
                        tr('الرئيسية', 'Home'),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 3,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF3FD2FF).withValues(alpha: 0.6 + _pulseCtrl.value * 0.4),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  tr('حدود إبداعنا', 'Our Creative Bounds'),
                  style: TextStyle(
                    fontSize: size.width > 600 ? 48 : 32,
                    fontWeight: FontWeight.w900,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Color(0xFF3FD2FF), Color(0xFFA78BFA)],
                      ).createShader(
                        const Rect.fromLTWH(0, 0, 400, 60),
                      ),
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Text(
                    tr(
                      'عالم لا نهاية له من الإبداع والابتكار. انزل لاكتشاف ما لا يستطيع غيرنا فعله.',
                      'A world of endless creativity and innovation. Scroll down to discover what no one else can do.',
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width > 600 ? 18 : 15,
                      color: const Color(0xFFA6ABB6),
                      height: 1.7,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _isHovering = true),
                  onExit: (_) => setState(() => _isHovering = false),
                  child: GestureDetector(
                    onTap: widget.onEnter,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF3FD2FF).withValues(alpha: _isHovering ? 0.25 : 0.12),
                            const Color(0xFFA78BFA).withValues(alpha: _isHovering ? 0.25 : 0.12),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color.lerp(
                            const Color(0xFF3FD2FF),
                            const Color(0xFFA78BFA),
                            _pulseCtrl.value,
                          )!.withValues(alpha: _isHovering ? 0.6 : 0.3),
                          width: _isHovering ? 2 : 1,
                        ),
                        boxShadow: _isHovering
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF3FD2FF).withValues(alpha: 0.2),
                                  blurRadius: 40,
                                  spreadRadius: 0,
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.keyboard_double_arrow_down,
                            color: Color(0xFF3FD2FF),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            tr('ابدأ الرحلة', 'Begin the Journey'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _isHovering ? Colors.white : const Color(0xFF3FD2FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (context, _) {
                    return Opacity(
                      opacity: 0.3 + _pulseCtrl.value * 0.3,
                      child: const Icon(
                        Icons.expand_more,
                        color: Color(0xFF3FD2FF),
                        size: 32,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
