import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/view/viewmodel/announcement/announcement_view_model.dart';
import 'package:smart_city/view/viewmodel/city/city_service_view_model.dart';
import 'package:smart_city/view/viewmodel/event/event_view_model.dart';
import 'package:smart_city/view/viewmodel/news/news_view_model.dart';
import 'package:smart_city/view/viewmodel/project/project_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/core/components/app_bar/main_app_bar.dart';
import 'package:smart_city/view/view/announcement/announcement_view.dart';
import 'package:smart_city/view/view/event/event_view.dart';
import 'package:smart_city/view/view/news/news_view.dart';
import 'package:smart_city/view/view/city/city_services_view.dart';
import 'package:smart_city/view/view/project/project_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smart_city/view/viewmodel/heroimage/hero_image_view_model.dart';
import 'package:smart_city/core/components/parallax/parallax_hero.dart';
import 'package:smart_city/core/components/loading/skeleton_loading.dart';
import 'package:smart_city/core/components/animations/micro_animations.dart';
import 'package:smart_city/core/components/lazy_loading/lazy_loading_widget.dart';
import 'package:smart_city/core/components/performance/memory_manager.dart';

// --- ENHANCED ANIMATION WIDGETS ---
class EnhancedFadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Curve curve;
  final double beginOffset;

  const EnhancedFadeInWidget({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.beginOffset = 30.0,
  });

  @override
  State<EnhancedFadeInWidget> createState() => _EnhancedFadeInWidgetState();
}

class _EnhancedFadeInWidgetState extends State<EnhancedFadeInWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

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

// --- ENHANCED HOVER WIDGET ---
class EnhancedHoverWidget extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;
  final Color? glowColor;

  const EnhancedHoverWidget({
    super.key,
    required this.child,
    this.scale = 1.05,
    this.duration = const Duration(milliseconds: 300),
    this.glowColor,
  });

  @override
  State<EnhancedHoverWidget> createState() => _EnhancedHoverWidgetState();
}

class _EnhancedHoverWidgetState extends State<EnhancedHoverWidget> {
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
          borderRadius: BorderRadius.circular(24),
          boxShadow: _hovered && widget.glowColor != null
              ? [BoxShadow(color: widget.glowColor!.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)]
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}

// --- GRADIENT BACKGROUND WIDGET ---
class GradientBackgroundWidget extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientBackgroundWidget({
    super.key,
    required this.child,
    this.colors = const [Color(0xFF667eea), Color(0xFF764ba2)],
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: begin, end: end),
      ),
      child: child,
    );
  }
}

// --- FLOATING ACTION CARD ---
class FloatingActionCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double elevation;
  final EdgeInsetsGeometry? padding;

  const FloatingActionCard({super.key, required this.child, this.backgroundColor, this.elevation = 8.0, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: elevation,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: elevation * 2,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

// --- ANIMATED COUNTER WIDGET ---
class AnimatedCounterWidget extends StatefulWidget {
  final int endValue;
  final String suffix;
  final TextStyle? style;
  final Duration duration;

  const AnimatedCounterWidget({
    super.key,
    required this.endValue,
    this.suffix = '',
    this.style,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<AnimatedCounterWidget> createState() => _AnimatedCounterWidgetState();
}

class _AnimatedCounterWidgetState extends State<AnimatedCounterWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = IntTween(begin: 0, end: widget.endValue).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text('${_animation.value}${widget.suffix}', style: widget.style);
      },
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

// --- FADE IN WIDGET ---
class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const FadeInWidget({super.key, required this.child, this.delay = Duration.zero});

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

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
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}

// --- HOVER SCALE WIDGET ---
class HoverScaleWidget extends StatefulWidget {
  final Widget child;

  const HoverScaleWidget({super.key, required this.child});

  @override
  State<HoverScaleWidget> createState() => _HoverScaleWidgetState();
}

class _HoverScaleWidgetState extends State<HoverScaleWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: widget.child,
      ),
    );
  }
}

// --- BUTTON HOVER EFFECT ---
class HoverScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final OutlinedBorder? shape;
  final bool outlined;
  final Color? borderColor;
  final double? elevation;
  const HoverScaleButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.padding,
    this.color,
    this.shape,
    this.outlined = false,
    this.borderColor,
    this.elevation,
  });
  @override
  State<HoverScaleButton> createState() => _HoverScaleButtonState();
}

class _HoverScaleButtonState extends State<HoverScaleButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: widget.outlined
            ? OutlinedButton(
                onPressed: widget.onPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: widget.color,
                  side: BorderSide(color: widget.borderColor ?? widget.color ?? Colors.blue, width: 1.5),
                  padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: widget.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: widget.child,
              )
            : ElevatedButton(
                onPressed: widget.onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  elevation: _hovered ? (widget.elevation ?? 6) : (widget.elevation ?? 2),
                  padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: widget.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: widget.child,
              ),
      ),
    );
  }
}

