import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'components.dart';
import 'custom_cursor.dart';
import 'portal/clean_hero_bg.dart';
import 'pages.dart';
import 'pages/portal_entry.dart';
import 'pages/infinite_portal.dart';
import 'pages/support_page.dart';
import 'pages/owner_secret_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageManager.instance,
      builder: (context, _) {
        final isAr = LanguageManager.instance.isArabic;
        return MaterialApp(
          title: tr('Code Master | أفضل شركة حلول تقنية وتصميم تطبيقات في العراق', 'Code Master | Best Software & App Development in Iraq'),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF080C16),
            primaryColor: const Color(0xFF1080E0),
            fontFamily: 'Inter',
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1080E0),
              surface: Color(0xFF080C16),
            ),
          ),
          home: Directionality(
            textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
            child: const CustomCursorOverlay(
              child: HomePage(),
            ),
          ),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _visionKey = GlobalKey();
  final GlobalKey _ctaKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _handleLinkTap(String link) {
    if (link == '#') {
      _scrollToKey(_homeKey);
    } else if (link == '#services') {
      _scrollToKey(_servicesKey);
    } else if (link == '#vision') {
      _scrollToKey(_visionKey);
    } else if (link == '#cta') {
      _scrollToKey(_ctaKey);
    } else if (link == '#portal') {
      _openPortal();
    } else if (link == '#tech') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TechnologyView(onBack: () => Navigator.pop(context))),
      );
    } else if (link == '#studio') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => StudioView(onBack: () => Navigator.pop(context))),
      );
    } else if (link == '#contact') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ContactView(onBack: () => Navigator.pop(context))),
      );
    }
  }

  void _openPortal() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => PortalEntryPage(
          onEnter: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => InfinitePortalPage(onBack: () => Navigator.pop(context)),
                transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
                transitionDuration: const Duration(milliseconds: 600),
              ),
            );
          },
          onBack: () => Navigator.pop(context),
        ),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _openSupport() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => SupportPage(onBack: () => Navigator.pop(context)),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _openOwnerSecret() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => OwnerSecretPage(onBack: () => Navigator.pop(context)),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Container(
                  key: _homeKey,
                  child: HeroSection(
                    onGetStarted: () => _handleLinkTap('#cta'),
                    onServices: () => _handleLinkTap('#services'),
                    onPortal: _openPortal,
                    onOwnerSecret: _openOwnerSecret,
                  ),
                ),
                _ScrollReveal(
                  scrollController: _scrollController,
                  child: StatsSection(scrollController: _scrollController),
                ),
                Container(
                  key: _servicesKey,
                  child: _ScrollReveal(
                    scrollController: _scrollController,
                    child: const ServicesSection(),
                  ),
                ),
                Container(
                  key: _visionKey,
                  child: _ScrollReveal(
                    scrollController: _scrollController,
                    child: const VisionSection(),
                  ),
                ),
                _ScrollReveal(
                  scrollController: _scrollController,
                  child: const FAQSection(),
                ),
                Container(
                  key: _ctaKey,
                  child: _ScrollReveal(
                    scrollController: _scrollController,
                    child: const CTASection(),
                  ),
                ),
                _ScrollReveal(
                  scrollController: _scrollController,
                  child: const FooterSection(),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Navbar(
              scrollController: _scrollController,
              onLogoTap: () => _scrollToKey(_homeKey),
              onLinkTap: _handleLinkTap,
            ),
          ),
          // Floating support button
          Positioned(
            bottom: 24,
            right: 24,
            child: _FloatingSupportButton(onTap: _openSupport),
          ),
        ],
      ),
    );
  }
}

class _ScrollReveal extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  const _ScrollReveal({required this.child, required this.scrollController});

  @override
  State<_ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<_ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    widget.scrollController.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_done) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final y = box.localToGlobal(Offset.zero).dy;
    final h = MediaQuery.of(context).size.height;
    if (y < h * 0.9) {
      _done = true;
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_check);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56, height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF1080E0), Color(0xFF2090FF), Color(0xFF1080E0)]),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Color(0xFF8892A4), height: 1.6),
          ),
        ),
      ],
    );
  }
}

