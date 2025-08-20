import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/view/viewmodel/event/event_view_model.dart';
import 'package:smart_city/view/authentication/test/model/eventmodel/event_model.dart';
import 'package:smart_city/core/components/skeleton/shimmer.dart';
import 'package:smart_city/core/components/cards/unified_info_card.dart';
import 'package:smart_city/core/components/carousel/sliding_window_carousel.dart';
import 'package:smart_city/core/components/particles/particle_background.dart';

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final viewModel = Provider.of<EventViewModel>(context, listen: false);
      viewModel.fetchEvents();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final viewModel = Provider.of<EventViewModel>(context, listen: false);

        if (viewModel.isLoading) {
          return _buildLoadingState();
        }

        if (viewModel.hasError) {
          return _buildErrorState(viewModel);
        }

        if (viewModel.eventList == null || viewModel.eventList!.isEmpty) {
          return _buildEmptyState();
        }

        return _buildEventSection(viewModel.eventList!);
      },
    );
  }

  Widget _buildLoadingState() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1400),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 64, vertical: isMobile ? 48 : 100),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
                  'ETKİNLİKLER',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: isMobile ? 32 : 42,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                _buildSeeAllButton(isMobile),
              ],
            ),
            const SizedBox(height: 48),
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
            crossAxisSpacing: 32,
            mainAxisSpacing: 32,
            childAspectRatio: 0.75,
          ),
          itemCount: 8,
          itemBuilder: (context, index) => _eventSkeletonCard(),
        );
      },
    );
  }

  Widget _eventSkeletonCard() {
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
                BoxShadow(color: const Color(0xFF0A4A9D).withOpacity(0.10), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Görsel placeholder
            Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
              ),
            ),
            // Metin placeholder
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 6),
                      SkeletonLine(widthFactor: 0.85, height: 14),
                      SizedBox(height: 10),
                      SkeletonLine(widthFactor: 1.0, height: 12),
                      SizedBox(height: 6),
                      SkeletonLine(widthFactor: 0.7, height: 12),
                      Spacer(),
                      SkeletonLine(widthFactor: 0.55, height: 10),
                      SizedBox(height: 6),
                      SkeletonLine(widthFactor: 0.4, height: 10),
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

  Widget _buildErrorState(EventViewModel viewModel) {
    return Container(
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
          Text(
            'Bir hata oluştu',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: const Color(0xFF374151), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            viewModel.errorMessage ?? 'Etkinlikler yüklenirken bir sorun oluştu',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => viewModel.retryFetchEvents(),
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.event_outlined, size: 48, color: Color(0xFF10B981)),
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz etkinlik bulunmuyor',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: const Color(0xFF374151), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Yeni etkinlikler eklendiğinde burada görünecek',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEventSection(List<EventModel> events) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth < 1024;

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
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 64, vertical: isMobile ? 48 : 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık ve TÜMÜNÜ GÖRÜNTÜLE bölümü
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ETKİNLİKLER',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: isMobile ? 32 : 42,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    _buildSeeAllButton(isMobile),
                  ],
                ),
                const SizedBox(height: 48),

                // Etkinlik Kaydırmalı Pencere (3'lü görünüm, ileri/geri 1'er adım)
                _buildEventCarousel(events),

                const SizedBox(height: 48),

                // Footer Text
                _buildFooterText(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCarousel(List<EventModel> events) {
    return SlidingWindowCarousel<EventModel>(
      items: events,
      maxVisible: 3,
      enableLoop: true,
      gap: 24,
      itemAspectRatio: 0.9,
      itemBuilder: (context, item, index) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: _buildEventCard(item),
      ),
    );
  }

  Widget _buildEventCard(EventModel event) {
    final DateTime now = DateTime.now();
    final DateTime? eventDate = event.date;
    final bool isPast = eventDate != null ? now.isAfter(eventDate) : false;

    return UnifiedInfoCard(
      imageUrl: event.imageUrl,
      fallbackIcon: Icons.event,
      title: event.title ?? 'Başlık Yok',
      description: event.description,
      borderRadius: 20,
      overlayHeight: 72,
      contentPadding: const EdgeInsets.all(16),
      bottomRowChildren: [
        const Icon(Icons.access_time, size: 12, color: Color(0xFF7AA2D6)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _formatDate(event.date),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF7AA2D6), fontSize: 12, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
        TextButton.icon(
          onPressed: () => context.go('/events/${event.id ?? ''}'),
          icon: const Icon(Icons.arrow_forward, size: 16),
          label: const Text('Detay'),
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF0A4A9D)),
        ),
      ],
      secondaryBottomRowChildren: event.location != null
          ? [
              const Icon(Icons.location_on, size: 12, color: Color(0xFF7AA2D6)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF7AA2D6), fontSize: 12, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                ),
              ),
            ]
          : null,
      topLeftOverlayWidget: eventDate != null
          ? Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))]),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('${eventDate.day}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0A4A9D), height: 1.0)),
                Text(_monthShortTR(eventDate.month), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1F2937), height: 1.0)),
              ]),
            )
          : null,
      topRightOverlayWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isPast ? const Color(0xFFE0ECFF) : const Color(0xFF0A4A9D),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFF0A4A9D).withOpacity(0.2)),
        ),
        child: Text(
          isPast ? 'Geçmiş' : 'Yakında',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isPast ? const Color(0xFF0A4A9D) : Colors.white),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tarih belirtilmemiş';

    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      return 'Geçmiş etkinlik';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} gün sonra';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat sonra';
    } else {
      return 'Bugün';
    }
  }

  String _monthShortTR(int month) {
    const months = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }

  Widget _buildSeeAllButton(bool isMobile) {
    bool isHovered = false;
    return StatefulBuilder(builder: (context, setLocal) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
        onEnter: (_) => setLocal(() => isHovered = true),
        onExit: (_) => setLocal(() => isHovered = false),
      child: GestureDetector(
          onTap: () => context.go('/events-detail'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            transform: Matrix4.identity()..translate(0.0, isHovered ? -2.0 : 0.0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0A4A9D),
              borderRadius: BorderRadius.circular(6),
              boxShadow: isHovered
                  ? [BoxShadow(color: const Color(0xFF0A4A9D).withOpacity(0.28), blurRadius: 10, offset: const Offset(0, 4))]
                  : [BoxShadow(color: const Color(0xFF0A4A9D).withOpacity(0.18), blurRadius: 6, offset: const Offset(0, 3))],
            ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
                Image.asset('asset/icons/calendar.png', width: 16, height: 16, color: Colors.white, colorBlendMode: BlendMode.srcIn),
              const SizedBox(width: 8),
                const Text('TÜMÜNÜ GÖRÜNTÜLE', style: TextStyle(fontFamily: 'Roboto', fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.5)),
                const SizedBox(width: 6),
                AnimatedScale(scale: isHovered ? 1.12 : 1.0, duration: const Duration(milliseconds: 180), curve: Curves.easeOut, child: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
    });
  }

  Widget _buildFooterText() {
    return Center(
      child: Text(
        'Daha fazla etkinlik için takipte kalın',
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
