import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/view/viewmodel/search/search_view_model.dart';
import 'package:smart_city/view/authentication/test/model/searchmodel/search_model.dart';

class SearchView extends StatefulWidget {
  final SearchViewModel searchViewModel;

  const SearchView({super.key, required this.searchViewModel});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      widget.searchViewModel.search(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arama'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Şehir hizmetleri, projeler, duyurular, haberler ara...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          widget.searchViewModel.clearSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0A4A9D), width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),
          // Search Results
          Expanded(
            child: Observer(
              builder: (_) {
                if (widget.searchViewModel.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!widget.searchViewModel.isSearchActive) {
                  return _buildSearchSuggestions();
                }

                if (!widget.searchViewModel.hasResults) {
                  return _buildNoResults();
                }

                return _buildSearchResults();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ne arıyorsunuz?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          _buildSuggestionCard('Haberler', 'Güncel haberleri ara', Icons.article, const Color(0xFF10B981)),
          _buildSuggestionCard('Duyurular', 'Önemli duyuruları ara', Icons.campaign, const Color(0xFF0A4A9D)),
          _buildSuggestionCard('Projeler', 'Şehir projelerini ara', Icons.work_outline, const Color(0xFFF59E0B)),
          _buildSuggestionCard('Şehir Hizmetleri', 'Akıllı şehir hizmetlerini ara', Icons.apps, const Color(0xFF8B5CF6)),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        onTap: () {
          _searchController.text = title;
          widget.searchViewModel.search(title);
        },
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Sonuç bulunamadı',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '"${widget.searchViewModel.currentQuery}" için sonuç bulunamadı',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (widget.searchViewModel.newsResults.isNotEmpty) ...[
          _buildSectionHeader('Haberler', Icons.article, const Color(0xFF10B981)),
          ...widget.searchViewModel.newsResults.map((result) => _buildResultCard(result)),
        ],
        if (widget.searchViewModel.announcementResults.isNotEmpty) ...[
          _buildSectionHeader('Duyurular', Icons.campaign, const Color(0xFF0A4A9D)),
          ...widget.searchViewModel.announcementResults.map((result) => _buildResultCard(result)),
        ],
        if (widget.searchViewModel.projectResults.isNotEmpty) ...[
          _buildSectionHeader('Projeler', Icons.work_outline, const Color(0xFFF59E0B)),
          ...widget.searchViewModel.projectResults.map((result) => _buildResultCard(result)),
        ],
        if (widget.searchViewModel.cityServiceResults.isNotEmpty) ...[
          _buildSectionHeader('Şehir Hizmetleri', Icons.apps, const Color(0xFF8B5CF6)),
          ...widget.searchViewModel.cityServiceResults.map((result) => _buildResultCard(result)),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(SearchModel result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: result.imageUrl != null || result.iconUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  result.imageUrl ?? result.iconUrl ?? '',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getIconForType(result.type ?? ''),
                        color: Colors.grey.shade600,
                      ),
                    );
                  },
                ),
              )
            : Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconForType(result.type ?? ''),
                  color: Colors.grey.shade600,
                ),
              ),
        title: Text(
          result.title ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result.content != null && result.content!.isNotEmpty)
              Text(
                result.content!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            if (result.description != null && result.description!.isNotEmpty)
              Text(
                result.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            if (result.publishedAt != null || result.date != null)
              Text(
                _formatDate(result.publishedAt ?? result.date),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        onTap: () => _navigateToDetail(result),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'news':
        return Icons.article;
      case 'announcement':
        return Icons.campaign;
      case 'project':
        return Icons.work_outline;
      case 'city_service':
        return Icons.apps;
      default:
        return Icons.info;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToDetail(SearchModel result) {
    switch (result.type) {
      case 'news':
        context.go('/news-detail');
        break;
      case 'announcement':
        context.go('/announcements-detail');
        break;
      case 'project':
        context.go('/projects-detail');
        break;
      case 'city_service':
        context.go('/city-services-detail');
        break;
    }
  }
} 