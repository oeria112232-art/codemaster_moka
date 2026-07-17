import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../components.dart';
import '../hero_scene.dart';

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
    with TickerProviderStateMixin {
  bool _showContent = false;
  bool _isHovering = false;
  late final AnimationController _fadeCtrl;
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _showContent = true);
        _fadeCtrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF010409),
      body: Stack(
        children: [
          const Positioned.fill(child: HeroScene()),
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
            child: FadeTransition(
              opacity: _fadeCtrl,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tr('إبداعنا يفوق التخيلات', 'Our Creativity Exceeds Imagination'),
                    style: TextStyle(
                      fontSize: size.width > 600 ? 44 : 28,
                      fontWeight: FontWeight.w900,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [Color(0xFF3FD2FF), Color(0xFF22C55E)],
                        ).createShader(const Rect.fromLTWH(0, 0, 500, 60)),
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
                              const Color(0xFF22C55E).withValues(alpha: _isHovering ? 0.25 : 0.12),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Color.lerp(
                              const Color(0xFF3FD2FF),
                              const Color(0xFF22C55E),
                              _pulseCtrl.value,
                            )!.withValues(alpha: _isHovering ? 0.6 : 0.3),
                            width: _isHovering ? 2 : 1,
                          ),
                          boxShadow: _isHovering
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF3FD2FF).withValues(alpha: 0.2),
                                    blurRadius: 40,
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.play_arrow_rounded,
                              color: Color(0xFF3FD2FF),
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              tr('اضغط للتأكد من ذلك', 'Click to Verify'),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
