import 'package:flutter/material.dart';
import 'dart:math';
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
  final GlobalKey _capabilitiesKey = GlobalKey();
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
      if (href == '#capabilities') {
        _currentView = 'home';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToKey(_capabilitiesKey);
        });
      } else if (href == '#cta') {
        _currentView = 'launch-project';
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
      case 'capability_ai':
        activeWidget = CapabilityDetailView(capabilityId: 'ai', onBack: () => _handleLinkTap('#capabilities'));
        break;
      case 'capability_3d':
        activeWidget = CapabilityDetailView(capabilityId: '3d', onBack: () => _handleLinkTap('#capabilities'));
        break;
      case 'capability_saas':
        activeWidget = CapabilityDetailView(capabilityId: 'saas', onBack: () => _handleLinkTap('#capabilities'));
        break;
      case 'capability_security':
        activeWidget = CapabilityDetailView(capabilityId: 'security', onBack: () => _handleLinkTap('#capabilities'));
        break;
      case 'capability_architecture':
        activeWidget = CapabilityDetailView(capabilityId: 'architecture', onBack: () => _handleLinkTap('#capabilities'));
        break;
      case 'capability_immersive':
        activeWidget = CapabilityDetailView(capabilityId: 'immersive', onBack: () => _handleLinkTap('#capabilities'));
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
            CapabilitiesSection(
              key: _capabilitiesKey,
              onFeatureTap: (id) {
                setState(() {
                  _currentView = 'capability_$id';
                });
              },
            ),
            CTASection(
              key: _ctaKey,
              onLaunchPressed: () => _handleLinkTap('#cta'),
              onStrategyPressed: () => _handleLinkTap('#contact'),
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
                if (href == '#capabilities') {
                  _handleLinkTap('#capabilities');
                } else if (href == '#cta') {
                  _handleLinkTap('#cta');
                } else {
                  // Direct paths
                  if (href.contains('Capabilities')) {
                    _handleLinkTap('#capabilities');
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

class CapabilitiesSection extends StatefulWidget {
  final Function(String) onFeatureTap;
  const CapabilitiesSection({super.key, required this.onFeatureTap});

  @override
  State<CapabilitiesSection> createState() => _CapabilitiesSectionState();
}

class _CapabilitiesSectionState extends State<CapabilitiesSection> with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  String? _hoveredId;
  final GlobalKey _cockpitKey = GlobalKey();

  final List<Map<String, dynamic>> _features = [
    {
      'id': 'ai',
      'titleAr': 'تكامل الذكاء الاصطناعي',
      'titleEn': 'AI Integration',
      'descAr': 'تضمين الوكلاء الأذكياء، خطوط إمداد RAG، والاستدلال الفوري مباشرة في منتجاتك البرمجية.',
      'descEn': 'Embed intelligent agents, RAG pipelines, and real-time inference directly into your products.',
    },
    {
      'id': '3d',
      'titleAr': 'تطوير الويب ثلاثي الأبعاد',
      'titleEn': '3D Web Development',
      'descAr': 'تجارب WebGL غامرة وتفاعلية، معارض منتجات تفاعلية وواجهات مجسمة سينمائية.',
      'descEn': 'Immersive WebGL experiences, interactive product showcases, and cinematic spatial interfaces.',
    },
    {
      'id': 'saas',
      'titleAr': 'أنظمة SaaS المخصصة',
      'titleEn': 'Custom SaaS',
      'descAr': 'منصات شاملة مهندسة للتوسع والتطوير فائق السرعة وأنظمة الفوترة والمستأجرين المتعددين.',
      'descEn': 'End-to-end platforms engineered for multi-tenant scale, billing, and lightning-fast iteration.',
    },
    {
      'id': 'security',
      'titleAr': 'الأمن السيبراني',
      'titleEn': 'Cyber Security',
      'descAr': 'بنية الثقة الصفرية، نمذجة التهديدات، والتدقيق والرقابة المستمرة لضمان حماية أنظمتك من الاختراق.',
      'descEn': 'Zero-trust architecture, threat modeling, and continuous auditing to keep your systems impenetrable.',
    },
    {
      'id': 'architecture',
      'titleAr': 'بنية تحتية قابلة للتوسع',
      'titleEn': 'Scalable Architecture',
      'descAr': 'بنية سحابية مرنة مصممة خصيصاً لتتكامل وتتوسع وتخدم من مستخدمك الأول وحتى مستخدمك المائة مليون.',
      'descEn': 'Cloud-native infrastructure that flexes from your first user to your hundred-millionth.',
    },
    {
      'id': 'immersive',
      'titleAr': 'تجارب مستخدم تفاعلية',
      'titleEn': 'Immersive Experiences',
      'descAr': 'واجهات ويب متقنة البكسلات، غنية بالرسوم الحركية تنبض بالحياة وتحقق معايير تحويل رفيعة المستوى.',
      'descEn': 'Pixel-perfect, motion-rich interfaces that feel alive and convert at elite agency standards.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..addListener(() {
        setState(() {});
      })..repeat();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1152),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Column(
          children: [
            // Section Header
            Text(
              tr('// قمرة التحكم بالقدرات', '// CAPABILITIES COCKPIT'),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Color(0xFF3FD2FF),
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              tr('بوابة الأنظمة الهولوغرافية ثلاثية الأبعاد', '3D Holographic Control Dashboard'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 32),

            // Main Space Cockpit Viewport
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                key: _cockpitKey,
                height: isMobile ? 550 : 480,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF070B13),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: const Color(0xFF3FD2FF).withOpacity(0.25), width: 1.5),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF3FD2FF).withOpacity(0.08), blurRadius: 40)
                  ]
                ),
                child: Stack(
                  children: [
                    // Deep Space Custom Painter (Stars and Earth)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: CockpitSpacePainter(
                          animationValue: _animCtrl.value,
                          hoveredId: _hoveredId,
                        ),
                      ),
                    ),

                    // Interactive Spheres Layout
                    Positioned.fill(
                      child: isMobile ? _buildMobileGrid() : _buildDesktopNodes(),
                    ),

                    // Bottom Floating Dashboard
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: _buildConsoleStatus(isMobile),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsoleStatus(bool isMobile) {
    final activeFeature = _features.firstWhere(
      (f) => f['id'] == _hoveredId,
      orElse: () => {
        'titleAr': 'بوابة الأنظمة الهولوغرافية',
        'titleEn': 'Holographic Systems Portal',
        'descAr': 'مرر مؤشر الفأرة فوق إحدى الكرات الزجاجية النشطة لفحص أداء النظام واستعراض تقنياته ثلاثية الأبعاد.',
        'descEn': 'Hover over any active holographic core to monitor system stats and launch preview.',
      },
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1D).withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _hoveredId != null ? const Color(0xFF3FD2FF) : const Color(0xFF3FD2FF).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          if (_hoveredId != null)
            BoxShadow(color: const Color(0xFF3FD2FF).withOpacity(0.15), blurRadius: 16)
        ]
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tr(activeFeature['titleAr']!, activeFeature['titleEn']!),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3FD2FF), fontFamily: 'Inter'),
                ),
                const SizedBox(height: 4),
                Text(
                  tr(activeFeature['descAr']!, activeFeature['descEn']!),
                  style: const TextStyle(fontSize: 12, color: Color(0xFFA6ABB6), height: 1.4, fontFamily: 'Inter'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (_hoveredId != null) ...[
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => widget.onFeatureTap(_hoveredId!),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3FD2FF),
                foregroundColor: const Color(0xFF090D16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Text(
                tr("تشغيل المحاكي", "Launch Demo"),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildDesktopNodes() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final positions = {
          'ai': Offset(w * 0.23, h * 0.28),
          '3d': Offset(w * 0.50, h * 0.21),
          'saas': Offset(w * 0.77, h * 0.28),
          'security': Offset(w * 0.20, h * 0.58),
          'architecture': Offset(w * 0.50, h * 0.65),
          'immersive': Offset(w * 0.80, h * 0.58),
        };

        return Stack(
          children: positions.entries.map((entry) {
            final id = entry.key;
            final pos = entry.value;
            final isHovered = _hoveredId == id;

            return Positioned(
              left: pos.dx - 45,
              top: pos.dy - 45,
              child: MouseRegion(
                onEnter: (_) => setState(() => _hoveredId = id),
                onExit: (_) => setState(() => _hoveredId = null),
                child: GestureDetector(
                  onTap: () => widget.onFeatureTap(id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isHovered ? 90 : 80,
                    height: isHovered ? 90 : 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF0A0F1D).withOpacity(0.4),
                      border: Border.all(
                        color: isHovered ? const Color(0xFF3FD2FF) : const Color(0xFF3FD2FF).withOpacity(0.3),
                        width: isHovered ? 2.5 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isHovered 
                              ? const Color(0xFF3FD2FF).withOpacity(0.35) 
                              : const Color(0xFF3FD2FF).withOpacity(0.08),
                          blurRadius: isHovered ? 24 : 12,
                        )
                      ]
                    ),
                    padding: const EdgeInsets.all(8),
                    child: ClipOval(
                      child: Card3DVisualizer(
                        id: id,
                        isHovered: isHovered,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildMobileGrid() {
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 120),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.9,
      children: _features.map((f) {
        final id = f['id'] as String;
        final isHovered = _hoveredId == id;
        return GestureDetector(
          onTap: () {
            setState(() => _hoveredId = id);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isHovered ? const Color(0xFF141A29).withOpacity(0.7) : const Color(0xFF0A0F1D).withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isHovered ? const Color(0xFF3FD2FF) : const Color(0xFF3FD2FF).withOpacity(0.2),
                width: isHovered ? 2.0 : 1.0,
              ),
              boxShadow: [
                if (isHovered)
                  BoxShadow(color: const Color(0xFF3FD2FF).withOpacity(0.25), blurRadius: 12)
              ]
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: ClipOval(
                    child: Card3DVisualizer(
                      id: id,
                      isHovered: isHovered,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tr(f['titleAr']!, f['titleEn']!),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isHovered ? const Color(0xFF3FD2FF) : Colors.white70, fontFamily: 'Inter'),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class CockpitSpacePainter extends CustomPainter {
  final double animationValue;
  final String? hoveredId;

  CockpitSpacePainter({required this.animationValue, this.hoveredId});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // Background cosmic dark void
    final bgGrad = LinearGradient(
      colors: [const Color(0xFF020408), const Color(0xFF070B14)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..shader = bgGrad.createShader(Rect.fromLTWH(0, 0, w, h)));

    // Drifting starfield
    final starPaint = Paint()..color = Colors.white;
    for (int i = 0; i < 45; i++) {
      double t = (animationValue + i * 0.02) % 1.0;
      double sx = (i * 53.0) % w;
      double sy = ((i * 17.0) + t * h) % h;
      starPaint.color = Colors.white.withOpacity(sin(t * pi) * 0.45);
      canvas.drawCircle(Offset(sx, sy), 1.0 + (i % 2), starPaint);
    }

    // Positions of the cockpit console nodes
    final nodePositions = {
      'ai': Offset(w * 0.23, h * 0.28),
      '3d': Offset(w * 0.50, h * 0.21),
      'saas': Offset(w * 0.77, h * 0.28),
      'security': Offset(w * 0.20, h * 0.58),
      'architecture': Offset(w * 0.50, h * 0.65),
      'immersive': Offset(w * 0.80, h * 0.58),
    };

    if (w > 600) {
      final connections = [
        ['ai', '3d'], ['3d', 'saas'],
        ['security', 'architecture'], ['architecture', 'immersive'],
        ['ai', 'security'], ['3d', 'architecture'], ['saas', 'immersive'],
        ['ai', 'architecture'], ['saas', 'architecture']
      ];

      for (var conn in connections) {
        final p1 = nodePositions[conn[0]]!;
        final p2 = nodePositions[conn[1]]!;
        
        final isActive = hoveredId == conn[0] || hoveredId == conn[1];
        final drawPaint = Paint()
          ..color = isActive ? const Color(0xFF3FD2FF).withOpacity(0.35) : const Color(0xFF3FD2FF).withOpacity(0.12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isActive ? 2.2 : 1.2;
        
        canvas.drawLine(p1, p2, drawPaint);

        if (isActive) {
          final t = (animationValue * 2.5) % 1.0;
          final ox = p1.dx + (p2.dx - p1.dx) * t;
          final oy = p1.dy + (p2.dy - p1.dy) * t;
          canvas.drawCircle(Offset(ox, oy), 2.5, Paint()..color = const Color(0xFF3FD2FF));
        }
      }
    }

    // Earth metrics and drawing
    final earthCenter = Offset(cx, h + 300);
    final double earthRadius = 370.0;
    
    // Dynamic Earth Glow on hover
    final isHovered = hoveredId != null;
    final themeColor = isHovered ? const Color(0xFFFF2A85) : const Color(0xFF3FD2FF);
    final glowScale = isHovered ? 1.4 : 1.0;

    final atmPaint1 = Paint()
      ..color = themeColor.withOpacity(0.18 * glowScale)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);
    canvas.drawCircle(earthCenter, earthRadius + 18, atmPaint1);

    final atmPaint2 = Paint()
      ..color = themeColor.withOpacity(0.35 * glowScale)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11);
    canvas.drawCircle(earthCenter, earthRadius + 8, atmPaint2);

    final earthPaint = Paint()
      ..shader = LinearGradient(
        colors: isHovered 
            ? [const Color(0xFF2E091A), const Color(0xFF0F0408)]
            : [const Color(0xFF081830), const Color(0xFF040810)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: earthCenter, radius: earthRadius));
    canvas.drawCircle(earthCenter, earthRadius, earthPaint);

    final earthBorder = Paint()
      ..color = themeColor.withOpacity(0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawCircle(earthCenter, earthRadius, earthBorder);

    // Draw Laser beam & Planetary explosion shockwaves if a node is hovered
    if (isHovered && nodePositions.containsKey(hoveredId)) {
      final nodePos = nodePositions[hoveredId]!;
      final directionVec = earthCenter - nodePos;
      final dist = directionVec.distance;

      if (dist > 0) {
        final dirNorm = Offset(directionVec.dx / dist, directionVec.dy / dist);
        // Laser impact point on the curved Earth atmosphere
        final impactPoint = earthCenter - dirNorm * earthRadius;

        // Draw pulsing laser core and outer glowing beam
        final beamGlow = Paint()
          ..color = const Color(0xFFFF2A85).withOpacity(0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6.0
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        
        final beamCore = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8;

        canvas.drawLine(nodePos, impactPoint, beamGlow);
        canvas.drawLine(nodePos, impactPoint, beamCore);

        // Draw expanding planetary implosion shockwave rings
        final rippleAnim = (animationValue * 3.5) % 1.0;
        for (int r = 0; r < 3; r++) {
          final t = (rippleAnim + r * 0.33) % 1.0;
          final rippleRadius = t * 45.0;
          final ripplePaint = Paint()
            ..color = const Color(0xFFFF2A85).withOpacity((1.0 - t) * 0.7)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;
          canvas.drawCircle(impactPoint, rippleRadius, ripplePaint);
        }

        // Draw exploding plasma sparks/particles shooting up from the Earth impact point
        final particleCount = 12;
        for (int p = 0; p < particleCount; p++) {
          final baseAngle = atan2(-dirNorm.dy, -dirNorm.dx);
          final spreadAngle = baseAngle + (p - (particleCount / 2)) * 0.16;
          final speed = 20.0 + (p * 7.0) % 35.0;
          final pTime = (animationValue * 4.0 + p * 0.08) % 1.0;
          final distTravelled = pTime * speed * 2.0;

          final px = impactPoint.dx + cos(spreadAngle) * distTravelled;
          final py = impactPoint.dy + sin(spreadAngle) * distTravelled;

          final sparkPaint = Paint()
            ..color = const Color(0xFF3FD2FF).withOpacity((1.0 - pTime) * 0.95)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(
            Offset(px, py),
            (3.5 * (1.0 - pTime)).clamp(0.5, 4.0),
            sparkPaint,
          );
        }
      }
    }

    final consolePaint = Paint()
      ..color = const Color(0xFF3FD2FF).withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(Offset(cx, -100), 200, consolePaint);
  }

  @override
  bool shouldRepaint(covariant CockpitSpacePainter oldDelegate) => true;
}

class CTASection extends StatelessWidget {
  final VoidCallback onLaunchPressed;
  final VoidCallback onStrategyPressed;

  const CTASection({
    super.key,
    required this.onLaunchPressed,
    required this.onStrategyPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 960), // max-w-5xl
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 112),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: const Color(0xFF141A29).withOpacity(0.5), // glass
            border: Border.all(
              color: const Color(0xFF3FD2FF).withOpacity(0.2),
              width: 1.0,
            ),
          ),
          child: Stack(
            children: [
              // Radial glow top-middle inside CTA
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
                        'تشارك مع كود ماستر وحوّل رؤيتك الطموحة إلى واقع برمجي آمن، متكامل وقابل للتوسع.',
                        'Partner with Code Master and turn your most ambitious vision into a shipped, scalable reality.'
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
                            label: tr('احجز مكالمة استراتيجية', 'Book a Strategy Call'),
                            onPressed: onStrategyPressed,
                            isSolid: false,
                          ),
                        ),
                      ],
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
