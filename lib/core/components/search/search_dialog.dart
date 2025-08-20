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
    _debounceTimer = Timer(const Duration(milliseconds: 1000), () {
      final searchText = _searchController.text.trim();
      if (searchText.isNotEmpty) {
        // Arama metnini normalize et (büyük/küçük harf ve noktalama işareti önemsiz)
        final normalizedSearch = _normalizeSearchText(searchText);
        widget.searchViewModel.search(normalizedSearch);
      } else {
        widget.searchViewModel.clearSearch();
      }
    });
  }

  String _normalizeSearchText(String text) {
    // Türkçe karakterleri normalize et
    return text
        .toLowerCase()
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ı', 'i')
        .replaceAll('ö', 'o')
        .replaceAll('ş', 's')
        .replaceAll('ü', 'u')
        // Noktalama işaretlerini kaldır
        .replaceAll(RegExp(r'[^\w\s]'), '')
        // Fazla boşlukları tek boşluğa çevir
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              blurRadius: 8,
              offset: const Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with Neumorphic Search Bar
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  // Back Button with Neumorphic effect
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(1, 1)),
                        BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 4, offset: const Offset(-1, -1)),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF666666)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Neumorphic Search Bar
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(2, 2)),
                          BoxShadow(color: Colors.white.withOpacity(0.6), blurRadius: 6, offset: const Offset(-2, -2)),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.text,
                        enableSuggestions: false,
                        autocorrect: false,
                        enableIMEPersonalizedLearning: false,
                        smartDashesType: SmartDashesType.disabled,
                        smartQuotesType: SmartQuotesType.disabled,
                        style: const TextStyle(fontSize: 16, color: Color(0xFF333333), fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Şehir hizmetleri, projeler, duyurular, haberler ara...',
                          hintStyle: const TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8E8E8),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.search, color: Color(0xFF666666), size: 20),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8E8E8),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      widget.searchViewModel.clearSearch();
                                    },
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
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

                  // Eğer arama yapılmamışsa kategorileri göster
                  if (!widget.searchViewModel.isSearchActive) {
                    return _buildCategories();
                  }

                  // Eğer arama yapılmışsa sonuçları göster
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

  Widget _buildCategories() {
    return const SingleChildScrollView(
      child: Padding(padding: EdgeInsets.all(20), child: _CategoriesContent()),
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        _navigateToDetail(result);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Resim veya Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: result.imageUrl != null && result.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          result.imageUrl!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildFallbackIcon(result.type ?? '');
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return _buildFallbackIcon(result.type ?? '');
                          },
                        ),
                      )
                    : result.iconUrl != null && result.iconUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              result.iconUrl!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildFallbackIcon(result.type ?? '');
                              },
                            ),
                          )
                        : _buildFallbackIcon(result.type ?? ''),
              ),
              const SizedBox(width: 16),
              // İçerik
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (result.content != null && result.content!.isNotEmpty)
                      Text(
                        result.content!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (result.description != null && result.description!.isNotEmpty)
                      Text(
                        result.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Tip etiketi
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getTypeColor(result.type ?? '').withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getTypeColor(result.type ?? '').withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getTypeLabel(result.type ?? ''),
                        style: TextStyle(
                          color: _getTypeColor(result.type ?? ''),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Ok işareti
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackIcon(String type) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: _getTypeColor(type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getIconForType(type),
        color: _getTypeColor(type),
        size: 24,
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
      case 'event':
        return Icons.event;
      default:
        return Icons.info;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'news':
        return const Color(0xFF10B981);
      case 'announcement':
        return const Color(0xFF0A4A9D);
      case 'project':
        return const Color(0xFFF59E0B);
      case 'city_service':
        return const Color(0xFF8B5CF6);
      case 'event':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'news':
        return 'Haber';
      case 'announcement':
        return 'Duyuru';
      case 'project':
        return 'Proje';
      case 'city_service':
        return 'Hizmet';
      case 'event':
        return 'Etkinlik';
      default:
        return 'Diğer';
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

class _CategoriesContent extends StatelessWidget {
  const _CategoriesContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(1, 1)),
              BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 4, offset: const Offset(-1, -1)),
            ],
          ),
          child: const Text(
            'Ne arıyorsunuz?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF333333)),
          ),
        ),
        const SizedBox(height: 20),
        // İlk satır - Duyurular ve Haberler
        SizedBox(
          height: 125,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _CategoryIconCard(
                    icon: Icons.campaign,
                    label: 'Duyurular',
                    subtitle: 'Önemli duyuruları ara',
                    color: Color(0xFF0A4A9D),
                    onTap: () => context.go('/announcements-detail'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _CategoryIconCard(
                    icon: Icons.article,
                    label: 'Haberler',
                    subtitle: 'Güncel haberleri ara',
                    color: Color(0xFF10B981),
                    onTap: () => context.go('/news-detail'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // İkinci satır - Etkinlikler ve Şehir Hizmetleri
        SizedBox(
          height: 125,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _CategoryIconCard(
                    icon: Icons.event,
                    label: 'Etkinlikler',
                    subtitle: 'Yaklaşan etkinlikleri ara',
                    color: Color(0xFFF59E0B),
                    onTap: () => context.go('/events-detail'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _CategoryIconCard(
                    icon: Icons.location_city,
                    label: 'Şehir Hizmetleri',
                    subtitle: 'Şehir hizmetlerini ara',
                    color: Color(0xFF8B5CF6),
                    onTap: () => context.go('/city-services-detail'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Üçüncü satır - Projeler (ortalanmış)
        SizedBox(
          height: 125,
          child: Row(
            children: [
              const Spacer(flex: 1),
              Expanded(
                flex: 2,
                child: _CategoryIconCard(
                  icon: Icons.construction,
                  label: 'Projeler',
                  subtitle: 'Şehir projelerini ara',
                  color: Color(0xFFEF4444),
                  onTap: () => context.go('/projects-detail'),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryIconCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CategoryIconCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<_CategoryIconCard> createState() => _CategoryIconCardState();
}

class _CategoryIconCardState extends State<_CategoryIconCard> with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _translateAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _translateAnimation = Tween<double>(
      begin: 0.0,
      end: -2.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _shadowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool hovered) {
    if (hovered != isHovered) {
      setState(() => isHovered = hovered);
      if (hovered) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        highlightColor: widget.color.withOpacity(0.1),
        splashColor: widget.color.withOpacity(0.2),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..translate(0.0, _translateAnimation.value)
                ..scale(_scaleAnimation.value),
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isHovered ? widget.color.withOpacity(0.3) : const Color(0xFFE0E0E0),
                    width: isHovered ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.08 + (_shadowAnimation.value * 0.07)),
                      blurRadius: 12 + (_shadowAnimation.value * 8),
                      offset: Offset(0, 4 + (_shadowAnimation.value * 4)),
                      spreadRadius: _shadowAnimation.value * 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withOpacity(0.3 + (_shadowAnimation.value * 0.3)),
                              blurRadius: 8 + (_shadowAnimation.value * 8),
                              offset: Offset(0, 4 + (_shadowAnimation.value * 4)),
                            ),
                          ],
                        ),
                        child: Icon(widget.icon, color: Colors.white, size: 20 + (_shadowAnimation.value * 2)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: 14 + (_shadowAnimation.value * 1),
                          fontWeight: FontWeight.w700,
                          color: widget.color,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: 10 + (_shadowAnimation.value * 1),
                          color: const Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
