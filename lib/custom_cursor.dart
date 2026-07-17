import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomCursorManager extends ChangeNotifier {
  static final CustomCursorManager instance = CustomCursorManager._();
  CustomCursorManager._();

  Offset _position = Offset.zero;
  Offset get position => _position;

  bool _isHovering = false;
  bool get isHovering => _isHovering;

  bool _visible = false;
  bool get visible => _visible;

  void updatePosition(Offset pos) {
    _position = pos;
    _visible = true;
    notifyListeners();
  }

  void setHovering(bool hovering) {
    if (_isHovering != hovering) {
      _isHovering = hovering;
      notifyListeners();
    }
  }

  void hide() {
    if (_visible) {
      _visible = false;
      notifyListeners();
    }
  }
}

class CustomCursorHover extends StatefulWidget {
  final Widget child;
  const CustomCursorHover({super.key, required this.child});

  @override
  State<CustomCursorHover> createState() => _CustomCursorHoverState();
}

class _CustomCursorHoverState extends State<CustomCursorHover> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (_) => CustomCursorManager.instance.setHovering(true),
      onExit: (_) => CustomCursorManager.instance.setHovering(false),
      child: widget.child,
    );
  }
}

class CustomCursorOverlay extends StatefulWidget {
  final Widget child;
  const CustomCursorOverlay({super.key, required this.child});

  @override
  State<CustomCursorOverlay> createState() => _CustomCursorOverlayState();
}

class _CustomCursorOverlayState extends State<CustomCursorOverlay>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  
  double _ringX = 0;
  double _ringY = 0;
  double _velX = 0;
  double _velY = 0;
  
  double _dotX = 0;
  double _dotY = 0;

  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _ticker.start();

    final initPos = CustomCursorManager.instance.position;
    _ringX = initPos.dx;
    _ringY = initPos.dy;
    _dotX = initPos.dx;
    _dotY = initPos.dy;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    
    final target = CustomCursorManager.instance.position;
    final isHover = CustomCursorManager.instance.isHovering;

    _dotX += (target.dx - _dotX) * 0.35;
    _dotY += (target.dy - _dotY) * 0.35;

    const stiffness = 0.16;
    const damping = 0.75;

    final ax = (target.dx - _ringX) * stiffness;
    final ay = (target.dy - _ringY) * stiffness;
    _velX = (_velX + ax) * damping;
    _velY = (_velY + ay) * damping;
    _ringX += _velX;
    _ringY += _velY;

    final targetScale = isHover ? 2.4 : 1.0;
    _scale += (targetScale - _scale) * 0.15;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CustomCursorManager.instance,
      builder: (context, _) {
        final manager = CustomCursorManager.instance;
        final showCursor = manager.visible;
        
        return MouseRegion(
          opaque: false,
          cursor: SystemMouseCursors.none,
          onHover: (event) {
            CustomCursorManager.instance.updatePosition(event.position);
          },
          onExit: (event) {
            CustomCursorManager.instance.hide();
          },
          child: Stack(
            children: [
              widget.child,
              if (showCursor)
                IgnorePointer(
                  child: Stack(
                    children: [
                      Positioned(
                        left: _ringX - 20,
                        top: _ringY - 20,
                        child: Transform.scale(
                          scale: _scale,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF1080E0).withOpacity(0.06),
                              border: Border.all(
                                color: const Color(0xFF1080E0).withOpacity(0.6),
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1080E0).withOpacity(0.45),
                                  blurRadius: 22,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: _dotX - 3,
                        top: _dotY - 3,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1080E0),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1080E0).withOpacity(0.9),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