class HeroSection extends StatefulWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onServices;
  final VoidCallback onPortal;
  final VoidCallback onOwnerSecret;

  const HeroSection({
    super.key,
    required this.onGetStarted,
    required this.onServices,
    required this.onPortal,
    required this.onOwnerSecret,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with TickerProviderStateMixin {
  late final AnimationController _badgeCtrl;
  late final AnimationController _terminalCtrl;
  late final Animation<double> _badgePulse;

  @override
  void initState() {
    super.initState();
    _badgeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500))..repeat(reverse: true);
    _terminalCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat(reverse: true);
    _badgePulse = Tween<double>(begin: 0.85, end: 1.0).animate(CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _badgeCtrl.dispose();
    _terminalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isDesktop = size.width > 900;

    final heroContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _badgePulse,
          builder: (_, __) => Transform.scale(
            scale: _badgePulse.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  const Color(0xFF1080E0).withValues(alpha: 0.15),
                  const Color(0xFF2090FF).withValues(alpha: 0.08),
                ]),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7, height: 7,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2090FF),
                      boxShadow: [BoxShadow(color: Color(0xFF2090FF), blurRadius: 6)],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    tr('شريكك التقني المتكامل', 'Your Integrated Tech Partner'),
                    style: TextStyle(color: const Color(0xFF1080E0), fontSize: isMobile ? 11 : 13, fontWeight: FontWeight.w600, letterSpacing: 1.2),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: isMobile ? 28 : 36),
        GestureDetector(
          onTap: widget.onOwnerSecret,
          child: Semantics(
            header: true,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1080E0), Color(0xFF40A0FF), Color(0xFFFFFFFF), Color(0xFF1080E0)],
                stops: [0.0, 0.3, 0.6, 1.0],
              ).createShader(bounds),
              child: Text(
                'Code Master',
                style: TextStyle(
                  fontSize: isMobile ? 46 : (size.width > 1100 ? 88 : 72),
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: isMobile ? 2 : 6,
                  height: 1.05,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: isMobile ? 10 : 16),
        Text(
          tr('أفضل شركة حلول تقنية وتصميم تطبيقات في العراق', 'Best Software Solutions & App Development in Iraq'),
          style: TextStyle(
            fontSize: isMobile ? 15 : 22,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2090FF),
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: isMobile ? 20 : 28),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isDesktop ? 500 : 660),
          child: Text(
            tr(
              'نبتكر ونطور أحدث الحلول التقنية للشركات في العراق. من تطبيقات الموبايل إلى المتاجر الإلكترونية وأنظمة ERP المتكاملة.',
              'We innovate and develop cutting-edge tech solutions for businesses in Iraq. From mobile apps to e-commerce and integrated ERP systems.',
            ),
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            style: TextStyle(fontSize: isMobile ? 13.5 : 16, color: const Color(0xFF8892A4), height: 1.9),
          ),
        ),
        SizedBox(height: isMobile ? 32 : 44),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            _HeroButton(label: tr('ابدأ مشروعك الآن', 'Start Your Project'), isSolid: true, onPressed: widget.onGetStarted),
            _HeroButton(label: tr('خدماتنا', 'Our Services'), isSolid: false, onPressed: widget.onServices),
            _HeroButton(label: tr('حدود إبداعنا', 'Creative Bounds'), isSolid: false, onPressed: widget.onPortal),
          ],
        ),
      ],
    );

    final terminalWidget = _AnimatedTerminal();

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: [
          const Positioned.fill(child: CleanHeroBg()),
          Positioned(
            bottom: 0, left: 0, right: 0, height: 200,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xFF080C16)],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48),
              child: isDesktop
                  ? IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 5, child: heroContent),
                          const SizedBox(width: 60),
                          Expanded(flex: 4, child: Center(child: terminalWidget)),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        heroContent,
                        if (isMobile) ...[
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            height: 260,
                            child: terminalWidget,
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedTerminal extends StatefulWidget {
  @override
  State<_AnimatedTerminal> createState() => _AnimatedTerminalState();
}

class _AnimatedTerminalState extends State<_AnimatedTerminal> with TickerProviderStateMixin {
  late final AnimationController _typeCtrl;
  int _currentLine = 0;
  int _currentChar = 0;
  bool _showCursor = true;
  final List<String> _lines = [];
  late final AnimationController _cursorCtrl;

  static const _codeLines = [
    "import 'package:flutter/material.dart';",
    "import 'dart:math';",
    "",
    "class CodeMasterApp extends StatelessWidget {",
    "  @override",
    "  Widget build(BuildContext context) {",
    "    return MaterialApp(",
    "      title: 'Code Master',",
    "      theme: ThemeData.dark(),",
    "      home: const HomePage(),",
    "    );",
    "  }",
    "}",
    "",
    "// Building the future of digital Iraq",
    "const List<String> services = [",
    "  'Mobile Apps',",
    "  'E-Commerce',",
    "  'ERP Systems',",
    "];",
  ];

  @override
  void initState() {
    super.initState();
    _cursorCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
    _typeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 80))..addListener(_onTick);
    _startTyping();
  }

  void _startTyping() {
    _typeCtrl.repeat();
  }

  void _onTick() {
    if (_currentLine >= _codeLines.length) {
      _typeCtrl.stop();
      return;
    }
    final line = _codeLines[_currentLine];
    if (_currentChar < line.length) {
      setState(() {
        _currentChar++;
        _lines.removeRange(0, _lines.length);
        for (int i = 0; i <= _currentLine; i++) {
          if (i == _currentLine) {
            _lines.add(_codeLines[i].substring(0, _currentChar));
          } else {
            _lines.add(_codeLines[i]);
          }
        }
      });
    } else {
      setState(() {
        _currentLine++;
        _currentChar = 0;
        if (_currentLine >= _codeLines.length) {
          _typeCtrl.stop();
        }
      });
    }
  }

  @override
  void dispose() {
    _typeCtrl.dispose();
    _cursorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: const Color(0xFF1080E0).withValues(alpha: 0.06), blurRadius: 40, spreadRadius: 0),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Terminal header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF0D1220),
              border: Border(bottom: BorderSide(color: Color(0xFF1A2035))),
            ),
            child: Row(
              children: [
                Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFF5F57))),
                const SizedBox(width: 7),
                Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFBD2E))),
                const SizedBox(width: 7),
                Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF28CA42))),
                const SizedBox(width: 16),
                const Text('code_master.dart', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontFamily: 'monospace')),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1080E0).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Dart', style: TextStyle(fontSize: 10, color: Color(0xFF1080E0), fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          // Code content
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFF080C16),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: _buildCodeWidget(),
              ),
            ),
          ),
          // Bottom status bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF0D1220),
              border: Border(top: BorderSide(color: Color(0xFF1A2035))),
            ),
            child: Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF28CA42),
                    boxShadow: [BoxShadow(color: const Color(0xFF28CA42).withValues(alpha: 0.5), blurRadius: 4)],
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Ready', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                const Spacer(),
                const Text('UTF-8', style: TextStyle(fontSize: 11, color: Color(0xFF4B5563))),
                const SizedBox(width: 12),
                const Text('Dart 3.4', style: TextStyle(fontSize: 11, color: Color(0xFF4B5563))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeWidget() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 12, fontFamily: 'monospace', height: 1.7, color: Color(0xFF9CA3AF)),
        children: [
          for (int i = 0; i < _lines.length; i++)
            TextSpan(children: [
              TextSpan(
                text: '${(i + 1).toString().padLeft(3)}  ',
                style: TextStyle(color: const Color(0xFF3B4252).withValues(alpha: 0.6), fontSize: 11),
              ),
              TextSpan(text: _highlightLine(_lines[i])),
              if (i == _lines.length - 1 && _currentLine < _codeLines.length)
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: AnimatedBuilder(
                    animation: _cursorCtrl,
                    builder: (_, __) => Container(
                      width: 2,
                      height: 14,
                      color: Color(0xFF1080E0).withValues(alpha: _cursorCtrl.value),
                    ),
                  ),
                ),
            ]),
          if (_currentLine >= _codeLines.length)
            const TextSpan(text: '\n\n// ✅ Build successful', style: TextStyle(color: Color(0xFF28CA42))),
        ],
      ),
    );
  }

  String _highlightLine(String line) {
    if (line.trim().startsWith('//')) return line;
    return line;
  }
}

class _HeroButton extends StatefulWidget {
  final String label;
  final bool isSolid;
  final VoidCallback onPressed;
  const _HeroButton({required this.label, required this.isSolid, required this.onPressed});

  @override
  State<_HeroButton> createState() => _HeroButtonState();
}

class _HeroButtonState extends State<_HeroButton> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = const Color(0xFF1080E0);
    final isMobile = MediaQuery.of(context).size.width < 600;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) { setState(() => _pressed = false); widget.onPressed(); },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()..scale(_pressed ? 0.95 : (_hover ? 1.04 : 1.0)),
          transformAlignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 32, vertical: isMobile ? 18 : 16),
          decoration: BoxDecoration(
            gradient: widget.isSolid
                ? LinearGradient(colors: [
                    baseColor,
                    if (_hover) const Color(0xFF2090FF) else baseColor,
                  ])
                : null,
            color: widget.isSolid ? null : const Color(0xFF0D1220),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hover
                  ? baseColor.withValues(alpha: 0.7)
                  : baseColor.withValues(alpha: widget.isSolid ? 0 : 0.2),
              width: widget.isSolid ? 0 : 1,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: baseColor.withValues(alpha: widget.isSolid ? 0.35 : 0.12),
                      blurRadius: widget.isSolid ? 28 : 18,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.isSolid ? Colors.white : const Color(0xFF1080E0),
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class StatsSection extends StatefulWidget {
  final ScrollController scrollController;
  const StatsSection({super.key, required this.scrollController});

  @override
  State<StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _counterCtrl;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _counterCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    widget.scrollController.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_started) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final y = box.localToGlobal(Offset.zero).dy;
    if (y < MediaQuery.of(context).size.height * 0.85) {
      _started = true;
      _counterCtrl.forward();
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_check);
    _counterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: isMobile ? 24 : 40),
      padding: EdgeInsets.all(isMobile ? 28 : 44),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1018),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.1)),
      ),
      child: isMobile
          ? Column(
              children: [
                _AnimatedStat(target: 50, prefix: '+', label: tr('مشروع مكتمل', 'Projects'), animation: _counterCtrl, icon: Icons.rocket_launch),
                const SizedBox(height: 24),
                _AnimatedStat(target: 200, prefix: '+', label: tr('عميل', 'Clients'), animation: _counterCtrl, icon: Icons.people),
                const SizedBox(height: 24),
                _AnimatedStat(target: 5, prefix: '+', label: tr('سنوات خبرة', 'Years'), animation: _counterCtrl, icon: Icons.workspace_premium),
                const SizedBox(height: 24),
                _StaticStat(value: '24/7', label: tr('دعم فني', 'Support'), icon: Icons.support_agent),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AnimatedStat(target: 50, prefix: '+', label: tr('مشروع مكتمل', 'Projects'), animation: _counterCtrl, icon: Icons.rocket_launch),
                Container(width: 1, height: 50, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, const Color(0xFF1080E0).withValues(alpha: 0.2), Colors.transparent]))),
                _AnimatedStat(target: 200, prefix: '+', label: tr('عميل', 'Clients'), animation: _counterCtrl, icon: Icons.people),
                Container(width: 1, height: 50, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, const Color(0xFF1080E0).withValues(alpha: 0.2), Colors.transparent]))),
                _AnimatedStat(target: 5, prefix: '+', label: tr('سنوات خبرة', 'Years'), animation: _counterCtrl, icon: Icons.workspace_premium),
                Container(width: 1, height: 50, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, const Color(0xFF1080E0).withValues(alpha: 0.2), Colors.transparent]))),
                _StaticStat(value: '24/7', label: tr('دعم فني', 'Support'), icon: Icons.support_agent),
              ],
            ),
    );
  }
}

