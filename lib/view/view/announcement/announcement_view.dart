import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/view/viewmodel/announcement/announcement_view_model.dart';
import 'package:smart_city/view/authentication/test/model/announcementmodel/announcement_model.dart';
import 'package:smart_city/core/components/particles/particle_background.dart';

class AnnouncementView extends StatefulWidget {
  const AnnouncementView({super.key});

  @override
  State<AnnouncementView> createState() => _AnnouncementViewState();
}

class _AnnouncementViewState extends State<AnnouncementView> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final viewModel = Provider.of<AnnouncementViewModel>(context, listen: false);
      viewModel.fetchAnnouncement();
      _initialized = true;
    }
  }

  Widget _buildDetailButton(AnnouncementModel announcement) {
    // Eğer id yoksa butonu gösterme
    if (announcement.id == null) {
      return const SizedBox.shrink();
    }
    
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setLocal) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setLocal(() => isHovered = true),
          onExit: (_) => setLocal(() => isHovered = false),
          child: InkWell(
            onTap: () {
              context.go('/announcements/${announcement.id}');
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              transform: Matrix4.identity()..translate(0.0, isHovered ? -1.0 : 0.0),
              decoration: BoxDecoration(
                color: const Color(0xFF0A4A9D),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0A4A9D).withOpacity(isHovered ? 0.45 : 0.30),
                    blurRadius: isHovered ? 12 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Detay',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedScale(
                    scale: isHovered ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final viewModel = Provider.of<AnnouncementViewModel>(context, listen: false);

        if (viewModel.isLoading) {
          return _buildLoadingState();
        }

        if (viewModel.hasError) {
          return _buildErrorState(viewModel);
        }

        if (viewModel.announcementList == null || viewModel.announcementList!.isEmpty) {
          return _buildEmptyState();
        }

        return _buildAnnouncementSection(viewModel.announcementList!);
      },
    );
  }

  Widget _buildLoadingState() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 64, vertical: isMobile ? 32 : 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DUYURULAR',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                _buildSeeAllButton(isMobile),
              ],
            ),
            const SizedBox(height: 32),
            // Skeleton list
            _buildSkeletonList(),
            const SizedBox(height: 16),
            _buildFooterText(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonList() {
    return Column(children: List.generate(3, (_) => _announcementSkeletonCard()));
  }

  Widget _announcementSkeletonCard() {
    const Color base = Color(0xFFE5E7EB);
    const Color highlight = Color(0xFFF3F4F6);

    return Shimmer(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: const Border(left: BorderSide(color: Color(0xFF0A4A9D), width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              // Icon placeholder
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              ),
              const SizedBox(width: 20),
              // Text block
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonLine(widthFactor: 0.55, height: 16),
                    SizedBox(height: 10),
                    _SkeletonLine(widthFactor: 0.95, height: 12),
                    SizedBox(height: 8),
                    _SkeletonLine(widthFactor: 0.8, height: 12),
                    SizedBox(height: 12),
                    _SkeletonLine(widthFactor: 0.35, height: 10),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Button placeholder
              Container(
                width: 120,
                height: 38,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(AnnouncementViewModel viewModel) {
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
            viewModel.errorMessage ?? 'Duyurular yüklenirken bir sorun oluştu',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => viewModel.retryFetchAnnouncement(),
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), foregroundColor: Colors.white),
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
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.campaign_outlined, size: 48, color: Color(0xFF3B82F6)),
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz duyuru bulunmuyor',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: const Color(0xFF374151), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Yeni duyurular eklendiğinde burada görünecek',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementSection(List<AnnouncementModel> announcements) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth < 1024;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Stack(
        children: [
          // Parçacık animasyonu arka planda
          Positioned.fill(
            child: ParticleBackground(
              particleColor: Colors.white,
              particleCount: isMobile ? 25 : 40,
              speed: 0.2,
              opacity: 0.12,
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
                      'DUYURULAR',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: isMobile ? 28 : 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    _buildSeeAllButton(isMobile),
                  ],
                ),
                const SizedBox(height: 32),

                // Duyuru Listesi (en fazla 3)
                ...announcements.take(3).map((announcement) {
                  final index = announcements.indexOf(announcement);
                  return _buildAnnouncementCard(announcement, index, isMobile);
                }),

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

  Widget _buildAnnouncementCard(AnnouncementModel announcement, int index, bool isMobile) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setLocal) {
        return MouseRegion(
          onEnter: (_) => setLocal(() => isHovered = true),
          onExit: (_) => setLocal(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            margin: const EdgeInsets.only(bottom: 24),
            transform: Matrix4.identity()..translate(0.0, isHovered ? -2.0 : 0.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border(
                left: BorderSide(color: const Color(0xFF0A4A9D), width: isHovered ? 5 : 4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isHovered ? 0.12 : 0.08),
                  blurRadius: isHovered ? 20 : 16,
                  offset: const Offset(0, 6),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Sol tarafta megaphone ikonu
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0A4A9D), Color(0xFF00A8E8)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0A4A9D).withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(Icons.campaign, color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Orta kısım - duyuru içeriği
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          announcement.title ?? 'Başlık Yok',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2937),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          announcement.content ?? 'İçerik yok',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: isMobile ? 14 : 15,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 14, color: const Color(0xFF9CA3AF)),
                            const SizedBox(width: 6),
                            Text(
                              _formatDate(announcement.date),
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Sağ tarafta DAHA FAZLA DETAY butonu
                  _buildDetailButton(announcement),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSeeAllButton(bool isMobile) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setLocal) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setLocal(() => isHovered = true),
          onExit: (_) => setLocal(() => isHovered = false),
          child: GestureDetector(
            onTap: () => context.go('/announcements-detail'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              transform: Matrix4.identity()..translate(0.0, isHovered ? -2.0 : 0.0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isHovered ? Colors.white.withOpacity(0.08) : Colors.transparent,
                border: Border.all(color: Colors.white.withOpacity(isHovered ? 0.6 : 0.3), width: 1),
                borderRadius: BorderRadius.circular(6),
                boxShadow: isHovered
                    ? [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 3))]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.campaign_outlined, size: 16, color: Colors.white.withOpacity(isHovered ? 1.0 : 0.95)),
                  const SizedBox(width: 8),
                  Text(
                    'TÜMÜNÜ GÖRÜNTÜLE',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedScale(
                    scale: isHovered ? 1.12 : 1.0,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    child: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
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
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(
          'Müzdecek, Faktörlendir',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tarih belirtilmemiş';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }
}

// --- Shimmer primitives (shared with Events) ---
class _SkeletonLine extends StatelessWidget {
  final double widthFactor;
  final double height;
  const _SkeletonLine({required this.widthFactor, this.height = 12});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class Shimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const Shimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE5E7EB),
    this.highlightColor = const Color(0xFFF3F4F6),
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
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
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            final double width = bounds.width;
            final double dx = -width + (2 * width * _controller.value);
            final Rect shimmerRect = Rect.fromLTWH(dx, 0, 2 * width, bounds.height);
            return LinearGradient(
              colors: [widget.baseColor, widget.highlightColor, widget.baseColor],
              stops: const [0.35, 0.5, 0.65],
            ).createShader(shimmerRect);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
