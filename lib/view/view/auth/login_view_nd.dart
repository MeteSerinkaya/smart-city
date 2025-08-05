import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/view/viewmodel/auth/auth_view_model.dart';
import 'package:smart_city/core/components/common/common_widgets.dart';

// --- MODERN ANIMATION WIDGETS ---
class ModernFadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Curve curve;
  final double beginOffset;

  const ModernFadeInWidget({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.beginOffset = 30.0,
  });

  @override
  State<ModernFadeInWidget> createState() => _ModernFadeInWidgetState();
}

class _ModernFadeInWidgetState extends State<ModernFadeInWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.beginOffset / 100),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
    );
  }
}

// --- MODERN HOVER WIDGET ---
class ModernHoverWidget extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;
  final Color? glowColor;

  const ModernHoverWidget({
    super.key,
    required this.child,
    this.scale = 1.05,
    this.duration = const Duration(milliseconds: 300),
    this.glowColor,
  });

  @override
  State<ModernHoverWidget> createState() => _ModernHoverWidgetState();
}

class _ModernHoverWidgetState extends State<ModernHoverWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..scale(_hovered ? widget.scale : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: _hovered && widget.glowColor != null
              ? [BoxShadow(color: widget.glowColor!.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)]
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}

// --- MODERN FLOATING CARD ---
class ModernFloatingCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double elevation;
  final EdgeInsetsGeometry? padding;

  const ModernFloatingCard({super.key, required this.child, this.backgroundColor, this.elevation = 12.0, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: elevation,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: elevation * 2,
            offset: const Offset(0, 16),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

// --- PULSING DOT WIDGET ---
class PulsingDotWidget extends StatefulWidget {
  final Color color;
  final double size;

  const PulsingDotWidget({super.key, this.color = Colors.blue, this.size = 8.0});

  @override
  State<PulsingDotWidget> createState() => _PulsingDotWidgetState();
}

class _PulsingDotWidgetState extends State<PulsingDotWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this)..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
          ),
        );
      },
    );
  }
}

class LoginViewNd extends StatefulWidget {
  const LoginViewNd({super.key});

  @override
  State<LoginViewNd> createState() => _LoginViewNdState();
}

class _LoginViewNdState extends State<LoginViewNd> with TickerProviderStateMixin {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late AnimationController _formController;
  late Animation<double> _formAnimation;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    // Form animation
    _formController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _formAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic));

    // Start form animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _formController.forward();
      }
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1E3A8A),
              const Color(0xFF3B82F6),
              const Color(0xFF60A5FA),
              const Color(0xFF93C5FD),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and title with animations
                  ModernFadeInWidget(
                    delay: const Duration(milliseconds: 200),
                    beginOffset: 50.0,
                    child: ModernHoverWidget(
                      scale: 1.05,
                      glowColor: Colors.white,
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                        ),
                        child: Stack(
                          children: [
                            const Icon(Icons.admin_panel_settings, size: 80, color: Colors.white),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: PulsingDotWidget(color: Colors.white, size: 8.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title with gradient text
                  ModernFadeInWidget(
                    delay: const Duration(milliseconds: 400),
                    beginOffset: 30.0,
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.white, Colors.white.withOpacity(0.9)],
                      ).createShader(bounds),
                      child: Text(
                        'Admin Paneli',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 36,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ModernFadeInWidget(
                    delay: const Duration(milliseconds: 600),
                    beginOffset: 20.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                      ),
                      child: Text(
                        'Yönetici hesabınıza giriş yapın',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Login Form with animations
                  FadeTransition(
                    opacity: _formAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic)),
                      child: ModernFloatingCard(
                        elevation: 20.0,
                        child: Observer(
                          builder: (_) => Column(
                            children: [
                              // Form header with gradient
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
                                ).createShader(bounds),
                                child: Text(
                                  'Yönetici Girişi',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontSize: 28,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Username Field with enhanced styling
                              ModernHoverWidget(
                                scale: 1.02,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFF1E3A8A).withOpacity(0.2),
                                      width: 2,
                                    ),
                                  ),
                                  child: CommonWidgets.textField(
                                    controller: usernameController,
                                    label: 'Kullanıcı Adı',
                                    hint: 'admin',
                                    prefixIcon: Icons.person,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Password Field with enhanced styling
                              ModernHoverWidget(
                                scale: 1.02,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFF1E3A8A).withOpacity(0.2),
                                      width: 2,
                                    ),
                                  ),
                                  child: CommonWidgets.textField(
                                    controller: passwordController,
                                    label: 'Şifre',
                                    hint: '••••••••',
                                    isPassword: true,
                                    prefixIcon: Icons.lock,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Login Button with enhanced styling
                              ModernHoverWidget(
                                scale: 1.05,
                                glowColor: const Color(0xFF1E3A8A),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF1E3A8A).withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: CommonWidgets.primaryButton(
                                    text: 'Giriş Yap',
                                    isLoading: viewModel.isLoading,
                                    onPressed: () async {
                                      print('DEBUG: Login attempt started');
                                      final success = await viewModel.login(
                                        usernameController.text,
                                        passwordController.text,
                                      );

                                      print('DEBUG: Login result: $success');
                                      print('DEBUG: Error message: ${viewModel.errorMessage}');

                                      if (success) {
                                        // ✅ Admin girişi başarılı - Admin paneline yönlendir
                                        print('DEBUG: Redirecting to /admin');
                                        if (mounted) {
                                          context.go('/admin');
                                        }
                                      } else {
                                        print('DEBUG: Login failed, showing error');
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(viewModel.errorMessage ?? 'Giriş başarısız'),
                                              backgroundColor: Colors.red,
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Back to Home Button with enhanced styling
                              ModernHoverWidget(
                                scale: 1.03,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFF1E3A8A).withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: CommonWidgets.secondaryButton(
                                    text: 'Ana Sayfaya Dön',
                                    onPressed: () {
                                      context.go('/home');
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Footer with animation
                  ModernFadeInWidget(
                    delay: const Duration(milliseconds: 1000),
                    beginOffset: 20.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                      ),
                      child: Text(
                        '© 2024 Erzurum Akıllı Şehir. Tüm hakları saklıdır.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
