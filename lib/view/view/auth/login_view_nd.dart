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

// Arkaplan resmi için önbellek yöneticisi
class BackgroundImageCache {
  static ImageProvider? _cachedBackgroundImage;
  static bool _isImageLoaded = false;
  static final Map<String, ImageProvider> _imageCache = {};
  
  static ImageProvider getBackgroundImage() {
    const imagePath = 'asset/image/arkaplan21.jpg';
    
    if (_cachedBackgroundImage == null) {
      _cachedBackgroundImage = AssetImage(imagePath);
      // Resmi önbelleğe ekle
      _imageCache[imagePath] = _cachedBackgroundImage!;
    }
    
    return _cachedBackgroundImage!;
  }
  
  static bool get isImageLoaded => _isImageLoaded;
  
  static void setImageLoaded(bool loaded) {
    _isImageLoaded = loaded;
  }
  
  // Resmi tamamen önbelleğe al
  static Future<void> preloadImage(BuildContext context) async {
    const imagePath = 'asset/image/arkaplan21.jpg';
    
    if (!_imageCache.containsKey(imagePath)) {
      final imageProvider = AssetImage(imagePath);
      _imageCache[imagePath] = imageProvider;
      
      // Resmi önceden yükle
      await precacheImage(imageProvider, context);
      _isImageLoaded = true;
    }
  }
}

extension _LoginViewNdHelpers on _LoginViewNdState {
  // Submit with validation
  Future<void> _onSubmit(AuthViewModel viewModel) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen zorunlu alanları doldurun')));
      return;
    }

    final success = await viewModel.login(usernameController.text.trim(), passwordController.text);

    if (success) {
      if (mounted) context.go('/admin');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage ?? 'Giriş başarısız'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  // Custom field builder with consistent modern styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    void Function(String)? onSubmitted,
    TextInputAction textInputAction = TextInputAction.done,
    bool isPassword = false,
    FocusNode? focusNode,
  }) {
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: const Color(0xFF1E3A8A).withOpacity(0.2), width: 2),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E3A8A).withOpacity(0.2), width: 2),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: isPassword ? _obscurePassword : false,
        autocorrect: !isPassword,
        enableSuggestions: !isPassword,
        textInputAction: textInputAction,
        onFieldSubmitted: onSubmitted,
        validator: validator,
        autofillHints: isPassword ? const [AutofillHints.password] : const [AutofillHints.username],
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: isPassword
              ? IconButton(
                  tooltip: _obscurePassword ? 'Şifreyi göster' : 'Şifreyi gizle',
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: const Color(0xFF6B7280),
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  splashRadius: 20,
                )
              : null,
          border: baseBorder,
          enabledBorder: baseBorder,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  bool _rememberMe = false;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Arkaplan resmini önceden yükle ve önbelleğe al
    _preloadBackgroundImage();
  }

  // Arkaplan resmini önceden yükleme metodu
  void _preloadBackgroundImage() {
    // Yeni cache sistemi ile resmi önceden yükle
    BackgroundImageCache.preloadImage(context).then((_) {
      if (mounted) {
        setState(() {
          // Resim yüklendi, artık kullanılabilir
        });
      }
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    _passwordFocusNode.dispose();
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: BackgroundImageCache.getBackgroundImage(),
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0F172A).withOpacity(0.8),
              const Color(0xFF1E293B).withOpacity(0.7),
              const Color(0xFF334155).withOpacity(0.6),
              const Color(0xFF475569).withOpacity(0.5),
            ],
            stops: [0.0, 0.25, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [const Color(0xFF3B82F6).withOpacity(0.1), Colors.transparent]),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -100,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [const Color(0xFF8B5CF6).withOpacity(0.08), Colors.transparent]),
                ),
              ),
            ),
            // Glass morphism overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white.withOpacity(0.02), Colors.transparent, Colors.black.withOpacity(0.05)],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 820),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo images side by side
                        ModernFadeInWidget(
                          delay: const Duration(milliseconds: 200),
                          beginOffset: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // First image
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: Image.asset(
                                  'asset/image/images.png',
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              // Second image
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: Image.asset(
                                  'asset/image/akillisehir.png',
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
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
                              'Kurumsal Giriş',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 36,
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
                            child: Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.9)],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 40,
                                    offset: const Offset(0, 20),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Observer(
                                builder: (_) => Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      // Form header with enhanced styling
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        child: Column(
                                          children: [
                                            ShaderMask(
                                              shaderCallback: (bounds) => LinearGradient(
                                                colors: [
                                                  const Color(0xFF0F172A),
                                                  const Color(0xFF1E293B),
                                                  const Color(0xFF3B82F6),
                                                ],
                                              ).createShader(bounds),
                                              child: Text(
                                                'Yönetici Girişi',
                                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                  fontSize: 32,
                                                  letterSpacing: -0.5,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 3,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                                                ),
                                                borderRadius: BorderRadius.circular(2),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 32),

                                      // Username Field with validation
                                      ModernHoverWidget(
                                        scale: 1.02,
                                        child: _buildTextField(
                                          controller: usernameController,
                                          label: 'Kullanıcı Adı',
                                          hint: 'admin',
                                          textInputAction: TextInputAction.next,
                                          validator: (v) =>
                                              (v == null || v.trim().isEmpty) ? 'Kullanıcı adı zorunlu' : null,
                                          onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      // Password Field with toggle and validation
                                      ModernHoverWidget(
                                        scale: 1.02,
                                        child: _buildTextField(
                                          controller: passwordController,
                                          label: 'Şifre',
                                          hint: '••••••••',
                                          isPassword: true,
                                          focusNode: _passwordFocusNode,
                                          textInputAction: TextInputAction.done,
                                          validator: (v) => (v == null || v.isEmpty) ? 'Şifre zorunlu' : null,
                                          onSubmitted: (_) => _onSubmit(viewModel),
                                        ),
                                      ),
                                      const SizedBox(height: 32),

                                      // Remember me + forgot password
                                      Row(
                                        children: [
                                          Transform.translate(
                                            offset: const Offset(-8, 0),
                                            child: Checkbox(
                                              value: _rememberMe,
                                              onChanged: (v) => setState(() => _rememberMe = v ?? false),
                                              activeColor: const Color(0xFF1E3A8A),
                                            ),
                                          ),
                                          const Text('Beni hatırla'),
                                          const Spacer(),
                                          TextButton(
                                            onPressed: () {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(const SnackBar(content: Text('Şifre sıfırlama yakında')));
                                            },
                                            child: const Text('Şifremi unuttum?'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

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
                                            onPressed: () => _onSubmit(viewModel),
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
                              '© 2025 Erzurum Akıllı Şehir. Tüm hakları saklıdır.',
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
          ],
        ),
      ),
    );
  }
}
