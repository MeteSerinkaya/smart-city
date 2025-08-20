import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/view/viewmodel/announcement/announcement_view_model.dart';
import 'package:smart_city/view/authentication/test/model/announcementmodel/announcement_model.dart';
import 'package:smart_city/core/components/app_bar/main_app_bar.dart';
import 'package:smart_city/core/components/detail/hero_detail_scaffold.dart';
import 'package:flutter/services.dart';

class AnnouncementDetailView extends StatefulWidget {
  final int? announcementId;
  const AnnouncementDetailView({super.key, this.announcementId});

  @override
  State<AnnouncementDetailView> createState() => _AnnouncementDetailViewState();
}

class _AnnouncementDetailViewState extends State<AnnouncementDetailView> with TickerProviderStateMixin {
  bool _initialized = false;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _slideController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final viewModel = Provider.of<AnnouncementViewModel>(context, listen: false);

      // Eğer announcementId varsa tek duyuru getir, yoksa tüm duyuruları getir
      if (widget.announcementId != null) {
        viewModel.getAnnouncementById(widget.announcementId!);
      } else {
        viewModel.fetchAnnouncement();
      }

      _initialized = true;

      // Animasyonları başlat
      _fadeController.forward();
      _slideController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const MainAppBar(
        isTransparent: false,
        onNavTap: null,
        activeItemOverride: 'Duyurular',
        showOnlyActiveItem: true,
        showBackButton: true,
      ),
      body: Observer(
        builder: (context) {
          final viewModel = Provider.of<AnnouncementViewModel>(context, listen: false);

          if (viewModel.isLoading) {
            return _buildLoadingState();
          }

          if (viewModel.announcementList == null || viewModel.announcementList!.isEmpty) {
            return _buildEmptyState();
          }

          // Eğer spesifik bir id gönderildiyse tek ilanı göster
          if (widget.announcementId != null) {
            if (viewModel.singleAnnouncement == null) {
              return _buildAnnouncementNotFoundState();
            }
            return _buildSingleAnnouncementView(viewModel.singleAnnouncement!);
          }

          return _buildAnnouncementList(viewModel.announcementList!);
        },
      ),
    );
  }

  Widget _buildSingleAnnouncementView(AnnouncementModel announcement) {
    // Format date for display
    final String? formattedDate = announcement.date != null
        ? '${announcement.date!.day.toString().padLeft(2, '0')}/${announcement.date!.month.toString().padLeft(2, '0')}/${announcement.date!.year}'
        : null;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: HeroDetailScaffold(
          title: announcement.title ?? 'Başlık Yok',
          imageUrl: null, // Announcement'ta image yok
          date: formattedDate,
          description: announcement.content, // content kullanılıyor
          heroTag: 'announcement_${announcement.id ?? announcement.title ?? ''}',
          bottomActions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
              ),
              child: InkWell(
                onTap: () {
                  final url = Uri.base.toString();
                  Clipboard.setData(ClipboardData(text: url));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bağlantı kopyalandı')));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.share_outlined, size: 16, color: const Color(0xFF666666)),
                    const SizedBox(width: 8),
                    Text(
                      'Paylaş',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementNotFoundState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.announcement_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('Duyuru bulunamadı', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text(
            'Aradığınız duyuru mevcut değil veya kaldırılmış olabilir.',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0A4A9D).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A4A9D)),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: _fadeAnimation,
            child: const Text(
              'Duyurular yükleniyor...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF374151)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF0A4A9D).withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0A4A9D).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.campaign_outlined, size: 64, color: Color(0xFF0A4A9D)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Henüz duyuru bulunmuyor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Yeni duyurular eklendiğinde burada görünecek',
              style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementList(List<AnnouncementModel> announcements) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Duyurular',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF1F2937)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${announcements.length} duyuru bulundu',
                      style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final announcement = announcements[index];
                  return _buildAnnouncementCard(announcement, index);
                }, childCount: announcements.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(AnnouncementModel announcement, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: _AnnouncementCardContent(announcement: announcement),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tarih belirtilmemiş';

    // Yıl/ay/gün formatında göster
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}

class _AnnouncementCardContent extends StatefulWidget {
  final AnnouncementModel announcement;

  const _AnnouncementCardContent({required this.announcement});

  @override
  State<_AnnouncementCardContent> createState() => _AnnouncementCardContentState();
}

class _AnnouncementCardContentState extends State<_AnnouncementCardContent> {
  bool isHovered = false;
  bool isButtonHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 20),
        transform: Matrix4.identity()..translate(0.0, isHovered ? -4.0 : 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.15 : 0.08),
              blurRadius: isHovered ? 30 : 20,
              offset: Offset(0, isHovered ? 12 : 8),
              spreadRadius: isHovered ? 2 : 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A4A9D).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'DUYURU',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0A4A9D)),
                    ),
                  ),
                  const Spacer(),
                  if (widget.announcement.date != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Color(0xFF6B7280)),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(widget.announcement.date),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6B7280)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.announcement.title ?? 'Başlıksız Duyuru',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.announcement.content ?? 'Açıklama bulunmuyor',
                style: const TextStyle(fontSize: 16, color: Color(0xFF374151), height: 1.6),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  MouseRegion(
                    onEnter: (_) => setState(() => isButtonHovered = true),
                    onExit: (_) => setState(() => isButtonHovered = false),
                    child: InkWell(
                      onTap: () {
                        // Eğer announcement ID varsa detay sayfasına git
                        if (widget.announcement.id != null) {
                          context.go('/announcements/${widget.announcement.id}');
                        }
                      },
                      borderRadius: BorderRadius.circular(25),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        transform: Matrix4.identity()..scale(isButtonHovered ? 1.05 : 1.0),
                        decoration: BoxDecoration(
                          color: isButtonHovered ? const Color(0xFF0056CC) : const Color(0xFF0A4A9D),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0A4A9D).withOpacity(isButtonHovered ? 0.4 : 0.2),
                              blurRadius: isButtonHovered ? 12 : 8,
                              offset: Offset(0, isButtonHovered ? 6 : 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info_outline, size: 16, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Detayları Gör',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tarih belirtilmemiş';

    // Yıl/ay/gün formatında göster
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}
