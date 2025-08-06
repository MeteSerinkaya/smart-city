import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/view/viewmodel/search/search_view_model.dart';
import 'package:smart_city/view/authentication/test/model/searchmodel/search_model.dart';

class SearchDialog extends StatefulWidget {
  final SearchViewModel searchViewModel;

  const SearchDialog({super.key, required this.searchViewModel});

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  final bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Auto-focus the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Şehir hizmetleri, projeler, duyurular, haberler ara...',
                        border: InputBorder.none,
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  widget.searchViewModel.clearSearch();
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Observer(
                builder: (_) {
                  if (widget.searchViewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildSuggestionCard('Haberler', 'Güncel haberleri ara', Icons.article, const Color(0xFF10B981)),
                _buildSuggestionCard('Duyurular', 'Önemli duyuruları ara', Icons.campaign, const Color(0xFF0A4A9D)),
                _buildSuggestionCard('Projeler', 'Şehir projelerini ara', Icons.work_outline, const Color(0xFFF59E0B)),
                _buildSuggestionCard(
                  'Şehir Hizmetleri',
                  'Akıllı şehir hizmetlerini ara',
                  Icons.apps,
                  const Color(0xFF8B5CF6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          _searchController.text = title;
          widget.searchViewModel.search(title);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Sonuç bulunamadı',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            '"${widget.searchViewModel.currentQuery}" için sonuç bulunamadı',
            style: TextStyle(color: Colors.grey.shade500),
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
        if (widget.searchViewModel.eventResults.isNotEmpty) ...[
          _buildSectionHeader('Etkinlikler', Icons.event, const Color(0xFFEF4444)),
          ...widget.searchViewModel.eventResults.map((result) => _buildResultCard(result)),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(SearchModel result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: result.imageUrl != null || result.iconUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  result.imageUrl ?? result.iconUrl ?? '',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
                      child: Icon(_getIconForType(result.type ?? ''), color: Colors.grey.shade600, size: 20),
                    );
                  },
                ),
              )
            : Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
                child: Icon(_getIconForType(result.type ?? ''), color: Colors.grey.shade600, size: 20),
              ),
        title: Text(
          result.title ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result.content != null && result.content!.isNotEmpty)
              Text(
                result.content!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            if (result.description != null && result.description!.isNotEmpty)
              Text(
                result.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
          ],
        ),
        onTap: () {
          Navigator.of(context).pop();
          _navigateToDetail(result);
        },
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