class _AnimatedStat extends StatelessWidget {
  final int target;
  final String prefix;
  final String label;
  final Animation<double> animation;
  final IconData icon;

  const _AnimatedStat({
    required this.target,
    required this.prefix,
    required this.label,
    required this.animation,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final numberSize = isMobile ? 32.0 : 40.0;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final v = (animation.value * target).toInt();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [const Color(0xFF1080E0).withValues(alpha: 0.1), const Color(0xFF1080E0).withValues(alpha: 0.03)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF2090FF), size: isMobile ? 22 : 26),
            ),
            const SizedBox(height: 14),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF1080E0), Color(0xFF40A0FF)],
              ).createShader(bounds),
              child: Text(
                '$prefix$v',
                style: TextStyle(fontSize: numberSize, fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(fontSize: isMobile ? 12 : 14, color: const Color(0xFF8892A4), fontWeight: FontWeight.w500),
            ),
          ],
        );
      },
    );
  }
}

class _StaticStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _StaticStat({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [const Color(0xFF1080E0).withValues(alpha: 0.1), const Color(0xFF1080E0).withValues(alpha: 0.03)]),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF2090FF), size: isMobile ? 22 : 26),
        ),
        const SizedBox(height: 14),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF1080E0), Color(0xFF40A0FF)],
          ).createShader(bounds),
          child: Text(
            value,
            style: TextStyle(fontSize: isMobile ? 32 : 40, fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: isMobile ? 12 : 14, color: const Color(0xFF8892A4), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class VisionSection extends StatelessWidget {
  const VisionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      children: [
        // Wave divider
        _WaveDivider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 48, vertical: isMobile ? 36 : 60),
          child: Column(
            children: [
              _SectionHeader(
                title: tr('رؤيتنا ورسالتنا', 'Our Vision & Mission'),
                subtitle: tr('نلتزم بقيادة التحول الرقمي للشركات والمؤسسات في العراق', 'Committed to leading digital transformation in Iraq'),
              ),
              const SizedBox(height: 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;
                  return isWide
                      ? IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: _buildVisionCard()),
                              const SizedBox(width: 24),
                              Expanded(child: _buildMissionCard()),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            _buildVisionCard(),
                            const SizedBox(height: 24),
                            _buildMissionCard(),
                          ],
                        );
                },
              ),
              const SizedBox(height: 40),
              _buildStrategicGoals(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVisionCard() {
    return Builder(
      builder: (context) {
        return _AnimatedGradientBorder(
          color: const Color(0xFF1080E0),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1018),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1080E0), Color(0xFF0060B0)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: const Color(0xFF1080E0).withValues(alpha: 0.3), blurRadius: 16)],
                  ),
                  child: const Icon(Icons.visibility, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 24),
                Text(tr('رؤيتنا', 'Our Vision'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 16),
                Text(
                  tr(
                    'أن نكون الشريك التقني الأول في العراق والمنطقة، من خلال تقديم حلول برمجية مبتكرة تتجاوز توقعات عملائنا.',
                    'To be the leading tech partner in the region by delivering innovative solutions that exceed expectations.',
                  ),
                  style: const TextStyle(fontSize: 15, color: Color(0xFF8892A4), height: 1.8),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMissionCard() {
    return Builder(
      builder: (context) {
        return _AnimatedGradientBorder(
          color: const Color(0xFF2090FF),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1018),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF2090FF), Color(0xFF0060B0)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: const Color(0xFF2090FF).withValues(alpha: 0.3), blurRadius: 16)],
                  ),
                  child: const Icon(Icons.flag, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 24),
                Text(tr('مهمتنا', 'Our Mission'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 16),
                Text(
                  tr(
                    'تمكين الشركات من خلال منتجات رقمية متكاملة عالية الجودة، مبنية على أسس هندسية صلبة ومصممة لتحقيق أقصى عائد.',
                    'Empowering companies through high-quality digital products, built on solid engineering principles.',
                  ),
                  style: const TextStyle(fontSize: 15, color: Color(0xFF8892A4), height: 1.8),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStrategicGoals() {
    return Builder(
      builder: (context) {
        return _AnimatedGradientBorder(
          color: const Color(0xFF1080E0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1018),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr('الأهداف الاستراتيجية', 'Strategic Goals'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 28),
                _GoalItem(icon: Icons.trending_up, text: tr('التوسع في خدماتنا التقنية داخل العراق والمنطقة', 'Expanding our tech services across Iraq and the region')),
                const SizedBox(height: 16),
                _GoalItem(icon: Icons.cloud_queue, text: tr('تبني تقنيات الحوسبة السحابية المتقدمة', 'Adopting advanced cloud computing technologies')),
                const SizedBox(height: 16),
                _GoalItem(icon: Icons.public, text: tr('بناء شراكات استراتيجية عالمية', 'Building global strategic partnerships')),
                const SizedBox(height: 16),
                _GoalItem(icon: Icons.star, text: tr('تحقيق أعلى معايير جودة الخدمات', 'Achieving the highest service quality standards')),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GoalItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _GoalItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [const Color(0xFF1080E0).withValues(alpha: 0.12), const Color(0xFF1080E0).withValues(alpha: 0.04)]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF2090FF), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 15, color: Color(0xFF8892A4), height: 1.5)),
        ),
      ],
    );
  }
}

