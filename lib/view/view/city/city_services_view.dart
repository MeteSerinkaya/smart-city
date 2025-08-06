import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/view/viewmodel/city/city_service_view_model.dart';
import 'package:smart_city/view/authentication/test/model/citymodel/city_service_model.dart';

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
              return _buildLoadingState();
            }

            if (cityServiceViewModel.hasError) {
              return _buildErrorState(cityServiceViewModel);
            }

            if (cityServices.isEmpty) {
              return _buildEmptyState();
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount;
                if (constraints.maxWidth < 768) {
                  crossAxisCount = 1;
                } else if (constraints.maxWidth < 1024) {
                  crossAxisCount = 2;
                } else {
                  crossAxisCount = 3;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: cityServices.length,
                  itemBuilder: (context, index) {
                    final service = cityServices[index];
                    return RepaintBoundary(child: CityServiceCardWidget(service: service));
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
            ),
            SizedBox(height: 16),
            Text(
              'Şehir hizmetleri yükleniyor...',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 16,
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
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bir hata oluştu',
              style: TextStyle(
                color: Color(0xFF374151),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage ?? 'Şehir hizmetleri yüklenirken bir sorun oluştu',
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => viewModel.retryFetchCityService(),
              icon: const Icon(Icons.refresh),
              label: const Text('Tekrar Dene'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF8B5CF6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.apps,
                size: 48,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Henüz şehir hizmeti eklenmemiş',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Yeni hizmetler eklendiğinde burada görünecek',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CityServiceCardWidget extends StatelessWidget {
  final CityServiceModel service;

  const CityServiceCardWidget({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      elevation: 2,
      hoverElevation: 12,
      borderRadius: 16,
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(color: Color(0x1A8B5CF6), shape: BoxShape.circle),
            child: service.iconUrl != null && service.iconUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      service.iconUrl!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.apps, size: 40, color: Color(0xFF8B5CF6));
                      },
                    ),
                  )
                : const Icon(Icons.apps, size: 40, color: Color(0xFF8B5CF6)),
          ),
          const SizedBox(height: 20),
          Text(
            service.title ?? 'Başlıksız',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            service.description ?? 'Açıklama yok',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0x991F2937),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          HoverScaleButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('${service.title ?? 'Hizmet'} detayları yakında eklenecek')));
            },
            outlined: true,
            color: const Color(0xFF8B5CF6),
            borderColor: const Color(0xFF8B5CF6),
            child: const Text(
              'Detay',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF8B5CF6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
