import 'package:flutter/material.dart';
import '../components.dart';
import '../custom_cursor.dart';

class OwnerSecretPage extends StatefulWidget {
  final VoidCallback onBack;
  const OwnerSecretPage({super.key, required this.onBack});

  @override
  State<OwnerSecretPage> createState() => _OwnerSecretPageState();
}

class _OwnerSecretPageState extends State<OwnerSecretPage> with SingleTickerProviderStateMixin {
  late final AnimationController _revealCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _revealCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim = CurvedAnimation(parent: _revealCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _revealCtrl, curve: Curves.easeOutCubic));
  }

  void _reveal() {
    setState(() => _revealed = true);
    _revealCtrl.forward();
  }

  @override
  void dispose() {
    _revealCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: Stack(
        children: [
          // Background gradient
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
                    Color(0xFF101828),
                  ],
                ),
              ),
            ),
          ),
          // Subtle blue glow
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, 0.3),
                  radius: 1.0,
                  colors: [
                    const Color(0xFF1080E0).withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Content
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: isMobile ? 60 : 80,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Back button
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: CustomCursorHover(
                          child: TextButton.icon(
                            onPressed: widget.onBack,
                            icon: const Icon(Icons.arrow_back, color: Color(0xFF1080E0)),
                            label: Text(
                              tr('العودة للرئيسية', 'Back to Home'),
                              style: const TextStyle(color: Color(0xFF1080E0), fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Secret lock icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF1080E0).withValues(alpha: 0.15),
                              const Color(0xFF2090FF).withValues(alpha: 0.08),
                            ],
                          ),
                          border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.3)),
                        ),
                        child: Icon(
                          _revealed ? Icons.person : Icons.lock_outline,
                          color: const Color(0xFF1080E0),
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 28),

                      Text(
                        tr('هوية صاحب الشركة', 'Company Owner Identity'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        tr(
                          'هذا مسار سري. هل تريد الكشف؟',
                          'This is a secret path. Do you want to reveal?',
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFFA6ABB6),
                        ),
                      ),
                      const SizedBox(height: 40),

                      if (!_revealed)
                        GestureDetector(
                          onTap: _reveal,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF1080E0), Color(0xFF2090FF)],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1080E0).withValues(alpha: 0.3),
                                    blurRadius: 24,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.vpn_key, color: Colors.white, size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    tr('افتح القفل', 'Unlock'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      if (_revealed)
                        FadeTransition(
                          opacity: _fadeAnim,
                          child: SlideTransition(
                            position: _slideAnim,
                            child: Column(
                              children: [
                                // Avatar
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF1080E0).withValues(alpha: 0.2),
                                        const Color(0xFF2090FF).withValues(alpha: 0.1),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: const Color(0xFF1080E0).withValues(alpha: 0.4),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'CM',
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF1080E0),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // Name
                                const Text(
                                  'Ali',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1080E0).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.25)),
                                  ),
                                  child: Text(
                                    tr('المؤسس والرئيس التنفيذي', 'Founder & CEO'),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2090FF),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 36),

                                // Info cards
                                _SecretInfoCard(
                                  icon: Icons.business,
                                  titleAr: 'الشركة',
                                  titleEn: 'Company',
                                  value: 'Code Master',
                                ),
                                const SizedBox(height: 12),
                                _SecretInfoCard(
                                  icon: Icons.location_on,
                                  titleAr: 'الموقع',
                                  titleEn: 'Location',
                                  value: 'Al-Amarah, Maysan, Iraq',
                                ),
                                const SizedBox(height: 12),
                                _SecretInfoCard(
                                  icon: Icons.code,
                                  titleAr: 'التخصص',
                                  titleEn: 'Specialty',
                                  value: tr('تطوير التطبيقات والأنظمة البرمجية', 'App Development & Software Systems'),
                                ),
                                const SizedBox(height: 12),
                                _SecretInfoCard(
                                  icon: Icons.phone,
                                  titleAr: 'الهاتف',
                                  titleEn: 'Phone',
                                  value: '+964 777 163 2241',
                                ),
                                const SizedBox(height: 48),

                                // Closing note
                                Text(
                                  tr(
                                    'شكراً لزيارتك المسار السري',
                                    'Thanks for visiting the secret path',
                                  ),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFF6B7280),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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

class _SecretInfoCard extends StatelessWidget {
  final IconData icon;
  final String titleAr;
  final String titleEn;
  final String value;

  const _SecretInfoCard({
    required this.icon,
    required this.titleAr,
    required this.titleEn,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141A29).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1080E0).withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1080E0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF1080E0), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(titleAr, titleEn),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
