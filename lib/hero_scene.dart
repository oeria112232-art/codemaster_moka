import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'custom_cursor.dart';
import 'components.dart';

class Vector3 {
  final double x, y, z;
  const Vector3(this.x, this.y, this.z);

  Vector3 operator +(Vector3 other) => Vector3(x + other.x, y + other.y, z + other.z);
  Vector3 operator -(Vector3 other) => Vector3(x - other.x, y - other.y, z - other.z);
  Vector3 operator *(double s) => Vector3(x * s, y * s, z * s);

  double length() => math.sqrt(x * x + y * y + z * z);
  Vector3 normalized() {
    final len = length();
    return len == 0 ? const Vector3(0, 0, 0) : this * (1.0 / len);
  }
}

class SparkParticle {
  double x, y, z;
  final double vx, vy, vz;
  final Color color;
  final double size;
  final double lifeDecay;
  double life = 1.0;

  SparkParticle({
    required this.x,
    required this.y,
    required this.z,
    required this.vx,
    required this.vy,
    required this.vz,
    required this.color,
    required this.size,
    required this.lifeDecay,
  });
}

class MatrixCode {
  double x, y;
  double speed;
  String char;
  double opacity;

  MatrixCode({
    required this.x,
    required this.y,
    required this.speed,
    required this.char,
    required this.opacity,
  });
}

class ThreatVector {
  final double startX, startY;
  final double angle;
  final double speed;
  double progress = 0.0;

  ThreatVector({
    required this.startX,
    required this.startY,
    required this.angle,
    required this.speed,
  });
}

class HeroScene extends StatefulWidget {
  const HeroScene({super.key});

  @override
  State<HeroScene> createState() => _HeroSceneState();
}

