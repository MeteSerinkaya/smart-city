import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/view/viewmodel/news/news_view_model.dart';
import 'package:smart_city/view/authentication/test/model/newsmodel/news_model.dart';

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
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
          ),
          const SizedBox(height: 16),
          Text(
            'Haberler yükleniyor...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
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
            child: const Icon(
              Icons.error_outline,
              size: 48,
              color: Color(0xFFEF4444),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Bir hata oluştu',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF374151),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            viewModel.errorMessage ?? 'Haberler yüklenirken bir sorun oluştu',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => viewModel.retryFetchNews(),
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
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
              color: const Color(0xFFF59E0B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.article_outlined,
              size: 48,
              color: Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz haber bulunmuyor',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF374151),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yeni haberler eklendiğinde burada görünecek',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList(List<NewsModel> news) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: news.length,
      itemBuilder: (context, index) {
        final newsItem = news[index];
        return _buildNewsCard(newsItem);
      },
    );
  }

  Widget _buildNewsCard(NewsModel news) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resim
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: news.imageUrl != null && news.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        news.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            child: const Icon(
                              Icons.article,
                              color: Color(0xFFF59E0B),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(16),
                      child: const Icon(
                        Icons.article,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            // İçerik
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title ?? 'Başlık Yok',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (news.content != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      news.content!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: const Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(news.publishedAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Haber',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFFF59E0B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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

  Widget _buildSeeAllSection(bool isMobile) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF59E0B),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'TÜMÜNÜ GÖRÜNTÜLE',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
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
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Container(
        color: const Color(0xFF2C2C2C), // Changed to #2c2c2c
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 64, vertical: isMobile ? 32 : 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ana Başlık
            Text(
              'HABERLER',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.w700,
                color: Colors.white, // Changed to white for better contrast
              ),
            ),
            const SizedBox(height: 32),

            // Haber Listesi
            _buildNewsList(news),

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
}
