import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'components.dart';
import 'custom_cursor.dart';
import 'hero_scene.dart';
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
          title: tr('CodeMaster - نبني المستقبل الرقمي', 'CodeMaster - Building the Digital Future'),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF090D16),
            primaryColor: const Color(0xFF3FD2FF),
            fontFamily: 'Inter',
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF3FD2FF),
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
              colors: [Color(0xFF3FD2FF), Color(0xFFA78BFA)],
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

class HeroSection extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onServices;

  const HeroSection({
    super.key,
    required this.onGetStarted,
    required this.onServices,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: [
          const Positioned.fill(child: HeroScene()),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.2),
                  radius: 1.2,
                  colors: [
                    const Color(0xFF3FD2FF).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xFF090D16),
                  ],
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
                  Container(
                    width: 48,
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3FD2FF), Color(0xFFA78BFA)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3FD2FF).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFF3FD2FF).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      tr('شريكك التقني المتكامل', 'Your Integrated Tech Partner'),
                      style: const TextStyle(
                        color: Color(0xFF3FD2FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF3FD2FF), Color(0xFFA78BFA)],
                    ).createShader(bounds),
                    child: Text(
                      'CodeMaster',
                      style: TextStyle(
                        fontSize: size.width > 600 ? 80 : 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    tr('حلول برمجية متكاملة', 'Integrated Software Solutions'),
                    style: TextStyle(
                      fontSize: size.width > 600 ? 22 : 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFA78BFA),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Text(
                      tr(
                        'نطور منصات رقمية مبتكرة تمنح الشركات القدرة على التفوق في عالم التكنولوجيا المتسارع',
                        'We develop innovative digital platforms that empower companies to excel in the rapidly evolving world of technology',
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: size.width > 600 ? 18 : 15,
                        color: const Color(0xFFA6ABB6),
                        height: 1.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      MagneticButton(
                        label: tr('ابدأ مشروعك الآن', 'Start Your Project Now'),
                        icon: const Icon(Icons.rocket_launch, size: 18),
                        isSolid: true,
                        onPressed: onGetStarted,
                      ),
                      MagneticButton(
                        label: tr('خدماتنا', 'Our Services'),
                        icon: const Icon(Icons.arrow_downward, size: 18),
                        isSolid: false,
                        onPressed: onServices,
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
        color: const Color(0xFF141A29).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF3FD2FF).withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _AnimatedStat(
            target: 50,
            prefix: '+',
            label: tr('مشروع مكتمل', 'Projects'),
            animation: _counterCtrl,
          ),
          _AnimatedStat(
            target: 30,
            prefix: '+',
            label: tr('عميل راضي', 'Clients'),
            animation: _counterCtrl,
          ),
          _AnimatedStat(
            target: 5,
            prefix: '+',
            label: tr('سنوات خبرة', 'Years'),
            animation: _counterCtrl,
          ),
          const _StaticStat(value: '24/7', label: 'Support / دعم'),
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

  const _AnimatedStat({
    required this.target,
    required this.prefix,
    required this.label,
    required this.animation,
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
            Text(
              '$prefix$v',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Color(0xFF3FD2FF),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFA6ABB6),
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
  const _StaticStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Color(0xFF3FD2FF),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFA6ABB6),
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
              'نلتزم بقيادة التحول الرقمي وتمكين الشركات من النجاح',
              'Committed to leading digital transformation and empowering companies to succeed',
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
              color: const Color(0xFF3FD2FF).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3FD2FF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.visibility,
                  color: Color(0xFF3FD2FF),
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
                  'أن نكون الشريك التقني الأول في المنطقة، من خلال تقديم حلول مبتكرة تتجاوز توقعات عملائنا وتساهم في تحولهم الرقمي.',
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
              color: const Color(0xFFA78BFA).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFA78BFA).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.flag,
                  color: Color(0xFFA78BFA),
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
                  'تمكين الشركات والمؤسسات من خلال منتجات رقمية متكاملة عالية الجودة، مبنية على أسس هندسية صلبة ومصممة لتحقيق أقصى عائد على استثمارهم التقني.',
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
              color: const Color(0xFF3FD2FF).withValues(alpha: 0.1),
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
                text: tr('التوسع الإقليمي في خدماتنا التقنية', 'Regional expansion of our tech services'),
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
            color: const Color(0xFF3FD2FF).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF3FD2FF), size: 20),
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
        titleEn: 'Web Development',
        titleAr: 'تطوير المواقع',
        descriptionEn: 'Custom websites built with cutting-edge technologies, responsive design, and optimized performance.',
        descriptionAr: 'مواقع مخصصة مبنية بأحدث التقنيات، تصميم متجاوب وأداء محسّن.',
        icon: Icons.language,
        color: const Color(0xFF3FD2FF),
        tags: ['React', 'Next.js', 'Flutter', 'Node.js'],
      ),
      _ServiceData(
        number: '02',
        titleEn: 'App Development',
        titleAr: 'تطوير التطبيقات',
        descriptionEn: 'Native and cross-platform mobile applications with seamless user experiences.',
        descriptionAr: 'تطبيقات موبايل أصلية ومتعددة المنصات مع تجارب مستخدم سلسة.',
        icon: Icons.phone_android,
        color: const Color(0xFFA78BFA),
        tags: ['Flutter', 'iOS', 'Android', 'Kotlin'],
      ),
      _ServiceData(
        number: '03',
        titleEn: 'System Development',
        titleAr: 'تطوير الأنظمة',
        descriptionEn: 'Enterprise-level systems, APIs, and backend architecture for scalable solutions.',
        descriptionAr: 'أنظمة مؤسسية، واجهات برمجية، وبنية تحتية قابلة للتوسع.',
        icon: Icons.settings_suggest,
        color: const Color(0xFF25D366),
        tags: ['Python', 'Django', 'AWS', 'Docker'],
      ),
      _ServiceData(
        number: '04',
        titleEn: 'Cybersecurity',
        titleAr: 'الأمن السيبراني',
        descriptionEn: 'Comprehensive security audits, penetration testing, and protection solutions.',
        descriptionAr: 'تدقيق أمني شامل، اختبار اختراق، وحلول حماية متقدمة.',
        icon: Icons.shield,
        color: const Color(0xFFFF6B6B),
        tags: ['Pen Testing', 'SOC', 'ISO 27001', 'Encryption'],
      ),
      _ServiceData(
        number: '05',
        titleEn: 'UI/UX Design',
        titleAr: 'تصميم واجهات المستخدم',
        descriptionEn: 'User-centered design with modern aesthetics and intuitive interactions.',
        descriptionAr: 'تصميم يركّز على المستخدم مع جماليات حديثة وتفاعلات بديهية.',
        icon: Icons.design_services,
        color: const Color(0xFFFFD93D),
        tags: ['Figma', 'Prototyping', 'Research', 'Design System'],
      ),
      _ServiceData(
        number: '06',
        titleEn: 'Digital Products',
        titleAr: 'المنتجات الرقمية',
        descriptionEn: 'End-to-end product development from concept to launch and beyond.',
        descriptionAr: 'تطوير منتجات رقمية شامل من المفهوم إلى الإطلاق وما بعده.',
        icon: Icons.inventory_2,
        color: const Color(0xFF06D6A0),
        tags: ['MVP', 'SaaS', 'Analytics', 'Growth'],
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          _SectionHeader(
            title: tr('خدماتنا', 'Our Services'),
            subtitle: tr(
              'حلول تقنية شاملة لنجاح أعمالك',
              'Comprehensive tech solutions for your business success',
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF141A29),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? d.color.withValues(alpha: 0.5)
                : d.color.withValues(alpha: 0.1),
            width: _isHovered ? 1.5 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: d.color.withValues(alpha: 0.15),
                    blurRadius: 30,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            if (isWide) {
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: d.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(d.icon, color: d.color, size: 32),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    d.number,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: d.color.withValues(alpha: 0.3),
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          desc,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFA6ABB6),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: d.tags
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: d.color.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: d.color.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: d.color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: d.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(d.icon, color: d.color, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      d.number,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: d.color.withValues(alpha: 0.3),
                        fontFamily: 'monospace',
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFA6ABB6),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: d.tags
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: d.color.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: d.color.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 12,
                                color: d.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                      .toList(),
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
        color: const Color(0xFF3FD2FF),
      ),
      _ValueData(
        icon: Icons.stars,
        titleEn: 'Quality',
        titleAr: 'الجودة',
        descriptionEn: 'Excellence is not negotiable. We deliver top-tier quality.',
        descriptionAr: 'التميز غير قابل للتفاوض. نقدم جودة من الطراز الأول.',
        color: const Color(0xFFA78BFA),
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
        color: const Color(0xFFFF6B6B),
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 220,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF141A29),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? d.color.withValues(alpha: 0.5)
                : d.color.withValues(alpha: 0.1),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: d.color.withValues(alpha: 0.12),
                    blurRadius: 24,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: d.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(d.icon, color: d.color, size: 30),
            ),
            const SizedBox(height: 16),
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

class CTASection extends StatelessWidget {
  const CTASection({super.key});

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
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: const Color(0xFF141A29).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF3FD2FF).withValues(alpha: 0.15),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -60,
                  right: -60,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF3FD2FF).withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tr('جاهز لبناء المستقبل الرقمي؟', 'Ready to Build the Digital Future?'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.3,
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
                    const SizedBox(height: 36),
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
                        ),
                        _CTAButton(
                          label: 'Telegram',
                          icon: Icons.send,
                          color: const Color(0xFF0088cc),
                          url: 'https://t.me/codemaster6',
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Container(
                      height: 1,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Color(0xFF3FD2FF), Colors.transparent],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _openPortal(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF3FD2FF).withValues(alpha: 0.12),
                                const Color(0xFFA78BFA).withValues(alpha: 0.12),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFA78BFA).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.auto_awesome, color: Color(0xFFA78BFA), size: 22),
                              const SizedBox(width: 12),
                              Text(
                                tr('حدود إبداعنا', 'Our Creative Bounds'),
                                style: const TextStyle(
                                  color: Color(0xFFA78BFA),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_ios, color: Color(0xFFA78BFA), size: 14),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.phone,
                          color: Color(0xFF3FD2FF),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+964 777 163 2241',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF3FD2FF),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
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
    );
  }
}

