import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/core/components/search/search_dialog.dart';
import 'package:smart_city/core/repository/search/search_repository.dart';
import 'package:smart_city/core/service/search/search_service.dart';
import 'package:smart_city/view/viewmodel/search/search_view_model.dart';
import 'package:smart_city/core/components/app_bar/navigation_item_colors.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final void Function(String label)? onNavTap;
  final bool isTransparent;
  final ScrollController? scrollController;
  final double? scrollProgress;
  final String? activeItemOverride;
  final bool showOnlyActiveItem;
  final bool showBackButton;

  const MainAppBar({
    super.key,
    this.onNavTap,
    this.isTransparent = true,
    this.scrollController,
    this.scrollProgress,
    this.activeItemOverride,
    this.showOnlyActiveItem = false,
    this.showBackButton = false,
  });

  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MainAppBarState extends State<MainAppBar> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Animation controllers
  late AnimationController _heightController;
  late AnimationController _opacityController;
  late AnimationController _shadowController;

  // Animations
  late Animation<double> _heightAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _shadowAnimation;

  // Scroll state
  bool _isScrolled = false;

  // Active navigation item
  final String _activeNavigationItem = 'Ana Sayfa';

  // Material 3 Color Palette
  static const Color primaryColor = Color(0xFF0A4A9D);
  static const Color secondaryColor = Color(0xFF00A8E8);
  static const Color surfaceColor = Colors.white;
  static const Color onSurfaceColor = Color(0xFF1F2937);

  // 2. Memoize navItems list with static const - Ortak ikon kullanımı
  static const List<NavItem> _navItems = [
    NavItem(label: 'Ana Sayfa', icon: 'asset/icons/remove.png', route: '/home'),
    NavItem(label: 'Duyurular', icon: 'asset/icons/remove.png', route: '/announcements'),
    NavItem(label: 'Etkinlikler', icon: 'asset/icons/remove.png', route: '/events'),
    NavItem(label: 'Haberler', icon: 'asset/icons/remove.png', route: '/news'),
    NavItem(label: 'Şehir Hizmetleri', icon: 'asset/icons/remove.png', route: '/city-services'),
    NavItem(label: 'Projeler', icon: 'asset/icons/remove.png', route: '/projects'),
    NavItem(label: 'Akıllı Şehir Nedir?', icon: 'asset/icons/remove.png', route: '/smart-city-info'),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _heightController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    _opacityController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);

    _shadowController = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);

    // Initialize animations
    _heightAnimation = Tween<double>(
      begin: kToolbarHeight,
      end: kToolbarHeight + 8, // Slightly taller when scrolled
    ).animate(CurvedAnimation(parent: _heightController, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _opacityController, curve: Curves.easeInOut));

    _shadowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _shadowController, curve: Curves.easeInOut));

    // Listen to scroll changes
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _opacityController.dispose();
    _shadowController.dispose();
    if (widget.scrollController != null) {
      widget.scrollController!.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _onScroll() {
    if (widget.scrollController == null) return;

    final scrollOffset = widget.scrollController!.offset;
    final scrollThreshold = 50.0; // Scroll threshold to trigger animation

    if (scrollOffset > scrollThreshold && !_isScrolled) {
      // User scrolled down - show solid app bar
      setState(() => _isScrolled = true);
      _heightController.forward();
      _opacityController.forward();
      _shadowController.forward();
    } else if (scrollOffset <= scrollThreshold && _isScrolled) {
      // User scrolled back to top - show transparent app bar
      setState(() => _isScrolled = false);
      _heightController.reverse();
      _opacityController.reverse();
      _shadowController.reverse();
    }

    // Active item artık HomeView tarafından override ediliyor; burada hesaplama yok
    // Sadece scrolled görünüm animasyonları yönetiliyor.
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    // 6. Replace MediaQuery with LayoutBuilder for responsive checks
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 768;
        final bool isTablet = constraints.maxWidth < 1024;
        final String location = GoRouterState.of(context).uri.toString();

        return AnimatedBuilder(
          animation: Listenable.merge([_heightController, _opacityController, _shadowController]),
          builder: (context, child) {
            return Column(
              children: [
                Container(
                  height: _heightAnimation.value,
                  decoration: BoxDecoration(
                    color: _isScrolled
                        ? Colors.white.withOpacity(_opacityAnimation.value)
                        : (widget.isTransparent ? Colors.transparent : Colors.white),
                    // Add subtle gradient background for better text readability when transparent
                    gradient: !_isScrolled && widget.isTransparent
                        ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                            stops: const [0.0, 0.7],
                          )
                        : null,
                    // Add shadow when scrolled
                    boxShadow: _isScrolled
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1 * _shadowAnimation.value),
                              blurRadius: 8 * _shadowAnimation.value,
                              offset: Offset(0, 2 * _shadowAnimation.value),
                            ),
                          ]
                        : null,
                  ),
                  child: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      height: _heightAnimation.value,
                      child: Row(
                        children: [
                          // 2. Convert helper methods to StatelessWidget classes
                          LogoWidget(isTransparent: !_isScrolled && widget.isTransparent),
                          const SizedBox(width: 32),

                          // Desktop Navigation (Tablet ve üzeri)
                          if (!isMobile) ...[
                            Expanded(
                              child: ResponsiveNavigationWidget(
                                location: location,
                                isTablet: isTablet,
                                onNavTap: widget.onNavTap,
                                isTransparent: !_isScrolled && widget.isTransparent,
                                activeItem: widget.activeItemOverride ?? _activeNavigationItem,
                                showOnlyActiveItem: widget.showOnlyActiveItem,
                              ),
                            ),
                            const SizedBox(width: 24),
                            if (widget.showBackButton) ...[
                              BackButton(isTransparent: !_isScrolled && widget.isTransparent),
                              const SizedBox(width: 16),
                            ],
                            SearchButton(isTransparent: !_isScrolled && widget.isTransparent),
                            const SizedBox(width: 16),
                            LoginButton(isTransparent: !_isScrolled && widget.isTransparent),
                          ],

                          // Mobile Menu Button
                          if (isMobile) ...[
                            const Spacer(),
                            if (widget.showBackButton) ...[
                              BackButton(isTransparent: !_isScrolled && widget.isTransparent),
                              const SizedBox(width: 16),
                            ],
                            SearchButton(isTransparent: !_isScrolled && widget.isTransparent),
                            const SizedBox(width: 16),
                            LoginButton(isTransparent: !_isScrolled && widget.isTransparent),
                            const SizedBox(width: 16),
                            MobileMenuButton(isTransparent: !_isScrolled && widget.isTransparent),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                // Scroll Progress Bar
                if (_isScrolled && widget.scrollProgress != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0A4A9D), Color(0xFF00A8E8)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: widget.scrollProgress!.clamp(0.0, 1.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF0A4A9D), Color(0xFF00A8E8)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

// 2. Convert helper methods to StatelessWidget classes
class LogoWidget extends StatelessWidget {
  final bool isTransparent;

  const LogoWidget({super.key, required this.isTransparent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 9. Add Semantics for accessibility
        Semantics(
          label: 'Erzurum Akıllı Şehir Logo',
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: Border.all(color: isTransparent ? Colors.white : const Color(0xFF0A4A9D), width: 1),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Image.asset(
                'asset/image/images.png',
                width: 60,
                height: 60,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.location_city,
                    color: isTransparent ? Colors.white : const Color(0xFF0A4A9D),
                    size: 30,
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Akıllı Şehir icon
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: isTransparent ? Colors.white : const Color(0xFF0A4A9D), width: 1),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Image.asset(
              'asset/image/akillisehir.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.smart_toy, color: isTransparent ? Colors.white : const Color(0xFF0A4A9D), size: 30);
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 9. Add SelectionArea for text selection
        SelectionArea(
          child: Text(
            'Erzurum Akıllı Şehir',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isTransparent ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class ResponsiveNavigationWidget extends StatelessWidget {
  final String location;
  final bool isTablet;
  final void Function(String label)? onNavTap;
  final bool isTransparent;
  final String activeItem;
  final bool showOnlyActiveItem;

  const ResponsiveNavigationWidget({
    super.key,
    required this.location,
    required this.isTablet,
    this.onNavTap,
    required this.isTransparent,
    required this.activeItem,
    required this.showOnlyActiveItem,
  });

  @override
  Widget build(BuildContext context) {
    // 4. Replace SingleChildScrollView with ListView.builder
    List<NavItem> displayItems;

    if (showOnlyActiveItem) {
      // Sadece aktif item'ı göster
      displayItems = _MainAppBarState._navItems.where((item) => item.label == activeItem).toList();
    } else if (isTablet) {
      // Tablet için sınırlı items
      displayItems = _MainAppBarState._navItems
          .where((item) => ['Ana Sayfa', 'Haberler', 'Etkinlikler', 'Duyurular'].contains(item.label))
          .toList();
    } else {
      // Tüm items
      displayItems = _MainAppBarState._navItems;
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: displayItems.length,
      itemBuilder: (context, index) {
        final item = displayItems[index];
        final isSelected = location == item.route;

        // 4. Add RepaintBoundary around each navigation button
        return RepaintBoundary(
          child: _NavButton(
            label: item.label,
            icon: item.icon,
            selected: item.label == activeItem,
            onTap: () {
              if (onNavTap != null) {
                onNavTap!(item.label);
              }
              // context.go(item.route); // Bu satırı kaldırdık - artık sadece scroll yapacak
            },
            isTransparent: isTransparent,
            isCompact: false,
            activeItem: activeItem,
          ),
        );
      },
    );
  }
}

class SearchButton extends StatelessWidget {
  final bool isTransparent;

  const SearchButton({super.key, required this.isTransparent});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Arama',
      button: true,
      child: Container(
        decoration: BoxDecoration(
          color: isTransparent ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(isTransparent ? 12 : 8),
        ),
        child: IconButton(
          onPressed: () {
            // Show search dialog
            showDialog(
              context: context,
              builder: (context) => SearchDialog(searchViewModel: SearchViewModel(SearchRepository(SearchService()))),
            );
          },
          icon: Icon(Icons.search, color: isTransparent ? Colors.white : Colors.black, size: isTransparent ? 20 : 18),
          style: IconButton.styleFrom(
            padding: EdgeInsets.all(isTransparent ? 12 : 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isTransparent ? 12 : 8)),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final bool isTransparent;

  const LoginButton({super.key, this.isTransparent = false});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Admin Girişi',
      button: true,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: isTransparent
              ? null
              : const [BoxShadow(color: Color(0x3300A8E8), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: ElevatedButton(
          onPressed: () => context.go('/admin-login'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isTransparent ? Colors.transparent : const Color(0xFF00A8E8),
            foregroundColor: isTransparent ? Colors.white : Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            side: isTransparent ? const BorderSide(color: Colors.white, width: 1) : null,
          ),
          child: const Text(
            'Kurumsal Giriş',
            style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ),
    );
  }
}

class MobileMenuButton extends StatelessWidget {
  final bool isTransparent;

  const MobileMenuButton({super.key, required this.isTransparent});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Mobil Menü',
      button: true,
      child: IconButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mobil menü yakında eklenecek')));
        },
        icon: Icon(Icons.menu, color: isTransparent ? Colors.white : Colors.black, size: 24),
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(8),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
      ),
    );
  }
}

class NavItem {
  final String label;
  final String icon;
  final String route;

  const NavItem({required this.label, required this.icon, required this.route});
}

class BackButton extends StatelessWidget {
  final bool isTransparent;

  const BackButton({super.key, required this.isTransparent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isTransparent ? Colors.white.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isTransparent ? Colors.white.withOpacity(0.3) : const Color(0xFFE5E7EB), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            final router = GoRouter.of(context);
            if (router.canPop()) {
              router.pop();
            } else {
              // Fallback: infer list route from current location
              final location = GoRouterState.of(context).uri.path;
              String fallback = '/home';
              if (location.startsWith('/events/')) {
                fallback = '/events-detail';
              } else if (location.startsWith('/news/')) {
                fallback = '/news-detail';
              } else if (location.startsWith('/city-services/')) {
                fallback = '/city-services-detail';
              } else if (location.startsWith('/projects/')) {
                fallback = '/projects-detail';
              } else if (location.startsWith('/announcements/')) {
                fallback = '/announcements-detail';
              }
              context.go(fallback);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/icons/back.png',
                  width: 18,
                  height: 18,
                  color: isTransparent ? Colors.white : const Color(0xFF374151),
                  alignment: Alignment.center,
                ),
                const SizedBox(width: 10),
                Text(
                  'Geri Dön',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: isTransparent ? Colors.white : const Color(0xFF374151),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 3. Convert _NavButton to use ValueNotifier for hover state
class _NavButton extends StatefulWidget {
  final String label;
  final String icon;
  final bool selected;
  final VoidCallback onTap;
  final bool isTransparent;
  final bool isCompact;
  final String activeItem;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.isTransparent,
    required this.isCompact,
    required this.activeItem,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> with TickerProviderStateMixin {
  late final ValueNotifier<bool> _hovered;
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hovered = ValueNotifier<bool>(false);
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _hovered.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: MouseRegion(
        onEnter: (_) {
          _hovered.value = true;
          _animationController.forward();
        },
        onExit: (_) {
          _hovered.value = false;
          _animationController.reverse();
        },
        child: ValueListenableBuilder<bool>(
          valueListenable: _hovered,
          builder: (context, hovered, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: widget.isCompact ? 8 : 12, vertical: widget.isCompact ? 6 : 8),
              decoration: BoxDecoration(
                color: NavigationItemColors.getBackgroundColor(
                  widget.label,
                  widget.activeItem,
                  widget.isTransparent,
                  hovered,
                ),
                borderRadius: BorderRadius.circular(widget.isCompact ? 8 : 12),
                border: Border.all(
                  color: NavigationItemColors.getBorderColor(widget.label, widget.activeItem, widget.isTransparent),
                  width: widget.isCompact ? 0.5 : 1,
                ),
              ),
              child: GestureDetector(
                onTap: widget.onTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      widget.icon,
                      width: 20,
                      height: 20,
                      color: NavigationItemColors.getColor(widget.label, widget.activeItem, widget.isTransparent),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: NavigationItemColors.getColor(widget.label, widget.activeItem, widget.isTransparent),
                        fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: widget.isCompact ? 11 : 13,
                      ),
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
