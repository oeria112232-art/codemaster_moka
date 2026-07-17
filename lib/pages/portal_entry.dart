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
  bool _isHovering = false;
  late final AnimationController _planetCtrl;
  late final AnimationController _pulseCtrl;
  late final List<AnimationController> _wordCtrls;
  late final AnimationController _buttonCtrl;

  @override
  void initState() {
    super.initState();
    _planetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _wordCtrls = List.generate(5, (_) => AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    ));

    _buttonCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    _planetCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    for (final ctrl in _wordCtrls) {
      ctrl.forward();
      await Future.delayed(const Duration(milliseconds: 200));
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _buttonCtrl.forward();
  }

  @override
  void dispose() {
    _planetCtrl.dispose();
    _pulseCtrl.dispose();
    for (final c in _wordCtrls) {
      c.dispose();
    }
    _buttonCtrl.dispose();
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
                      color: const Color(0xFF1080E0).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back, color: Color(0xFF1080E0), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        tr('الرئيسية', 'Home'),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: CurvedAnimation(parent: _planetCtrl, curve: Curves.easeIn),
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(parent: _planetCtrl, curve: Curves.easeOut),
                    ),
                    child: _buildTitle(size),
                  ),
                ),
                const SizedBox(height: 60),
                FadeTransition(
                  opacity: CurvedAnimation(parent: _buttonCtrl, curve: Curves.easeIn),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: _buttonCtrl, curve: Curves.easeOut)),
                    child: MouseRegion(
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
                                const Color(0xFF1080E0).withValues(alpha: _isHovering ? 0.25 : 0.12),
                                const Color(0xFF2090FF).withValues(alpha: _isHovering ? 0.25 : 0.12),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Color.lerp(
                                const Color(0xFF1080E0),
                                const Color(0xFF2090FF),
                                _pulseCtrl.value,
                              )!.withValues(alpha: _isHovering ? 0.6 : 0.3),
                              width: _isHovering ? 2 : 1,
                            ),
                            boxShadow: _isHovering
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF1080E0).withValues(alpha: 0.2),
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
                                color: Color(0xFF1080E0),
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                tr('اضغط للتأكد من ذلك', 'Click to Verify'),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: _isHovering ? Colors.white : const Color(0xFF1080E0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(Size size) {
    final words = tr(
      'إبداعنا يفوق التخيلات',
      'Our Creativity Exceeds Imagination',
    ).split(' ');

    return Wrap(
      spacing: size.width > 600 ? 16 : 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(words.length, (i) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: _wordCtrls[i], curve: Curves.easeIn),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.4),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: _wordCtrls[i], curve: Curves.easeOut)),
            child: Text(
              words[i],
              style: TextStyle(
                fontSize: size.width > 600 ? 44 : 28,
                fontWeight: FontWeight.w900,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [Color(0xFF1080E0), Color(0xFF2090FF)],
                  ).createShader(const Rect.fromLTWH(0, 0, 500, 60)),
              ),
            ),
          ),
        );
      }),
    );
  }
}
