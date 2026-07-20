import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components.dart';
import '../custom_cursor.dart';

class SupportPage extends StatefulWidget {
  final VoidCallback onBack;
  const SupportPage({super.key, required this.onBack});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final problems = [
      {
        'icon': Icons.language,
        'titleAr': 'الموقع لا يعمل أو يفتح ببطء',
        'titleEn': 'Website not loading or slow',
        'descAr': 'تأكد من اتصالك بالإنترنت. إذا استمرت المشكلة، قد يكون الموقع قيد الصيانة. تواصل معنا وسنساعدك فوراً.',
        'descEn': 'Check your internet connection. If the issue persists, the site may be under maintenance. Contact us and we\'ll help immediately.',
      },
      {
        'icon': Icons.shopping_cart,
        'titleAr': 'مشاكل في المتجر الإلكتروني أو الدفع',
        'titleEn': 'E-commerce or payment issues',
        'descAr': 'إذا واجهت مشكلة في عملية الشراء أو الدفع، تأكد من صحة بيانات الدفع. يمكنك أيضاً التواصل معنا عبر واتساب لمساعدتك.',
        'descEn': 'If you encounter issues with checkout or payment, verify your payment details. You can also reach us via WhatsApp for immediate help.',
      },
      {
        'icon': Icons.phone_android,
        'titleAr': 'تطبيق الموبايل لا يعمل بشكل صحيح',
        'titleEn': 'Mobile app not working properly',
        'descAr': 'جرب تحديث التطبيق أو إعادة تثبيته. تأكد من أن جهازك متوافق مع إصدار التطبيق الأخير. اتصل بنا للدعم الفني.',
        'descEn': 'Try updating or reinstalling the app. Ensure your device is compatible with the latest version. Contact us for technical support.',
      },
      {
        'icon': Icons.lock,
        'titleAr': 'مشاكل في تسجيل الدخول أو الحساب',
        'titleEn': 'Login or account issues',
        'descAr': 'إذا نسيت كلمة المرور، استخدم خيار "نسيت كلمة المرور". للمشاكل الأخرى، تواصل معنا وسنقوم بإعادة تعيين حسابك.',
        'descEn': 'If you forgot your password, use the "Forgot Password" option. For other issues, contact us and we\'ll reset your account.',
      },
      {
        'icon': Icons.build,
        'titleAr': 'طلب صيانة أو تحديث لنظامك الحالي',
        'titleEn': 'Maintenance or update request',
        'descAr': 'نقدم خدمات صيانة وتحديث مستمرة لأنظمتنا. تواصل معنا لتحديد موعد ومناقشة احتياجاتك.',
        'descEn': 'We provide ongoing maintenance and update services for our systems. Contact us to schedule and discuss your needs.',
      },
      {
        'icon': Icons.help_outline,
        'titleAr': 'سؤال عام أو استفسار',
        'titleEn': 'General question or inquiry',
        'descAr': 'لا تتردد في التواصل معنا لأي سؤال. فريقنا جاهز للإجابة على جميع استفساراتك.',
        'descEn': 'Don\'t hesitate to reach out with any question. Our team is ready to answer all your inquiries.',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF050810),
                    Color(0xFF090D16),
                    Color(0xFF0C1220),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: isMobile ? 60 : 80,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      CustomCursorHover(
                        child: TextButton.icon(
                          onPressed: widget.onBack,
                          icon: const Icon(Icons.arrow_back, color: Color(0xFF1080E0)),
                          label: Text(
                            tr('العودة للرئيسية', 'Back to Home'),
                            style: const TextStyle(color: Color(0xFF1080E0), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Contact Support button at top
                      _SupportContactButton(isMobile: isMobile),
                      const SizedBox(height: 48),

                      // Header
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
                        tr('الدعم والمساعدة', 'Support & Help'),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        tr(
                          'اختر المشكلة التي تواجهها وسنقوم بمساعدتك',
                          'Choose the issue you\'re facing and we\'ll help you',
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFA6ABB6),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Problem cards
                      ...List.generate(problems.length, (i) {
                        final p = problems[i];
                        final isExpanded = _expandedIndex == i;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _expandedIndex = isExpanded ? null : i;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                              padding: EdgeInsets.all(isMobile ? 20 : 24),
                              decoration: BoxDecoration(
                                color: isExpanded
                                    ? const Color(0xFF1080E0).withValues(alpha: 0.08)
                                    : const Color(0xFF141A29).withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isExpanded
                                      ? const Color(0xFF1080E0).withValues(alpha: 0.4)
                                      : const Color(0xFF1080E0).withValues(alpha: 0.1),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1080E0).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(p['icon'] as IconData, color: const Color(0xFF1080E0), size: 22),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          tr(p['titleAr'] as String, p['titleEn'] as String),
                                          style: TextStyle(
                                            fontSize: isMobile ? 15 : 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      AnimatedRotation(
                                        turns: isExpanded ? 0.5 : 0,
                                        duration: const Duration(milliseconds: 300),
                                        child: const Icon(Icons.expand_more, color: Color(0xFF1080E0)),
                                      ),
                                    ],
                                  ),
                                  AnimatedCrossFade(
                                    firstChild: const SizedBox.shrink(),
                                    secondChild: Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Text(
                                        tr(p['descAr'] as String, p['descEn'] as String),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFA6ABB6),
                                          height: 1.8,
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
                        );
                      }),
                      const SizedBox(height: 48),

                      // Bottom contact CTA
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF1080E0).withValues(alpha: 0.1),
                              const Color(0xFF2090FF).withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.15)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              tr('لم تجد حل لمشكلتك؟', 'Couldn\'t find a solution?'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tr(
                                'فريقنا جاهز لمساعدتك على مدار الساعة',
                                'Our team is ready to help you around the clock',
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFFA6ABB6),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _SupportContactButton(isMobile: isMobile),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportContactButton extends StatelessWidget {
  final bool isMobile;
  const _SupportContactButton({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _SupportBtn(
          label: tr('واتساب', 'WhatsApp'),
          icon: Icons.chat,
          color: const Color(0xFF25D366),
          url: 'https://wa.me/9647771632241',
        ),
        _SupportBtn(
          label: tr('تيليجرام', 'Telegram'),
          icon: Icons.send,
          color: const Color(0xFF0088cc),
          url: 'https://t.me/codemaster6',
        ),
      ],
    );
  }
}

class _SupportBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String url;
  const _SupportBtn({required this.label, required this.icon, required this.color, required this.url});

  @override
  State<_SupportBtn> createState() => _SupportBtnState();
}

class _SupportBtnState extends State<_SupportBtn> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.color,
                if (_hover) Color.lerp(widget.color, Colors.white, 0.12)! else widget.color,
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: _hover
                ? [BoxShadow(color: widget.color.withValues(alpha: 0.35), blurRadius: 20)]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                widget.label,
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
