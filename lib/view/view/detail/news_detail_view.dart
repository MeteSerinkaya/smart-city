import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/view/viewmodel/news/news_view_model.dart';
import 'package:smart_city/view/authentication/test/model/newsmodel/news_model.dart';
import 'package:smart_city/core/components/app_bar/main_app_bar.dart';
import 'package:smart_city/core/components/cards/hover_card.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/core/components/detail/hero_detail_scaffold.dart';
import 'package:flutter/services.dart';


class NewsDetailView extends StatefulWidget {
  final int? newsId;
  const NewsDetailView({super.key, this.newsId});

  @override
  State<NewsDetailView> createState() => _NewsDetailViewState();
}

class _NewsDetailViewState extends State<NewsDetailView> with TickerProviderStateMixin {
  bool _initialized = false;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Search için state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final viewModel = Provider.of<NewsViewModel>(context, listen: false);

      // Eğer newsId varsa tek haber getir, yoksa tüm haberleri getir
      if (widget.newsId != null) {
        viewModel.getNewsById(widget.newsId!);
      } else {
        viewModel.fetchNews();
      }

      _initialized = true;

      // Animasyonları başlat
      _fadeController.forward();
      _slideController.forward();
    }
  }

  // Arama fonksiyonu
  List<NewsModel> _filterNews(List<NewsModel> newsList) {
    if (_searchQuery.isEmpty) return newsList;

    return newsList.where((news) {
      final query = _searchQuery.toLowerCase();
      return news.title?.toLowerCase().contains(query) == true || news.content?.toLowerCase().contains(query) == true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const MainAppBar(
        isTransparent: false,
        onNavTap: null,
        activeItemOverride: 'Haberler',
        showOnlyActiveItem: true,
        showBackButton: true,
      ),
      body: Observer(
        builder: (context) {
          final viewModel = Provider.of<NewsViewModel>(context, listen: false);

          if (viewModel.isLoading) {
            return _buildLoadingState();
          }

          // Eğer newsId varsa tek haber göster
          if (widget.newsId != null) {
            if (viewModel.singleNews == null) {
              return _buildNewsNotFoundState();
            }
            return _buildSingleNewsView(viewModel.singleNews!);
          }

          // Eğer newsId yoksa tüm haberleri göster
          if (viewModel.newsList == null || viewModel.newsList!.isEmpty) {
            return _buildEmptyState();
          }

          final newsList = _filterNews(viewModel.newsList!);

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
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
                            'Haberler',
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF1F2937)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${newsList.length} haber bulundu',
                            style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  // Search Bar
                  SliverToBoxAdapter(child: _buildSearchBar()),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final news = newsList[index];
                        return _buildNewsCard(news, index);
                      }, childCount: newsList.length),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            ),
          );
        },
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
              color: const Color(0xFF00A8E8).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00A8E8)),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: _fadeAnimation,
            child: const Text(
              'Haberler yükleniyor...',
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
                color: const Color(0xFF00A8E8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00A8E8).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.article_outlined, size: 64, color: Color(0xFF00A8E8)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Henüz haber bulunmuyor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Yeni haberler eklendiğinde burada görünecek',
              style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsNotFoundState() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF00A8E8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00A8E8).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.article_outlined, size: 64, color: Color(0xFF00A8E8)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Haber bulunamadı',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Aradığınız haber mevcut değil veya kaldırılmış olabilir.',
              style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleNewsView(NewsModel news) {
    final DateTime? publishedDate = news.publishedAt;
    final String? resolvedImage = (news.imageUrl != null && news.imageUrl!.isNotEmpty)
        ? _buildFullImageUrl(news.imageUrl!)
        : null;

    // Format date for display
    final String? formattedDate = publishedDate != null 
        ? '${publishedDate.day.toString().padLeft(2, '0')}/${publishedDate.month.toString().padLeft(2, '0')}/${publishedDate.year}'
        : null;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: HeroDetailScaffold(
          title: news.title ?? 'Başlık Yok',
          imageUrl: resolvedImage,
          date: formattedDate,
          description: news.content,
          heroTag: 'news_${news.id ?? news.title ?? ''}',
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bağlantı kopyalandı')),
                  );
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

  Widget _buildNewsCard(NewsModel news, int index) {
    final DateTime? publishedDate = news.publishedAt;
    final bool isRecent = publishedDate != null && DateTime.now().difference(publishedDate).inDays <= 7;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: HoverCard(
              imageUrl: news.imageUrl,
              title: news.title ?? 'Başlık Yok',
              description: news.content ?? 'İçerik yok',
              date: publishedDate,
              location: null,
              cardType: CardType.news,
              statusText: isRecent ? 'YENİ' : 'ESKİ',
              statusColor: isRecent ? const Color(0xFF00A8E8) : Colors.grey[400],
              statusIcon: isRecent ? Icons.new_releases : Icons.schedule,
              onTap: () => context.go('/news/${news.id ?? ''}'),
            ),
          ),
        );
      },
    );
  }

  Widget _infoChip(IconData icon, String text, {Color? bg, Color? fg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg ?? const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: fg ?? const Color(0xFF374151)),
        const SizedBox(width: 8),
        Text(text,
            style: TextStyle(
              color: fg ?? const Color(0xFF374151),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            )),
      ]),
    );
  }

  String _buildFullImageUrl(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }
    if (imageUrl.startsWith('/')) {
      return 'https://localhost:7276$imageUrl';
    }
    return 'https://localhost:7276/upload/$imageUrl';
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(32, 0, 32, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Haber ara...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }
}
