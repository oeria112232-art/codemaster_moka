import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'components.dart';
import 'custom_cursor.dart';
import 'portal/clean_hero_bg.dart';
import 'pages.dart';
import 'pages/portal_entry.dart';
import 'pages/infinite_portal.dart';

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
            scaffoldBackgroundColor: const Color(0xFF090D16),
            primaryColor: const Color(0xFF1080E0),
            fontFamily: 'Inter',
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1080E0),
              surface: Color(0xFF090D16),
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
  final GlobalKey _valuesKey = GlobalKey();
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
    } else if (link == '#values') {
      _scrollToKey(_valuesKey);
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
                Container(
                  key: _valuesKey,
                  child: _ScrollReveal(
                    scrollController: _scrollController,
                    child: const ValuesSection(),
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
          width: 48,
          height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1080E0), Color(0xFF2090FF)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFA6ABB6),
              height: 1.6,
            ),
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

  const HeroSection({
    super.key,
    required this.onGetStarted,
    required this.onServices,
    required this.onPortal,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with TickerProviderStateMixin {
  late final AnimationController _badgeCtrl;
  late final AnimationController _glowCtrl;
  late final Animation<double> _badgePulse;
  late final Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();
    _badgeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500))..repeat(reverse: true);
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat(reverse: true);
    _badgePulse = Tween<double>(begin: 0.85, end: 1.0).animate(CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeInOut));
    _glowOpacity = Tween<double>(begin: 0.05, end: 0.18).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _badgeCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: [
          const Positioned.fill(child: CleanHeroBg()),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _glowCtrl,
              builder: (_, __) => Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.2),
                    radius: 1.2,
                    colors: [
                      const Color(0xFF1080E0).withValues(alpha: _glowOpacity.value),
                      const Color(0xFF2090FF).withValues(alpha: _glowOpacity.value * 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0, height: 200,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xFF090D16)],
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
                  // Animated glow dot
                  AnimatedBuilder(
                    animation: _badgePulse,
                    builder: (_, __) => Container(
                      width: 6 * _badgePulse.value,
                      height: 6 * _badgePulse.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1080E0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1080E0).withValues(alpha: 0.4 * _badgePulse.value),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Badge with animated pulse
                  AnimatedBuilder(
                    animation: _badgePulse,
                    builder: (_, __) => Transform.scale(
                      scale: _badgePulse.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF1080E0).withValues(alpha: 0.15),
                              const Color(0xFF2090FF).withValues(alpha: 0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.35)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1080E0).withValues(alpha: 0.08),
                              blurRadius: 16,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7, height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF2090FF),
                                boxShadow: [BoxShadow(color: const Color(0xFF2090FF).withValues(alpha: 0.6), blurRadius: 6)],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              tr('شريكك التقني المتكامل في العراق', 'Your Integrated Tech Partner in Iraq'),
                              style: const TextStyle(
                                color: Color(0xFF1080E0),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Title — Code Master with gradient
                  Semantics(
                    header: true,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF1080E0), Color(0xFF40A0FF), Color(0xFF2090FF)],
                      ).createShader(bounds),
                      child: Text(
                        'Code Master',
                        style: TextStyle(
                          fontSize: size.width > 600 ? 82 : 46,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 5,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Subtitle
                  Text(
                    tr(
                      'أفضل شركة حلول تقنية وتصميم تطبيقات في العراق',
                      'Best Software Solutions & App Development in Iraq',
                    ),
                    style: TextStyle(
                      fontSize: size.width > 600 ? 21 : 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2090FF),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Description
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 660),
                    child: Text(
                      tr(
                        'مرحباً بك في منصة Code Master للحلول البرمجية المتكاملة. نحن نبتكر ونطور أحدث الحلول التقنية للشركات في العراق، ونمكّن أصحاب الأعمال والشركات الناشئة من امتلاك بنية رقمية قوية عبر تصميم مواقع إلكترونية احترافية وتطوير تطبيقات الموبايل الذكية.',
                        'Welcome to Code Master. We innovate and develop the latest tech solutions for businesses in Iraq, empowering entrepreneurs with professional websites and smart mobile apps.',
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: size.width > 600 ? 16 : 13.5,
                        color: const Color(0xFFA6ABB6),
                        height: 1.95,
                      ),
                    ),
                  ),
                  const SizedBox(height: 44),
                  // Buttons
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _HeroButton(
                        label: tr('ابدأ مشروعك الآن', 'Start Your Project Now'),
                        isSolid: true,
                        onPressed: widget.onGetStarted,
                      ),
                      _HeroButton(
                        label: tr('خدماتنا', 'Our Services'),
                        isSolid: false,
                        onPressed: widget.onServices,
                      ),
                      _HeroButton(
                        label: tr('حدود إبداعنا', 'Creative Bounds'),
                        isSolid: false,
                        onPressed: widget.onPortal,
                      ),
                    ],
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
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            gradient: widget.isSolid
                ? LinearGradient(colors: [
                    baseColor,
                    if (_hover) const Color(0xFF2090FF) else baseColor,
                  ])
                : null,
            color: widget.isSolid ? null : const Color(0xFF141A29),
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
    _counterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFF141A29).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(color: const Color(0xFF1080E0).withValues(alpha: 0.04), blurRadius: 40, spreadRadius: 0),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _AnimatedStat(
            target: 50,
            prefix: '+',
            label: tr('مشروع مكتمل', 'Projects'),
            animation: _counterCtrl,
            icon: Icons.rocket_launch,
          ),
          Container(width: 1, height: 40, color: const Color(0xFF1080E0).withValues(alpha: 0.1)),
          _AnimatedStat(
            target: 30,
            prefix: '+',
            label: tr('عميل راضي', 'Clients'),
            animation: _counterCtrl,
            icon: Icons.people,
          ),
          Container(width: 1, height: 40, color: const Color(0xFF1080E0).withValues(alpha: 0.1)),
          _AnimatedStat(
            target: 5,
            prefix: '+',
            label: tr('سنوات خبرة', 'Years'),
            animation: _counterCtrl,
            icon: Icons.workspace_premium,
          ),
          Container(width: 1, height: 40, color: const Color(0xFF1080E0).withValues(alpha: 0.1)),
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
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final v = (animation.value * target).toInt();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1080E0).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF1080E0), size: 22),
            ),
            const SizedBox(height: 12),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF1080E0), Color(0xFF40A0FF)],
              ).createShader(bounds),
              child: Text(
                '$prefix$v',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFA6ABB6),
                fontWeight: FontWeight.w500,
              ),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF1080E0).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF1080E0), size: 22),
        ),
        const SizedBox(height: 12),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF1080E0), Color(0xFF40A0FF)],
          ).createShader(bounds),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFFA6ABB6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class VisionSection extends StatelessWidget {
  const VisionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          _SectionHeader(
            title: tr('رؤيتنا ورسالتنا', 'Our Vision & Mission'),
            subtitle: tr(
              'نلتزم بقيادة التحول الرقمي للشركات والمؤسسات في العراق',
              'Committed to leading digital transformation for businesses in Iraq',
            ),
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildVisionCard()),
                        const SizedBox(width: 24),
                        Expanded(child: _buildMissionCard()),
                      ],
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
    );
  }

  Widget _buildVisionCard() {
    return Builder(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF141A29),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF1080E0).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1080E0).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.visibility,
                  color: Color(0xFF1080E0),
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                tr('رؤيتنا', 'Our Vision'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                tr(
                  'أن نكون الشريك التقني الأول في العراق والمنطقة، من خلال تقديم حلول برمجية مبتكرة تتجاوز توقعات عملائنا وتساهم في تحولهم الرقمي.',
                  'To be the leading tech partner in the region by delivering innovative solutions that exceed our clients\' expectations and contribute to their digital transformation.',
                ),
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFFA6ABB6),
                  height: 1.7,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMissionCard() {
    return Builder(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
          color: const Color(0xFF141A29),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF2090FF).withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2090FF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.flag,
                color: Color(0xFF2090FF),
                size: 28,
              ),
            ),
              const SizedBox(height: 20),
              Text(
                tr('مهمتنا', 'Our Mission'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                tr(
                  'تمكين الشركات والمؤسسات في العراق من خلال منتجات رقمية متكاملة عالية الجودة، مبنية على أسس هندسية صلبة ومصممة لتحقيق أقصى عائد على استثمارهم التقني.',
                  'Empowering companies through high-quality integrated digital products, built on solid engineering principles and designed to maximize their technology ROI.',
                ),
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFFA6ABB6),
                  height: 1.7,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStrategicGoals() {
    return Builder(
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF141A29),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF1080E0).withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr('الأهداف الاستراتيجية', 'Strategic Goals'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              _GoalItem(
                icon: Icons.trending_up,
                text:                 tr('التوسع في خدماتنا التقنية داخل العراق والمنطقة', 'Expanding our tech services across Iraq and the region'),
              ),
              const SizedBox(height: 16),
              _GoalItem(
                icon: Icons.cloud_queue,
                text: tr('تبني تقنيات الحوسبة السحابية المتقدمة', 'Adopting advanced cloud computing technologies'),
              ),
              const SizedBox(height: 16),
              _GoalItem(
                icon: Icons.public,
                text: tr('بناء شراكات استراتيجية عالمية', 'Building global strategic partnerships'),
              ),
              const SizedBox(height: 16),
              _GoalItem(
                icon: Icons.star,
                text: tr('تحقيق أعلى معايير جودة الخدمات', 'Achieving the highest service quality standards'),
              ),
            ],
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1080E0).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF1080E0), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFFA6ABB6),
            ),
          ),
        ),
      ],
    );
  }
}

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      _ServiceData(
        number: '01',
        titleEn: 'Mobile App Development',
        titleAr: 'تصميم وتطوير تطبيقات الموبايل',
        descriptionEn: 'We specialize in programming and designing professional mobile apps for iPhone and Android. Using Flutter framework for fast, modern UIs that adapt to all screen sizes.',
        descriptionAr: 'نحن متخصصون في برمجة وتصميم تطبيقات احترافية للهواتف الذكية بنظامي آيفون وأندرويد. نعتمد على أحدث التقنيات البرمجية العالمية مثل إطار عمل فلاتر لنمنحك تطبيقاً سريعاً، ذا واجهة مستخدم عصرية، ومتوافقاً مع كافة الشاشات ليلبي تطلعات عملائك في السوق العراقي.',
        icon: Icons.phone_android,
        color: const Color(0xFF1080E0),
        tags: ['Flutter', 'iOS', 'Android', 'UI/UX'],
      ),
      _ServiceData(
        number: '02',
        titleEn: 'E-Commerce & Digital Stores',
        titleAr: 'حلول التجارة الإلكترونية والمتاجر الرقمية',
        descriptionEn: 'Complete e-commerce stores with smart dashboards for product management. Local payment gateway integration including Zain Cash, Asia Hawala, and credit cards.',
        descriptionAr: 'نوفر خدمات تصميم متجر إلكتروني متكامل في العراق مع لوحة تحكم ذكية وشاملة لإدارة المنتجات والمبيعات. الميزة الأهم لدينا هي دعم وتسهيل ربط بوابات الدفع المحلية مثل زين كاش وآسيا حوالة بداخل التطبيقات والمواقع، مما يضمن لعملائك تجربة تسوق محلية وسلسة تزيد من نسب أرباحك.',
        icon: Icons.shopping_cart,
        color: const Color(0xFF2090FF),
        tags: ['Zain Cash', 'Asia Hawala', 'Store', 'Payment'],
      ),
      _ServiceData(
        number: '03',
        titleEn: 'Enterprise Systems & ERP',
        titleAr: 'الأنظمة الإدارية وأتمتة الأعمال للشركات',
        descriptionEn: 'Custom database development, ERP systems, sales & inventory management, and process automation to boost efficiency.',
        descriptionAr: 'نساعدك على تنظيم وإدارة شركتك من خلال برمجة وتطوير قواعد بيانات مخصصة وأنظمة إدارة المؤسسات ERP. نوفر حلولاً ذكية تشمل برمجة نظام مبيعات ومخازن، تتبع حركة الموظفين والعملاء، وأتمتة العمليات اليومية لرفع الكفاءة التشغيلية وتقليل الأخطاء البشرية.',
        icon: Icons.business_center,
        color: const Color(0xFF25D366),
        tags: ['ERP', 'CRM', 'Database', 'Automation'],
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          _SectionHeader(
            title: tr('خدماتنا البرمجية', 'Our Software Services'),
            subtitle: tr(
              'حلول تقنية شاملة مصممة خصيصاً للشركات والمؤسسات في العراق',
              'Comprehensive tech solutions designed specifically for businesses in Iraq',
            ),
          ),
          const SizedBox(height: 48),
          ...services.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _ServiceCard(data: s),
              )),
        ],
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

  const _ServiceData({
    required this.number,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.icon,
    required this.color,
    required this.tags,
  });
}

