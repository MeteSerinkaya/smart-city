import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/view/viewmodel/announcement/announcement_view_model.dart';
import 'package:smart_city/view/authentication/test/model/announcementmodel/announcement_model.dart';

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
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6))),
          const SizedBox(height: 16),
          Text(
            'Duyurular yükleniyor...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280)),
          ),
        ],
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
            ),
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 64, vertical: isMobile ? 32 : 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ana Başlık
            Text(
              'DUYURULAR',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.w700,
                color: Colors.white, // Changed to white for better contrast
              ),
            ),
            const SizedBox(height: 32),

            // Duyuru Listesi
            ...announcements.take(6).map((announcement) {
              final index = announcements.indexOf(announcement);
              return _buildAnnouncementItem(announcement, index, isMobile);
            }),

            const SizedBox(height: 48),

            // TÜMÜNÜ GÖRÜNTÜLE Bölümü
            _buildSeeAllSection(isMobile),

            const SizedBox(height: 32),

            // Footer Text
            _buildFooterText(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementItem(AnnouncementModel announcement, int index, bool isMobile) {
    final isLarge = index % 2 == 0; // Alternatif başlık stilleri

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık
        Text(
          announcement.title ?? 'Başlık Yok',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: isLarge
                ? (isMobile ? 20 : 24) // H1 style
                : (isMobile ? 18 : 22), // H2 style
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),

        // Tarih
        Text(
          _formatDate(announcement.date),
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: isMobile ? 12 : 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 16),

        // Divider (son item hariç)
        if (index < 5) // İlk 6 item için divider
          const Divider(color: Color(0xFFE5E7EB), height: 1, thickness: 1),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSeeAllSection(bool isMobile) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Tüm duyuruları göster
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tüm duyurular gösteriliyor...')));
          // TODO: Burada tüm duyuruları gösteren bir sayfaya yönlendirme yapılabilir
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFF3B82F6), width: 1)),
          ),
          child: Text(
            'TÜMÜNÜ GÖRÜNTÜLE',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3B82F6),
            ),
          ),
        ),
      ),
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
            color: const Color(0xFF9CA3AF),
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