class _WaveDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: CustomPaint(
        painter: _WaveDividerPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _WaveDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = const LinearGradient(
        colors: [Colors.transparent, Color(0xFF1080E0), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 0));

    final path = Path();
    path.moveTo(0, size.height / 2);
    for (double x = 0; x <= size.width; x += 1) {
      final y = size.height / 2 + sin((x / size.width) * pi * 4) * 12;
      path.lineTo(x, y);
    }
    paint.color = const Color(0xFF1080E0).withValues(alpha: 0.15);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AnimatedGradientBorder extends StatefulWidget {
  final Widget child;
  final Color color;
  const _AnimatedGradientBorder({required this.child, required this.color});

  @override
  State<_AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<_AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          final angle = _ctrl.value * 2 * pi;
          return Container(
            padding: _hovered ? const EdgeInsets.all(2) : EdgeInsets.zero,
            decoration: _hovered
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: SweepGradient(
                      center: Alignment.center,
                      startAngle: angle,
                      endAngle: angle + pi * 2,
                      colors: [
                        widget.color.withValues(alpha: 0.5),
                        widget.color.withValues(alpha: 0.0),
                        widget.color.withValues(alpha: 0.5),
                        widget.color.withValues(alpha: 0.0),
                        widget.color.withValues(alpha: 0.5),
                      ],
                    ),
                  )
                : null,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  int _hoveredIndex = -1;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final services = [
      _ServiceData(
        number: '01',
        titleEn: 'Mobile App Development',
        titleAr: 'تصميم وتطوير تطبيقات الموبايل',
        descriptionEn: 'We build blazing-fast, pixel-perfect mobile apps for iOS & Android using Flutter.',
        descriptionAr: 'نبني تطبيقات موبايل فائقة السرعة ودقيقة التصميم لنظامي iOS و Android باستخدام Flutter.',
        icon: Icons.phone_android,
        color: const Color(0xFF1080E0),
        tags: ['Flutter', 'iOS', 'Android', 'UI/UX'],
        features: ['تصميم UI/UX احترافي', 'أداء فائق السرعة', 'توافق شامل', 'دعم فني مستمر'],
        progress: 95,
        projects: 25,
      ),
      _ServiceData(
        number: '02',
        titleEn: 'E-Commerce & Digital Stores',
        titleAr: 'حلول التجارة الإلكترونية والمتاجر الرقمية',
        descriptionEn: 'Complete e-commerce ecosystems with smart dashboards, inventory tracking, and local payment integration.',
        descriptionAr: 'نظام تجارة إلكترونية متكامل مع لوحة تحكم ذكية وتتبع المخزون وربط مع بوابات الدفع المحلية.',
        icon: Icons.shopping_cart,
        color: const Color(0xFF2090FF),
        tags: ['Zain Cash', 'Asia Hawala', 'Store', 'Payment'],
        features: ['ربط بوابات الدفع المحلية', 'لوحة تحكم شاملة', 'تتبع المخزون', 'تقارير مبيعات ذكية'],
        progress: 90,
        projects: 18,
      ),
      _ServiceData(
        number: '03',
        titleEn: 'Enterprise Systems & ERP',
        titleAr: 'الأنظمة الإدارية وأتمتة الأعمال',
        descriptionEn: 'Custom ERP systems, database architecture, and process automation for data-driven operations.',
        descriptionAr: 'أنظمة ERP مخصصة وهندسة قواعد بيانات وأتمتة عمليات تحول أعمالك إلى عمليات مدفوعة بالبيانات.',
        icon: Icons.business_center,
        color: const Color(0xFF40A0FF),
        tags: ['ERP', 'CRM', 'Database', 'Automation'],
        features: ['أتمتة العمليات', 'قواعد بيانات مخصصة', 'تقارير لحظية', 'تكامل مؤسسي'],
        progress: 88,
        projects: 15,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 16, vertical: 60),
          child: Column(
            children: [
              _SectionHeader(
                title: tr('خدماتنا البرمجية', 'Our Software Services'),
                subtitle: tr('حلول تقنية شاملة للشركات والمؤسسات في العراق', 'Comprehensive tech solutions for businesses in Iraq'),
              ),
              const SizedBox(height: 24),
              // Trust badges
              AnimatedBuilder(
                animation: _entranceCtrl,
                builder: (_, __) => Opacity(
                  opacity: _entranceCtrl.value,
                  child: Wrap(
                    spacing: 12, runSpacing: 8, alignment: WrapAlignment.center,
                    children: [
                      _TrustBadge(icon: Icons.verified, label: tr('جودة مضمونة', 'Quality Assured')),
                      _TrustBadge(icon: Icons.support_agent, label: tr('دعم 24/7', '24/7 Support')),
                      _TrustBadge(icon: Icons.speed, label: tr('تسليم سريع', 'Fast Delivery')),
                      _TrustBadge(icon: Icons.lock, label: tr('أمان متقدم', 'Advanced Security')),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // Bento grid on desktop, stacked on mobile
              if (isDesktop)
                _BentoServiceGrid(services: services, hoveredIndex: _hoveredIndex, onHover: (i) => setState(() => _hoveredIndex = i), entranceCtrl: _entranceCtrl)
              else
                ...List.generate(services.length, (i) {
                  final delay = (i * 0.2).clamp(0.0, 1.0);
                  final animInterval = Interval(delay, (delay + 0.6).clamp(0.0, 1.0), curve: Curves.easeOutCubic);
                  return AnimatedBuilder(
                    animation: _entranceCtrl,
                    builder: (_, child) {
                      final animValue = animInterval.transform(_entranceCtrl.value.clamp(0.0, 1.0));
                      return Opacity(
                        opacity: animValue,
                        child: Transform.translate(offset: Offset(0, 40 * (1 - animValue)), child: child),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _ProfessionalServiceCard(
                        data: services[i], isHovered: _hoveredIndex == i,
                        onHover: (v) => setState(() => _hoveredIndex = v ? i : -1),
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 32),
              // Bottom stats bar
              AnimatedBuilder(
                animation: _entranceCtrl,
                builder: (_, __) => Opacity(
                  opacity: _entranceCtrl.value,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        const Color(0xFF1080E0).withValues(alpha: 0.08),
                        const Color(0xFF2090FF).withValues(alpha: 0.04),
                      ]),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.1)),
                    ),
                    child: isDesktop
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _ServiceMiniStat(value: '58+', label: tr('مشروع منجز', 'Completed')),
                              Container(width: 1, height: 28, color: const Color(0xFF1080E0).withValues(alpha: 0.15)),
                              _ServiceMiniStat(value: '99%', label: tr('رضا العملاء', 'Satisfaction')),
                              Container(width: 1, height: 28, color: const Color(0xFF1080E0).withValues(alpha: 0.15)),
                              _ServiceMiniStat(value: '<48h', label: tr('استجابة', 'Response')),
                            ],
                          )
                        : Column(
                            children: [
                              _ServiceMiniStat(value: '58+', label: tr('مشروع منجز', 'Completed')),
                              const SizedBox(height: 12),
                              _ServiceMiniStat(value: '99%', label: tr('رضا العملاء', 'Satisfaction')),
                              const SizedBox(height: 12),
                              _ServiceMiniStat(value: '<48h', label: tr('استجابة', 'Response')),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BentoServiceGrid extends StatelessWidget {
  final List<_ServiceData> services;
  final int hoveredIndex;
  final ValueChanged<int> onHover;
  final AnimationController entranceCtrl;

  const _BentoServiceGrid({required this.services, required this.hoveredIndex, required this.onHover, required this.entranceCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: entranceCtrl,
      builder: (_, __) => Opacity(
        opacity: entranceCtrl.value,
        child: SizedBox(
          height: 520,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Large card (Mobile) - takes 55% width
              Expanded(
                flex: 55,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - entranceCtrl.value)),
                  child: _ProfessionalServiceCard(
                    data: services[0], isHovered: hoveredIndex == 0,
                    onHover: (v) => onHover(v ? 0 : -1),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Right column: 2 smaller cards stacked
              Expanded(
                flex: 45,
                child: Column(
                  children: [
                    Expanded(
                      child: Transform.translate(
                        offset: Offset(20 * (1 - entranceCtrl.value), 0),
                        child: _ProfessionalServiceCard(
                          data: services[1], isHovered: hoveredIndex == 1,
                          onHover: (v) => onHover(v ? 1 : -1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Transform.translate(
                        offset: Offset(20 * (1 - entranceCtrl.value), 0),
                        child: _ProfessionalServiceCard(
                          data: services[2], isHovered: hoveredIndex == 2,
                          onHover: (v) => onHover(v ? 2 : -1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1080E0).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF1080E0), size: 14),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Color(0xFF1080E0), fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ServiceMiniStat extends StatelessWidget {
  final String value;
  final String label;
  const _ServiceMiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF1080E0), Color(0xFF40A0FF)],
          ).createShader(bounds),
          child: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFFA6ABB6))),
      ],
    );
  }
}

class _ServiceParticlesPainter extends CustomPainter {
  final double time;
  _ServiceParticlesPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final p = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 20; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * 600;
      final r = 1.0 + rng.nextDouble() * 2;
      final dy = sin(time * 0.3 + i * 1.5) * 15;
      p.color = const Color(0xFF1080E0).withValues(alpha: 0.06 + sin(time * 0.5 + i) * 0.03);
      canvas.drawCircle(Offset(x, y + dy), r, p);
    }
  }

  @override
  bool shouldRepaint(covariant _ServiceParticlesPainter old) => old.time != time;
}

class _ServiceIcon3D extends StatefulWidget {
  final IconData icon;
  final Color color;
  final bool isHovered;
  const _ServiceIcon3D({required this.icon, required this.color, required this.isHovered});

  @override
  State<_ServiceIcon3D> createState() => _ServiceIcon3DState();
}

class _ServiceIcon3DState extends State<_ServiceIcon3D>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final Animation<double> _floatAnim;
  late final AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -4, end: 4).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.color;
    return AnimatedBuilder(
      animation: Listenable.merge([_floatCtrl, _glowCtrl]),
      builder: (_, __) {
        final glow = 0.15 + _glowCtrl.value * 0.15;
        return Transform.translate(
          offset: Offset(0, _floatAnim.value),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(widget.isHovered ? 0.08 : 0)
              ..rotateY(widget.isHovered ? -0.08 : 0),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: d.withValues(alpha: glow),
                    blurRadius: widget.isHovered ? 36 : 20,
                    spreadRadius: widget.isHovered ? 4 : 0,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: d.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      d.withValues(alpha: widget.isHovered ? 0.3 : 0.18),
                      d.withValues(alpha: widget.isHovered ? 0.12 : 0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: d.withValues(alpha: widget.isHovered ? 0.5 : 0.2)),
                ),
                child: Center(
                  child: Icon(widget.icon, color: d, size: 38),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SampleProjectDialog extends StatefulWidget {
  final String title;
  final Color color;
  final int serviceIndex;
  const _SampleProjectDialog({required this.title, required this.color, required this.serviceIndex});

  @override
  State<_SampleProjectDialog> createState() => _SampleProjectDialogState();
}

class _SampleProjectDialogState extends State<_SampleProjectDialog>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = -1;
  int _descIndex = -1;
  late final AnimationController _descAnimCtrl;
  late final Animation<double> _descFade;

  @override
  void initState() {
    super.initState();
    _descAnimCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _descFade = CurvedAnimation(parent: _descAnimCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _descAnimCtrl.dispose();
    super.dispose();
  }

  void _toggleDesc(int index) {
    if (_descIndex == index) {
      _descAnimCtrl.reverse().then((_) => setState(() => _descIndex = -1));
    } else {
      setState(() => _descIndex = index);
      _descAnimCtrl.forward(from: 0);
    }
  }

  void _openFullView(int index) {
    final samples = _getSamples();
    Navigator.push(context, PageRouteBuilder(
      pageBuilder: (_, __, ___) => _FullSampleView(
        sample: samples[index],
        color: widget.color,
      ),
      transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 400),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final samples = _getSamples();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return Dialog(
      backgroundColor: const Color(0xFF0B1018),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isMobile ? screenWidth * 0.95 : 700,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  widget.color.withValues(alpha: 0.12),
                  widget.color.withValues(alpha: 0.04),
                ]),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Icon(Icons.visibility, color: widget.color, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tr('عينة: ${widget.title}', 'Sample: ${widget.title}'),
                      style: TextStyle(fontSize: isMobile ? 16 : 20, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Color(0xFFA6ABB6)),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(isMobile ? 12 : 20),
                itemCount: samples.length,
                itemBuilder: (ctx, i) {
                  final s = samples[i];
                  final isSelected = _selectedIndex == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutCubic,
                    margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
                    height: isSelected ? (isMobile ? 280 : 380) : (isMobile ? 160 : 210),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [widget.color.withValues(alpha: isSelected ? 0.25 : 0.15), const Color(0xFF0B1018)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: widget.color.withValues(alpha: isSelected ? 0.5 : 0.15),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: widget.color.withValues(alpha: 0.2), blurRadius: 24, spreadRadius: 0)]
                          : [],
                    ),
                    child: GestureDetector(
                      onTap: () => _openFullView(i),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: widget.color.withValues(alpha: 0.08),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            child: Row(
                              children: [
                                Icon(s['icon'] as IconData, color: widget.color, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  s['title'] as String,
                                  style: TextStyle(color: widget.color, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color)),
                                const SizedBox(width: 4),
                                Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color.withValues(alpha: 0.5))),
                                const SizedBox(width: 4),
                                Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color.withValues(alpha: 0.25))),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...List.generate(s['lines'] as int, (j) => Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    height: 10,
                                    width: (150.0 + (j * 40) % 100),
                                    decoration: BoxDecoration(
                                      color: widget.color.withValues(alpha: 0.08 + (j * 0.02)),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  )),
                                  const Spacer(),
                                  Row(
                                    children: List.generate(3, (k) => Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: widget.color.withValues(alpha: 0.06 + k * 0.03),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0B1018),
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _toggleDesc(i),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: widget.color.withValues(alpha: _descIndex == i ? 0.2 : 0.08),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: widget.color.withValues(alpha: 0.2)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.info_outline, color: widget.color, size: 14),
                                        const SizedBox(width: 6),
                                        Text(tr('شرح', 'Details'), style: TextStyle(color: widget.color, fontSize: 12, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Icon(Icons.open_in_full, color: widget.color.withValues(alpha: 0.5), size: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getSamples() {
    switch (widget.serviceIndex) {
      case 0:
        return [
          {'title': tr('تطبيق توصيل طعام', 'Food Delivery App'), 'icon': Icons.delivery_dining, 'lines': 5,
           'descAr': 'تطبيق متكامل لتوصيل الطعام يدعم تتبع الطلب لحظياً، نظام تقييم، وربط مع المطاعم المحلية مع دفع إلكتروني.',
           'descEn': 'Full food delivery app with real-time order tracking, rating system, local restaurant integration and electronic payment.'},
          {'title': tr('تطبيق إدارة المهام', 'Task Management App'), 'icon': Icons.task_alt, 'lines': 4,
           'descAr': 'تطبيق ذكي لإدارة المهام والمشاريع مع تقويم تفاعلي، إشعارات فورية، ومشاركة الفريق.',
           'descEn': 'Smart task management app with interactive calendar, instant notifications, and team collaboration.'},
          {'title': tr('تطبيق صحة لاسلكي', 'Health Tracking App'), 'icon': Icons.monitor_heart, 'lines': 6,
           'descAr': 'تطبيق متابعة صحية يتتبع العادات اليومية، الخطوات، جودة النوم، ويوفر تقارير طبية قابلة للمشاركة.',
           'descEn': 'Health tracking app that monitors daily habits, steps, sleep quality, and provides shareable medical reports.'},
        ];
      case 1:
        return [
          {'title': tr('متجر إلكتروني للأزياء', 'Fashion E-Store'), 'icon': Icons.checkroom, 'lines': 5,
           'descAr': 'متجر إلكتروني احترافي مع كتالوج منتجات، سلة شراء ذكية، وربط مع بوابات الدفع المحلية.',
           'descEn': 'Professional e-store with product catalog, smart cart, and local payment gateway integration.'},
          {'title': tr('منصة بيع الإلكترونيات', 'Electronics Marketplace'), 'icon': Icons.devices, 'lines': 4,
           'descAr': 'منصة تسوق إلكترونية للإلكترونيات مع فلتر ذكي، مقارنة أسعار، ونظام مراجعة المنتجات.',
           'descEn': 'Electronics marketplace with smart filtering, price comparison, and product review system.'},
          {'title': tr('متجر محلّي مع توصيل', 'Local Store with Delivery'), 'icon': Icons.store, 'lines': 5,
           'descAr': 'متجر محلي متكامل مع نظام توصيل، إدارة طلبات، وربط مع زين كاش وآسيا حوالة.',
           'descEn': 'Integrated local store with delivery system, order management, and Zain Cash/Asia Hawala integration.'},
        ];
      case 2:
        return [
          {'title': tr('نظام إدارة مخزون', 'Inventory Management System'), 'icon': Icons.inventory_2, 'lines': 6,
           'descAr': 'نظام ERP لإدارة المخزون مع تنبيهات إعادة الطلب، تقارير المبيعات اللحظية، ونظام صلاحيات متعدد.',
           'descEn': 'ERP inventory management system with reorder alerts, real-time sales reports, and multi-level permissions.'},
          {'title': tr('لوحة تحكم مالية', 'Financial Dashboard'), 'icon': Icons.analytics, 'lines': 5,
           'descAr': 'لوحة تحكم مالية تفاعلية تعرض الإيرادات والمصروفات مع رسوم بيانية تفاعلية وتصدير التقارير.',
           'descEn': 'Interactive financial dashboard showing revenue and expenses with interactive charts and report export.'},
          {'title': tr('نظام CRM للمبيعات', 'CRM Sales System'), 'icon': Icons.handshake, 'lines': 4,
           'descAr': 'نظام إدارة علاقات العملاء مع تتبع المبيعات، إدارة pipelines، وأتمتة المتابعة.',
           'descEn': 'CRM system with sales tracking, pipeline management, and automated follow-ups.'},
        ];
      default:
        return [];
    }
  }
}

class _FullSampleView extends StatelessWidget {
  final Map<String, dynamic> sample;
  final Color color;
  const _FullSampleView({required this.sample, required this.color});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: const Color(0xFF080C16),
      appBar: AppBar(
      backgroundColor: const Color(0xFF0B1018),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(sample['title'] as String, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: isMobile ? 350 : 500,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withValues(alpha: 0.2), const Color(0xFF0B1018)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.08),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Row(
                      children: [
                        Icon(sample['icon'] as IconData, color: color, size: 20),
                        const SizedBox(width: 10),
                        Text(sample['title'] as String, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...List.generate((sample['lines'] as int) + 4, (j) => Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            height: j == 0 ? 16 : 12,
                            width: j == 0 ? 250.0 : (120.0 + (j * 50) % 180),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.06 + (j * 0.015)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          )),
                          const Spacer(),
                          Row(
                            children: List.generate(4, (k) => Container(
                              margin: const EdgeInsets.only(right: 12),
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.05 + k * 0.03),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isMobile ? 20 : 32),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1018),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description, color: color, size: 22),
                      const SizedBox(width: 10),
                      Text(tr('شرح النموذج', 'Project Description'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    LanguageManager.instance.isArabic ? sample['descAr'] as String : sample['descEn'] as String,
                    style: const TextStyle(fontSize: 16, color: Color(0xFFA6ABB6), height: 1.9),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceData {
  final String number;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final IconData icon;
  final Color color;
  final List<String> tags;
  final List<String> features;
  final int progress;
  final int projects;

  const _ServiceData({
    required this.number,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.icon,
    required this.color,
    required this.tags,
    required this.features,
    required this.progress,
    required this.projects,
  });
}

class _ProfessionalServiceCard extends StatefulWidget {
  final _ServiceData data;
  final bool isHovered;
  final ValueChanged<bool> onHover;

  const _ProfessionalServiceCard({required this.data, required this.isHovered, required this.onHover});

  @override
  State<_ProfessionalServiceCard> createState() => _ProfessionalServiceCardState();
}

class _ProfessionalServiceCardState extends State<_ProfessionalServiceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _expandCtrl;
  late final Animation<double> _expandAnim;
  bool _expanded = false;
  final GlobalKey _cardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _expandCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _expandAnim = CurvedAnimation(parent: _expandCtrl, curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() => _expanded = !_expanded);
    _expanded ? _expandCtrl.forward() : _expandCtrl.reverse();
    if (_expanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _cardKey.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
            alignment: 0.2,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final title = LanguageManager.instance.isArabic ? d.titleAr : d.titleEn;
    final desc = LanguageManager.instance.isArabic ? d.descriptionAr : d.descriptionEn;

    return MouseRegion(
      onEnter: (_) => widget.onHover(true),
      onExit: (_) => widget.onHover(false),
      child: GestureDetector(
        onTap: _toggleExpand,
        child: AnimatedContainer(
          key: _cardKey,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            color: const Color(0xFF0B1018),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.isHovered
                  ? d.color.withValues(alpha: 0.6)
                  : d.color.withValues(alpha: 0.06),
              width: widget.isHovered ? 2 : 1,
            ),
            boxShadow: widget.isHovered
                ? [
                    BoxShadow(color: d.color.withValues(alpha: 0.2), blurRadius: 40, spreadRadius: 0),
                    BoxShadow(color: d.color.withValues(alpha: 0.08), blurRadius: 80, spreadRadius: 0),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main card content
              Padding(
                padding: const EdgeInsets.all(32),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left: Icon + Number + Progress
                          SizedBox(
                            width: 180,
                            child: Column(
                              children: [
                                // Icon with animated glow
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  padding: const EdgeInsets.all(22),
                                  decoration: BoxDecoration(
                                    gradient: widget.isHovered
                                        ? LinearGradient(colors: [
                                            d.color.withValues(alpha: 0.25),
                                            d.color.withValues(alpha: 0.08),
                                          ])
                                        : null,
                                    color: widget.isHovered ? null : d.color.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: widget.isHovered
                                        ? [BoxShadow(color: d.color.withValues(alpha: 0.25), blurRadius: 24)]
                                        : [],
                                  ),
                                  child: _ServiceIcon3D(icon: d.icon, color: d.color, isHovered: widget.isHovered),
                                ),
                                const SizedBox(height: 16),
                                // Service number
                                Text(d.number, style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w800,
                                  color: d.color.withValues(alpha: 0.4), fontFamily: 'monospace',
                                )),
                                const SizedBox(height: 20),
                                // Skill progress bar
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(tr('الإتقان', 'Mastery'), style: TextStyle(fontSize: 11, color: d.color.withValues(alpha: 0.6))),
                                        Text('${d.progress}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: d.color)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: d.progress / 100,
                                        minHeight: 5,
                                        backgroundColor: d.color.withValues(alpha: 0.08),
                                        valueColor: AlwaysStoppedAnimation(d.color.withValues(alpha: 0.8)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Projects count
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: d.color.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.folder_open, size: 14, color: d.color),
                                      const SizedBox(width: 6),
                                      Text('${d.projects} ${tr('مشاريع', 'Projects')}', style: TextStyle(fontSize: 12, color: d.color, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 32),
                          // Right: Title, Description, Features, Tags
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title, style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white, height: 1.3,
                                )),
                                const SizedBox(height: 12),
                                Text(desc, style: const TextStyle(
                                  fontSize: 15, color: Color(0xFFA6ABB6), height: 1.7,
                                )),
                                const SizedBox(height: 20),
                                // Feature list
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 8,
                                  children: d.features.map((f) => Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check_circle, size: 15, color: d.color.withValues(alpha: 0.8)),
                                      const SizedBox(width: 5),
                                      Text(f, style: TextStyle(fontSize: 13, color: d.color.withValues(alpha: 0.9), fontWeight: FontWeight.w500)),
                                    ],
                                  )).toList(),
                                ),
                                const SizedBox(height: 16),
                                // Tags
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: d.tags.map((tag) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: d.color.withValues(alpha: widget.isHovered ? 0.14 : 0.06),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: d.color.withValues(alpha: widget.isHovered ? 0.35 : 0.12)),
                                    ),
                                    child: Text(tag, style: TextStyle(fontSize: 12, color: d.color, fontWeight: FontWeight.w600)),
                                  )).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    // Mobile layout
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: widget.isHovered
                                    ? LinearGradient(colors: [d.color.withValues(alpha: 0.25), d.color.withValues(alpha: 0.08)])
                                    : null,
                                color: widget.isHovered ? null : d.color.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: _ServiceIcon3D(icon: d.icon, color: d.color, isHovered: widget.isHovered),
                            ),
                            const SizedBox(width: 16),
                            Text(d.number, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: d.color.withValues(alpha: 0.3), fontFamily: 'monospace')),
                            const Spacer(),
                            // Mini progress
                            SizedBox(
                              width: 50, height: 50,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: d.progress / 100,
                                    strokeWidth: 4,
                                    backgroundColor: d.color.withValues(alpha: 0.1),
                                    valueColor: AlwaysStoppedAnimation(d.color),
                                  ),
                                  Text('${d.progress}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: d.color)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                        const SizedBox(height: 10),
                        Text(desc, style: const TextStyle(fontSize: 14, color: Color(0xFFA6ABB6), height: 1.7)),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 10, runSpacing: 6,
                          children: d.features.map((f) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, size: 14, color: d.color.withValues(alpha: 0.8)),
                              const SizedBox(width: 4),
                              Text(f, style: TextStyle(fontSize: 12, color: d.color.withValues(alpha: 0.9), fontWeight: FontWeight.w500)),
                            ],
                          )).toList(),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: d.tags.map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: d.color.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: d.color.withValues(alpha: 0.12)),
                            ),
                            child: Text(tag, style: TextStyle(fontSize: 11, color: d.color, fontWeight: FontWeight.w600)),
                          )).toList(),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Expandable details section
              SizeTransition(
                sizeFactor: _expandAnim,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF080C16),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: d.color.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome, color: d.color, size: 18),
                            const SizedBox(width: 8),
                            Text(tr('لماذا نحن؟', 'Why Choose Us?'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: d.color)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tr(
                            'فريقنا من المطورين المحترفين يمتلك خبرة تزيد عن 5 سنوات في هذا المجال. نستخدم أحدث التقنيات وأفضل الممارسات لضمان تحصل على منتج رقمي متميز يفوق توقعاتك.',
                            'Our team of professional developers has over 5 years of experience. We use the latest technologies and best practices to ensure you get a digital product that exceeds your expectations.',
                          ),
                          style: const TextStyle(fontSize: 14, color: Color(0xFFA6ABB6), height: 1.8),
                        ),
                        const SizedBox(height: 16),
                        // Tech icons row
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: d.tags.map((t) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: d.color.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(t, style: TextStyle(fontSize: 11, color: d.color, fontWeight: FontWeight.w600, fontFamily: 'monospace')),
                          )).toList(),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => _SampleProjectDialog(
                                title: LanguageManager.instance.isArabic ? d.titleAr : d.titleEn,
                                color: d.color,
                                serviceIndex: int.parse(d.number) - 1,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: d.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: d.color.withValues(alpha: 0.25)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.remove_red_eye, color: d.color, size: 18),
                                const SizedBox(width: 8),
                                Text(tr('عرض عينات', 'View Samples'), style: TextStyle(color: d.color, fontSize: 14, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Tap hint
              AnimatedOpacity(
                opacity: _expanded ? 0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(Icons.keyboard_arrow_down, color: d.color.withValues(alpha: 0.4), size: 20),
                      ),
                      const SizedBox(width: 4),
                      Text(tr('اضغط للمزيد', 'Tap for more'), style: TextStyle(fontSize: 11, color: d.color.withValues(alpha: 0.4))),
                    ],
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

class FAQSection extends StatefulWidget {
  const FAQSection({super.key});

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  int _expandedIndex = -1;

  final _faqs = [
    {
      'questionAr': 'هل تدعم المتاجر والأنظمة المبرمجة بواسطة Code Master طرق الدفع المحلية في العراق؟',
      'questionEn': 'Does Code Master support local payment methods in Iraq for stores and systems?',
      'answerAr': 'نعم بكل تأكيد. نحن ندرك أهمية البيئة المالية المحلية، لذا نتولى بشكل كامل ربط بوابة دفع زين كاش، وآسيا حوالة، وبطاقات الائتمان بداخل موقعك أو تطبيقك. هذا يتيح للمستخدمين في بغداد، العمارة، البصرة، وكافة المحافظات العراقية إتمام عمليات الشراء والدفع بأمان وسهولة فائقة.',
      'answerEn': 'Absolutely. We fully integrate Zain Cash, Asia Hawala, and credit card payment gateways into your website or app. This enables users in Baghdad, Al-Amarah, Basra, and all Iraqi governorates to complete purchases securely and easily.',
    },
    {
      'questionAr': 'ما الذي يجعل Code Master أفضل شركة حلول تقنية برمجية في العراق؟',
      'questionEn': 'What makes Code Master the best software solutions company in Iraq?',
      'answerAr': 'تميزنا يكمن في تقديم حلول تقنية متكاملة ومخصصة لكل عميل؛ فنحن لا نكتفي بكتابة كود برمجي، بل نؤمن مشروعك باستضافة فائقة السرعة مدعومة بتقنيات توزيع المحتوى والـ Cloudflare لتقليل زمن الاستجابة داخل العراق، بالإضافة إلى توفير حماية مشددة لقواعد البيانات، ودعم فني متواصل على مدار الساعة يضمن استقرار عمل أنظمتك وموقعك دون أي انقطاع.',
      'answerEn': 'Our distinction lies in delivering integrated, customized tech solutions for every client. We go beyond coding — we provision high-speed hosting powered by Cloudflare CDN for minimal latency within Iraq, provide robust database protection, and offer 24/7 technical support to ensure your systems and website run without interruption.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      children: [
        _WaveDivider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 48, vertical: isMobile ? 36 : 60),
          child: Column(
            children: [
              _SectionHeader(
                title: tr('الأسئلة الشائعة', 'Frequently Asked Questions'),
                subtitle: tr('إجابات على أكثر الاستفسارات شيوعاً', 'Answers to the most common questions'),
              ),
              const SizedBox(height: 48),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  children: List.generate(_faqs.length, (i) {
                    final faq = _faqs[i];
                    final isExpanded = _expandedIndex == i;
                    final question = LanguageManager.instance.isArabic ? faq['questionAr']! : faq['questionEn']!;
                    final answer = LanguageManager.instance.isArabic ? faq['answerAr']! : faq['answerEn']!;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => setState(() => _expandedIndex = isExpanded ? -1 : i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0B1018),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isExpanded ? const Color(0xFF1080E0).withValues(alpha: 0.4) : const Color(0xFF1080E0).withValues(alpha: 0.06),
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [const Color(0xFF1080E0).withValues(alpha: 0.12), const Color(0xFF1080E0).withValues(alpha: 0.04)]),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(Icons.question_answer, color: Color(0xFF2090FF), size: 20),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, height: 1.5)),
                                      ),
                                      const SizedBox(width: 12),
                                      AnimatedRotation(
                                        turns: isExpanded ? 0.5 : 0,
                                        duration: const Duration(milliseconds: 300),
                                        child: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1080E0), size: 24),
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedCrossFade(
                                  firstChild: const SizedBox.shrink(),
                                  secondChild: Padding(
                                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF080C16),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.06)),
                                      ),
                                      child: Text(answer, style: const TextStyle(fontSize: 15, color: Color(0xFF8892A4), height: 1.8)),
                                    ),
                                  ),
                                  crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                  duration: const Duration(milliseconds: 300),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FloatingSupportButton extends StatefulWidget {
  final VoidCallback onTap;
  const _FloatingSupportButton({required this.onTap});

  @override
  State<_FloatingSupportButton> createState() => _FloatingSupportButtonState();
}

class _FloatingSupportButtonState extends State<_FloatingSupportButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  bool _hover = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (_, __) => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            transform: Matrix4.identity()..scale(_hover ? 1.08 : 1.0),
            transformAlignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 18 : 24,
              vertical: isMobile ? 14 : 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1080E0),
                  if (_hover) const Color(0xFF2090FF) else const Color(0xFF1080E0),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1080E0).withValues(
                    alpha: _hover ? 0.4 : 0.15 + _pulseCtrl.value * 0.1,
                  ),
                  blurRadius: _hover ? 28 : 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.headset_mic, color: Colors.white, size: 22),
                if (!isMobile) ...[
                  const SizedBox(width: 10),
                  Text(
                    tr('الدعم', 'Support'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CTASection extends StatefulWidget {
  const CTASection({super.key});

  @override
  State<CTASection> createState() => _CTASectionState();
}

class _CTASectionState extends State<CTASection> {
  bool _hoverWA = false;
  bool _hoverTG = false;

  void _openPortal(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => PortalEntryPage(
          onEnter: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => InfinitePortalPage(onBack: () => Navigator.pop(context)),
                transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
                transitionDuration: const Duration(milliseconds: 600),
              ),
            );
          },
          onBack: () => Navigator.pop(context),
        ),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 48, vertical: isMobile ? 36 : 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: _AnimatedGradientBorder(
            color: const Color(0xFF1080E0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(isMobile ? 32 : 60),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1018),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Stack(
                children: [
                  // Decorative orbs
                  Positioned(
                    top: -100, right: -100,
                    child: Container(
                      width: 280, height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          const Color(0xFF1080E0).withValues(alpha: 0.08),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -80, left: -80,
                    child: Container(
                      width: 220, height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          const Color(0xFF2090FF).withValues(alpha: 0.05),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFFFFFFF), Color(0xFF90C8FF)],
                        ).createShader(bounds),
                        child: Text(
                          tr('جاهز لبناء المستقبل الرقمي؟', 'Ready to Build the Digital Future?'),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: isMobile ? 26 : 36, fontWeight: FontWeight.w900, color: Colors.white, height: 1.3),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tr('تواصل معنا الآن واحصل على استشارة مجانية', 'Contact us now for a free consultation'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Color(0xFF8892A4)),
                      ),
                      const SizedBox(height: 44),
                      Wrap(
                        spacing: 16, runSpacing: 12, alignment: WrapAlignment.center,
                        children: [
                          _CTAButton(
                            label: 'واتساب | WhatsApp',
                            customIcon: const _WhatsAppIcon(size: 20),
                            color: const Color(0xFF25D366),
                            url: 'https://wa.me/9647771632241',
                            isHovered: _hoverWA,
                            onHover: (v) => setState(() => _hoverWA = v),
                          ),
                          _CTAButton(
                            label: 'Telegram',
                            icon: Icons.send,
                            color: const Color(0xFF0088cc),
                            url: 'https://t.me/codemaster6',
                            isHovered: _hoverTG,
                            onHover: (v) => setState(() => _hoverTG = v),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CTAButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Widget? customIcon;
  final Color color;
  final String url;
  final bool isHovered;
  final ValueChanged<bool> onHover;

  const _CTAButton({
    required this.label,
    this.icon,
    this.customIcon,
    required this.color,
    required this.url,
    this.isHovered = false,
    required this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                if (isHovered) Color.lerp(color, Colors.white, 0.15)! else color,
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: isHovered
                ? [BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 4))]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              customIcon ?? Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF0D1220), width: 1)),
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              return isWide
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLogo(),
                        const SizedBox(width: 40),
                        Expanded(child: _buildNavLinks(context)),
                        const SizedBox(width: 40),
                        _buildSocialLinks(),
                      ],
                    )
                  : Column(
                      children: [
                        _buildLogo(),
                        const SizedBox(height: 32),
                        _buildNavLinks(context),
                        const SizedBox(height: 32),
                        _buildSocialLinks(),
                      ],
                    );
            },
          ),
          const SizedBox(height: 44),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(0xFF1080E0).withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${tr('© 2026', '© 2026')} ',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
                const TextSpan(
                  text: 'Code Master. ',
                  style: TextStyle(fontSize: 13, color: Color(0xFF1080E0), fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: tr('جميع الحقوق محفوظة - العراق', 'All rights reserved - Iraq'),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr('العمارة، ميسان، العراق', 'Al-Amarah, Maysan, Iraq'),
            style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Code',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          TextSpan(
            text: 'Master',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFF1080E0)),
          ),
        ],
      ),
    );
  }

  Widget _buildNavLinks(BuildContext context) {
    return Wrap(
      spacing: 28,
      runSpacing: 14,
      alignment: WrapAlignment.center,
      children: [
        _FooterLink(label: tr('الخدمات', 'Services'), onTap: () {}),
        _FooterLink(label: tr('رؤيتنا', 'Vision'), onTap: () {}),
        _FooterLink(label: tr('اتصل بنا', 'Contact'), onTap: () {}),
      ],
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialIcon(customIcon: const _WhatsAppIcon(size: 20), color: const Color(0xFF25D366), url: 'https://wa.me/9647771632241'),
        const SizedBox(width: 12),
        _SocialIcon(icon: Icons.send, color: const Color(0xFF0088cc), url: 'https://t.me/codemaster6'),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFA6ABB6),
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData? icon;
  final Widget? customIcon;
  final Color color;
  final String url;

  const _SocialIcon({
    this.icon,
    this.customIcon,
    required this.color,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: customIcon ?? Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}

class _WhatsAppIcon extends StatelessWidget {
  final double size;
  const _WhatsAppIcon({this.size = 20});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _WhatsAppIconPainter(),
    );
  }
}

class _WhatsAppIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    final center = Offset(size.width / 2, size.height / 2);

    final bgPaint = Paint()..color = const Color(0xFF25D366);
    canvas.drawOval(Rect.fromCenter(center: center, width: 22 * scale, height: 22 * scale), bgPaint);

    final path = Path();
    path.moveTo(12 * scale, 5.5 * scale);
    path.cubicTo(8.4 * scale, 5.5 * scale, 5.5 * scale, 8.4 * scale, 5.5 * scale, 12 * scale);
    path.cubicTo(5.5 * scale, 13.2 * scale, 5.8 * scale, 14.3 * scale, 6.4 * scale, 15.3 * scale);
    path.lineTo(5.2 * scale, 18.8 * scale);
    path.lineTo(8.9 * scale, 17.7 * scale);
    path.cubicTo(9.9 * scale, 18.2 * scale, 10.9 * scale, 18.5 * scale, 12 * scale, 18.5 * scale);
    path.cubicTo(15.6 * scale, 18.5 * scale, 18.5 * scale, 15.6 * scale, 18.5 * scale, 12 * scale);
    path.cubicTo(18.5 * scale, 8.4 * scale, 15.6 * scale, 5.5 * scale, 12 * scale, 5.5 * scale);
    path.close();

    path.moveTo(10.2 * scale, 9.2 * scale);
    path.lineTo(11.2 * scale, 9.2 * scale);
    path.cubicTo(11.5 * scale, 9.2 * scale, 11.8 * scale, 9.5 * scale, 11.8 * scale, 9.8 * scale);
    path.lineTo(11.8 * scale, 11 * scale);
    path.cubicTo(11.8 * scale, 11.3 * scale, 11.5 * scale, 11.6 * scale, 11.2 * scale, 11.6 * scale);
    path.lineTo(10.8 * scale, 11.6 * scale);
    path.cubicTo(10.5 * scale, 12.1 * scale, 10.3 * scale, 12.6 * scale, 10.1 * scale, 13.2 * scale);
    path.lineTo(10 * scale, 13.2 * scale);
    path.cubicTo(9.7 * scale, 13.2 * scale, 9.4 * scale, 12.9 * scale, 9.4 * scale, 12.6 * scale);
    path.lineTo(9.4 * scale, 11.8 * scale);
    path.cubicTo(9.4 * scale, 11.2 * scale, 9.7 * scale, 10.7 * scale, 10.2 * scale, 10.3 * scale);
    path.close();

    path.moveTo(12.9 * scale, 13.2 * scale);
    path.cubicTo(12.9 * scale, 13.2, 13.3 * scale, 14.8 * scale, 13.4 * scale, 15.2 * scale);
    path.cubicTo(13.4 * scale, 15.3 * scale, 13.4 * scale, 15.4 * scale, 13.3 * scale, 15.5 * scale);
    path.lineTo(13 * scale, 15.2 * scale);
    path.cubicTo(12.8 * scale, 15.1 * scale, 12.6 * scale, 15 * scale, 12.3 * scale, 14.8 * scale);
    path.cubicTo(11.3 * scale, 14.4 * scale, 10.4 * scale, 13.5 * scale, 10 * scale, 12.6 * scale);
    path.cubicTo(9.8 * scale, 12.1 * scale, 10.1 * scale, 11.6 * scale, 10.6 * scale, 11.4 * scale);
    path.lineTo(11 * scale, 11.3 * scale);
    path.cubicTo(11.3 * scale, 11.2 * scale, 11.5 * scale, 11 * scale, 11.6 * scale, 10.7 * scale);
    path.lineTo(12 * scale, 9.5 * scale);
    path.cubicTo(12.1 * scale, 9.2 * scale, 12.4 * scale, 9 * scale, 12.7 * scale, 9 * scale);
    path.lineTo(13.8 * scale, 9 * scale);
    path.cubicTo(14.1 * scale, 9 * scale, 14.4 * scale, 9.3 * scale, 14.4 * scale, 9.6 * scale);
    path.lineTo(14.4 * scale, 10.5 * scale);
    path.cubicTo(14.4 * scale, 10.8 * scale, 14.2 * scale, 11 * scale, 13.9 * scale, 11.1 * scale);
    path.close();

    final fillPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WidgetDirectionalityFix extends StatelessWidget {
  final Widget child;

  const WidgetDirectionalityFix({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isArabic = LanguageManager.instance.isArabic;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: child,
    );
  }
}
