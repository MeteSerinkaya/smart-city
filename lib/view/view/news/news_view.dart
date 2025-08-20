import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/core/components/skeleton/shimmer.dart';
import 'package:smart_city/core/components/cards/unified_info_card.dart';
import 'package:smart_city/core/components/carousel/sliding_window_carousel.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/view/viewmodel/news/news_view_model.dart';
import 'package:smart_city/view/authentication/test/model/newsmodel/news_model.dart';
import 'package:smart_city/core/components/particles/particle_background.dart';

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final viewModel = Provider.of<NewsViewModel>(context, listen: false);
      viewModel.fetchNews();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final viewModel = Provider.of<NewsViewModel>(context, listen: false);

        if (viewModel.isLoading) {
          return _buildLoadingState();
        }

        if (viewModel.hasError) {
          return _buildErrorState(viewModel);
        }

        if (viewModel.newsList == null || viewModel.newsList!.isEmpty) {
          return _buildEmptyState();
        }

        return _buildNewsSection(viewModel.newsList!);
      },
    );
  }

  Widget _buildLoadingState() {
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
                  'HABERLER',
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
          itemBuilder: (context, index) => _newsSkeletonCard(),
        );
      },
    );
  }

  Widget _newsSkeletonCard() {
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
            // Image placeholder
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
              ),
            ),
            // Content placeholder
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F9FF),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 6),
                      SkeletonLine(widthFactor: 0.9, height: 14),
                      SizedBox(height: 10),
                      SkeletonLine(widthFactor: 1.0, height: 12),
                      SizedBox(height: 6),
                      SkeletonLine(widthFactor: 0.75, height: 12),
                      Spacer(),
                      SkeletonLine(widthFactor: 0.6, height: 10),
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

  Widget _buildErrorState(NewsViewModel viewModel) {
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
            viewModel.errorMessage ?? 'Haberler yüklenirken bir sorun oluştu',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => viewModel.retryFetchNews(),
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF59E0B), foregroundColor: Colors.white),
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
              color: const Color(0xFFF59E0B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.article_outlined, size: 48, color: Color(0xFFF59E0B)),
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz haber bulunmuyor',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: const Color(0xFF374151), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Yeni haberler eklendiğinde burada görünecek',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList(List<NewsModel> news) {
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
            crossAxisSpacing: 24, // Standardized spacing
            mainAxisSpacing: 24, // Standardized spacing
            childAspectRatio: 0.75, // Standardized aspect ratio for consistent card proportions
          ),
          itemCount: news.length,
          itemBuilder: (context, index) {
            final newsItem = news[index];
            return _buildNewsCard(newsItem);
          },
        );
      },
    );
  }

  Widget _buildNewsCarousel(List<NewsModel> news) {
    return SlidingWindowCarousel<NewsModel>(
      items: news,
      maxVisible: 3,
      enableLoop: true,
      gap: 24,
      itemAspectRatio: 0.9,
      itemBuilder: (context, item, index) =>
          Padding(padding: const EdgeInsets.only(bottom: 4), child: _buildNewsCard(item)),
    );
  }

  Widget _buildNewsCard(NewsModel news) {
    final String? content = news.content;
    final String readingTime = _estimateReadingTime(content);

    return UnifiedInfoCard(
      imageUrl: news.imageUrl,
      fallbackIcon: Icons.article,
      title: news.title ?? 'Başlık Yok',
      description: content,
      contentPadding: const EdgeInsets.all(16),
      actionIconsTopRight: const [
        _ActionIcon(icon: Icons.share_outlined, tooltip: 'Paylaş'),
        SizedBox(width: 8),
        _ActionIcon(icon: Icons.bookmark_border, tooltip: 'Kaydet'),
      ],
      bottomRowChildren: [
        Icon(Icons.access_time, size: 12, color: Colors.black.withOpacity(0.5)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            _formatDate(news.publishedAt),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black.withOpacity(0.5), fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.menu_book_outlined, size: 12, color: Colors.black.withOpacity(0.5)),
        const SizedBox(width: 4),
        Text(
          readingTime,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.black.withOpacity(0.6),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton.icon(
          onPressed: () => context.go('/news/${news.id ?? ''}'),
          icon: const Icon(Icons.arrow_forward, size: 16),
          label: const Text('Detay'),
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF0A4A9D)),
        ),
      ],
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

  String _estimateReadingTime(String? text) {
    if (text == null || text.trim().isEmpty) return '1 dk';
    final words = text.trim().split(RegExp(r'\s+')).length;
    final minutes = (words / 200).ceil().clamp(1, 60);
    return '$minutes dk';
  }

  Widget _buildSeeAllButton(bool isMobile) {
    bool hovered = false;
    return StatefulBuilder(
      builder: (context, setLocal) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setLocal(() => hovered = true),
          onExit: (_) => setLocal(() => hovered = false),
          child: GestureDetector(
            onTap: () => context.go('/news-detail'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              transform: Matrix4.identity()..translate(0.0, hovered ? -2.0 : 0.0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                boxShadow: hovered
                    ? [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 3))]
                    : [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('asset/icons/newspaper-folded.png', width: 16, height: 16, color: Colors.white),
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
        'Daha fazla haber için takipte kalın',
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

  Widget _buildNewsSection(List<NewsModel> news) {
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
                      'HABERLER',
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

                // Haberler Kaydırmalı Pencere
                _buildNewsCarousel(news),

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
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  const _ActionIcon({required this.icon, required this.tooltip, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