// --- CARD HOVER EFFECT ---
class HoverCard extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final double elevation;
  final double hoverElevation;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  const HoverCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.elevation = 2,
    this.hoverElevation = 12,
    this.color,
    this.padding,
  });
  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedPhysicalModel(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        elevation: _hovered ? widget.hoverElevation : widget.elevation,
        color: widget.color ?? Colors.white,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        shape: BoxShape.rectangle,
        child: Padding(padding: widget.padding ?? EdgeInsets.zero, child: widget.child),
      ),
    );
  }
}

// --- DRAWER MENU TOGGLE ---
// Drawer için bir GlobalKey ve fonksiyon ekle
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
void openDrawer() {
  _scaffoldKey.currentState?.openEndDrawer();
}

// --- SMOOTH SCROLL ---
void smoothScrollToSection(GlobalKey key) {
  final context = key.currentContext;
  if (context != null) {
    Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 700), curve: Curves.easeInOutQuart);
  }
}

// Global color constants for all widgets
class AppColors {
  static const Color primaryColor = Color(0xFF0A4A9D);
  static const Color secondaryColor = Color(0xFF00A8E8);
  static const Color surfaceColor = Color(0xFFFAFBFC);
  static const Color onSurfaceColor = Color(0xFF1F2937);
  static const Color cardColor = Colors.white;
  static const Color shadowColor = Color(0xFFE5E7EB);
}

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _announcementKey = GlobalKey();
  final GlobalKey _eventKey = GlobalKey();
  final GlobalKey _newsKey = GlobalKey();
  final GlobalKey _cityServiceKey = GlobalKey();
  final GlobalKey _projectKey = GlobalKey();

  // Scroll progress tracking
  double _scrollProgress = 0.0;
  bool _showFixedAppBar = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheImages();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      // Calculate progress based on total scrollable content
      // This makes the progress more sensitive and shows progress even on hero section
      final totalHeight = _scrollController.position.viewportDimension + maxScroll;
      final progress = totalHeight > 0 ? currentScroll / totalHeight : 0.0;

      // Show fixed AppBar when user scrolls past hero section (600px height)
      // Changed to show immediately when scrolling starts
      final showFixedAppBar = currentScroll > 0;

      setState(() {
        _scrollProgress = progress.clamp(0.0, 1.0);
        _showFixedAppBar = showFixedAppBar;
      });
    }
  }

  void _precacheImages() {
    precacheImage(
      const NetworkImage(
        'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1920&q=80',
      ),
      context,
    );

    // Load data for all sections
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final announcementViewModel = Provider.of<AnnouncementViewModel>(context, listen: false);
      final eventViewModel = Provider.of<EventViewModel>(context, listen: false);
      final newsViewModel = Provider.of<NewsViewModel>(context, listen: false);
      final cityServiceViewModel = Provider.of<CityServiceViewModel>(context, listen: false);
      final projectViewModel = Provider.of<ProjectViewModel>(context, listen: false);

      announcementViewModel.fetchAnnouncement();
      eventViewModel.fetchEvents();
      newsViewModel.fetchNews();
      cityServiceViewModel.fetchCityService();
      projectViewModel.fetchProjects();
    });
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 700), curve: Curves.easeInOutQuart);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PerformanceMonitor(
      child: Scaffold(
        backgroundColor: AppColors.surfaceColor,
        body: ScrollPerformanceOptimizer(
          scrollController: _scrollController,
          child: Stack(
            children: [
              ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(physics: const BouncingScrollPhysics()),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      _HeroSectionWithAppBarWidget(
                        onNavTap: (label) {
                          if (label == 'Ana Sayfa') {
                            // Ana sayfa için en başa dön
                            _scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeInOutQuart,
                            );
                          } else if (label == 'Duyurular') {
                            _scrollToSection(_announcementKey);
                          } else if (label == 'Etkinlikler') {
                            _scrollToSection(_eventKey);
                          } else if (label == 'Haberler') {
                            _scrollToSection(_newsKey);
                          } else if (label == 'Şehir Hizmetleri') {
                            _scrollToSection(_cityServiceKey);
                          } else if (label == 'Projeler') {
                            _scrollToSection(_projectKey);
                          }
                        },
                        scrollProgress: _scrollProgress,
                        scrollController: _scrollController,
                      ),
                      LazyLoadingWidget(
                        delay: const Duration(milliseconds: 200),
                        child: const _StatisticsSectionWidget(),
                      ),
                      LazyLoadingWidget(
                        delay: const Duration(milliseconds: 400),
                        child: const _PartnersSectionWidget(),
                      ),
                      LazyLoadingWidget(
                        delay: const Duration(milliseconds: 600),
                        child: _NavigationSectionWidget(
                          announcementKey: _announcementKey,
                          eventKey: _eventKey,
                          newsKey: _newsKey,
                          cityServiceKey: _cityServiceKey,
                          projectKey: _projectKey,
                          scrollToSection: _scrollToSection,
                        ),
                      ),
                      LazyLoadingWidget(
                        delay: const Duration(milliseconds: 800),
                        child: _ContentSectionsWidget(
                          announcementKey: _announcementKey,
                          eventKey: _eventKey,
                          newsKey: _newsKey,
                          cityServiceKey: _cityServiceKey,
                          projectKey: _projectKey,
                        ),
                      ),
                      LazyLoadingWidget(delay: const Duration(milliseconds: 1000), child: const _FooterWidget()),
                    ],
                  ),
                ),
              ),
              // Animated AppBar that responds to scroll
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: MainAppBar(
                  scrollController: _scrollController,
                  scrollProgress: _scrollProgress,
                  onNavTap: (label) {
                    if (label == 'Ana Sayfa') {
                      // Ana sayfa için en başa dön
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOutQuart,
                      );
                    } else if (label == 'Duyurular') {
                      _scrollToSection(_announcementKey);
                    } else if (label == 'Etkinlikler') {
                      _scrollToSection(_eventKey);
                    } else if (label == 'Haberler') {
                      _scrollToSection(_newsKey);
                    } else if (label == 'Şehir Hizmetleri') {
                      _scrollToSection(_cityServiceKey);
                    } else if (label == 'Projeler') {
                      _scrollToSection(_projectKey);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. Convert helper methods to StatelessWidget classes
class _ScrollProgressIndicator extends StatelessWidget {
  final double progress;

  const _ScrollProgressIndicator({required this.progress});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.secondaryColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.secondaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSectionWidget extends StatefulWidget {
  final ScrollController? scrollController;

  const _HeroSectionWidget({this.scrollController});

  @override
  State<_HeroSectionWidget> createState() => _HeroSectionWidgetState();
}

class _HeroSectionWidgetState extends State<_HeroSectionWidget> {
  @override
  void initState() {
    super.initState();
    // HeroImage'leri yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final heroImageViewModel = context.read<HeroImageViewModel>();
      heroImageViewModel.fetchHeroImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final heroImageViewModel = context.read<HeroImageViewModel>();

        if (heroImageViewModel.isLoading) {
          return const HeroSkeletonLoading();
        }

        if (!heroImageViewModel.hasImages) {
          // Fallback image when no hero images
          return Container(
            width: double.infinity,
            height: 600,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1920&q=80',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(102, 30, 64, 175), // Palandöken mavi tonu (0.4 opacity)
                    Color.fromARGB(179, 7, 7, 7), // Koyu gradient alt kısımda
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
              child: _buildHeroContent(0),
            ),
          );
        }

        // Carousel Slider with Parallax Hero Images
        final images = heroImageViewModel.heroImageList;
        if (images == null || images.isEmpty) {
          // Fallback when no images are available
          return Container(
            height: 600,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(102, 30, 64, 175), Color.fromARGB(179, 7, 7, 7)],
              ),
            ),
            child: _buildHeroContent(0),
          );
        }

        return CarouselSlider.builder(
          itemCount: images.length,
          itemBuilder: (context, index, realIndex) {
            final image = images[index];
            return ParallaxHero(
              imageUrl: 'https://localhost:7276${image.imageUrl}',
              height: 600,
              scrollController: widget.scrollController,
              child: _buildHeroContent(index),
            );
          },
          options: CarouselOptions(
            height: 600,
            viewportFraction: 1.0,
            autoPlay: images.length > 1,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              if (reason == CarouselPageChangedReason.manual) {
                heroImageViewModel.goToImage(index);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildHeroContent(int currentIndex) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // Slide Indicator
              Positioned(
                bottom: 30,
                right: 30,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Observer(
                    builder: (context) {
                      final heroImageViewModel = context.read<HeroImageViewModel>();
                      final totalImages = heroImageViewModel.heroImageList?.length ?? 1;
                      return Text(
                        '${currentIndex + 1}/$totalImages',
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      );
                    },
                  ),
                ),
              ),

              // Left-aligned Content
              Positioned(
                left: 48,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Observer(
                      builder: (context) {
                        final heroImageViewModel = context.read<HeroImageViewModel>();
                        final images = heroImageViewModel.heroImageList;

                        if (images != null && images.isNotEmpty && currentIndex < images.length) {
                          final currentImage = images[currentIndex];

                          // Get title and description from current image
                          final title = currentImage.title?.isNotEmpty == true ? currentImage.title! : 'ARAÇ FİLOSU';
                          final description = currentImage.description?.isNotEmpty == true
                              ? currentImage.description!
                              : 'Ulaşım ve diğer hizmetlerimizde kullanılmak üzere filomuzu 1200 araç ve iş makineleriyle güçlendirdik.';

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Enhanced Animated Title with Gradient
                              EnhancedFadeInWidget(
                                delay: const Duration(milliseconds: 200),
                                beginOffset: 50.0,
                                child: SelectionArea(
                                  child: ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white.withOpacity(0.9),
                                        Colors.white.withOpacity(0.7),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds),
                                    child: AnimatedText(
                                      text: title,
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 56,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        height: 1.2,
                                        letterSpacing: -0.5,
                                        shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4)],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Enhanced Animated Description
                              EnhancedFadeInWidget(
                                delay: const Duration(milliseconds: 400),
                                beginOffset: 30.0,
                                child: SelectionArea(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                                    ),
                                    child: AnimatedText(
                                      text: description,
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        height: 1.4,
                                        shadows: [Shadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 2)],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Fallback content with animations
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FadeInWidget(
                                delay: const Duration(milliseconds: 200),
                                child: SelectionArea(
                                  child: const AnimatedText(
                                    text: 'ARAÇ FİLOSU',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 56,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      height: 1.2,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              FadeInWidget(
                                delay: const Duration(milliseconds: 400),
                                child: SelectionArea(
                                  child: const AnimatedText(
                                    text:
                                        'Ulaşım ve diğer hizmetlerimizde kullanılmak üzere filomuzu 1200 araç ve iş makineleriyle güçlendirdik.',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xE6FFFFFF),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Bottom-left Button with Animation
        Padding(
          padding: const EdgeInsets.only(bottom: 48, left: 48),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FadeInWidget(
              delay: const Duration(milliseconds: 600),
              child: HoverScaleWidget(child: _HeroButtonWidget()),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroButtonWidget extends StatelessWidget {
  const _HeroButtonWidget();

  @override
  Widget build(BuildContext context) {
    return EnhancedHoverWidget(
      scale: 1.08,
      glowColor: const Color(0xFF0A4A9D),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0A4A9D).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement hero button action
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Araç filosu detayları yakında eklenecek'),
                backgroundColor: Color(0xFF0A4A9D),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A4A9D),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'DEVAMI',
                style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 0.5),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatisticsSectionWidget extends StatelessWidget {
  const _StatisticsSectionWidget();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 64, vertical: isMobile ? 32 : 80),
          child: Column(
            children: [
              const Text(
                'Şehir İstatistikleri',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Erzurum\'un dijital dönüşümünü rakamlarla takip edin',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xB31F2937),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: const [
                  _StatCardWidget(
                    icon: 'asset/icons/megaphone.png',
                    title: 'Aktif Duyuru',
                    value: '12',
                    subtitle: 'Güncel',
                    color: Color(0xFF0A4A9D),
                  ),
                  _StatCardWidget(
                    icon: 'asset/icons/calendar.png',
                    title: 'Yaklaşan Etkinlik',
                    value: '8',
                    subtitle: 'Bu ay',
                    color: Color(0xFF00A8E8),
                  ),
                  _StatCardWidget(
                    icon: 'asset/icons/newspaper-folded.png',
                    title: 'Güncel Haber',
                    value: '15',
                    subtitle: 'Bu hafta',
                    color: Color(0xFF10B981),
                  ),
                  _StatCardWidget(
                    icon: 'asset/icons/group.png',
                    title: 'Aktif Kullanıcı',
                    value: '2.5K',
                    subtitle: 'Günlük',
                    color: Color(0xFF8B5CF6),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCardWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _StatCardWidget({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        return EnhancedHoverWidget(
          scale: 1.03,
          glowColor: color,
          child: FloatingActionCard(
            elevation: 12.0,
            child: SizedBox(
              width: isMobile ? double.infinity : 280,
              child: Column(
                children: [
                  // Enhanced Icon Container with Gradient
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: color.withOpacity(0.2), width: 1),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(icon, width: 36, height: 36, color: color),
                        // Pulsing dot indicator
                        Positioned(top: 0, right: 0, child: PulsingDotWidget(color: color, size: 6.0)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Animated Counter for Value
                  AnimatedCounterWidget(
                    endValue: int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
                    suffix: value.replaceAll(RegExp(r'[0-9]'), ''),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: color,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Enhanced Title with Gradient Text
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        LinearGradient(colors: [color, color.withOpacity(0.8)]).createShader(bounds),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle with enhanced styling
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: color.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ApplicationsSectionWidget extends StatelessWidget {
  const _ApplicationsSectionWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer<CityServiceViewModel>(
      builder: (context, cityServiceViewModel, child) {
        return Observer(
          builder: (_) {
            final cityServices = cityServiceViewModel.cityServiceList ?? [];

            return LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                int crossAxisCount;
                if (screenWidth < 768) {
                  crossAxisCount = 1;
                } else if (screenWidth < 1024) {
                  crossAxisCount = 2;
                } else {
                  crossAxisCount = 4;
                }

                return Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth < 600 ? 12 : 64,
                    vertical: screenWidth < 600 ? 32 : 80,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Şehir Hizmetleri',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Şehir hayatını kolaylaştıran akıllı hizmetler',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Color(0x991F2937),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 64),
                      if (cityServiceViewModel.isLoading) const Center(child: CircularProgressIndicator()),
                      if (!cityServiceViewModel.isLoading && cityServices.isEmpty)
                        const Center(
                          child: Text(
                            'Henüz hizmet eklenmemiş.',
                            style: TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
                          ),
                        ),
                      if (!cityServiceViewModel.isLoading && cityServices.isNotEmpty)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 30,
                            mainAxisSpacing: 30,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: cityServices.length,
                          itemBuilder: (context, index) {
                            final service = cityServices[index];
                            return RepaintBoundary(child: CityServiceCardWidget(service: service));
                          },
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _PartnersSectionWidget extends StatelessWidget {
  const _PartnersSectionWidget();

  @override
  Widget build(BuildContext context) {
    final List<PartnerItem> partners = [
      PartnerItem(
        name: 'Erzurum Büyükşehir Belediyesi',
        logoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfPqrKpWhKvdu6YlI1lT55kl-lKrm7OEoWAA&s',
      ),
      PartnerItem(name: 'Erzurum Teknoloji Vakfı', logoUrl: 'asset/paydas/ttv.png'),
      PartnerItem(name: 'Erzurum Ticaret ve Sanayi Odası', logoUrl: 'asset/paydas/ticaret.jpeg'),
      PartnerItem(name: 'Atatürk Üniversitesi', logoUrl: 'asset/paydas/Ataturkuni_logo.png'),
      PartnerItem(name: 'Erzurum Teknik Üniversitesi', logoUrl: 'asset/paydas/etu.png'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double viewportFraction = 0.33;
        if (constraints.maxWidth < 600) {
          viewportFraction = 1.0;
        } else if (constraints.maxWidth < 900) {
          viewportFraction = 0.5;
        }
        return Container(
          color: const Color(0xFF2C2C2C), // Changed to #2c2c2c
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth < 600 ? 12 : 64,
            vertical: constraints.maxWidth < 600 ? 32 : 80,
          ),
          child: Column(
            children: [
              Text(
                'Paydaşlar',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: constraints.maxWidth < 600 ? 22 : 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.white, // Changed to white for better contrast
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Akıllı şehir projemizin değerli iş ortakları',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: constraints.maxWidth < 600 ? 14 : 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.7), // Changed for better contrast
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              LayoutBuilder(
                builder: (context, constraints) {
                  return CarouselSlider(
                    options: CarouselOptions(
                      height: 160,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 2),
                      viewportFraction: viewportFraction,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: partners.map((partner) {
                      return Center(child: _buildPartnerLogoCard(partner));
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPartnerLogoCard(PartnerItem partner) {
    return Container(
      width: 240,
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: partner.logoUrl.startsWith('asset/')
            ? Image.asset(
                partner.logoUrl,
                width: 240,
                height: 140,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 240,
                    height: 140,
                    decoration: const BoxDecoration(
                      color: Color(0x33CCCCCC),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.business, size: 32, color: AppColors.primaryColor),
                          const SizedBox(height: 8),
                          Text(
                            partner.name,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Image.network(
                partner.logoUrl,
                width: 240,
                height: 140,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 240,
                    height: 140,
                    decoration: const BoxDecoration(
                      color: Color(0x33CCCCCC),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 240,
                    height: 140,
                    decoration: const BoxDecoration(
                      color: Color(0x33CCCCCC),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.business, size: 32, color: AppColors.primaryColor),
                          const SizedBox(height: 8),
                          Text(
                            partner.name,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _NavigationSectionWidget extends StatelessWidget {
  final GlobalKey announcementKey;
  final GlobalKey eventKey;
  final GlobalKey newsKey;
  final GlobalKey cityServiceKey;
  final GlobalKey projectKey;
  final void Function(GlobalKey) scrollToSection;

  const _NavigationSectionWidget({
    required this.announcementKey,
    required this.eventKey,
    required this.newsKey,
    required this.cityServiceKey,
    required this.projectKey,
    required this.scrollToSection,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth < 600 ? 12 : 64,
            vertical: constraints.maxWidth < 600 ? 32 : 80,
          ),
          child: Column(
            children: [
              Text(
                'Hızlı Erişim',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: constraints.maxWidth < 600 ? 22 : 36,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'İhtiyacınız olan bilgilere kolayca ulaşın',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: constraints.maxWidth < 600 ? 14 : 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurfaceColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: [
                      EnhancedFadeInWidget(
                        delay: const Duration(milliseconds: 100),
                        beginOffset: 40.0,
                        child: _buildNavigationCard(
                          icon: 'asset/icons/megaphone.png',
                          title: 'Duyurular',
                          subtitle: 'Önemli duyuruları ve güncellemeleri takip edin',
                          color: AppColors.primaryColor,
                          onTap: () => _openDetailPage(context, '/announcements-detail'),
                          isMobile: isMobile,
                        ),
                      ),
                      EnhancedFadeInWidget(
                        delay: const Duration(milliseconds: 200),
                        beginOffset: 40.0,
                        child: _buildNavigationCard(
                          icon: 'asset/icons/calendar.png',
                          title: 'Etkinlikler',
                          subtitle: 'Şehir etkinliklerini ve organizasyonları keşfedin',
                          color: AppColors.secondaryColor,
                          onTap: () => _openDetailPage(context, '/events-detail'),
                          isMobile: isMobile,
                        ),
                      ),
                      EnhancedFadeInWidget(
                        delay: const Duration(milliseconds: 300),
                        beginOffset: 40.0,
                        child: _buildNavigationCard(
                          icon: 'asset/icons/newspaper-folded.png',
                          title: 'Haberler',
                          subtitle: 'Güncel haberleri ve gelişmeleri okuyun',
                          color: const Color(0xFF10B981),
                          onTap: () => _openDetailPage(context, '/news-detail'),
                          isMobile: isMobile,
                        ),
                      ),
                      EnhancedFadeInWidget(
                        delay: const Duration(milliseconds: 400),
                        beginOffset: 40.0,
                        child: _buildNavigationCard(
                          icon: 'asset/icons/company.png',
                          title: 'Şehir Hizmetleri',
                          subtitle: 'Şehir hayatını kolaylaştıran akıllı hizmetler',
                          color: const Color(0xFF8B5CF6),
                          onTap: () => _openDetailPage(context, '/city-services-detail'),
                          isMobile: isMobile,
                        ),
                      ),
                      EnhancedFadeInWidget(
                        delay: const Duration(milliseconds: 500),
                        beginOffset: 40.0,
                        child: _buildNavigationCard(
                          icon: 'asset/icons/project-management.png',
                          title: 'Projeler',
                          subtitle: 'Şehrimizin gelişim projeleri',
                          color: const Color(0xFFF59E0B),
                          onTap: () => _openDetailPage(context, '/projects-detail'),
                          isMobile: isMobile,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openDetailPage(BuildContext context, String route) {
    // Route üzerinden git, yeni sekme açma
    context.go(route);
  }

  Widget _buildNavigationCard({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required bool isMobile,
  }) {
    return EnhancedHoverWidget(
      scale: 1.05,
      glowColor: color,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: FloatingActionCard(
            elevation: 15.0,
            child: SizedBox(
              width: isMobile ? double.infinity : 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced Icon Container with Animated Background
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withOpacity(0.15), color.withOpacity(0.05), color.withOpacity(0.1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: color.withOpacity(0.3), width: 1.5),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(icon, width: 32, height: 32, color: color),
                        // Animated border effect
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: color.withOpacity(0.1), width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Enhanced Title with Gradient
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        LinearGradient(colors: [color, color.withOpacity(0.8)]).createShader(bounds),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Enhanced Subtitle
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceColor.withOpacity(0.8),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Enhanced Action Button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Görüntüle',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white),
                      ],
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

class _ContentSectionsWidget extends StatefulWidget {
  final GlobalKey announcementKey;
  final GlobalKey eventKey;
  final GlobalKey newsKey;
  final GlobalKey cityServiceKey;
  final GlobalKey projectKey;

  const _ContentSectionsWidget({
    required this.announcementKey,
    required this.eventKey,
    required this.newsKey,
    required this.cityServiceKey,
    required this.projectKey,
  });

  @override
  State<_ContentSectionsWidget> createState() => _ContentSectionsWidgetState();
}

class _ContentSectionsWidgetState extends State<_ContentSectionsWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth < 600 ? 12 : 64,
            vertical: constraints.maxWidth < 600 ? 32 : 80,
          ),
          child: Column(
            children: [
              _buildContentSection(
                key: widget.announcementKey,
                icon: 'asset/icons/megaphone.png',
                title: 'Duyurular',
                color: AppColors.onSurfaceColor,
                child: AnnouncementView(),
              ),
              const SizedBox(height: 80),
              _buildContentSection(
                key: widget.eventKey,
                icon: 'asset/icons/calendar.png',
                title: 'Etkinlikler',
                color: AppColors.secondaryColor,
                child: EventView(),
              ),
              const SizedBox(height: 80),
              _buildDarkContentSection(
                key: widget.newsKey,
                icon: 'asset/icons/newspaper-folded.png',
                title: 'Haberler',
                color: const Color(0xFF10B981),
                child: NewsView(),
              ),
              const SizedBox(height: 80),
              _buildContentSection(
                key: widget.cityServiceKey,
                icon: 'asset/icons/company.png',
                title: 'Şehir Hizmetleri',
                color: const Color(0xFF8B5CF6),
                child: const CityServicesView(),
              ),
              const SizedBox(height: 80),
              _buildDarkContentSection(
                key: widget.projectKey,
                icon: 'asset/icons/project-management.png',
                title: 'Projeler',
                color: const Color(0xFFF59E0B),
                child: const ProjectView(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentSection({
    required GlobalKey key,
    required String icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Header with Gradient Background
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.05), color.withOpacity(0.02)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.1), width: 1),
            ),
            child: Row(
              children: [
                // Enhanced Icon Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [color.withOpacity(0.2), color.withOpacity(0.1)]),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withOpacity(0.3), width: 1.5),
                    boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: Stack(
                    children: [
                      Image.asset(icon, width: 28, height: 28, color: color),
                      // Pulsing indicator
                      Positioned(top: 0, right: 0, child: PulsingDotWidget(color: color, size: 6.0)),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Enhanced Title with Gradient
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        LinearGradient(colors: [color, color.withOpacity(0.8)]).createShader(bounds),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                // Enhanced Action Button
                EnhancedHoverWidget(
                  scale: 1.05,
                  glowColor: color,
                  child: ElevatedButton.icon(
                    onPressed: () => _openDetailPage(context, _getDetailRoute(title)),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('Detayları Gör'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      shadowColor: color.withOpacity(0.3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Enhanced Content Container
          FloatingActionCard(
            elevation: 12.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.1), width: 1),
              ),
              child: Padding(padding: const EdgeInsets.all(24), child: child),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkContentSection({
    required GlobalKey key,
    required String icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      key: key,
      color: const Color(0xFF2C2C2C), // Full width dark background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Header with Dark Background
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: Row(
              children: [
                // Enhanced Icon Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [color.withOpacity(0.2), color.withOpacity(0.1)]),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withOpacity(0.3), width: 1.5),
                    boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: Stack(
                    children: [
                      Image.asset(icon, width: 28, height: 28, color: color),
                      // Pulsing indicator
                      Positioned(top: 0, right: 0, child: PulsingDotWidget(color: color, size: 6.0)),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Enhanced Title with White Color
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
                // Enhanced Action Button
                EnhancedHoverWidget(
                  scale: 1.05,
                  glowColor: color,
                  child: ElevatedButton.icon(
                    onPressed: () => _openDetailPage(context, _getDetailRoute(title)),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('Detayları Gör'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      shadowColor: color.withOpacity(0.3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Content Container with Dark Background
          Container(
            color: const Color(0xFF2C2C2C),
            child: Padding(padding: const EdgeInsets.all(24), child: child),
          ),
        ],
      ),
    );
  }

  String _getDetailRoute(String title) {
    switch (title) {
      case 'Duyurular':
        return '/announcements-detail';
      case 'Etkinlikler':
        return '/events-detail';
      case 'Haberler':
        return '/news-detail';
      case 'Şehir Hizmetleri':
        return '/city-services-detail';
      case 'Projeler':
        return '/projects-detail';
      default:
        return '/home';
    }
  }

  void _openDetailPage(BuildContext context, String route) {
    // Route üzerinden git, yeni sekme açma
    context.go(route);
  }
}

class _FooterWidget extends StatelessWidget {
  const _FooterWidget();

  @override
  Widget build(BuildContext context) {
    final links = ['Hakkımızda', 'İletişim', 'SSS'];
    final legal = ['Gizlilik Politikası', 'Çerez Politikası', 'Kullanım Şartları'];
    final contact = ['erzurumbuyuksehirbelediyesi@hs01.kep.tr', 'Tel: 0(442) 344 10 00', 'Erzurum, Türkiye'];
    final socialIcons = [
      {'icon': FontAwesomeIcons.facebookF, 'url': 'https://facebook.com'},
      {'icon': FontAwesomeIcons.twitter, 'url': 'https://twitter.com'},
      {'icon': FontAwesomeIcons.instagram, 'url': 'https://instagram.com'},
      {'icon': FontAwesomeIcons.linkedinIn, 'url': 'https://linkedin.com'},
      {'icon': FontAwesomeIcons.youtube, 'url': 'https://youtube.com'},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;
        final padding = EdgeInsets.symmetric(
          horizontal: constraints.maxWidth < 600 ? 12 : 64,
          vertical: constraints.maxWidth < 600 ? 32 : 80,
        );
        final titleFont = constraints.maxWidth < 600 ? 16.0 : 18.0;
        final itemFont = constraints.maxWidth < 600 ? 13.0 : 15.0;
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xFF0A4A9D)),
          child: Stack(
            children: [
              // Background Image with Drawing Effect
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('asset/image/News_12032025073722.png'),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      opacity: 1.0, // Tam görünür çizim efekti
                    ),
                  ),
                ),
              ),
              // Gradient overlay for better text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF0A4A9D).withOpacity(0.2),
                        const Color(0xFF0A4A9D).withOpacity(0.3),
                        const Color(0xFF0A4A9D).withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFooterColumn('Bağlantılar', links, titleFont, itemFont),
                              const SizedBox(height: 32),
                              _buildFooterColumn('Yasal', legal, titleFont, itemFont),
                              const SizedBox(height: 32),
                              _buildFooterColumn('İletişim', contact, titleFont, itemFont, isContact: true),
                              const SizedBox(height: 32),
                              _buildFooterSocial(socialIcons),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildFooterColumn('Bağlantılar', links, titleFont, itemFont)),
                              Expanded(child: _buildFooterColumn('Yasal', legal, titleFont, itemFont)),
                              Expanded(
                                child: _buildFooterColumn('İletişim', contact, titleFont, itemFont, isContact: true),
                              ),
                              Expanded(child: _buildFooterSocial(socialIcons)),
                            ],
                          ),
                    const SizedBox(height: 40),
                    Divider(color: Colors.white.withOpacity(0.2), thickness: 1),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        '© 2024 Erzurum Akıllı Şehir. Tüm hakları saklıdır.',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: itemFont,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
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

  Widget _buildFooterColumn(
    String title,
    List<String> items,
    double titleFont,
    double itemFont, {
    bool isContact = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontFamily: 'Roboto', fontSize: titleFont, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 20),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: isContact
                ? Row(
                    children: [
                      Icon(
                        item.contains('@')
                            ? Icons.email
                            : item.contains('Tel')
                            ? Icons.phone
                            : Icons.location_on,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          item,
                          style: TextStyle(fontFamily: 'Roboto', fontSize: itemFont, color: Colors.white70),
                        ),
                      ),
                    ],
                  )
                : InkWell(
                    onTap: () {},
                    child: Text(
                      item,
                      style: TextStyle(fontFamily: 'Roboto', fontSize: itemFont, color: Colors.white70),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSocial(List<Map<String, dynamic>> icons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sosyal Medya',
          style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Row(
          children: icons.map((iconData) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: InkWell(
                onTap: () {
                  // TODO: Sosyal medya linkine yönlendirme
                },
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), shape: BoxShape.circle),
                  child: Icon(iconData['icon'], color: Colors.white, size: 22),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class PartnerItem {
  final String name;
  final String logoUrl;

  const PartnerItem({required this.name, required this.logoUrl});
}

class _HeroSectionWithAppBarWidget extends StatelessWidget {
  final void Function(String label)? onNavTap;
  final double scrollProgress;
  final ScrollController? scrollController;

  const _HeroSectionWithAppBarWidget({required this.onNavTap, required this.scrollProgress, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hero Section Background
        _HeroSectionWidget(scrollController: scrollController),
      ],
    );
  }
}

class _FixedAppBarWidget extends StatelessWidget {
  final void Function(String label)? onNavTap;
  final double scrollProgress;

  const _FixedAppBarWidget({required this.onNavTap, required this.scrollProgress});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: SafeArea(
        child: SizedBox(
          height: kToolbarHeight + 4,
          child: Stack(
            children: [
              // Modern AppBar without logo and title
              Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    height: kToolbarHeight,
                    child: Row(
                      children: [
                        // Navigation buttons on the left
                        Expanded(
                          child: ResponsiveNavigationWidget(
                            location: GoRouterState.of(context).uri.toString(),
                            isTablet: MediaQuery.of(context).size.width < 1024,
                            onNavTap: onNavTap,
                            isTransparent: false,
                          ),
                        ),

                        // Right side buttons
                        const SizedBox(width: 24),
                        const SearchButton(isTransparent: false),
                        const SizedBox(width: 16),
                        const LoginButton(),
                      ],
                    ),
                  ),
                ),
              ),

              // Progress indicator at bottom
              Positioned(bottom: 0, left: 0, right: 0, child: _ScrollProgressIndicator(progress: scrollProgress)),
            ],
          ),
        ),
      ),
    );
  }
}
