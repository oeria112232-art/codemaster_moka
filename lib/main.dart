import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'components.dart';
import 'custom_cursor.dart';
import 'hero_scene.dart';
import 'pages.dart';

void main() {
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
          title: tr('شركة كود ماستر - نسود الواقع', 'Code Master - We Master Reality'),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF090D16), // --background
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF3FD2FF), // --primary
              surface: Color(0xFF111726), // --card
              onPrimary: Color(0xFF090D16), // --primary-foreground
              onSurface: Color(0xFFF7F8FA), // --foreground
            ),
            fontFamily: 'Inter',
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
  final GlobalKey _worksKey = GlobalKey();
  final GlobalKey _ctaKey = GlobalKey();

  // Navigation views: 'home', 'technology', 'studio', 'contact', 'launch-project'
  String _currentView = 'home';

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _handleLinkTap(String href) {
    setState(() {
      if (href == '#works') {
        _currentView = 'home';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToKey(_worksKey);
        });
      } else if (href == '#cta') {
        _currentView = 'home';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToKey(_ctaKey);
        });
      } else if (href == '#') {
        _currentView = 'home';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToKey(_homeKey);
        });
      } else if (href == '#tech') {
        _currentView = 'technology';
      } else if (href == '#studio') {
        _currentView = 'studio';
      } else if (href == '#contact') {
        _currentView = 'contact';
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageManager.instance,
      builder: (context, _) {
        Widget activeWidget;

        switch (_currentView) {
      case 'technology':
        activeWidget = TechnologyView(onBack: () => _handleLinkTap('#'));
        break;
      case 'studio':
        activeWidget = StudioView(onBack: () => _handleLinkTap('#'));
        break;
      case 'contact':
        activeWidget = ContactView(onBack: () => _handleLinkTap('#'));
        break;
      case 'launch-project':
        activeWidget = LaunchProjectView(onBack: () => _handleLinkTap('#'));
        break;
      case 'home':
      default:
        activeWidget = Column(
          children: [
            HeroSection(
              key: _homeKey,
              onLaunchPressed: () => _handleLinkTap('#cta'),
              onExplorePressed: () => _handleLinkTap('#tech'),
            ),
            const StatsSection(),
            WorksSection(
              key: _worksKey,
            ),
            CTASection(
              key: _ctaKey,
            ),
            const FooterSection(),
          ],
        );
        break;
    }

    return Scaffold(
      body: Stack(
        children: [
          // Scrollable Content / Custom View
          SingleChildScrollView(
            controller: _scrollController,
            child: activeWidget,
          ),
          
          // Fixed Floating Navbar
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Navbar(
              scrollController: _scrollController,
              onLogoTap: () => _handleLinkTap('#'),
              onLinkTap: (href) {
                // Intercept navbar actions
                if (href == '#works') {
                  _handleLinkTap('#works');
                } else if (href == '#cta') {
                  _handleLinkTap('#cta');
                } else {
                  // Direct paths
                  if (href.contains('Works')) {
                    _handleLinkTap('#works');
                  } else if (href.contains('Technology')) {
                    _handleLinkTap('#tech');
                  } else if (href.contains('Studio')) {
                    _handleLinkTap('#studio');
                  } else if (href.contains('Contact')) {
                    _handleLinkTap('#contact');
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}

class HeroSection extends StatelessWidget {
  final VoidCallback onLaunchPressed;
  final VoidCallback onExplorePressed;

  const HeroSection({
    super.key,
    required this.onLaunchPressed,
    required this.onExplorePressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      width: double.infinity,
      height: size.height,
      constraints: const BoxConstraints(minHeight: 650),
      child: Stack(
        children: [
          // 1. Neon grid floor
          Positioned.fill(
            child: Opacity(
              opacity: 0.18,
              child: CustomPaint(
                painter: GridFloorPainter(),
              ),
            ),
          ),

          // 2. Radial Fade over grid
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.1),
                  radius: 0.8,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF090D16).withOpacity(0.9),
                    const Color(0xFF090D16),
                  ],
                  stops: const [0.3, 0.75, 1.0],
                ),
              ),
            ),
          ),

          // 3. 3D Scene
          const Positioned.fill(
            child: HeroScene(),
          ),

          // 4. Central Radial Glow
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Container(
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF3FD2FF).withOpacity(0.12),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.6],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 5. Content Layout
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 896),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80), // spacer for top navbar
                  
                  // Top badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: const Color(0xFF141A29).withOpacity(0.5), // glass
                      border: Border.all(
                        color: const Color(0xFF3FD2FF).withOpacity(0.25),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF3FD2FF),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3FD2FF).withOpacity(0.8),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tr("رواد التكنولوجيا الأوائل في العراق", "Iraq's Premier Tech Pioneers"),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF3FD2FF),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Main Heading - modified to show "شركة كود ماستر"
                  Text(
                    tr("شركة كود ماستر", "CodeMaster Company"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 40 : 72,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Paragraph
                  Text(
                    tr(
                      "حلول برمجية من الجيل القادم، وتجارب ويب غامرة، وبنية تحتية قابلة للتوسع.",
                      "Next-gen software solutions, immersive web experiences, and scalable architecture."
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 18,
                      color: const Color(0xFFA6ABB6), // muted text
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Buttons
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      WidgetDirectionalityFix(
                        child: MagneticButton(
                          label: tr('أطلق مشروعك', 'Launch Your Project'),
                          onPressed: onLaunchPressed,
                          isSolid: true,
                        ),
                      ),
                      WidgetDirectionalityFix(
                        child: MagneticButton(
                          label: tr('استكشف تقنياتنا', 'Explore Our Tech'),
                          onPressed: onExplorePressed,
                          isSolid: false,
                          icon: const Text(
                            '</>',
                            style: TextStyle(
                              color: Color(0xFF3FD2FF),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 6. Bottom Fade
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 160,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF090D16),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridFloorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3FD2FF).withOpacity(0.25)
      ..strokeWidth = 1.0;

    const double step = 54.0;
    
    // Draw vertical lines
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    // Draw horizontal lines
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridFloorPainter oldDelegate) => false;
}

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    final stats = [
      {'value': '+200', 'labelAr': 'منتج تم تسليمه', 'labelEn': 'Products Shipped'},
      {'value': '+40M', 'labelAr': 'مستخدم تم الوصول إليه', 'labelEn': 'Users Reached'},
      {'value': '12', 'labelAr': 'دولة تم تقديم الخدمة لها', 'labelEn': 'Countries Served'},
      {'value': '99.99%', 'labelAr': 'معدل تشغيل مضمون', 'labelEn': 'Uptime Delivered'},
    ];

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1152), // max-w-6xl
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF141A29).withOpacity(0.5), // glass
            border: Border.all(
              color: const Color(0xFF3FD2FF).withOpacity(0.1),
              width: 1.0,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (isMobile) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stats.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (context, index) {
                    return _buildStatItem(
                      stats[index]['value']!, 
                      tr(stats[index]['labelAr']!, stats[index]['labelEn']!)
                    );
                  },
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: stats.map((stat) {
                    return Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: _buildStatItem(
                          stat['value']!, 
                          tr(stat['labelAr']!, stat['labelEn']!)
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: Color(0xFF3FD2FF),
            shadows: [
              Shadow(
                color: Color(0xFF3FD2FF),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Inter',
            color: Color(0xFFA6ABB6),
          ),
        ),
      ],
    );
  }
}

class WorksSection extends StatelessWidget {
  const WorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    final works = [
      {
        'icon': Icons.school_outlined,
        'titleAr': 'المنصات التعليمية',
        'titleEn': 'Educational Platforms',
        'descAr': 'أنظمة إدارة تعلم متكاملة ولوحات تعليمية تفاعلية للجامعات والمدارس والمؤسسات التدريبية.',
        'descEn': 'Complete learning management systems and interactive educational dashboards for universities, schools, and training institutions.',
        'color': const Color(0xFF3FD2FF),
      },
      {
        'icon': Icons.admin_panel_settings_outlined,
        'titleAr': 'أنظمة الإدارة',
        'titleEn': 'Admin Systems',
        'descAr': 'لوحات تحكم ذكية لإدارة المحتوى والمستخدمين والعمليات مع تقارير تحليلية متقدمة.',
        'descEn': 'Smart dashboards for content, user, and operations management with advanced analytics.',
        'color': const Color(0xFFA78BFA),
      },
      {
        'icon': Icons.language_outlined,
        'titleAr': 'المواقع الإلكترونية',
        'titleEn': 'Websites',
        'descAr': 'مواقع احترافية متجاوبة بأداء عالٍ وتصميم عصري يعكس هوية علامتك التجارية.',
        'descEn': 'Professional responsive websites with high performance and modern design reflecting your brand identity.',
        'color': const Color(0xFF25D366),
      },
      {
        'icon': Icons.phone_android_outlined,
        'titleAr': 'تطبيقات الجوال',
        'titleEn': 'Mobile Apps',
        'descAr': 'تطبيقات أندرويد وiOS أصلية بأداء سلس وتجربة مستخدم استثنائية.',
        'descEn': 'Native Android and iOS apps with smooth performance and exceptional user experience.',
        'color': const Color(0xFFFF6B6B),
      },
      {
        'icon': Icons.shopping_cart_outlined,
        'titleAr': 'متاجر إلكترونية',
        'titleEn': 'E-Commerce',
        'descAr': 'متاجر متكاملة مع أنظمة دفع آمنة وإدارة مخزون وتجربة تسوق سلسة.',
        'descEn': 'Full-featured stores with secure payment systems, inventory management, and smooth shopping experience.',
        'color': const Color(0xFFFFD93D),
      },
      {
        'icon': Icons.memory_outlined,
        'titleAr': 'الحلول الذكية',
        'titleEn': 'Smart Solutions',
        'descAr': 'أنظمة أتمتة ذكية وتكامل API وحلول مخصصة لتعزيز كفاءة أعمالك.',
        'descEn': 'Intelligent automation systems, API integrations, and custom solutions to boost your business efficiency.',
        'color': const Color(0xFF06D6A0),
      },
    ];

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1152),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Column(
          children: [
            Text(
              tr('// أعمالنا', '// OUR WORKS'),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Color(0xFF3FD2FF),
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              tr('مشاريع نفتخر بها', 'Projects We\'re Proud Of'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 16),
            Text(
              tr(
                'نقدم حلولاً تقنية متكاملة تلبي احتياجات الأعمال المتنوعة',
                'We deliver comprehensive tech solutions that meet diverse business needs'
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Color(0xFFA6ABB6), fontFamily: 'Inter', height: 1.6),
            ),
            const SizedBox(height: 48),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 3,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: isMobile ? 2.2 : 1.4,
              ),
              itemCount: works.length,
              itemBuilder: (context, index) {
                final work = works[index];
                final workColor = work['color'] as Color;
                return _WorkCard(
                  icon: work['icon'] as IconData,
                  title: tr(work['titleAr'] as String, work['titleEn'] as String),
                  description: tr(work['descAr'] as String, work['descEn'] as String),
                  color: workColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _WorkCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  State<_WorkCard> createState() => _WorkCardState();
}

class _WorkCardState extends State<_WorkCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _isHovered
              ? widget.color.withOpacity(0.08)
              : const Color(0xFF141A29).withOpacity(0.5),
          border: Border.all(
            color: _isHovered
                ? widget.color.withOpacity(0.5)
                : const Color(0xFF3FD2FF).withOpacity(0.12),
            width: 1.5,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: widget.color.withOpacity(0.15),
                blurRadius: 24,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: widget.color.withOpacity(0.12),
                border: Border.all(
                  color: widget.color.withOpacity(0.25),
                  width: 1,
                ),
              ),
              child: Icon(widget.icon, color: widget.color, size: 26),
            ),
            const SizedBox(height: 18),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isHovered ? widget.color : Colors.white,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFA6ABB6),
                fontFamily: 'Inter',
                height: 1.6,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class CTASection extends StatelessWidget {
  const CTASection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 960),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 112),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: const Color(0xFF141A29).withOpacity(0.5),
            border: Border.all(
              color: const Color(0xFF3FD2FF).withOpacity(0.2),
              width: 1.0,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: size.width * 0.4,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.0, -1.0),
                      radius: 0.8,
                      colors: [
                        const Color(0xFF3FD2FF).withOpacity(0.16),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 64,
                  vertical: isMobile ? 64 : 80,
                ),
                child: Column(
                  children: [
                    Text(
                      tr('هل أنت مستعد لبناء المستحيل؟', 'Ready to build the impossible?'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 30 : 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tr(
                        'تواصل معنا الآن واحصل على استشارة مجانية لمشروعك',
                        'Contact us now and get a free consultation for your project'
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                        color: Color(0xFFA6ABB6),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    WidgetDirectionalityFix(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            final url = Uri.parse('https://wa.me/9647771632241');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 32 : 40,
                              vertical: isMobile ? 18 : 22,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              color: const Color(0xFF25D366),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF25D366).withOpacity(0.35),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.chat_rounded, color: Colors.white, size: 24),
                                const SizedBox(width: 12),
                                Text(
                                  tr('تواصل عبر واتساب', 'Chat on WhatsApp'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '+964 777 163 2241',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        color: const Color(0xFFA6ABB6).withOpacity(0.7),
                        letterSpacing: 1.0,
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

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 640;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFF3FD2FF).withOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1152),
          child: Column(
            children: [
              Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        letterSpacing: -0.5,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(text: 'Code'),
                        TextSpan(
                          text: 'Master',
                          style: TextStyle(color: Color(0xFF3FD2FF)),
                        ),
                      ],
                    ),
                  ),
                  if (isMobile) const SizedBox(height: 16),
                  
                  // Copyright
                  Text(
                    tr(
                      '© ${DateTime.now().year} كود ماستر. نسود الواقع، سطراً برمجياً تلو الآخر.',
                      '© ${DateTime.now().year} Code Master. Mastering reality, one line at a time.'
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Inter',
                      color: Color(0xFFA6ABB6),
                    ),
                  ),
                  if (isMobile) const SizedBox(height: 16),
                  
                  // Links
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildFooterLink(tr('الخصوصية', 'Privacy')),
                      const SizedBox(width: 24),
                      _buildFooterLink(tr('الوظائف', 'Careers')),
                      const SizedBox(width: 24),
                      _buildFooterLink(tr('اتصل بنا', 'Contact')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return CustomCursorHover(
      child: InkWell(
        onTap: () {},
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'Inter',
            color: Color(0xFFA6ABB6),
          ),
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
    final isAr = LanguageManager.instance.isArabic;
    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: child,
    );
  }
}
