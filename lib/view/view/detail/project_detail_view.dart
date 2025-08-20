import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/view/viewmodel/project/project_view_model.dart';
import 'package:smart_city/view/authentication/test/model/project/project_model.dart';
import 'package:smart_city/core/components/app_bar/main_app_bar.dart';
import 'package:smart_city/core/components/cards/hover_card.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/core/components/detail/hero_detail_scaffold.dart';
import 'package:flutter/services.dart';


class ProjectDetailView extends StatefulWidget {
  final int? projectId;
  const ProjectDetailView({super.key, this.projectId});

  @override
  State<ProjectDetailView> createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<ProjectDetailView> with TickerProviderStateMixin {
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
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
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
      final viewModel = Provider.of<ProjectViewModel>(context, listen: false);
      if (widget.projectId != null) {
        viewModel.getProjectById(widget.projectId!);
      } else {
        viewModel.fetchProjects();
      }
      _initialized = true;
      
      // Animasyonları başlat
      _fadeController.forward();
      _slideController.forward();
    }
  }

  // Arama fonksiyonu
  List<ProjectModel> _filterProjects(List<ProjectModel> projects) {
    if (_searchQuery.isEmpty) return projects;

    return projects.where((project) {
      final query = _searchQuery.toLowerCase();
      return project.title?.toLowerCase().contains(query) == true ||
          project.description?.toLowerCase().contains(query) == true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const MainAppBar(
        isTransparent: false,
        onNavTap: null,
        activeItemOverride: 'Projeler',
        showOnlyActiveItem: true,
        showBackButton: true,
      ),
      body: Observer(
        builder: (context) {
          final viewModel = Provider.of<ProjectViewModel>(context, listen: false);

          if (viewModel.isLoading) {
            return _buildLoadingState();
          }

          if (widget.projectId != null) {
            if (viewModel.singleProject == null) {
              return _buildProjectNotFoundState();
            }
            return _buildSingleProjectView(viewModel.singleProject!);
          }

          if (viewModel.projectList == null || viewModel.projectList!.isEmpty) {
            return _buildEmptyState();
          }

          final projects = _filterProjects(viewModel.projectList!);

          return _buildProjectList(projects);
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
              color: const Color(0xFF06B6D4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF06B6D4)),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: _fadeAnimation,
            child: const Text(
              'Projeler yükleniyor...',
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
                color: const Color(0xFF06B6D4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.work_outline, size: 64, color: Color(0xFF06B6D4)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Henüz proje bulunmuyor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Yeni projeler eklendiğinde burada görünecek',
              style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectList(List<ProjectModel> projects) {
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
                      'Tüm Projeler',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF1F2937)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${projects.length} proje bulundu',
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
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final project = projects[index];
                    return _buildProjectCard(project, index);
                  },
                  childCount: projects.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
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
            hintText: 'Proje ara...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(ProjectModel project, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: HoverCard(
              imageUrl: project.imageUrl,
              title: project.title ?? 'Başlık Yok',
              description: project.description ?? 'Açıklama yok',
              date: null,
              location: null,
              cardType: CardType.project,
              statusText: 'PROJE',
              statusColor: const Color(0xFF06B6D4),
              statusIcon: Icons.engineering,
              onTap: () => context.go('/projects/${project.id ?? ''}'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectNotFoundState() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF06B6D4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.work_outline, size: 64, color: Color(0xFF06B6D4)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Proje bulunamadı',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Aradığınız proje mevcut değil veya kaldırılmış olabilir.',
              style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleProjectView(ProjectModel project) {
    final String? resolvedImage = (project.imageUrl != null && project.imageUrl!.isNotEmpty)
        ? _buildFullImageUrl(project.imageUrl!)
        : null;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: HeroDetailScaffold(
          title: project.title ?? 'Başlık Yok',
          imageUrl: resolvedImage,
          location: 'Erzurum',
          description: project.description,
          heroTag: 'project_${project.id ?? project.title ?? ''}',
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

  String _buildFullImageUrl(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }
    if (imageUrl.startsWith('/')) {
      return 'https://localhost:7276$imageUrl';
    }
    return 'https://localhost:7276/upload/$imageUrl';
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
} 