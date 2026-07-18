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
  late final AnimationController _titleCtrl;
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

    _titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _buttonCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    _planetCtrl.forward();
    
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    _titleCtrl.forward();
    
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    _buttonCtrl.forward();
  }

  @override
  void dispose() {
    _planetCtrl.dispose();
    _pulseCtrl.dispose();
    _titleCtrl.dispose();
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title Animation (No word splitting to guarantee 100% correct directionality & reading order)
                  FadeTransition(
                    opacity: CurvedAnimation(parent: _titleCtrl, curve: Curves.easeInOut),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOutCubic)),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF1080E0), Color(0xFF2090FF)],
                        ).createShader(bounds),
                        child: Text(
                          tr('إبداعنا يفوق التخيلات', 'Our Creativity Exceeds Imagination'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.width > 600 ? 44 : 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  
                  // Clean Button (no emojis/icons as requested)
                  FadeTransition(
                    opacity: CurvedAnimation(parent: _buttonCtrl, curve: Curves.easeInOut),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(parent: _buttonCtrl, curve: Curves.easeOutCubic)),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => setState(() => _isHovering = true),
                        onExit: (_) => setState(() => _isHovering = false),
                        child: GestureDetector(
                          onTap: widget.onEnter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF1080E0).withValues(alpha: _isHovering ? 0.25 : 0.12),
                                  const Color(0xFF2090FF).withValues(alpha: _isHovering ? 0.25 : 0.12),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(999),
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
                                        color: const Color(0xFF1080E0).withValues(alpha: 0.25),
                                        blurRadius: 40,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              tr('اضغط للتأكد من ذلك', 'Click to Verify'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _isHovering ? Colors.white : const Color(0xFF1080E0),
                                letterSpacing: 1,
                              ),
                            ),
                          ),
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
