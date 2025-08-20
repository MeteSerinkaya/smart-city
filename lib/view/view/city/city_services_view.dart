import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/core/components/skeleton/shimmer.dart';
import 'package:smart_city/core/components/cards/unified_info_card.dart';
import 'package:smart_city/core/components/carousel/sliding_window_carousel.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/view/viewmodel/city/city_service_view_model.dart';
import 'package:smart_city/view/authentication/test/model/citymodel/city_service_model.dart';
import 'package:smart_city/core/components/particles/particle_background.dart';

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.color ?? Colors.white,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hovered ? 0.15 : 0.05),
              blurRadius: _hovered ? widget.hoverElevation : widget.elevation,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}

class CityServicesView extends StatelessWidget {
  const CityServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CityServiceViewModel>(
      builder: (context, cityServiceViewModel, child) {
        return Observer(
          builder: (_) {
            final cityServices = cityServiceViewModel.cityServiceList ?? [];

            if (cityServiceViewModel.isLoading) {
              return _buildLoadingState(context);
            }

            if (cityServiceViewModel.hasError) {
              return _buildErrorState(cityServiceViewModel);
            }

            if (cityServices.isEmpty) {
              return _buildEmptyState();
            }

            return _buildCityServicesSection(context, cityServices);
          },
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1400),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 64, vertical: isMobile ? 32 : 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ŞEHİR HİZMETLERİ',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                _buildSeeAllButton(context, isMobile),
              ],
            ),
            const SizedBox(height: 32),
            _buildSkeletonGrid(),
            const SizedBox(height: 32),
            _buildFooterText(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth > 1400) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 1000) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 700) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 0.75,
          ),
          itemCount: 8,
          itemBuilder: (context, index) => _serviceSkeletonCard(),
        );
      },
    );
  }

  Widget _serviceSkeletonCard() {
    const Color base = Color(0xFFE0ECFF); // blue-tinted base
    const Color highlight = Color(0xFFF2F7FF); // blue-tinted highlight

    return Shimmer(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: Color(0x800A4A9D), width: 3),
            left: BorderSide(color: Color(0xFFE5E7EB), width: 1),
            right: BorderSide(color: Color(0xFFE5E7EB), width: 1),
            bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
          boxShadow: [
            BoxShadow(color: const Color(0xFF0A4A9D).withOpacity(0.10), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sol mavi şerit
            const SizedBox(height: 0, child: Row(children: [])),
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F9FF),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6),
                      SkeletonLine(widthFactor: 0.8, height: 14),
                      SizedBox(height: 10),
                      SkeletonLine(widthFactor: 0.6, height: 12),
                      SizedBox(height: 8),
                      // Meta satırı placeholder
                      SkeletonLine(widthFactor: 0.4, height: 10),
                      Spacer(),
                      SkeletonLine(widthFactor: 0.25, height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(CityServiceViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bir hata oluştu',
              style: TextStyle(color: Color(0xFF374151), fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage ?? 'Şehir hizmetleri yüklenirken bir sorun oluştu',
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => viewModel.retryFetchCityService(),
              icon: const Icon(Icons.refresh),
              label: const Text('Tekrar Dene'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6), foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Color(0xFF8B5CF6), shape: BoxShape.circle),
              child: const Icon(Icons.apps, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Henüz şehir hizmeti eklenmemiş',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Yeni hizmetler eklendiğinde burada görünecek',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityServicesSection(BuildContext context, List<CityServiceModel> cityServices) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1400),
      child: Stack(
        children: [
          // Parçacık animasyonu arka planda
          Positioned.fill(
            child: ParticleBackground(
              particleColor: const Color(0xFF0A4A9D), // Koyu mavi parçacıklar
              particleCount: isMobile ? 25 : 40,
              speed: 0.2,
              opacity: 0.15,
            ),
          ),
          
          // Ana içerik
          Container(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 64, vertical: isMobile ? 32 : 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık ve TÜMÜNÜ GÖRÜNTÜLE bölümü
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ŞEHİR HİZMETLERİ',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: isMobile ? 28 : 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    _buildSeeAllButton(context, isMobile),
                  ],
                ),
                const SizedBox(height: 32),

                // Şehir Hizmetleri Kaydırmalı Pencere
                _buildCityServicesCarousel(cityServices),

                const SizedBox(height: 32),

                // Footer Text
                _buildFooterText(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityServicesGrid(List<CityServiceModel> cityServices) {
    return SlidingWindowCarousel<CityServiceModel>(
      items: cityServices,
      maxVisible: 3,
      enableLoop: true,
      gap: 24,
      itemAspectRatio: 0.9,
      itemBuilder: (context, service, index) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: UnifiedInfoCard(
          imageUrl: service.iconUrl,
          fallbackIcon: Icons.apps,
          title: service.title ?? 'Başlıksız',
          description: service.description,
          contentPadding: const EdgeInsets.all(16),
          bottomRowChildren: [
            const Icon(Icons.access_time, size: 12, color: Color(0xFF7AA2D6)),
            const SizedBox(width: 4),
            const Text(
              '7/24',
              style: TextStyle(color: Color(0xFF7AA2D6), fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.public, size: 12, color: Color(0xFF7AA2D6)),
            const SizedBox(width: 4),
            const Expanded(
              child: Text(
                'Çevrim içi',
                style: TextStyle(color: Color(0xFF7AA2D6), fontSize: 12, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton.icon(
              onPressed: () => context.go('/city-services/${service.id ?? ''}'),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('Detay'),
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF0A4A9D)),
            ),
          ],
        ),
      ),
    );
  }

  // Backwards-compatible alias after migrating to carousel naming
  Widget _buildCityServicesCarousel(List<CityServiceModel> cityServices) => _buildCityServicesGrid(cityServices);

  Widget _buildSeeAllButton(BuildContext context, bool isMobile) {
    bool hovered = false;
    return StatefulBuilder(
      builder: (context, setLocal) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
          onEnter: (_) => setLocal(() => hovered = true),
          onExit: (_) => setLocal(() => hovered = false),
      child: GestureDetector(
        onTap: () {
          context.go('/city-services-detail');
        },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              transform: Matrix4.identity()..translate(0.0, hovered ? -2.0 : 0.0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0A4A9D),
                borderRadius: BorderRadius.circular(6),
                boxShadow: hovered
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0A4A9D).withOpacity(0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: const Color(0xFF0A4A9D).withOpacity(0.18),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
              ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'asset/icons/company.png',
                width: 16,
                height: 16,
                color: Colors.white,
                colorBlendMode: BlendMode.srcIn,
              ),
              const SizedBox(width: 8),
                  const Text(
                'TÜMÜNÜ GÖRÜNTÜLE',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                      fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
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

  Widget _buildFooterText() {
    return Center(
      child: Text(
        'Daha fazla şehir hizmeti için takipte kalın',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white.withOpacity(0.7),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Eski CityServiceCardWidget kaldırıldı; UnifiedInfoCard kullanılmaktadır.

// _Chip widgetı artık kullanılmıyor (çipler kaldırıldı)
