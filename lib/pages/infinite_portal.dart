import 'dart:math';
import 'package:flutter/material.dart';
import '../components.dart';
import '../portal/generative_painter.dart';

class InfinitePortalPage extends StatefulWidget {
  final VoidCallback onBack;
  const InfinitePortalPage({super.key, required this.onBack});

  @override
  State<InfinitePortalPage> createState() => _InfinitePortalPageState();
}

class _InfinitePortalPageState extends State<InfinitePortalPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _timeCtrl;
  final ScrollController _scrollCtrl = ScrollController();
  double _scrollDepth = 0.0;
  int _visibleCount = 12;
  static const double _sectionHeight = 800.0;

  static const _sections = _PortalSectionsData.sections;

  @override
  void initState() {
    super.initState();
    _timeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120),
    )..repeat();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollCtrl.offset;
    final maxScroll = _scrollCtrl.position.maxScrollExtent;
    setState(() {
      _scrollDepth = maxScroll > 0 ? (offset / _sectionHeight).clamp(0.0, 5.0) : 0.0;
      final targetCount = ((offset / _sectionHeight) + 6).ceil();
      if (targetCount > _visibleCount) {
        _visibleCount = targetCount + 4;
      }
    });
  }

  @override
  void dispose() {
    _timeCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = LanguageManager.instance.isArabic;
    final depthLabel = _getDepthLabel(_scrollDepth.floor(), isAr);

    return Scaffold(
      backgroundColor: const Color(0xFF010409),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _timeCtrl,
              builder: (context, _) {
                return CustomPaint(
                  painter: PortalVisualPainter(
                    time: _timeCtrl.value * 120,
                    depth: _scrollDepth,
                    seed: _scrollDepth.floor(),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: EdgeInsets.zero,
              itemCount: _visibleCount,
              itemBuilder: (context, index) {
                return _PortalSection(
                  index: index,
                  time: _timeCtrl,
                  scrollDepth: _scrollDepth,
                  data: _sections[index % _sections.length],
                  isAr: isAr,
                );
              },
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
                    color: const Color(0xFF141A29).withValues(alpha: 0.7),
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
                        tr('خروج', 'Exit'),
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
          Positioned(
            right: 24,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 3,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0xFF141A29).withValues(alpha: 0.5),
                ),
                child: Align(
                  alignment: Alignment(0, (_scrollDepth / 5.0 * 2 - 1).clamp(-1.0, 1.0)),
                  child: Container(
                    width: 3,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: const Color(0xFF3FD2FF).withValues(alpha: 0.8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3FD2FF).withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 24,
            top: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF141A29).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF3FD2FF).withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(_scrollDepth * 100).toInt()}%',
                    style: const TextStyle(
                      color: Color(0xFF3FD2FF),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    depthLabel,
                    style: const TextStyle(
                      color: Color(0xFFA6ABB6),
                      fontSize: 10,
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

  String _getDepthLabel(int zone, bool isAr) {
    const labelsAr = ['البوابة', 'الكون', 'الهندسة', 'الأمواج', 'الشبكة', 'اللا نهائي'];
    const labelsEn = ['Gate', 'Cosmos', 'Geometry', 'Waves', 'Network', 'Infinite'];
    return isAr
        ? labelsAr[zone.clamp(0, labelsAr.length - 1)]
        : labelsEn[zone.clamp(0, labelsEn.length - 1)];
  }
}

class _PortalSection extends StatelessWidget {
  final int index;
  final AnimationController time;
  final double scrollDepth;
  final _SectionData data;
  final bool isAr;

  const _PortalSection({
    required this.index,
    required this.time,
    required this.scrollDepth,
    required this.data,
    required this.isAr,
  });

  @override
  Widget build(BuildContext context) {
    final rng = Random(index * 7919);
    final sectionDepth = (index * 0.4).clamp(0.0, 5.0);

    return SizedBox(
      height: 800,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: time,
              builder: (context, _) {
                return CustomPaint(
                  painter: PortalVisualPainter(
                    time: time.value * 120,
                    depth: sectionDepth,
                    seed: index * 7919,
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF010409).withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.transparent,
                    const Color(0xFF010409).withValues(alpha: 0.5),
                  ],
                  stops: const [0, 0.2, 0.8, 1],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIndexBadge(),
                  const SizedBox(height: 24),
                  _buildTitle(),
                  const SizedBox(height: 16),
                  _buildSubtitle(),
                  const SizedBox(height: 32),
                  _buildFloatingShapes(rng),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndexBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF3FD2FF).withValues(alpha: 0.2),
        ),
        color: const Color(0xFF141A29).withValues(alpha: 0.5),
      ),
      child: Text(
        '#${(index + 1).toString().padLeft(3, '0')}',
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: Color(0xFF3FD2FF),
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      isAr ? data.titleAr : data.titleEn,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        foreground: Paint()
          ..shader = LinearGradient(
            colors: [data.color, data.color2],
          ).createShader(const Rect.fromLTWH(0, 0, 300, 50)),
      ),
    );
  }

  Widget _buildSubtitle() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Text(
        isAr ? data.descAr : data.descEn,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFFA6ABB6),
          height: 1.7,
        ),
      ),
    );
  }

  Widget _buildFloatingShapes(Random rng) {
    return SizedBox(
      height: 120,
      width: 300,
      child: AnimatedBuilder(
        animation: time,
        builder: (context, _) {
          return CustomPaint(
            painter: _FloatingShapesPainter(
              time: time.value,
              seed: index * 7919,
              color: data.color,
              color2: data.color2,
            ),
          );
        },
      ),
    );
  }
}