class _ServiceCard extends StatefulWidget {
  final _ServiceData data;

  const _ServiceCard({required this.data});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final title = LanguageManager.instance.isArabic ? d.titleAr : d.titleEn;
    final desc = LanguageManager.instance.isArabic ? d.descriptionAr : d.descriptionEn;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF141A29),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? d.color.withValues(alpha: 0.5)
                : d.color.withValues(alpha: 0.08),
            width: _isHovered ? 1.5 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(color: d.color.withValues(alpha: 0.12), blurRadius: 35, spreadRadius: 0),
                  BoxShadow(color: d.color.withValues(alpha: 0.05), blurRadius: 60, spreadRadius: 0),
                ]
              : [],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Number + Icon column
                  Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: _isHovered
                              ? LinearGradient(colors: [d.color.withValues(alpha: 0.2), d.color.withValues(alpha: 0.05)])
                              : null,
                          color: _isHovered ? null : d.color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: _isHovered
                              ? [BoxShadow(color: d.color.withValues(alpha: 0.15), blurRadius: 16)]
                              : [],
                        ),
                        child: Icon(d.icon, color: d.color, size: 34),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        d.number,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: d.color.withValues(alpha: 0.5),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 28),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          desc,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFA6ABB6),
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: d.tags.map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: d.color.withValues(alpha: _isHovered ? 0.12 : 0.06),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: d.color.withValues(alpha: _isHovered ? 0.3 : 0.12)),
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: _isHovered
                            ? LinearGradient(colors: [d.color.withValues(alpha: 0.2), d.color.withValues(alpha: 0.05)])
                            : null,
                        color: _isHovered ? null : d.color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(d.icon, color: d.color, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      d.number,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: d.color.withValues(alpha: 0.3), fontFamily: 'monospace'),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 18),
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 10),
                Text(desc, style: const TextStyle(fontSize: 14, color: Color(0xFFA6ABB6), height: 1.7)),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: d.tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: d.color.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: d.color.withValues(alpha: 0.12)),
                    ),
                    child: Text(tag, style: TextStyle(fontSize: 12, color: d.color, fontWeight: FontWeight.w600)),
                  )).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ValuesSection extends StatelessWidget {
  const ValuesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final values = [
      _ValueData(
        icon: Icons.verified,
        titleEn: 'Professionalism',
        titleAr: 'الاحترافية',
        descriptionEn: 'We uphold the highest professional standards in every project.',
        descriptionAr: 'نلتزم بأعلى المعايير المهنية في كل مشروع.',
        color: const Color(0xFF1080E0),
      ),
      _ValueData(
        icon: Icons.stars,
        titleEn: 'Quality',
        titleAr: 'الجودة',
        descriptionEn: 'Excellence is not negotiable. We deliver top-tier quality.',
        descriptionAr: 'التميز غير قابل للتفاوض. نقدم جودة من الطراز الأول.',
        color: const Color(0xFF2090FF),
      ),
      _ValueData(
        icon: Icons.lightbulb,
        titleEn: 'Innovation',
        titleAr: 'الابتكار',
        descriptionEn: 'We push boundaries with creative and forward-thinking solutions.',
        descriptionAr: 'ندفع الحدود بحلول إبداعية ومبتكرة.',
        color: const Color(0xFF25D366),
      ),
      _ValueData(
        icon: Icons.people,
        titleEn: 'Client Focus',
        titleAr: 'التركيز على العميل',
        descriptionEn: 'Your success is our mission. We put clients at the center.',
        descriptionAr: 'نجاحك مهمتنا. نضع العميل في مركز اهتمامنا.',
        color: const Color(0xFFFFB020),
      ),
      _ValueData(
        icon: Icons.speed,
        titleEn: 'Speed',
        titleAr: 'السرعة',
        descriptionEn: 'Fast delivery without compromising quality or attention to detail.',
        descriptionAr: 'تسليم سريع دون المساس بالجودة أو الاهتمام بالتفاصيل.',
        color: const Color(0xFF40A0FF),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          _SectionHeader(
            title: tr('قيمنا', 'Our Values'),
            subtitle: tr(
              'المبادئ التي نؤمن بها ونعمل وفقها',
              'The principles we believe in and work by',
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: values.map((v) => _ValueCard(data: v)).toList(),
          ),
        ],
      ),
    );
  }
}

