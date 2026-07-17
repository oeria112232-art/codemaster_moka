import 'package:flutter/material.dart';
import 'custom_cursor.dart';
import 'dart:math';

class LanguageManager extends ChangeNotifier {
  static final LanguageManager instance = LanguageManager();
  bool _isArabic = true; // default Arabic
  bool get isArabic => _isArabic;

  void toggleLanguage() {
    _isArabic = !_isArabic;
    notifyListeners();
  }
}

String tr(String arText, String enText) {
  return LanguageManager.instance.isArabic ? arText : enText;
}

class Navbar extends StatefulWidget {
  final ScrollController scrollController;
  final VoidCallback onLogoTap;
  final Function(String) onLinkTap;

  const Navbar({
    super.key,
    required this.scrollController,
    required this.onLogoTap,
    required this.onLinkTap,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final scrolled = widget.scrollController.hasClients &&
        widget.scrollController.offset > 24;
    if (scrolled != _isScrolled) {
      setState(() {
        _isScrolled = scrolled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    final isSmallMobile = size.width < 450;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallMobile ? 12 : 24,
        vertical: _isScrolled ? 12 : 20,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1152), // max-w-6xl
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: _isScrolled 
                  ? const Color(0xFF141A29).withOpacity(0.5) 
                  : Colors.transparent,
              border: Border.all(
                color: _isScrolled 
                    ? const Color(0xFF1080E0).withOpacity(0.15) 
                    : Colors.transparent,
                width: 1,
              ),
              boxShadow: _isScrolled ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ] : null,
            ),
            padding: EdgeInsets.symmetric(
                horizontal: isSmallMobile ? 12 : 24, 
                vertical: isSmallMobile ? 6 : 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                GestureDetector(
                  onTap: widget.onLogoTap,
                  child: CustomCursorHover(
                    child: Image.asset(
                      'assets/cm-logo.png',
                      height: isSmallMobile ? 36 : 48, // larger to show text clearly
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if logo not loaded
                        return Row(
                          children: [
                            Icon(
                              Icons.code,
                              color: const Color(0xFF1080E0),
                              size: isSmallMobile ? 24 : 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'CODE MASTER',
                              style: TextStyle(
                                fontSize: isSmallMobile ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                
                // Links (Desktop only)
                if (isDesktop)
                  Row(
                    children: [
                      _buildNavLink(tr('الخدمات', 'Services'), '#services'),
                      const SizedBox(width: 32),
                      _buildNavLink(tr('رؤيتنا', 'Vision'), '#vision'),
                      const SizedBox(width: 32),
                      _buildNavLink(tr('قيمنا', 'Values'), '#values'),
                      const SizedBox(width: 32),
                      _buildNavLink(tr('اتصل بنا', 'Contact'), '#cta'),
                    ],
                  ),

                // Language and Get Started Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Language switcher Globe
                    CustomCursorHover(
                      child: IconButton(
                        icon: Icon(Icons.language, color: Colors.white, size: isSmallMobile ? 18 : 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          LanguageManager.instance.toggleLanguage();
                        },
                        tooltip: tr('English', 'عربي'),
                      ),
                    ),
                    SizedBox(width: isSmallMobile ? 8 : 12),

                    CustomCursorHover(
                      child: TextButton(
                        onPressed: () => widget.onLinkTap('#cta'),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF1080E0),
                          foregroundColor: const Color(0xFF090D16),
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallMobile ? 12 : 20, 
                            vertical: isSmallMobile ? 6 : 10
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999)),
                          textStyle: TextStyle(
                              fontSize: isSmallMobile ? 12 : 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter'),
                        ),
                        child: Text(tr('ابدأ', 'Start')),
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

  Widget _buildNavLink(String label, String href) {
    return CustomCursorHover(
      child: InkWell(
        onTap: () => widget.onLinkTap(href),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFA6ABB6),
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

}

class MagneticButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSolid;
  final Widget? icon;

  const MagneticButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isSolid = true,
    this.icon,
  });

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton> {
  Offset _magneticOffset = Offset.zero;
  final GlobalKey _buttonKey = GlobalKey();

  void _onHover(PointerEvent event) {
    final RenderBox? renderBox = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final size = renderBox.size;
    final localPosition = renderBox.globalToLocal(event.position);
    
    // Position relative to center
    final x = localPosition.dx - size.width / 2;
    final y = localPosition.dy - size.height / 2;
    
    setState(() {
      // Scale translation factor
      _magneticOffset = Offset(x * 0.25, y * 0.35);
    });
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _magneticOffset = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: _buttonKey,
      onHover: _onHover,
      onExit: _onExit,
      cursor: SystemMouseCursors.none,
      child: CustomCursorHover(
        child: TweenAnimationBuilder<Offset>(
          tween: Tween<Offset>(begin: Offset.zero, end: _magneticOffset),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          builder: (context, offset, child) {
            return Transform.translate(
              offset: offset,
              child: child,
            );
          },
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(999),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: widget.isSolid ? const Color(0xFF1080E0) : const Color(0xFF141A29).withOpacity(0.5),
                border: Border.all(
                  color: widget.isSolid ? Colors.transparent : const Color(0xFF1080E0).withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: widget.isSolid ? [
                  BoxShadow(
                    color: const Color(0xFF1080E0).withOpacity(0.25),
                    blurRadius: 24,
                    spreadRadius: 0,
                  ),
                ] : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      color: widget.isSolid ? const Color(0xFF090D16) : Colors.white,
                    ),
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

class TiltCard extends StatefulWidget {
  final String id;
  final String title;
  final String desc;
  final VoidCallback? onTap;

  const TiltCard({
    super.key,
    required this.id,
    required this.title,
    required this.desc,
    this.onTap,
  });

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> {
  double _rotateX = 0.0;
  double _rotateY = 0.0;
  bool _isHovered = false;
  
  // Local coordinates of the cursor relative to card size
  double _glowX = 0.5;
  double _glowY = 0.5;
  
  final GlobalKey _cardKey = GlobalKey();

  void _onHover(PointerEvent event) {
    final RenderBox? box = _cardKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    
    final size = box.size;
    final localPos = box.globalToLocal(event.position);
    
    // Normalized hover coordinates
    final px = (localPos.dx / size.width) - 0.5;
    final py = (localPos.dy / size.height) - 0.5;
    
    setState(() {
      _isHovered = true;
      // Max rotation ~ 9 degrees (0.15 rad)
      _rotateX = -py * 0.15;
      _rotateY = px * 0.15;
      _glowX = localPos.dx / size.width;
      _glowY = localPos.dy / size.height;
    });
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _isHovered = false;
      _rotateX = 0.0;
      _rotateY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: _cardKey,
      onHover: _onHover,
      onExit: _onExit,
      cursor: SystemMouseCursors.none,
      child: CustomCursorHover(
        child: TweenAnimationBuilder<Matrix4>(
          tween: Matrix4Tween(
            begin: Matrix4.identity(),
            end: _isHovered 
                ? (Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateX(_rotateX)
                  ..rotateY(_rotateY)
                  ..translate(0.0, -4.0, 0.0)) // translate Y up
                : Matrix4.identity(),
          ),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          builder: (context, matrix, child) {
            return Transform(
              transform: matrix,
              alignment: Alignment.center,
              child: child,
            );
          },
          child: GestureDetector(
            onTap: widget.onTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF141A29).withOpacity(0.5), // glass
              border: Border.all(
                color: _isHovered 
                    ? const Color(0xFF1080E0).withOpacity(0.4) 
                    : const Color(0xFF1080E0).withOpacity(0.1),
                width: 1.0,
              ),
              boxShadow: _isHovered ? [
                BoxShadow(
                  color: const Color(0xFF1080E0).withOpacity(0.25),
                  blurRadius: 24,
                  spreadRadius: -8,
                ),
              ] : null,
            ),
            child: Stack(
              children: [
                // Custom Radial glow tracking the cursor
                if (_isHovered)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CustomPaint(
                        painter: CardGlowPainter(glowX: _glowX, glowY: _glowY),
                      ),
                    ),
                  ),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: _isHovered 
                            ? const Color(0xFF1080E0).withOpacity(0.2) 
                            : const Color(0xFF1080E0).withOpacity(0.1),
                      ),
                      alignment: Alignment.center,
                      child: Card3DVisualizer(
                        id: widget.id,
                        isHovered: _isHovered,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title
                    Row(
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '</>',
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                            color: Color(0x803FD2FF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Description
                    Text(
                      widget.desc,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        color: Color(0xFFA6ABB6), // muted text
                        height: 1.5,
                      ),
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

class CardGlowPainter extends CustomPainter {
  final double glowX;
  final double glowY;

  CardGlowPainter({required this.glowX, required this.glowY});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(glowX * size.width, glowY * size.height);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF1080E0).withOpacity(0.18),
          Colors.transparent,
        ],
        stops: const [0.0, 0.65],
      ).createShader(Rect.fromCircle(center: center, radius: 110));

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CardGlowPainter oldDelegate) {
    return oldDelegate.glowX != glowX || oldDelegate.glowY != glowY;
  }
}



// -------------------------------------------------------------
// Real-Time 3D Geometry Visualizer for Homepage Cards
// -------------------------------------------------------------

class Card3DVisualizer extends StatefulWidget {
  final String id;
  final bool isHovered;

  const Card3DVisualizer({
    super.key,
    required this.id,
    required this.isHovered,
  });

  @override
  State<Card3DVisualizer> createState() => _Card3DVisualizerState();
}

class _Card3DVisualizerState extends State<Card3DVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..addListener(() {
        setState(() {});
      })..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Card3DGeometryPainter(
        id: widget.id,
        animationValue: _controller.value,
        isHovered: widget.isHovered,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class Card3DGeometryPainter extends CustomPainter {
  final String id;
  final double animationValue;
  final bool isHovered;

  Card3DGeometryPainter({
    required this.id,
    required this.animationValue,
    required this.isHovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    
    // Rotations based on animation and hover state
    final speedMultiplier = isHovered ? 2.2 : 1.0;
    final angleY = animationValue * 2.0 * pi * speedMultiplier;
    final angleX = sin(animationValue * pi) * 0.4 * speedMultiplier;
    final angleZ = animationValue * 0.4 * pi;

    // Draw rotating outer diagnostic HUD ring segments for sci-fi look
    final ringPaint = Paint()
      ..color = const Color(0xFF1080E0).withOpacity(isHovered ? 0.28 : 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    final hudRadius = size.width * 0.44;
    final hudRect = Rect.fromCircle(center: Offset(cx, cy), radius: hudRadius);
    
    // Draw spinning segmented ring pieces in clockwise/counter-clockwise directions
    canvas.drawArc(hudRect, angleY, 1.2, false, ringPaint);
    canvas.drawArc(hudRect, angleY + pi, 1.2, false, ringPaint);
    canvas.drawArc(hudRect, -angleY * 0.7, 0.6, false, ringPaint..color = const Color(0xFF0060B0).withOpacity(isHovered ? 0.28 : 0.12));

    // Dash telemetry support circle
    final dashPaint = Paint()
      ..color = const Color(0xFF1080E0).withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawCircle(Offset(cx, cy), size.width * 0.38, dashPaint);

    final List<Offset> projected = [];
    final List<double> depths = [];
    final List<List<int>> edges = [];

    // Projection method with 3D rotations (Yaw, Pitch, Roll)
    void projectAndAdd(double x, double y, double z) {
      // Rotate around Y-axis (Yaw)
      double cosY = cos(angleY);
      double sinY = sin(angleY);
      double x1 = x * cosY - z * sinY;
      double z1 = x * sinY + z * cosY;

      // Rotate around X-axis (Pitch)
      double cosX = cos(angleX);
      double sinX = sin(angleX);
      double y2 = y * cosX - z1 * sinX;
      double z2 = y * sinX + z1 * cosX;

      // Rotate around Z-axis (Roll)
      double cosZ = cos(angleZ);
      double sinZ = sin(angleZ);
      double x3 = x1 * cosZ - y2 * sinZ;
      double y3 = x1 * sinZ + y2 * cosZ;

      double fov = 100.0;
      double scale = fov / (fov + z2);
      
      // Scale coordinates to fit nicely inside 80-90px circular container
      projected.add(Offset(cx + x3 * scale, cy + y3 * scale));
      depths.add(z2);
    }

    if (id == 'ai') {
      // 1. AI: Highly Detailed Human Brain & Neural Synaptic Chip
      final lobes = [
        // Left lobe vertices
        [-4.0, -8.0, 0.0], [-9.0, -6.0, -2.0], [-11.0, -2.0, -3.0], [-10.0, 3.0, -2.0],
        [-7.0, 7.0, -1.0], [-3.0, 8.0, 0.0], [-2.0, 4.0, 1.0], [-3.0, 0.0, 0.0],
        [-5.0, -4.0, -2.0],
        // Right lobe vertices
        [4.0, -8.0, 0.0], [9.0, -6.0, 2.0], [11.0, -2.0, 3.0], [10.0, 3.0, 2.0],
        [7.0, 7.0, 1.0], [3.0, 8.0, 0.0], [2.0, 4.0, -1.0], [3.0, 0.0, 0.0],
        [5.0, -4.0, 2.0],
        // CPU chip in the center
        [-2.5, -2.5, 0.0], [2.5, -2.5, 0.0], [2.5, 2.5, 0.0], [-2.5, 2.5, 0.0]
      ];

      for (var v in lobes) {
        projectAndAdd(v[0] * 1.5, v[1] * 1.5, v[2] * 1.5);
      }

      // Connect Left Lobe
      edges.addAll([
        [0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 0],
        [1, 8], [2, 7], [3, 6]
      ]);

      // Connect Right Lobe
      edges.addAll([
        [9, 10], [10, 11], [11, 12], [12, 13], [13, 14], [14, 15], [15, 16], [16, 17], [17, 9],
        [10, 17], [11, 16], [12, 15]
      ]);

      // Connect central CPU Chip
      edges.addAll([
        [18, 19], [19, 20], [20, 21], [21, 18], // outer chip square
        // synapses connecting CPU to lobes
        [18, 8], [19, 17], [21, 3], [20, 12]
      ]);

    } else if (id == '3d') {
      // 2. 3D WEB: 3D Browser Window Frame + Spinning Sphere Grid inside
      final browserVertices = [
        // Front Frame corners
        [-14.0, -10.0, -2.0], [14.0, -10.0, -2.0], [14.0, 10.0, -2.0], [-14.0, 10.0, -2.0],
        // Top tab line
        [-14.0, -7.0, -2.0], [14.0, -7.0, -2.0],
        // Close / Minimize / Maximize window buttons
        [-11.0, -8.5, -2.0], [-9.5, -8.5, -2.0], [-8.0, -8.5, -2.0]
      ];

      for (var v in browserVertices) {
        projectAndAdd(v[0], v[1], v[2]);
      }

      edges.addAll([
        [0, 1], [1, 2], [2, 3], [3, 0], // outer frame
        [4, 5], // title bar line
        [6, 7], [7, 8] // window buttons indicators
      ]);

      // Spinning 3D WebGL Sphere inside browser (10 vertices)
      final sphereStart = projected.length;
      final double r = 5.0;
      final sphereVertices = [
        [0.0, -r, 0.0], [0.0, r, 0.0],
        [-r, 0.0, 0.0], [r, 0.0, 0.0],
        [0.0, 0.0, -r], [0.0, 0.0, r],
        // diagonals
        [-r*0.7, -r*0.7, 0.0], [r*0.7, -r*0.7, 0.0],
        [-r*0.7, r*0.7, 0.0], [r*0.7, r*0.7, 0.0]
      ];

      final sphereAngle = animationValue * 4.0 * pi;
      for (var v in sphereVertices) {
        // Rotate sphere coordinates independently
        double sx = v[0] * cos(sphereAngle) - v[2] * sin(sphereAngle);
        double cz = v[0] * sin(sphereAngle) + v[2] * cos(sphereAngle);
        projectAndAdd(sx, v[1] + 1.0, cz);
      }

      edges.addAll([
        [sphereStart + 0, sphereStart + 2], [sphereStart + 2, sphereStart + 1],
        [sphereStart + 0, sphereStart + 3], [sphereStart + 3, sphereStart + 1],
        [sphereStart + 0, sphereStart + 4], [sphereStart + 4, sphereStart + 1],
        [sphereStart + 0, sphereStart + 5], [sphereStart + 5, sphereStart + 1],
        [sphereStart + 2, sphereStart + 4], [sphereStart + 4, sphereStart + 3],
        [sphereStart + 3, sphereStart + 5], [sphereStart + 5, sphereStart + 2],
        [sphereStart + 6, sphereStart + 9], [sphereStart + 7, sphereStart + 8]
      ]);

    } else if (id == 'saas') {
      // 3. SAAS: Rotating Industrial Gear + 3D Database Storage Stack
      final gearStart = projected.length;
      final double grOuter = 13.0;
      final double grInner = 8.0;
      final gearAngle = -animationValue * 3.0 * pi;

      for (int i = 0; i < 8; i++) {
        double theta = (i / 8) * 2 * pi + gearAngle;
        // Outer teeth points
        projectAndAdd(grOuter * cos(theta), grOuter * sin(theta), -3.0);
        // Inner points
        projectAndAdd(grInner * cos(theta), grInner * sin(theta), -3.0);
      }

      for (int i = 0; i < 8; i++) {
        int idx = gearStart + i * 2;
        int nextIdx = gearStart + ((i * 2 + 2) % 16);
        // Draw gear shape
        edges.add([idx, idx + 1]); // outer to inner radial lines
        edges.add([idx + 1, nextIdx + 1]); // inner ring connector
        if (i % 2 == 0) {
          edges.add([idx, gearStart + (i * 2 + 2) % 16]); // outer teeth edge
        }
      }

      // 3D Database Cylindrical Disk floating in front (Y-offset)
      final dbStart = projected.length;
      final double dr = 8.0;
      final dbVertices = [
        // Disk Top Rim
        [-dr, 4.0, 4.0], [0.0, 2.0, 7.0], [dr, 4.0, 4.0], [0.0, 6.0, 1.0],
        // Disk Bottom Rim
        [-dr, 9.0, 4.0], [0.0, 7.0, 7.0], [dr, 9.0, 4.0], [0.0, 11.0, 1.0]
      ];

      for (var v in dbVertices) {
        projectAndAdd(v[0], v[1], v[2]);
      }

      edges.addAll([
        [dbStart + 0, dbStart + 1], [dbStart + 1, dbStart + 2], [dbStart + 2, dbStart + 3], [dbStart + 3, dbStart + 0], // top
        [dbStart + 4, dbStart + 5], [dbStart + 5, dbStart + 6], [dbStart + 6, dbStart + 7], [dbStart + 7, dbStart + 4], // bot
        [dbStart + 0, dbStart + 4], [dbStart + 2, dbStart + 6] // vertical lines
      ]);

    } else if (id == 'security') {
      // 4. SECURITY: Cyber Knight Shield + Solid Center Padlock
      final shieldVertices = [
        [-12.0, -10.0, 0.0], [0.0, -12.0, 0.0], [12.0, -10.0, 0.0],
        [12.0, -2.0, 2.0], [7.0, 5.0, 3.0], [0.0, 12.0, 4.0],
        [-7.0, 5.0, 3.0], [-12.0, -2.0, 2.0],
        // Central Shield Cross
        [0.0, -10.0, 1.0], [0.0, 10.0, 2.0]
      ];

      for (var v in shieldVertices) {
        projectAndAdd(v[0], v[1], v[2]);
      }

      edges.addAll([
        [0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 0], // outer rim
        [1, 8], [8, 9] // vertical cross rib
      ]);

      // Padlock inside shield (8 vertices)
      final lockStart = projected.length;
      final lockVertices = [
        // base box
        [-4.5, 1.0, -3.0], [4.5, 1.0, -3.0], [4.5, 6.0, -3.0], [-4.5, 6.0, -3.0],
        // shackle loop
        [-3.0, 1.0, -3.0], [-3.0, -2.0, -3.0], [3.0, -2.0, -3.0], [3.0, 1.0, -3.0]
      ];

      for (var v in lockVertices) {
        projectAndAdd(v[0], v[1], v[2]);
      }

      edges.addAll([
        [lockStart + 0, lockStart + 1], [lockStart + 1, lockStart + 2], 
        [lockStart + 2, lockStart + 3], [lockStart + 3, lockStart + 0], // lock base
        [lockStart + 4, lockStart + 5], [lockStart + 5, lockStart + 6], [lockStart + 6, lockStart + 7] // shackle loop
      ]);

    } else if (id == 'architecture') {
      // 5. ARCHITECTURE: Server Infrastructure rack cabinet with connection cables
      final double sw = 11.0;
      final double sh = 13.0;
      final double sd = 4.0;
      final cabinetVertices = [
        [-sw, -sh, -sd], [sw, -sh, -sd], [sw, sh, -sd], [-sw, sh, -sd],
        [-sw, -sh, sd], [sw, -sh, sd], [sw, sh, sd], [-sw, sh, sd]
      ];

      for (var v in cabinetVertices) {
        projectAndAdd(v[0], v[1], v[2]);
      }

      edges.addAll([
        [0, 1], [1, 2], [2, 3], [3, 0], // front
        [4, 5], [5, 6], [6, 7], [7, 4], // back
        [0, 4], [1, 5], [2, 6], [3, 7]  // columns
      ]);

      // 3 Server shelves lines inside cabinet
      final shelfStart = projected.length;
      final shelfVertices = [
        [-sw, -4.0, -sd], [sw, -4.0, -sd],
        [-sw, 1.0, -sd], [sw, 1.0, -sd],
        [-sw, 6.0, -sd], [sw, 6.0, -sd]
      ];

      for (var v in shelfVertices) {
        projectAndAdd(v[0], v[1], v[2]);
      }

      edges.addAll([
        [shelfStart + 0, shelfStart + 1],
        [shelfStart + 2, shelfStart + 3],
        [shelfStart + 4, shelfStart + 5]
      ]);

    } else if (id == 'immersive') {
      // 6. IMMERSIVE UX: Sleek Futuristic VR Visor + Immersive Radar arcs
      final visorVertices = [
        // Visor front glass
        [-14.0, -4.5, -4.0], [14.0, -4.5, -4.0], [14.0, 4.5, -4.0], [-14.0, 4.5, -4.0],
        // Side frames
        [-11.0, -4.5, 4.0], [11.0, -4.5, 4.0], [11.0, 4.5, 4.0], [-11.0, 4.5, 4.0],
        // Nose cutout bridge
        [-3.0, 4.5, -4.0], [0.0, 2.0, -4.0], [3.0, 4.5, -4.0]
      ];

      for (var v in visorVertices) {
        projectAndAdd(v[0], v[1] - 1.0, v[2]);
      }

      edges.addAll([
        [0, 1], [1, 2], [2, 10], [10, 9], [9, 8], [8, 3], [3, 0], // front frame with nose cutout
        [4, 5], [5, 6], [6, 7], [7, 4], // back plate
        [0, 4], [1, 5], [2, 6], [3, 7]  // side temples
      ]);

      // Outer interactive wave arc
      final waveStart = projected.length;
      final int wavePoints = 7;
      final double wr = 17.0;
      for (int i = 0; i < wavePoints; i++) {
        double theta = -pi/3 + (i / (wavePoints - 1)) * (2 * pi / 3);
        projectAndAdd(wr * cos(theta), wr * sin(theta), 0.0);
      }
      for (int i = 0; i < wavePoints - 1; i++) {
        edges.add([waveStart + i, waveStart + i + 1]);
      }
    }

    // -------------------------------------------------------------
    // PAINTING WITH DUAL-PASS NEON GLOW & DEPTH SHADING
    // -------------------------------------------------------------

    // Add Epic Cosmic Explosion Particles on Hover
    if (isHovered) {
      final Random rnd = Random(42); // fixed seed for stable trajectory
      
      // Draw exploding cosmic rays
      for (int i = 0; i < 40; i++) {
        final angle = rnd.nextDouble() * 2 * pi;
        final lengthBase = 40.0 + rnd.nextDouble() * 60.0;
        final phase = rnd.nextDouble();
        // rapid time cycle for explosions
        final t = (animationValue * 6.0 + phase) % 1.0; 
        
        // Expansion logic
        final startDist = t * 20.0;
        final endDist = startDist + lengthBase * pow(1.0 - t, 2.0);
        
        final p1 = Offset(cx + cos(angle) * startDist, cy + sin(angle) * startDist);
        final p2 = Offset(cx + cos(angle) * endDist, cy + sin(angle) * endDist);
        
        final rayPaint = Paint()
          ..color = (i % 2 == 0 ? const Color(0xFF1080E0) : const Color(0xFF0060B0)).withOpacity((1.0 - t) * 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5 * (1.0 - t)
          ..strokeCap = StrokeCap.round;
          
        canvas.drawLine(p1, p2, rayPaint);
      }

      // Draw floating stardust and explosive particles
      for (int i = 0; i < 150; i++) {
        final angle = rnd.nextDouble() * 2 * pi;
        final speed = 30.0 + rnd.nextDouble() * 120.0;
        final phase = rnd.nextDouble();
        final t = (animationValue * 3.0 + phase) % 1.0;
        
        // Explode outward with deceleration
        final distance = speed * pow(t, 0.4); 
        final px = cx + cos(angle) * distance;
        final py = cy + sin(angle) * distance;
        
        final size = rnd.nextDouble() * 3.0 * (1.0 - t);
        final particleAlpha = (1.0 - t).clamp(0.0, 1.0);
        
        final particleColor = i % 3 == 0 
            ? const Color(0xFF0060B0) 
            : (i % 3 == 1 ? const Color(0xFF1080E0) : Colors.white);

        final pPaint = Paint()
          ..color = particleColor.withOpacity(particleAlpha * 0.9)
          ..style = PaintingStyle.fill;
          
        canvas.drawCircle(Offset(px, py), size, pPaint);
        
        // Core glowing dot for larger particles
        if (size > 1.5) {
          canvas.drawCircle(Offset(px, py), size * 0.4, Paint()..color = Colors.white.withOpacity(particleAlpha)..style = PaintingStyle.fill);
        }
      }
    }

    // First pass: Wide Blur neon glow
    for (var edge in edges) {
      if (edge[0] < projected.length && edge[1] < projected.length) {
        final zAvg = (depths[edge[0]] + depths[edge[1]]) / 2.0;
        
        // Depth-based opacity: elements in front are brighter
        double depthOpacity = (100.0 - zAvg) / 100.0;
        depthOpacity = depthOpacity.clamp(0.15, 1.0);

        final glowColor = isHovered ? const Color(0xFF0060B0) : const Color(0xFF1080E0);

        final glowPaint = Paint()
          ..color = glowColor.withOpacity(depthOpacity * (isHovered ? 0.4 : 0.28))
          ..style = PaintingStyle.stroke
          ..strokeWidth = (isHovered ? 4.5 : 3.6) * depthOpacity
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(projected[edge[0]], projected[edge[1]], glowPaint);
      }
    }

    // Second pass: Sharp Core line
    for (var edge in edges) {
      if (edge[0] < projected.length && edge[1] < projected.length) {
        final zAvg = (depths[edge[0]] + depths[edge[1]]) / 2.0;
        double depthOpacity = (100.0 - zAvg) / 100.0;
        depthOpacity = depthOpacity.clamp(0.15, 1.0);

        final coreColor = isHovered ? const Color(0xFFFFE0EE) : const Color(0xFFE0F7FF);

        final corePaint = Paint()
          ..color = coreColor.withOpacity(depthOpacity * 0.95)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.3 * depthOpacity
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(projected[edge[0]], projected[edge[1]], corePaint);
      }
    }

    // Draw glowing vertices (Points)
    for (int i = 0; i < projected.length; i++) {
      final p = projected[i];
      final z = depths[i];
      double depthOpacity = (100.0 - z) / 100.0;
      depthOpacity = depthOpacity.clamp(0.2, 1.0);
      
      // Dynamic pulsing effect on hover
      final pulse = isHovered ? sin(animationValue * pi * 8.0 + i) * 1.5 : 0.0;

      final pointColor = isHovered ? const Color(0xFF0060B0) : const Color(0xFF1080E0);

      // Outer neon particle dot
      final nodeGlow = Paint()
        ..color = pointColor.withOpacity(depthOpacity * 0.6)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(p, (3.2 + pulse) * depthOpacity, nodeGlow);

      // Inner white core particle dot
      final nodeCore = Paint()
        ..color = Colors.white.withOpacity(depthOpacity * 0.95)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(p, (1.2 + pulse * 0.3) * depthOpacity, nodeCore);
    }
  }

  @override
  bool shouldRepaint(covariant Card3DGeometryPainter oldDelegate) => true;
}