class _HeroSceneState extends State<HeroScene> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _time = 0.0;
  
  double _sphereRotationY = 0.0;
  double _sphereRotationX = 0.0;
  double _particleRotationY = 0.0;
  double _particleRotationX = 0.0;
  double _particleRotationZ = 0.0;

  double _pointerX = 0.0;
  double _pointerY = 0.0;

  late List<Vector3> _icoVertices;
  late List<List<int>> _icoEdges;
  late List<Vector3> _particles;
  late List<SparkParticle> _sparks;
  late List<MatrixCode> _matrixDrops;
  late List<ThreatVector> _miniMeteors;

  @override
  void initState() {
    super.initState();
    _initializeIcosahedron();
    _initializeParticles();
    _initializeSparks();
    _initializeMatrixDrops();
    _initializeMiniMeteors();

    _ticker = createTicker((elapsed) {
      if (!mounted) return;

      final pointerPos = CustomCursorManager.instance.position;
      final size = MediaQuery.of(context).size;
      final width = size.width > 0 ? size.width : 1200.0;
      final height = size.height > 0 ? size.height : 800.0;

      final targetPointerX = (pointerPos.dx / width) * 2 - 1;
      final targetPointerY = -((pointerPos.dy / height) * 2 - 1);

      _pointerX += (targetPointerX - _pointerX) * 0.06;
      _pointerY += (targetPointerY - _pointerY) * 0.06;

      const delta = 0.016;

      setState(() {
        _time += delta;
        if (_time >= 20.0) {
          _time = 0.0;
          _initializeSparks();
          _initializeMiniMeteors();
        }

        // Standard rotations (slightly faster for smoother high FPS feel)
        _sphereRotationY += delta * 0.32;
        _sphereRotationX = _sphereRotationX + (_pointerY * 0.35 - _sphereRotationX) * 0.05;
        _sphereRotationY += _pointerX * 0.0009;

        _particleRotationY -= delta * 0.06;
        _particleRotationX = _particleRotationX + (-_pointerY * 0.18 - _particleRotationX) * 0.04;
        _particleRotationZ = _particleRotationZ + (_pointerX * 0.12 - _particleRotationZ) * 0.04;

        // Update sparks if in explosion phase (10.0 to 13.5)
        if (_time >= 10.0 && _time < 13.5) {
          for (var spark in _sparks) {
            spark.x += spark.vx;
            spark.y += spark.vy;
            spark.z += spark.vz;
            spark.life = (spark.life - spark.lifeDecay).clamp(0.0, 1.0);
          }
        }

        // Update Matrix drops at all times
        final rand = math.Random();
        for (var drop in _matrixDrops) {
          drop.y += drop.speed;
          if (drop.y > height) {
            drop.y = -20;
            drop.char = rand.nextInt(2).toString();
            drop.opacity = 0.2 + rand.nextDouble() * 0.8;
          }
        }

        // Update mini shooting-stars / meteors during warning phase (7.0 to 10.0s)
        if (_time >= 7.0 && _time < 10.0) {
          for (var met in _miniMeteors) {
            met.progress += met.speed * delta;
          }
        }
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _initializeIcosahedron() {
    _icoVertices = [];
    _icoEdges = [];

    const int latBands = 15;
    const int lonBands = 15;

    // Generate detailed sphere vertices using latitude and longitude grid
    for (int lat = 0; lat <= latBands; lat++) {
      final double theta = lat * math.pi / latBands;
      final double sinTheta = math.sin(theta);
      final double cosTheta = math.cos(theta);

      for (int lon = 0; lon <= lonBands; lon++) {
        final double phi = lon * 2 * math.pi / lonBands;
        final double sinPhi = math.sin(phi);
        final double cosPhi = math.cos(phi);

        final double x = cosPhi * sinTheta;
        final double y = cosTheta;
        final double z = sinPhi * sinTheta;

        _icoVertices.add(Vector3(x, y, z));
      }
    }

    // Generate edges to form a wireframe grid
    for (int lat = 0; lat < latBands; lat++) {
      for (int lon = 0; lon < lonBands; lon++) {
        final int first = (lat * (lonBands + 1)) + lon;
        final int second = first + lonBands + 1;

        // Longitude lines
        _icoEdges.add([first, first + 1]);
        // Latitude lines
        _icoEdges.add([first, second]);
      }
    }
  }

  void _initializeParticles() {
    final random = math.Random();
    _particles = [];
    const count = 120;
    for (var i = 0; i < count; i++) {
      final r = 4.0 + random.nextDouble() * 6.0;
      final theta = random.nextDouble() * math.pi * 2;
      final phi = math.acos(2.0 * random.nextDouble() - 1.0);
      _particles.add(Vector3(
        r * math.sin(phi) * math.cos(theta),
        r * math.sin(phi) * math.sin(theta),
        r * math.cos(phi),
      ));
    }
  }

  void _initializeSparks() {
    final random = math.Random();
    _sparks = [];
    const count = 160;
    final colors = [
      const Color(0xFFFFFF00), // Yellow
      const Color(0xFFFF4500), // Fire Orange
      const Color(0xFFFF0033), // Red Plasma
      const Color(0xFF00E5FF), // Neon Cyan Rebuild Sparks
      const Color(0xFF0060B0), // Cyber Purple Sparks
    ];
    for (var i = 0; i < count; i++) {
      final theta = random.nextDouble() * math.pi * 2;
      final phi = math.acos(2.0 * random.nextDouble() - 1.0);
      final speed = 3.0 + random.nextDouble() * 7.0;
      _sparks.add(SparkParticle(
        x: 0,
        y: 0,
        z: 0,
        vx: speed * math.sin(phi) * math.cos(theta),
        vy: speed * math.sin(phi) * math.sin(theta),
        vz: speed * math.cos(phi),
        color: colors[random.nextInt(colors.length)],
        size: 1.5 + random.nextDouble() * 3.5,
        lifeDecay: 0.006 + random.nextDouble() * 0.016,
      ));
    }
  }

  void _initializeMatrixDrops() {
    final random = math.Random();
    _matrixDrops = [];
    const count = 45;
    for (var i = 0; i < count; i++) {
      _matrixDrops.add(MatrixCode(
        x: random.nextDouble() * 1920.0,
        y: random.nextDouble() * 1080.0,
        speed: 2.5 + random.nextDouble() * 5.5,
        char: random.nextInt(2).toString(),
        opacity: 0.15 + random.nextDouble() * 0.55,
      ));
    }
  }

  void _initializeMiniMeteors() {
    final random = math.Random();
    _miniMeteors = [];
    const count = 5;
    for (var i = 0; i < count; i++) {
      _miniMeteors.add(ThreatVector(
        startX: 400.0 + random.nextDouble() * 800.0,
        startY: -100.0 - random.nextDouble() * 200.0,
        angle: 2.2 + random.nextDouble() * 0.6,
        speed: 1.2 + random.nextDouble() * 1.5, // Faster travel speed
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: StoryScenePainter(
          time: _time,
          vertices: _icoVertices,
          edges: _icoEdges,
          particles: _particles,
          sparks: _sparks,
          matrixDrops: _matrixDrops,
          miniMeteors: _miniMeteors,
          sphereRotX: _sphereRotationX,
          sphereRotY: _sphereRotationY,
          partRotX: _particleRotationX,
          partRotY: _particleRotationY,
          partRotZ: _particleRotationZ,
          pointerX: _pointerX,
          pointerY: _pointerY,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class StoryScenePainter extends CustomPainter {
  final double time;
  final List<Vector3> vertices;
  final List<List<int>> edges;
  final List<Vector3> particles;
  final List<SparkParticle> sparks;
  final List<MatrixCode> matrixDrops;
  final List<ThreatVector> miniMeteors;

  final double sphereRotX;
  final double sphereRotY;

  final double partRotX;
  final double partRotY;
  final double partRotZ;

  final double pointerX;
  final double pointerY;

  const StoryScenePainter({
    required this.time,
    required this.vertices,
    required this.edges,
    required this.particles,
    required this.sparks,
    required this.matrixDrops,
    required this.miniMeteors,
    required this.sphereRotX,
    required this.sphereRotY,
    required this.partRotX,
    required this.partRotY,
    required this.partRotZ,
    required this.pointerX,
    required this.pointerY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double radiusReference = math.min(size.width, size.height);
    final double scaleFactor = radiusReference * 0.18;

    const cameraDistance = 6.0;
    final camDriftX = pointerX * 0.9;
    final camDriftY = pointerY * 0.6;

    final cosSX = math.cos(sphereRotX);
    final sinSX = math.sin(sphereRotX);
    final cosSY = math.cos(sphereRotY);
    final sinSY = math.sin(sphereRotY);

    final cosPX = math.cos(partRotX);
    final sinPX = math.sin(partRotX);
    final cosPY = math.cos(partRotY);
    final sinPY = math.sin(partRotY);
    final cosPZ = math.cos(partRotZ);
    final sinPZ = math.sin(partRotZ);

    // --- Draw Cosmic Nebula dust cloud in the background ---
    final nebulaPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.2),
        radius: 0.9,
        colors: [
          const Color(0xFF2E0854).withOpacity(0.18), // Deep purple dust
          const Color(0xFF5A002C).withOpacity(0.08), // Dark magenta edges
          Colors.transparent
        ],
        stops: const [0.0, 0.6, 1.0]
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), nebulaPaint);

    // Dynamic warning alert color shift for Nebula (8.0 to 13.0s)
    if (time >= 8.0 && time < 13.0) {
      final t = (time >= 10.0) ? (13.0 - time) / 3.0 : (time - 8.0) / 2.0;
      final alarmNebula = Paint()
        ..shader = RadialGradient(
          center: Alignment.topRight,
          radius: 1.0,
          colors: [
            const Color(0xFFFF0033).withOpacity(0.12 * t.clamp(0.0, 1.0)),
            Colors.transparent
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), alarmNebula);
    }

    // --- Draw Matrix Digital Streams (All times) ---
    for (final drop in matrixDrops) {
      if (drop.x > size.width) drop.x = drop.x % size.width;
      final double alpha = drop.opacity;

      final textPainter = TextPainter(
        text: TextSpan(
          text: drop.char,
          style: TextStyle(
            color: const Color(0xFF1080E0).withOpacity(alpha * 0.40),
            fontFamily: 'monospace',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: const Color(0xFF1080E0).withOpacity(alpha * 0.8), blurRadius: 8)
            ]
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(canvas, Offset(drop.x, drop.y));
    }

    // --- Draw Background Stars with Pointer Deflection ---
    final starPaint = Paint()..style = PaintingStyle.fill;
    final mousePos = Offset((pointerX + 1) * size.width / 2, (-pointerY + 1) * size.height / 2);

    for (final p in particles) {
      final double x1 = p.x * cosPY + p.z * sinPY;
      final double z1 = -p.x * sinPY + p.z * cosPY;
      final double y2 = p.y * cosPX - z1 * sinPX;
      final double z2 = p.y * sinPX + z1 * cosPX;
      final double x3 = x1 * cosPZ - y2 * sinPZ;
      final double y3 = x1 * sinPZ + y2 * cosPZ;

      final double rx = x3 - camDriftX;
      final double ry = y3 - camDriftY;
      final double rz = z2 - cameraDistance;

      if (rz >= 0) continue;
      final scale = cameraDistance / -rz;
      double px = center.dx + rx * scaleFactor * scale;
      double py = center.dy - ry * scaleFactor * scale;

      // Pointer deflection
      final starPos = Offset(px, py);
      final distToMouse = (starPos - mousePos).distance;
      if (distToMouse < 160.0 && distToMouse > 0) {
        final pushDir = (starPos - mousePos) / distToMouse;
        final force = (160.0 - distToMouse) / 160.0;
        px += pushDir.dx * force * 35.0;
        py += pushDir.dy * force * 35.0;
      }

      if (px >= 0 && px <= size.width && py >= 0 && py <= size.height) {
        Color starColor = const Color(0xFF1080E0);
        if (time >= 8.0 && time < 10.0) {
          final t = (time - 8.0) / 2.0;
          starColor = Color.lerp(const Color(0xFF1080E0), const Color(0xFFFF5500), t)!;
        } else if (time >= 10.0 && time < 13.5) {
          starColor = const Color(0xFFFF3300);
        } else if (time >= 13.5 && time < 17.5) {
          final t = (time - 13.5) / 4.0;
          starColor = Color.lerp(const Color(0xFFFF3300), const Color(0xFF1080E0), t)!;
        }
        canvas.drawCircle(
          Offset(px, py),
          1.5 * scale,
          starPaint..color = starColor.withOpacity(0.40 * scale.clamp(0.0, 1.0)),
        );
      }
    }

    // --- Story Stage Management ---
    Offset earthCenter = center;
    double warningAlertGlow = 0.0;
    if (time >= 8.0 && time < 10.0) {
      final intensity = (time - 8.0) * 7.0;
      final angle = time * 90;
      earthCenter = Offset(center.dx + math.sin(angle) * intensity, center.dy + math.cos(angle) * intensity);
      warningAlertGlow = (time - 8.0) / 2.0;
    } else if (time >= 10.0 && time < 11.0) {
      final intensity = (11.0 - time) * 35.0;
      final angle = time * 160;
      earthCenter = Offset(center.dx + math.sin(angle) * intensity, center.dy + math.cos(angle) * intensity);
    }

    // Danger indicator screen overlay
    if (warningAlertGlow > 0) {
      final alertPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            const Color(0xFFFF0033).withOpacity(0.08 * warningAlertGlow * (0.7 + 0.3 * math.sin(time * 30))),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), alertPaint);
      
      // Scary Glitch / Warning prompt text overlay in corner
      final textPainter = TextPainter(
        text: TextSpan(
          text: tr("⚠️ تحذير: تهديد مجهول يقترب ⚠️\n[!] خطأ في سلامة النظام", "⚠️ WARNING: DETECTED UNKNOWN IMPACT ⚠️\n[!] CORE INTEGRITY FAULT"),
          style: TextStyle(
            color: const Color(0xFFFF0033).withOpacity(0.6 * warningAlertGlow * (0.8 + 0.2 * math.sin(time * 40))),
            fontFamily: 'monospace',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          )
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(size.width * 0.05, size.height * 0.85));
    }

    // Draw 2 Orbiter Moons / Planets (Spherical Configs orbiting the Earth) at all times
    final planetConfigs = [
      _PlanetOrbitConfig(orbitRadius: 280.0, sizeRadius: 0.35, speed: 0.8, color: const Color(0xFF0060B0), name: "Planet Alpha"),
      _PlanetOrbitConfig(orbitRadius: 400.0, sizeRadius: 0.25, speed: -0.5, color: const Color(0xFFFF3F80), name: "Planet Beta"),
    ];

    final double meteorProg = (time - 8.0) / 2.0;
    final double meteorX = size.width * 1.25 + (earthCenter.dx - size.width * 1.25) * (time >= 8.0 ? meteorProg : 0.0);
    final double meteorY = -size.height * 0.25 + (earthCenter.dy - (-size.height * 0.25)) * (time >= 8.0 ? meteorProg : 0.0);
    final Offset metOffset = Offset(meteorX, meteorY);

    for (final pc in planetConfigs) {
      final double currentAngle = time * pc.speed;
      // Orbit calculation
      final double px = earthCenter.dx + pc.orbitRadius * math.cos(currentAngle);
      final double py = earthCenter.dy + pc.orbitRadius * 0.45 * math.sin(currentAngle);
      final Offset planetCenter = Offset(px, py);
      final double radius = pc.sizeRadius * scaleFactor;

      // 1. Glowing atmosphere aura
      canvas.drawCircle(
        planetCenter, 
        radius * 1.3, 
        Paint()
          ..color = pc.color.withOpacity(0.12)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      );

      // 2. Main spherical body wireframe lines
      final planetPaint = Paint()
        ..color = pc.color.withOpacity(0.55)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      
      canvas.drawCircle(planetCenter, radius, planetPaint);
      
      // Draw latitude and longitude lines inside for 3D sphere illusion
      canvas.drawOval(Rect.fromCenter(center: planetCenter, width: radius * 2, height: radius * 0.5), planetPaint);
      canvas.drawOval(Rect.fromCenter(center: planetCenter, width: radius * 0.5, height: radius * 2), planetPaint);

      // 3. Tilted Saturn-like rings for Planet Alpha
      if (pc.name == "Planet Alpha") {
        final ringPaint = Paint()
          ..color = pc.color.withOpacity(0.4)
          ..strokeWidth = 1.2
          ..style = PaintingStyle.stroke;
        
        // Outer ring
        canvas.save();
        canvas.translate(px, py);
        canvas.rotate(0.35); // tilt the ring 20 degrees
        canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: radius * 3.4, height: radius * 0.7), ringPaint);
        canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: radius * 2.8, height: radius * 0.55), ringPaint..color = pc.color.withOpacity(0.2));
        canvas.restore();
      }

      // 4. Smaller orbiting satellite moon for Planet Beta
      if (pc.name == "Planet Beta") {
        final double moonAngle = time * 3.0;
        final double mx = px + radius * 1.8 * math.cos(moonAngle);
        final double my = py + radius * 0.6 * math.sin(moonAngle);
        canvas.drawCircle(
          Offset(mx, my), 
          3.0, 
          Paint()..color = const Color(0xFF00E5FF)..style = PaintingStyle.fill
        );
        // Moon trail path
        canvas.drawOval(
          Rect.fromCenter(center: planetCenter, width: radius * 3.6, height: radius * 1.2),
          Paint()..color = const Color(0xFF00E5FF).withOpacity(0.08)..style = PaintingStyle.stroke..strokeWidth = 0.5
        );
      }
    }

    // --- DRAW SCENE: 1. Main Earth / Reborn Cyber-Core ---
    if (time < 10.0) {
      // Render main Earth
      final spheres = [
        _SphereConfig(radius: 1.15, opacity: 0.12, color: const Color(0xFF00E5FF), isCore: true),
        _SphereConfig(radius: 1.55, opacity: 0.50, color: const Color(0xFF1080E0), isCore: false),
        _SphereConfig(radius: 2.25, opacity: 0.22, color: const Color(0xFF40A0FF), isCore: false),
      ];

      for (final conf in spheres) {
        final projected = <Offset>[];
        final zDepth = <double>[];
        final randomGlitch = math.Random(time.hashCode);
        final bool isGlitchFrame = time >= 8.5 && time < 10.0 && randomGlitch.nextDouble() < 0.15;

        for (final v in vertices) {
          double rxRaw = v.x * conf.radius;
          double ryRaw = v.y * conf.radius;
          double rzRaw = v.z * conf.radius;

          final double x1 = rxRaw * cosSY + rzRaw * sinSY;
          final double z1 = -rxRaw * sinSY + rzRaw * cosSY;
          final double y2 = ryRaw * cosSX - z1 * sinSX;
          final double z2 = ryRaw * sinSX + z1 * cosSX;

          final double rx = x1 - camDriftX;
          final double ry = y2 - camDriftY;
          final double rz = z2 - cameraDistance;

          final scale = cameraDistance / -rz;
          double px = earthCenter.dx + rx * scaleFactor * scale;
          double py = earthCenter.dy - ry * scaleFactor * scale;

          // Glitch displacement offset
          if (isGlitchFrame) {
            px += (randomGlitch.nextDouble() - 0.5) * 22.0;
            py += (randomGlitch.nextDouble() - 0.5) * 22.0;
          }

          projected.add(Offset(px, py));
          zDepth.add(rz);
        }

        Color earthColor = conf.color;
        if (time >= 8.0) {
          earthColor = Color.lerp(conf.color, const Color(0xFFFF3300), meteorProg)!;
        }

        final edgePaint = Paint()
          ..color = earthColor.withOpacity(conf.opacity)
          ..strokeWidth = conf.isCore ? 0.8 : 1.4
          ..style = PaintingStyle.stroke;

        for (final edge in edges) {
          final p1 = projected[edge[0]];
          final p2 = projected[edge[1]];
          final avgZ = (zDepth[edge[0]] + zDepth[edge[1]]) / 2;
          final double fade = (avgZ + (cameraDistance + conf.radius)) / (2 * conf.radius);
          final currentOpacity = conf.opacity * fade.clamp(0.2, 1.0);

          canvas.drawLine(p1, p2, edgePaint..color = earthColor.withOpacity(currentOpacity));
        }

        if (conf.isCore) {
          canvas.drawCircle(
            earthCenter,
            conf.radius * scaleFactor * 0.95,
            Paint()
              ..color = earthColor.withOpacity(0.05)
              ..style = PaintingStyle.fill
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
          );
        }
      }
    } else if (time >= 10.0 && time < 13.5) {
      // SHATTERING DEBRIS PHASE
      final double progress = time - 10.0;
      final double expansion = progress * 3.5;
      final double fade = (1.0 - progress / 3.5).clamp(0.0, 1.0);

      final projected = <Offset>[];
      final randomDebris = math.Random(19);
      for (final v in vertices) {
        final rSpeed = 1.0 + randomDebris.nextDouble() * 0.8;
        final offsetScalar = 1.0 + expansion * rSpeed;
        
        final rxRaw = v.x * 1.55 * offsetScalar;
        final ryRaw = v.y * 1.55 * offsetScalar;
        final rzRaw = v.z * 1.55 * offsetScalar;

        final double x1 = rxRaw * cosSY + rzRaw * sinSY;
        final double z1 = -rxRaw * sinSY + rzRaw * cosSY;
        final double y2 = ryRaw * cosSX - z1 * sinSX;
        final double z2 = ryRaw * sinSX + z1 * cosSX;

        final double rx = x1 - camDriftX;
        final double ry = y2 - camDriftY;
        final double rz = z2 - cameraDistance;

        final scale = cameraDistance / -rz;
        projected.add(Offset(earthCenter.dx + rx * scaleFactor * scale, earthCenter.dy - ry * scaleFactor * scale));
      }

      final fragmentPaint = Paint()
        ..color = const Color(0xFFFF3300).withOpacity(0.60 * fade)
        ..strokeWidth = 1.6
        ..style = PaintingStyle.stroke;

      for (final edge in edges) {
        canvas.drawLine(projected[edge[0]], projected[edge[1]], fragmentPaint);
      }

      // Draw exploding plasma sparks
      final sparkPaint = Paint()..style = PaintingStyle.fill;
      for (final spark in sparks) {
        if (spark.life <= 0) continue;
        final double rx = spark.x - camDriftX;
        final double ry = spark.y - camDriftY;
        final double rz = spark.z - cameraDistance;

        if (rz >= 0) continue;
        final scale = cameraDistance / -rz;
        final sx = center.dx + rx * scaleFactor * 0.06 * scale;
        final sy = center.dy - ry * scaleFactor * 0.06 * scale;

        if (sx >= 0 && sx <= size.width && sy >= 0 && sy <= size.height) {
          canvas.drawCircle(
            Offset(sx, sy),
            spark.size * scale * spark.life,
            sparkPaint..color = spark.color.withOpacity(spark.life * fade),
          );
        }
      }
    } else {
      // REBIRTH & STABLE CYBER-CORE (13.5 to 20.0s)
      final double progress = time - 13.5;
      double assemblyScale = 1.0;
      double cyberOpacity = 0.65;

      if (progress < 2.0) {
        assemblyScale = 3.0 - (progress / 2.0) * 2.0;
        cyberOpacity = (progress / 2.0) * 0.65;
      }

      final double outerRotY = -sphereRotY * 1.4;

      final spheres = [
        _SphereConfig(radius: 1.15, opacity: 0.12 * (cyberOpacity / 0.65), color: const Color(0xFF00E5FF), isCore: true),
        _SphereConfig(radius: 1.55, opacity: 0.50 * (cyberOpacity / 0.65), color: const Color(0xFF1080E0), isCore: false),
        _SphereConfig(radius: 2.25, opacity: 0.22 * (cyberOpacity / 0.65), color: const Color(0xFF40A0FF), isCore: false),
      ];

      for (final conf in spheres) {
        final projected = <Offset>[];
        final zDepth = <double>[];

        for (final v in vertices) {
          final double rxRaw = v.x * conf.radius * assemblyScale;
          final double ryRaw = v.y * conf.radius * assemblyScale;
          final double rzRaw = v.z * conf.radius * assemblyScale;

          final double x1 = rxRaw * cosSY + rzRaw * sinSY;
          final double z1 = -rxRaw * sinSY + rzRaw * cosSY;
          final double y2 = ryRaw * cosSX - z1 * sinSX;
          final double z2 = ryRaw * sinSX + z1 * cosSX;

          final double rx = x1 - camDriftX;
          final double ry = y2 - camDriftY;
          final double rz = z2 - cameraDistance;

          final scale = cameraDistance / -rz;
          projected.add(Offset(center.dx + rx * scaleFactor * scale, center.dy - ry * scaleFactor * scale));
          zDepth.add(rz);
        }

        final edgePaint = Paint()
          ..color = conf.color.withOpacity(conf.opacity)
          ..strokeWidth = conf.isCore ? 0.8 : 1.4
          ..style = PaintingStyle.stroke;

        final glowPaint = Paint()
          ..color = const Color(0xFF0060B0).withOpacity(conf.opacity * 0.45)
          ..strokeWidth = conf.isCore ? 1.6 : 3.0;

        for (final edge in edges) {
          final p1 = projected[edge[0]];
          final p2 = projected[edge[1]];
          final avgZ = (zDepth[edge[0]] + zDepth[edge[1]]) / 2;
          final double fade = (avgZ + (cameraDistance + conf.radius * assemblyScale)) / (2 * conf.radius * assemblyScale);
          final currentOpacity = conf.opacity * fade.clamp(0.2, 1.0);

          // Draw the glowing cyber background line (purple neon shadow)
          canvas.drawLine(p1, p2, glowPaint..color = const Color(0xFF0060B0).withOpacity(currentOpacity * 0.45));
          // Draw the main clean detailed wireframe line
          canvas.drawLine(p1, p2, edgePaint..color = conf.color.withOpacity(currentOpacity));
        }

        if (conf.isCore) {
          canvas.drawCircle(
            center,
            conf.radius * assemblyScale * scaleFactor * 0.95,
            Paint()
              ..color = conf.color.withOpacity(0.05 * (cyberOpacity / 0.65))
              ..style = PaintingStyle.fill
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
          );
        }
      }

      final cosOY = math.cos(outerRotY);
      final sinOY = math.sin(outerRotY);
      final ringPoints = <Offset>[];
      
      for (int i = 0; i < 24; i++) {
        final double angle = (i / 24.0) * 2 * math.pi;
        final double rxRaw = 2.0 * math.cos(angle);
        final double rzRaw = 2.0 * math.sin(angle);
        final double ryRaw = 0.2 * math.sin(angle * 3);

        final double x1 = rxRaw * cosOY + rzRaw * sinOY;
        final double z1 = -rxRaw * sinOY + rzRaw * cosOY;
        final double y2 = ryRaw * cosSX - z1 * sinSX;
        final double z2 = ryRaw * sinSX + z1 * cosSX;

        final double rx = x1 - camDriftX;
        final double ry = y2 - camDriftY;
        final double rz = z2 - cameraDistance;

        final scale = cameraDistance / -rz;
        ringPoints.add(Offset(center.dx + rx * scaleFactor * scale, center.dy - ry * scaleFactor * scale));
      }

      final ringPaint = Paint()
        ..color = const Color(0xFF0060B0).withOpacity(cyberOpacity * 0.7)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;
      
      for (int i = 0; i < ringPoints.length; i++) {
        final p1 = ringPoints[i];
        final p2 = ringPoints[(i + 1) % ringPoints.length];
        canvas.drawLine(p1, p2, ringPaint);
        if (i % 4 == 0) {
          canvas.drawCircle(p1, 4.0, Paint()..color = const Color(0xFF00E5FF)..style = PaintingStyle.fill);
        }
      }

      final double pulse = math.sin(time * 9) * 0.08 + 1.0;
      canvas.drawCircle(
        center, 
        1.1 * scaleFactor * pulse * assemblyScale, 
        Paint()
          ..color = const Color(0xFF00E5FF).withOpacity(0.08 * cyberOpacity)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18)
      );

      if (progress >= 2.0) {
        for (int i = 0; i < 6; i++) {
          final double packetProg = ((progress + i * 1.5) % 4.5) / 4.5;
          final double rad = 1.4 * scaleFactor + packetProg * 180.0;
          final double alpha = (1.0 - packetProg) * 0.35;
          canvas.drawCircle(
            center, 
            rad, 
            Paint()
              ..color = const Color(0xFF00E5FF).withOpacity(alpha)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5,
          );
        }
      }
    }

    // --- DRAW SCENE: 2. Main Fireball Meteor (Approach Stage: 8.0 to 10.0s) ---
    if (time >= 8.0 && time < 10.1) {
      final double progress = (time - 8.0) / 2.0;
      final double startX = size.width * 1.25;
      final double startY = -size.height * 0.25;
      final double endX = earthCenter.dx;
      final double endY = earthCenter.dy;

      final double mx = startX + (endX - startX) * progress;
      final double my = startY + (endY - startY) * progress;

      final tailRandom = math.Random(45);
      for (int i = 0; i < 40; i++) {
        final tFactor = i / 40.0;
        final tx = startX + (endX - startX) * (progress - tFactor * 0.14 * progress);
        final ty = startY + (endY - startY) * (progress - tFactor * 0.14 * progress);

        final double sineOffset = math.sin(time * 35 + i * 0.65) * 12.0 * tFactor;
        final spreadX = (tailRandom.nextDouble() - 0.5) * 35 * tFactor + sineOffset;
        final spreadY = (tailRandom.nextDouble() - 0.5) * 35 * tFactor - sineOffset;

        final Color tailColor = Color.lerp(const Color(0xFFFF0033), const Color(0xFFFFD700), tailRandom.nextDouble())!;
        canvas.drawCircle(
          Offset(tx + spreadX, ty + spreadY), 
          (18.0 - 14.0 * tFactor) * (0.8 + 0.4 * tailRandom.nextDouble()), 
          Paint()
            ..color = tailColor.withOpacity(0.38 * (1.0 - tFactor))
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
        );
      }

      canvas.drawCircle(Offset(mx, my), 24.0, Paint()..color = const Color(0xFFFF0033)..style = PaintingStyle.fill..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
      canvas.drawCircle(Offset(mx, my), 15.0, Paint()..color = const Color(0xFFFF8C00)..style = PaintingStyle.fill);
      canvas.drawCircle(Offset(mx, my), 8.0, Paint()..color = const Color(0xFFFFFFFF)..style = PaintingStyle.fill);
    }

    // --- DRAW SCENE: 3. Swarm of Mini Meteors (Warning Phase: 7.0 to 10.0s) ---
    if (time >= 7.0 && time < 10.0) {
      final meteorPaint = Paint()
        ..color = const Color(0xFFFF4500)
        ..style = PaintingStyle.fill;
      for (final met in miniMeteors) {
        if (met.progress <= 0.0 || met.progress > 1.0) continue;
        
        final dx = math.cos(met.angle) * met.progress * 1200;
        final dy = math.sin(met.angle) * met.progress * 800;
        final double px = met.startX + dx;
        final double py = met.startY + dy;

        // Draw tracer line for shooting stars
        canvas.drawLine(
          Offset(px - math.cos(met.angle) * 40.0, py - math.sin(met.angle) * 40.0),
          Offset(px, py),
          Paint()
            ..color = const Color(0xFFFF4500).withOpacity(0.35)
            ..strokeWidth = 2.0
        );
        canvas.drawCircle(Offset(px, py), 3.0, meteorPaint);
      }
    }

    // --- DRAW SCENE: 5. 3D Perspective Shockwave Ring (Impact: 10.0 to 12.0s) ---
    if (time >= 10.0 && time < 12.0) {
      final double progress = (time - 10.0) / 2.0;
      final double shockRadius = progress * size.width * 0.70;
      final double opacity = (1.0 - progress).clamp(0.0, 1.0);

      final shockPoints = <Offset>[];
      for (int i = 0; i < 36; i++) {
        final angle = (i / 36.0) * 2 * math.pi;
        final double rxRaw = shockRadius * math.cos(angle) / scaleFactor;
        final double rzRaw = shockRadius * math.sin(angle) / scaleFactor;
        
        final double x1 = rxRaw * cosSY + rzRaw * sinSY;
        final double z1 = -rxRaw * sinSY + rzRaw * cosSY;
        final double y2 = 0.0 * cosSX - z1 * sinSX;
        final double z2 = 0.0 * sinSX + z1 * cosSX;

        final double scale = cameraDistance / -(z2 - cameraDistance);
        shockPoints.add(Offset(earthCenter.dx + x1 * scaleFactor * scale, earthCenter.dy - y2 * scaleFactor * scale));
      }

      final wavePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0 * (1.0 - progress)
        ..color = const Color(0xFFFF5500).withOpacity(opacity * 0.7);

      for (int i = 0; i < shockPoints.length; i++) {
        canvas.drawLine(shockPoints[i], shockPoints[(i + 1) % shockPoints.length], wavePaint);
        canvas.drawLine(
          shockPoints[i], shockPoints[(i + 1) % shockPoints.length], 
          wavePaint..color = const Color(0xFFFFFF00).withOpacity(opacity * 0.45)..strokeWidth = 8.0 * (1.0 - progress)
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant StoryScenePainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.sphereRotY != sphereRotY ||
        oldDelegate.sphereRotX != sphereRotX ||
        oldDelegate.partRotY != partRotY ||
        oldDelegate.partRotX != partRotX ||
        oldDelegate.partRotZ != partRotZ ||
        oldDelegate.pointerX != pointerX ||
        oldDelegate.pointerY != pointerY;
  }
}

class _SphereConfig {
  final double radius;
  final double opacity;
  final Color color;
  final bool isCore;

  _SphereConfig({
    required this.radius,
    required this.opacity,
    required this.color,
    required this.isCore,
  });
}

class _PlanetOrbitConfig {
  final double orbitRadius;
  final double sizeRadius;
  final double speed;
  final Color color;
  final String name;

  _PlanetOrbitConfig({
    required this.orbitRadius,
    required this.sizeRadius,
    required this.speed,
    required this.color,
    required this.name,
  });
}