class _ValueData {
  final IconData icon;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final Color color;

  const _ValueData({
    required this.icon,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.color,
  });
}

class _ValueCard extends StatefulWidget {
  final _ValueData data;

  const _ValueCard({required this.data});

  @override
  State<_ValueCard> createState() => _ValueCardState();
}

class _ValueCardState extends State<_ValueCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final title = LanguageManager.instance.isArabic ? d.titleAr : d.titleEn;
    final desc = LanguageManager.instance.isArabic ? d.descriptionAr : d.descriptionEn;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        width: 220,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF141A29),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _isHovered ? d.color.withValues(alpha: 0.5) : d.color.withValues(alpha: 0.08),
            width: _isHovered ? 1.5 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(color: d.color.withValues(alpha: 0.12), blurRadius: 28, spreadRadius: 0),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: _isHovered
                    ? LinearGradient(colors: [d.color.withValues(alpha: 0.2), d.color.withValues(alpha: 0.05)])
                    : null,
                color: _isHovered ? null : d.color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isHovered
                    ? [BoxShadow(color: d.color.withValues(alpha: 0.2), blurRadius: 14)]
                    : [],
              ),
              child: Icon(d.icon, color: d.color, size: 32),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFA6ABB6),
                height: 1.6,
              ),
            ),
          ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          _SectionHeader(
            title: tr('الأسئلة الشائعة', 'Frequently Asked Questions'),
            subtitle: tr(
              'إجابات على أكثر الاستفسارات شيوعاً حول خدماتنا',
              'Answers to the most common questions about our services',
            ),
          ),
          const SizedBox(height: 48),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: List.generate(_faqs.length, (i) {
                final faq = _faqs[i];
                final isExpanded = _expandedIndex == i;
                final question = LanguageManager.instance.isArabic
                    ? faq['questionAr']!
                    : faq['questionEn']!;
                final answer = LanguageManager.instance.isArabic
                    ? faq['answerAr']!
                    : faq['answerEn']!;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _expandedIndex = isExpanded ? -1 : i;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141A29),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isExpanded
                                ? const Color(0xFF1080E0).withValues(alpha: 0.4)
                                : const Color(0xFF1080E0).withValues(alpha: 0.08),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1080E0).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.question_answer,
                                      color: Color(0xFF1080E0),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      question,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  AnimatedRotation(
                                    turns: isExpanded ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 300),
                                    child: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xFF1080E0),
                                      size: 24,
                                    ),
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
                                    color: const Color(0xFF0F1320),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF1080E0).withValues(alpha: 0.08),
                                    ),
                                  ),
                                  child: Text(
                                    answer,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFFA6ABB6),
                                      height: 1.8,
                                    ),
                                  ),
                                ),
                              ),
                              crossFadeState: isExpanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(52),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF141A29).withValues(alpha: 0.8),
                  const Color(0xFF0F1828),
                  const Color(0xFF141A29).withValues(alpha: 0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.15)),
              boxShadow: [
                BoxShadow(color: const Color(0xFF1080E0).withValues(alpha: 0.06), blurRadius: 50, spreadRadius: 0),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -80, right: -80,
                  child: Container(
                    width: 220, height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        const Color(0xFF1080E0).withValues(alpha: 0.1),
                        Colors.transparent,
                      ]),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -60, left: -60,
                  child: Container(
                    width: 180, height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        const Color(0xFF2090FF).withValues(alpha: 0.06),
                        Colors.transparent,
                      ]),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Gradient title
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFFFFFFF), Color(0xFFB0D4FF)],
                      ).createShader(bounds),
                      child: Text(
                        tr('جاهز لبناء المستقبل الرقمي؟', 'Ready to Build the Digital Future?'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tr(
                        'تواصل معنا الآن واحصل على استشارة مجانية لمشروعك',
                        'Contact us now and get a free consultation for your project',
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFA6ABB6),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _CTAButton(
                          label: 'WhatsApp',
                          icon: Icons.chat,
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
                    const SizedBox(height: 36),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1080E0).withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.12)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.phone, color: Color(0xFF1080E0), size: 18),
                          const SizedBox(width: 10),
                          Text(
                            '+964 777 163 2241',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF1080E0),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CTAButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String url;
  final bool isHovered;
  final ValueChanged<bool> onHover;

  const _CTAButton({
    required this.label,
    required this.icon,
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
              Icon(icon, color: Colors.white, size: 20),
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
        border: Border(top: BorderSide(color: Color(0xFF141A29), width: 1)),
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
            tr('العمارة، ميسان، العراق | +964 777 163 2241', 'Al-Amarah, Maysan, Iraq | +964 777 163 2241'),
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
        _FooterLink(label: tr('قيمنا', 'Values'), onTap: () {}),
        _FooterLink(label: tr('اتصل بنا', 'Contact'), onTap: () {}),
      ],
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialIcon(icon: Icons.chat, color: const Color(0xFF25D366), url: 'https://wa.me/9647771632241'),
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
  final IconData icon;
  final Color color;
  final String url;

  const _SocialIcon({
    required this.icon,
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
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
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