class _CTAButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String url;

  const _CTAButton({
    required this.label,
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
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
                  fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFF141A29),
            width: 1,
          ),
        ),
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
          const SizedBox(height: 40),
          Container(
            height: 1,
            color: const Color(0xFF141A29),
          ),
          const SizedBox(height: 24),
          Text(
            '${tr('© 2025', '© 2025')} CodeMaster. ${tr('جميع الحقوق محفوظة', 'All rights reserved')}',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFA6ABB6),
            ),
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
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          TextSpan(
            text: 'Master',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF3FD2FF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavLinks(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _FooterLink(
          label: tr('الخدمات', 'Services'),
          onTap: () {},
        ),
        _FooterLink(
          label: tr('رؤيتنا', 'Vision'),
          onTap: () {},
        ),
        _FooterLink(
          label: tr('قيمنا', 'Values'),
          onTap: () {},
        ),
        _FooterLink(
          label: tr('اتصل بنا', 'Contact'),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialIcon(
          icon: Icons.chat,
          color: const Color(0xFF25D366),
          url: 'https://wa.me/9647771632241',
        ),
        const SizedBox(width: 12),
        _SocialIcon(
          icon: Icons.send,
          color: const Color(0xFF0088cc),
          url: 'https://t.me/codemaster6',
        ),
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
