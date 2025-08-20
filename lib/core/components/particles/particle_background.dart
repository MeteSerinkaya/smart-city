import 'dart:math';
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  final Color particleColor;
  final int particleCount;
  final double speed;
  final double opacity;
  
  const ParticleBackground({
    super.key,
    this.particleColor = Colors.white,
    this.particleCount = 50,
    this.speed = 0.5,
    this.opacity = 0.3,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _initializeParticles();
  }

  void _initializeParticles() {
    _particles = List.generate(widget.particleCount, (index) {
      return Particle(
        x: _random.nextDouble() * 1000,
        y: _random.nextDouble() * 1000,
        size: _random.nextDouble() * 2 + 1,
        speedX: (_random.nextDouble() - 0.5) * widget.speed,
        speedY: (_random.nextDouble() - 0.5) * widget.speed,
        opacity: _random.nextDouble() * widget.opacity + 0.1,
        rotation: _random.nextDouble() * 360,
        rotationSpeed: (_random.nextDouble() - 0.5) * 2,
        isCircle: _random.nextBool(),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        _updateParticles();
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            particleColor: widget.particleColor,
          ),
          size: Size.infinite,
          isComplex: false,
          willChange: false,
        );
      },
    );
  }

  void _updateParticles() {
    for (var particle in _particles) {
      particle.x += particle.speedX;
      particle.y += particle.speedY;

      // Wrap around screen edges
      if (particle.x < 0) particle.x = 1000;
      if (particle.x > 1000) particle.x = 0;
      if (particle.y < 0) particle.y = 1000;
      if (particle.y > 1000) particle.y = 0;
    }
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speedX;
  final double speedY;
  final double opacity;
  final double rotation;
  final double rotationSpeed;
  final bool isCircle;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
    this.isCircle = true,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color particleColor;

  ParticlePainter({
    required this.particles,
    required this.particleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = particleColor
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      paint.color = particleColor.withOpacity(particle.opacity);
      
      if (particle.isCircle) {
        canvas.drawCircle(
          Offset(particle.x, particle.y),
          particle.size,
          paint,
        );
      } else {
        // Kare parçacıklar
        final rect = Rect.fromCenter(
          center: Offset(particle.x, particle.y),
          width: particle.size * 2,
          height: particle.size * 2,
        );
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