class _FloatingShapesPainter extends CustomPainter {
  final double time;
  final int seed;
  final Color color;
  final Color color2;

  _FloatingShapesPainter({
    required this.time,
    required this.seed,
    required this.color,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(seed);
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.0;

    for (int i = 0; i < 6; i++) {
      final x = size.width * 0.1 + rng.nextDouble() * size.width * 0.8;
      final y = size.height * 0.5 + sin(time * 0.8 + i * 1.2) * 30;
      final r = 8.0 + rng.nextDouble() * 15;
      final alpha = (0.2 + sin(time + i) * 0.15).clamp(0.0, 0.4);

      paint.color = Color.lerp(color, color2, i / 6.0)!.withValues(alpha: alpha);

      if (i % 3 == 0) {
        canvas.drawCircle(Offset(x, y), r, paint);
      } else if (i % 3 == 1) {
        final rect = Rect.fromCenter(
          center: Offset(x, y),
          width: r * 2,
          height: r * 2,
        );
        canvas.drawRect(rect, paint);
      } else {
        final path = Path();
        for (int j = 0; j < 3; j++) {
          final angle = (j / 3) * 2 * pi + time * 0.3;
          final px = x + cos(angle) * r;
          final py = y + sin(angle) * r;
          if (j == 0) {
            path.moveTo(px, py);
          } else {
            path.lineTo(px, py);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingShapesPainter old) =>
      old.time != time;
}

class _SectionData {
  final String titleAr;
  final String titleEn;
  final String descAr;
  final String descEn;
  final Color color;
  final Color color2;

  const _SectionData({
    required this.titleAr,
    required this.titleEn,
    required this.descAr,
    required this.descEn,
    required this.color,
    required this.color2,
  });
}

class _PortalSectionsData {
  static const sections = [
    _SectionData(
      titleAr: 'بوابتنا الإبداعية',
      titleEn: 'Our Creative Gateway',
      descAr: 'كل مشروع نبدعه يبدأ من هنا. رحلة تبدأ من الصفر وتصل إلى ما لا يتصوره أحد.',
      descEn: 'Every project we create begins here. A journey from zero to the unimaginable.',
      color: Color(0xFF3FD2FF),
      color2: Color(0xFFA78BFA),
    ),
    _SectionData(
      titleAr: 'الكون الرقمي',
      titleEn: 'The Digital Cosmos',
      descAr: 'في عالم لا حدود له من الصفر والأحد، نبني أكواناً رقمية تتجاوز خيال المبدعين.',
      descEn: 'In a world of infinite zeros and ones, we build digital universes beyond imagination.',
      color: Color(0xFF58A6FF),
      color2: Color(0xFF79C0FF),
    ),
    _SectionData(
      titleAr: 'هندسة الأفكار',
      titleEn: 'Engineering Ideas',
      descAr: 'نحوّل الأفكار المجردة إلى هياكل تقنية صلبة تتحمل اختبار الزمن.',
      descEn: 'We transform abstract ideas into solid technical structures that stand the test of time.',
      color: Color(0xFF3FB950),
      color2: Color(0xFF56D364),
    ),
    _SectionData(
      titleAr: 'أمواج الابتكار',
      titleEn: 'Waves of Innovation',
      descAr: 'مثل الأمواج التي لا تتوقف، نستمر في دفع حدود التكنولوجيا إلى آفاق جديدة.',
      descEn: 'Like relentless waves, we keep pushing technology boundaries to new horizons.',
      color: Color(0xFFD2A8FF),
      color2: Color(0xFFBC8CFF),
    ),
    _SectionData(
      titleAr: 'شبكة الصلبة',
      titleEn: 'Solid Networks',
      descAr: 'شبكاتنا التقنية متينة كـالصخور. كل خط كود محسوب، وكل قرار مدروس.',
      descEn: 'Our tech networks are solid as rock. Every line of code calculated, every decision deliberate.',
      color: Color(0xFFF78166),
      color2: Color(0xFFFFA657),
    ),
    _SectionData(
      titleAr: 'عالم الخوارزميات',
      titleEn: 'The Algorithm World',
      descAr: 'في أعماق الكود، نصنع خوارزميات ذكية تتعلم وتتطور مع كل تفاعل.',
      descEn: 'In the depths of code, we craft smart algorithms that learn and evolve with every interaction.',
      color: Color(0xFF3FD2FF),
      color2: Color(0xFF06D6A0),
    ),
    _SectionData(
      titleAr: 'البنية التحتية السحابية',
      titleEn: 'Cloud Infrastructure',
      descAr: 'بنينا بنية تحتية سحابية تتحمل ملايين الطلبات في الثانية الواحدة.',
      descEn: 'We built cloud infrastructure that handles millions of requests per second.',
      color: Color(0xFF79C0FF),
      color2: Color(0xFFA78BFA),
    ),
    _SectionData(
      titleAr: 'الذكاء الاصطناعي الحي',
      titleEn: 'Living AI',
      descAr: 'أنظمة ذكاء اصطناعية تتنفس وتنمو. ليست مجرد كود، بل كيان رقمي يتطور.',
      descEn: 'AI systems that breathe and grow. Not just code, but evolving digital entities.',
      color: Color(0xFFD2A8FF),
      color2: Color(0xFFFF6B6B),
    ),
    _SectionData(
      titleAr: 'تجربة المستخدم العاطفية',
      titleEn: 'Emotional UX',
      descAr: 'نصمم واجهات تلمس المشاعر قبل أن تلمس الأصابع. كل بكسل له قصة.',
      descEn: 'We design interfaces that touch emotions before fingers. Every pixel has a story.',
      color: Color(0xFFFFB020),
      color2: Color(0xFFF78166),
    ),
    _SectionData(
      titleAr: 'الحماية السيبرانية المتقدمة',
      titleEn: 'Advanced Cybersecurity',
      descAr: 'دروع رقمية لا تتوقف. نحمي بياناتك كأنها أرواحنا.',
      descEn: 'Digital shields that never rest. We protect your data as if it were our own.',
      color: Color(0xFFFF6B6B),
      color2: Color(0xFFFF2A85),
    ),
    _SectionData(
      titleAr: 'أنظمة الدفع الذكية',
      titleEn: 'Smart Payment Systems',
      descAr: 'معاملات لحظية، أمان لا يُخترق، وسرعة تفوق التوقعات.',
      descEn: 'Instant transactions, impenetrable security, and speed that exceeds expectations.',
      color: Color(0xFF3FB950),
      color2: Color(0xFF3FD2FF),
    ),
    _SectionData(
      titleAr: 'تطبيقات الجوال الخارقة',
      titleEn: 'Super Mobile Apps',
      descAr: 'تطبيقات تحمل قوة أنظمة كاملة في جيبك. أداء خارق وتصميم ساحر.',
      descEn: 'Apps that carry the power of full systems in your pocket. Superb performance, stunning design.',
      color: Color(0xFFA78BFA),
      color2: Color(0xFF3FD2FF),
    ),
    _SectionData(
      titleAr: 'إدارة المحتوى الذكية',
      titleEn: 'Smart Content Management',
      descAr: 'أنظمة إدارة محتوى تفهمك قبل أن تطلب. تنظيم تلقائي ونشر ذكي.',
      descEn: 'Content management systems that understand you before you ask. Auto-organization, smart publishing.',
      color: Color(0xFF58A6FF),
      color2: Color(0xFF3FB950),
    ),
    _SectionData(
      titleAr: 'تحليل البيانات العميق',
      titleEn: 'Deep Data Analytics',
      descAr: 'نغرق في أعماق البيانات لنستخرج كنوزاً لا يراها أحد غيرنا.',
      descEn: 'We dive deep into data to extract treasures no one else can see.',
      color: Color(0xFFD2A8FF),
      color2: Color(0xFFFFB020),
    ),
    _SectionData(
      titleAr: 'المستقبل يبدأ الآن',
      titleEn: 'The Future Starts Now',
      descAr: 'ما نبنيه اليوم هو nền mañana لعالم تقني أفضل. حدود إبداعنا لا نهائية.',
      descEn: 'What we build today is the foundation for a better tech world. Our creative bounds are infinite.',
      color: Color(0xFF3FD2FF),
      color2: Color(0xFF06D6A0),
    ),
  ];
}
