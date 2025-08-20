import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/view/viewmodel/project/project_view_model.dart';
import 'package:smart_city/view/authentication/test/model/project/project_model.dart';
import 'package:smart_city/core/components/cards/unified_info_card.dart';
import 'package:smart_city/core/components/carousel/sliding_window_carousel.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/core/components/particles/particle_background.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final viewModel = Provider.of<ProjectViewModel>(context, listen: false);
      viewModel.fetchProjects();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final viewModel = Provider.of<ProjectViewModel>(context, listen: false);

        if (viewModel.isLoading) {
          return _buildLoadingState();
        }

        if (viewModel.hasError) {
          return _buildErrorState(viewModel);
        }

        if (viewModel.projectList == null || viewModel.projectList!.isEmpty) {
          return _buildEmptyState();
        }

        return _buildProjectSectionWithHeader(viewModel.projectList!);
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
            'Projeler yükleniyor...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ProjectViewModel viewModel) {
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
            viewModel.errorMessage ?? 'Projeler yüklenirken bir sorun oluştu',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => viewModel.retryFetchProjects(),
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), foregroundColor: Colors.white),
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
            child: const Icon(Icons.work_outline, size: 48, color: Color(0xFF3B82F6)),
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz proje bulunmuyor',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: const Color(0xFF374151), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Yeni projeler eklendiğinde burada görünecek',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectSectionWithHeader(List<ProjectModel> projects) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

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
                      'PROJELER',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: isMobile ? 28 : 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    _buildSeeAllButton(context, isMobile),
                  ],
                ),
                const SizedBox(height: 32),

                // Projeler Kaydırmalı Pencere
                _buildProjectCarousel(projects),

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

  Widget _buildProjectSection(List<ProjectModel> projects) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

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
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return _buildProjectCard(project);
          },
        );
      },
    );
  }

  Widget _buildProjectGrid(List<ProjectModel> projects) {
    return SlidingWindowCarousel<ProjectModel>(
      items: projects,
      maxVisible: 3,
      enableLoop: true,
      gap: 24,
      itemAspectRatio: 0.9,
      itemBuilder: (context, project, index) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: _buildProjectCard(project),
      ),
    );
  }

  Widget _buildProjectCarousel(List<ProjectModel> projects) => _buildProjectGrid(projects);

  Widget _buildProjectCard(ProjectModel project) {
    return UnifiedInfoCard(
      imageUrl: project.imageUrl,
      fallbackIcon: Icons.work_outline,
      title: project.title ?? 'Başlıksız Proje',
      description: project.description,
      contentPadding: const EdgeInsets.all(16),
      bottomRowChildren: [
        const Icon(Icons.check_circle, size: 12, color: Color(0xFF10B981)),
        const SizedBox(width: 4),
        const Expanded(
          child: Text('Aktif', style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
        ),
        TextButton.icon(
          onPressed: () => context.go('/projects/${project.id ?? ''}') ,
          icon: const Icon(Icons.arrow_forward, size: 16),
          label: const Text('Detay'),
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF0A4A9D)),
        ),
      ],
    );
  }

  Widget _buildSeeAllButton(BuildContext context, bool isMobile) {
    bool hovered = false;
    return StatefulBuilder(builder: (context, setLocal) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setLocal(() => hovered = true),
        onExit: (_) => setLocal(() => hovered = false),
        child: GestureDetector(
          onTap: () => context.go('/projects-detail'),
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
                Image.asset(
                  'asset/icons/project-management.png',
                  width: 16,
                  height: 16,
                  color: Colors.white,
                  colorBlendMode: BlendMode.srcIn,
                ),
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
    });
  }

  Widget _buildFooterText() {
    return Center(
      child: Text(
        'Daha fazla proje için takipte kalın',
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
}
