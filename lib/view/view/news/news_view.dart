import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/view/viewmodel/news/news_view_model.dart';
import 'package:smart_city/view/authentication/test/model/newsmodel/news_model.dart';
import 'package:smart_city/core/components/loading/smart_loading_widget.dart';

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
        
        return SmartLoadingWidget(
          isLoading: viewModel.isLoading,
          hasError: viewModel.hasError,
          errorMessage: viewModel.errorMessage,
          onRetry: viewModel.retry,
          child: _buildContent(viewModel),
        );
      },
    );
  }

  Widget _buildContent(NewsViewModel viewModel) {
    if (viewModel.newsList == null || viewModel.newsList!.isEmpty) {
      return _buildEmptyState();
    }
    
    return _buildNewsList(viewModel.newsList!);
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
}
