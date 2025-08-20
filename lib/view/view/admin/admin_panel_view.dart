import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:smart_city/view/viewmodel/announcement/announcement_view_model.dart';
import 'package:smart_city/view/authentication/test/model/announcementmodel/announcement_model.dart';
import 'package:smart_city/view/viewmodel/city/city_service_view_model.dart';
import 'package:smart_city/view/authentication/test/model/citymodel/city_service_model.dart';
import 'package:smart_city/view/viewmodel/event/event_view_model.dart';
import 'package:smart_city/view/authentication/test/model/eventmodel/event_model.dart';
import 'package:smart_city/view/viewmodel/news/news_view_model.dart';
import 'package:smart_city/view/authentication/test/model/newsmodel/news_model.dart';
import 'package:smart_city/view/authentication/test/model/project/project_model.dart';
import 'package:smart_city/view/viewmodel/heroimage/hero_image_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/view/view/admin/hero_image_management.dart';
import 'package:smart_city/view/viewmodel/project/project_view_model.dart';
import 'package:smart_city/core/components/admin/admin_table_card.dart';
import 'package:smart_city/view/viewmodel/admin_user/admin_user_view_model.dart';
import 'package:smart_city/view/authentication/test/model/adminuser/admin_user_model.dart';
import 'package:smart_city/view/authentication/test/model/adminuser/create_admin_user_model.dart';
import 'package:smart_city/core/init/cache/locale_manager.dart';
import 'package:smart_city/core/constants/enums/locale_keys_enum.dart';

class AdminPanelView extends StatefulWidget {
  const AdminPanelView({super.key});

  @override
  State<AdminPanelView> createState() => _AdminPanelViewState();
}

class _AdminPanelViewState extends State<AdminPanelView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final announcementViewModel = Provider.of<AnnouncementViewModel>(context, listen: false);
    final eventViewModel = Provider.of<EventViewModel>(context, listen: false);
    final newsViewModel = Provider.of<NewsViewModel>(context, listen: false);
    final cityServiceViewModel = Provider.of<CityServiceViewModel>(context, listen: false);
    final heroImageViewModel = Provider.of<HeroImageViewModel>(context, listen: false);
    final projectViewModel = Provider.of<ProjectViewModel>(context, listen: false);
    final adminUserViewModel = Provider.of<AdminUserViewModel>(context, listen: false);

    adminUserViewModel.fetchAdminUsers();

    announcementViewModel.fetchAnnouncement();
    eventViewModel.fetchEvents();
    newsViewModel.fetchNews();
    cityServiceViewModel.fetchCityService();
    heroImageViewModel.fetchHeroImages();
    projectViewModel.fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFFF8FAFC), const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
          ),
        ),
        child: Row(
          children: [
            // Sidebar
            _buildSidebar(),
            // Main Content
            Expanded(
              child: Column(
                children: [
                  // Custom Header with Logout
                  _buildCustomHeader(context),
                  // Main Content
                  Expanded(child: _buildMainContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.85)],
        ),
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Admin Panel Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF3B82F6).withOpacity(0.2), const Color(0xFF3B82F6).withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.admin_panel_settings, color: Color(0xFF3B82F6), size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Kurumsal Panel',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          // Logout Button
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFEF4444).withOpacity(0.1), const Color(0xFFEF4444).withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3), width: 1),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Çıkış Yap'),
                      content: const Text('Kurumsal panelden çıkmak istediğinize emin misiniz?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Vazgeç')),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);

                            // Clear JWT token and admin status
                            await LocaleManager.instance.setStringValue(PreferencesKeys.TOKEN, '');
                            await LocaleManager.instance.setBoolValue(PreferencesKeys.IS_ADMIN, false);

                            // Navigate to home page
                            context.go('/home');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4444),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Çıkış Yap'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout, color: Color(0xFFEF4444), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Çıkış Yap',
                        style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.9)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 10), spreadRadius: 0),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 60,
            offset: const Offset(0, 20),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFF0F172A), const Color(0xFF1E293B), const Color(0xFF334155)],
              ),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
              boxShadow: [
                BoxShadow(color: const Color(0xFF1E3A8A).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.15)]),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                  ),
                  child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kurumsal Panel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Yönetim Merkezi',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildMenuItem(icon: Icons.dashboard, title: 'Dashboard', index: 0),
                _buildMenuItem(icon: Icons.campaign, title: 'Duyurular', index: 1),
                _buildMenuItem(icon: Icons.event, title: 'Etkinlikler', index: 2),
                _buildMenuItem(icon: Icons.article, title: 'Haberler', index: 3),
                _buildMenuItem(icon: Icons.apps, title: 'Şehir Hizmetleri', index: 4),
                _buildMenuItem(icon: Icons.work_outline, title: 'Projeler', index: 5),
                _buildMenuItem(icon: Icons.image, title: 'Hero Resimler', index: 6),
                _buildMenuItem(icon: Icons.people, title: 'Kullanıcılar', index: 7),
                _buildMenuItem(icon: Icons.settings, title: 'Ayarlar', index: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required int index, bool isLogout = false}) {
    final isSelected = _selectedIndex == index;
    final color = isLogout ? const Color(0xFFEF4444) : const Color(0xFF64748B);
    final selectedColor = isLogout ? const Color(0xFFEF4444) : const Color(0xFF3B82F6);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [selectedColor.withOpacity(0.15), selectedColor.withOpacity(0.08)],
                    )
                  : null,
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(color: selectedColor.withOpacity(0.3), width: 1.5)
                  : Border.all(color: Colors.transparent, width: 1.5),
              boxShadow: isSelected
                  ? [BoxShadow(color: selectedColor.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? selectedColor.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: isSelected ? selectedColor : color, size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? selectedColor : color,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 15,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: selectedColor, shape: BoxShape.circle),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildAnnouncements();
      case 2:
        return _buildEvents();
      case 3:
        return _buildNews();
      case 4:
        return _buildCityServices();
      case 5:
        return _buildProjects();
      case 6:
        return const HeroImageManagement();
      case 7:
        return _buildUsers();
      case 8:
        return _buildSettings();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text('Dashboard', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Akıllı Şehir yönetim paneli',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFF6B7280)),
            ),
            const SizedBox(height: 32),

            // Stats Cards
            _buildStatsSection(),
            const SizedBox(height: 32),

            // Charts Section
            _buildChartsSection(),
            const SizedBox(height: 32),

            // Recent Activity
            _buildRecentActivity(),

            // Bottom padding for better scroll experience
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Consumer5<AnnouncementViewModel, EventViewModel, NewsViewModel, CityServiceViewModel, ProjectViewModel>(
          builder: (context, announcementVM, eventVM, newsVM, cityServiceVM, projectVM, child) {
            return Observer(
              builder: (_) {
                final announcementCount = announcementVM.announcementList?.length ?? 0;
                final eventCount = eventVM.eventList?.length ?? 0;
                final newsCount = newsVM.newsList?.length ?? 0;
                final cityServiceCount = cityServiceVM.cityServiceList?.length ?? 0;
                final projectCount = projectVM.projectList?.length ?? 0;

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildStatCard(
                      title: 'Toplam Duyuru',
                      value: announcementCount.toString(),
                      icon: Icons.campaign,
                      color: const Color(0xFF3B82F6),
                      change: announcementCount > 0 ? '+$announcementCount' : '0',
                      isPositive: announcementCount > 0,
                    ),
                    _buildStatCard(
                      title: 'Aktif Etkinlik',
                      value: eventCount.toString(),
                      icon: Icons.event,
                      color: const Color(0xFF10B981),
                      change: eventCount > 0 ? '+$eventCount' : '0',
                      isPositive: eventCount > 0,
                    ),
                    _buildStatCard(
                      title: 'Toplam Haber',
                      value: newsCount.toString(),
                      icon: Icons.article,
                      color: const Color(0xFFF59E0B),
                      change: newsCount > 0 ? '+$newsCount' : '0',
                      isPositive: newsCount > 0,
                    ),
                    _buildStatCard(
                      title: 'Şehir Hizmetleri',
                      value: cityServiceCount.toString(),
                      icon: Icons.business,
                      color: const Color(0xFF8B5CF6),
                      change: cityServiceCount > 0 ? '+$cityServiceCount' : '0',
                      isPositive: cityServiceCount > 0,
                    ),
                    _buildStatCard(
                      title: 'Toplam Proje',
                      value: projectCount.toString(),
                      icon: Icons.work_outline,
                      color: const Color(0xFF06B6D4),
                      change: projectCount > 0 ? '+$projectCount' : '0',
                      isPositive: projectCount > 0,
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String change,
    required bool isPositive,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10), spreadRadius: 0),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color.withOpacity(0.15), color.withOpacity(0.08)]),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: color.withOpacity(0.2), width: 1),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isPositive
                        ? [const Color(0xFF10B981).withOpacity(0.2), const Color(0xFF10B981).withOpacity(0.1)]
                        : [const Color(0xFFEF4444).withOpacity(0.2), const Color(0xFFEF4444).withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isPositive
                        ? const Color(0xFF10B981).withOpacity(0.3)
                        : const Color(0xFFEF4444).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 12,
                      color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      change,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 36,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildChartCard(
            title: 'Aylık Aktivite',
            subtitle: 'Son 6 ay',
            child: Container(
              height: 200,
              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
              child: const Center(
                child: Text('Grafik burada görünecek', style: TextStyle(color: Color(0xFF6B7280))),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: _buildChartCard(
            title: 'Kullanıcı Dağılımı',
            subtitle: 'Bu ay',
            child: Container(
              height: 200,
              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
              child: const Center(
                child: Text('Pie Chart burada', style: TextStyle(color: Color(0xFF6B7280))),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard({required String title, required String subtitle, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontSize: 20, color: const Color(0xFF1E293B)),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Son Aktiviteler',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontSize: 20, color: const Color(0xFF1E293B)),
          ),
          const SizedBox(height: 16),
          Consumer5<AnnouncementViewModel, EventViewModel, NewsViewModel, CityServiceViewModel, ProjectViewModel>(
            builder: (context, announcementVM, eventVM, newsVM, cityServiceVM, projectVM, child) {
              return Observer(
                builder: (_) {
                  List<Widget> activities = [];

                  // En son duyuru (tarihe göre sıralı)
                  if (announcementVM.announcementList?.isNotEmpty == true) {
                    final sortedAnnouncements = List.from(announcementVM.announcementList!)
                      ..sort((a, b) {
                        if (a.date == null && b.date == null) return 0;
                        if (a.date == null) return 1;
                        if (b.date == null) return -1;
                        return b.date!.compareTo(a.date!);
                      });
                    final latestAnnouncement = sortedAnnouncements.first;
                    activities.add(
                      _buildActivityItem(
                        icon: Icons.campaign,
                        title: 'Yeni duyuru eklendi',
                        subtitle: latestAnnouncement.title ?? 'Yeni duyuru',
                        time: _getTimeAgoFromDate(latestAnnouncement.date),
                        color: const Color(0xFF3B82F6),
                      ),
                    );
                  }

                  // En son etkinlik (tarihe göre sıralı)
                  if (eventVM.eventList?.isNotEmpty == true) {
                    final sortedEvents = List.from(eventVM.eventList!)
                      ..sort((a, b) {
                        if (a.date == null && b.date == null) return 0;
                        if (a.date == null) return 1;
                        if (b.date == null) return -1;
                        return b.date!.compareTo(a.date!);
                      });
                    final latestEvent = sortedEvents.first;
                    activities.add(
                      _buildActivityItem(
                        icon: Icons.event,
                        title: 'Yeni etkinlik eklendi',
                        subtitle: latestEvent.title ?? 'Yeni etkinlik',
                        time: _getTimeAgoFromDate(latestEvent.date),
                        color: const Color(0xFF10B981),
                      ),
                    );
                  }

                  // En son haber (tarihe göre sıralı)
                  if (newsVM.newsList?.isNotEmpty == true) {
                    final sortedNews = List.from(newsVM.newsList!)
                      ..sort((a, b) {
                        if (a.publishedAt == null && b.publishedAt == null) return 0;
                        if (a.publishedAt == null) return 1;
                        if (b.publishedAt == null) return -1;
                        return b.publishedAt!.compareTo(a.publishedAt!);
                      });
                    final latestNews = sortedNews.first;
                    activities.add(
                      _buildActivityItem(
                        icon: Icons.article,
                        title: 'Yeni haber yayınlandı',
                        subtitle: latestNews.title ?? 'Yeni haber',
                        time: _getTimeAgoFromDate(latestNews.publishedAt),
                        color: const Color(0xFFF59E0B),
                      ),
                    );
                  }

                  // En son şehir hizmeti
                  if (cityServiceVM.cityServiceList?.isNotEmpty == true) {
                    final latestService = cityServiceVM.cityServiceList!.last;
                    activities.add(
                      _buildActivityItem(
                        icon: Icons.business,
                        title: 'Yeni şehir hizmeti eklendi',
                        subtitle: latestService.title ?? 'Yeni hizmet',
                        time: 'Yakın zamanda',
                        color: const Color(0xFF8B5CF6),
                      ),
                    );
                  }

                  // En son proje
                  if (projectVM.projectList?.isNotEmpty == true) {
                    final latestProject = projectVM.projectList!.last;
                    activities.add(
                      _buildActivityItem(
                        icon: Icons.work_outline,
                        title: 'Yeni proje eklendi',
                        subtitle: latestProject.title ?? 'Yeni proje',
                        time: 'Yakın zamanda',
                        color: const Color(0xFF06B6D4),
                      ),
                    );
                  }

                  // Eğer hiç aktivite yoksa placeholder göster
                  if (activities.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(Icons.history, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            'Henüz aktivite bulunmuyor',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }

                  // Son 5 aktiviteyi göster
                  if (activities.length > 5) {
                    activities = activities.take(5).toList();
                  }

                  return Column(children: activities);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _getTimeAgoFromDate(DateTime? date) {
    if (date == null) return 'Yakın zamanda';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Az önce';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} dakika önce';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} saat önce';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks hafta önce';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ay önce';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years yıl önce';
    }
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.05), color.withOpacity(0.02)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color.withOpacity(0.2), color.withOpacity(0.1)]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF1E293B)),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: const Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF94A3B8), fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncements() {
    return Consumer<AnnouncementViewModel>(
      builder: (context, viewModel, child) {
        return Observer(
          builder: (_) {
            final announcements = viewModel.announcementList ?? [];
            return Container(
              padding: AdminTableCardConstants.contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminSectionHeader(
                    title: 'Duyuru Yönetimi',
                    subtitle: 'Tüm duyuruları yönetin ve düzenleyin',
                    action: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => _AnnouncementFormDialog(),
                        );
                        if (result == true) {
                          await viewModel.fetchAnnouncement();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Yeni Duyuru'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  if (viewModel.isLoading) const AdminLoadingWidget(),
                  if (!viewModel.isLoading && announcements.isEmpty)
                    const AdminEmptyStateWidget(message: 'Hiç duyuru yok.', icon: Icons.campaign_outlined),
                  if (!viewModel.isLoading && announcements.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: AdminDataTable(
                          columns: const [
                            DataColumn(label: Text('Başlık')),
                            DataColumn(label: Text('Açıklama')),
                            DataColumn(label: Text('Tarih')),
                            DataColumn(label: Text('İşlemler')),
                          ],
                          rows: announcements.map((announcement) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 200),
                                    child: Text(announcement.title ?? '', overflow: TextOverflow.ellipsis, maxLines: 2),
                                  ),
                                ),
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 300),
                                    child: Text(announcement.content ?? '', overflow: TextOverflow.ellipsis, maxLines: 3),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    announcement.date != null ? announcement.date!.toIso8601String().substring(0, 10) : '',
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
                                        tooltip: 'Düzenle',
                                        onPressed: () async {
                                          final result = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => _AnnouncementFormDialog(announcement: announcement),
                                          );
                                          if (result == true) {
                                            await viewModel.fetchAnnouncement();
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Color(0xFFEF4444)),
                                        tooltip: 'Sil',
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Duyuru Sil'),
                                              content: const Text('Bu duyuruyu silmek istediğinize emin misiniz?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  child: const Text('Vazgeç'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () => Navigator.pop(context, true),
                                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                                                  child: const Text('Sil'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            await viewModel.deleteAnnouncement(announcement.id!);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEvents() {
    return Consumer<EventViewModel>(
      builder: (context, viewModel, child) {
        return Observer(
          builder: (_) {
            final events = viewModel.eventList ?? [];
            return Container(
              padding: AdminTableCardConstants.contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminSectionHeader(
                    title: 'Etkinlik Yönetimi',
                    subtitle: 'Tüm etkinlikleri yönetin ve düzenleyin',
                    action: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => _EventFormDialog(),
                        );
                        if (result == true) {
                          await viewModel.fetchEvents();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Yeni Etkinlik'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  if (viewModel.isLoading) const AdminLoadingWidget(),
                  if (!viewModel.isLoading && events.isEmpty)
                    const AdminEmptyStateWidget(message: 'Hiç etkinlik yok.', icon: Icons.event_outlined),
                  if (!viewModel.isLoading && events.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: AdminDataTable(
                          columns: const [
                            DataColumn(label: Text('Başlık')),
                            DataColumn(label: Text('Açıklama')),
                            DataColumn(label: Text('Konum')),
                            DataColumn(label: Text('Tarih')),
                            DataColumn(label: Text('İşlemler')),
                          ],
                          rows: events.map((event) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 180),
                                    child: Text(event.title ?? '', overflow: TextOverflow.ellipsis, maxLines: 2),
                                  ),
                                ),
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 250),
                                    child: Text(event.description ?? '', overflow: TextOverflow.ellipsis, maxLines: 3),
                                  ),
                                ),
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 150),
                                    child: Text(event.location ?? '', overflow: TextOverflow.ellipsis, maxLines: 2),
                                  ),
                                ),
                                DataCell(Text(event.date != null ? event.date!.toIso8601String().substring(0, 10) : '')),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
                                        tooltip: 'Düzenle',
                                        onPressed: () async {
                                          final result = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => _EventFormDialog(event: event),
                                          );
                                          if (result == true) {
                                            await viewModel.fetchEvents();
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Color(0xFFEF4444)),
                                        tooltip: 'Sil',
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Etkinlik Sil'),
                                              content: const Text('Bu etkinliği silmek istediğinize emin misiniz?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  child: const Text('Vazgeç'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () => Navigator.pop(context, true),
                                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                                                  child: const Text('Sil'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            await viewModel.deleteEvent(event.id!);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNews() {
    return Consumer<NewsViewModel>(
      builder: (context, viewModel, child) {
        return Observer(
          builder: (_) {
            final newsList = viewModel.newsList ?? [];
            return Container(
              padding: AdminTableCardConstants.contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminSectionHeader(
                    title: 'Haber Yönetimi',
                    subtitle: 'Tüm haberleri yönetin ve düzenleyin',
                    action: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => _NewsFormDialog(),
                        );
                        if (result == true) {
                          await viewModel.fetchNews();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Yeni Haber'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  if (viewModel.isLoading) const AdminLoadingWidget(),
                  if (!viewModel.isLoading && newsList.isEmpty)
                    const AdminEmptyStateWidget(message: 'Hiç haber yok.', icon: Icons.article_outlined),
                  if (!viewModel.isLoading && newsList.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: AdminDataTable(
                          columns: const [
                            DataColumn(label: Text('Başlık')),
                            DataColumn(label: Text('Açıklama')),
                            DataColumn(label: Text('Tarih')),
                            DataColumn(label: Text('İşlemler')),
                          ],
                          rows: newsList.map((news) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 200),
                                    child: Text(news.title ?? '', overflow: TextOverflow.ellipsis, maxLines: 2),
                                  ),
                                ),
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 300),
                                    child: Text(news.content ?? '', overflow: TextOverflow.ellipsis, maxLines: 3),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    news.publishedAt != null ? news.publishedAt!.toIso8601String().substring(0, 10) : '',
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
                                        tooltip: 'Düzenle',
                                        onPressed: () async {
                                          final result = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => _NewsFormDialog(news: news),
                                          );
                                          if (result == true) {
                                            await viewModel.fetchNews();
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Color(0xFFEF4444)),
                                        tooltip: 'Sil',
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Haber Sil'),
                                              content: const Text('Bu haberi silmek istediğinize emin misiniz?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  child: const Text('Vazgeç'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () => Navigator.pop(context, true),
                                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                                                  child: const Text('Sil'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            await viewModel.deleteNews(news.id!);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCityServices() {
    return Consumer<CityServiceViewModel>(
      builder: (context, viewModel, child) {
        return Observer(
          builder: (_) {
            final cityServiceList = viewModel.cityServiceList ?? [];
            return Container(
              padding: AdminTableCardConstants.contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminSectionHeader(
                    title: 'Şehir Hizmetleri Yönetimi',
                    subtitle: 'Tüm şehir hizmetlerini yönetin ve düzenleyin',
                    action: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => _CityServiceFormDialog(),
                        );
                        if (result == true) {
                          await viewModel.fetchCityService();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Yeni Hizmet'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  if (viewModel.isLoading) const AdminLoadingWidget(),
                  if (!viewModel.isLoading && cityServiceList.isEmpty)
                    const AdminEmptyStateWidget(message: 'Hiç şehir hizmeti yok.', icon: Icons.business_outlined),
                  if (!viewModel.isLoading && cityServiceList.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: AdminDataTable(
                          columns: const [
                            DataColumn(label: Text('Başlık')),
                            DataColumn(label: Text('Açıklama')),
                            DataColumn(label: Text('İkon URL')),
                            DataColumn(label: Text('İşlemler')),
                          ],
                          rows: cityServiceList.map((service) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 180),
                                    child: Text(service.title ?? '', overflow: TextOverflow.ellipsis, maxLines: 2),
                                  ),
                                ),
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 280),
                                    child: Text(service.description ?? '', overflow: TextOverflow.ellipsis, maxLines: 3),
                                  ),
                                ),
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 200),
                                    child: Text(service.iconUrl ?? '', overflow: TextOverflow.ellipsis, maxLines: 2),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
                                        tooltip: 'Düzenle',
                                        onPressed: () async {
                                          final result = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => _CityServiceFormDialog(service: service),
                                          );
                                          if (result == true) {
                                            await viewModel.fetchCityService();
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Color(0xFFEF4444)),
                                        tooltip: 'Sil',
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Hizmet Sil'),
                                              content: const Text('Bu hizmeti silmek istediğinize emin misiniz?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  child: const Text('Vazgeç'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () => Navigator.pop(context, true),
                                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                                                  child: const Text('Sil'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            await viewModel.deleteCityService(service.id!);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProjects() {
    return Consumer<ProjectViewModel>(
      builder: (context, viewModel, child) {
        return Observer(
          builder: (_) {
            final projects = viewModel.projectList ?? [];
            return Container(
              padding: AdminTableCardConstants.contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminSectionHeader(
                    title: 'Projeler Yönetimi',
                    subtitle: 'Tüm projeleri yönetin ve düzenleyin',
                    action: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => _ProjectFormDialog(),
                        );
                        if (result == true) {
                          await viewModel.fetchProjects();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Yeni Proje'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06B6D4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  if (viewModel.isLoading) const AdminLoadingWidget(),
                  if (!viewModel.isLoading && projects.isEmpty)
                    const AdminEmptyStateWidget(message: 'Hiç proje yok.', icon: Icons.work_outline),
                  if (!viewModel.isLoading && projects.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: AdminDataTable(
                          columnSpacing: 25,
                          columns: const [
                            DataColumn(label: Text('Başlık')),
                            DataColumn(label: Text('Açıklama')),
                            DataColumn(label: Text('Resim URL')),
                            DataColumn(label: Text('İşlemler')),
                          ],
                          rows: projects.map((project) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 180),
                                    child: Text(project.title ?? '', overflow: TextOverflow.ellipsis, maxLines: 2),
                                  ),
                                ),
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 250),
                                    child: Text(project.description ?? '', overflow: TextOverflow.ellipsis, maxLines: 3),
                                  ),
                                ),
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 200),
                                    child: Text(
                                      project.imageUrl ?? 'Resim yok',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
                                        tooltip: 'Düzenle',
                                        onPressed: () async {
                                          final result = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => _ProjectFormDialog(project: project),
                                          );
                                          if (result == true) {
                                            await viewModel.fetchProjects();
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Color(0xFFEF4444)),
                                        tooltip: 'Sil',
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Proje Sil'),
                                              content: const Text('Bu projeyi silmek istediğinize emin misiniz?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  child: const Text('Vazgeç'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () => Navigator.pop(context, true),
                                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                                                  child: const Text('Sil'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            await viewModel.deleteProject(project.id!);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUsers() {
    return Observer(
      builder: (_) {
        final viewModel = Provider.of<AdminUserViewModel>(context, listen: false);
        final users = viewModel.adminUserList ?? [];
        return Container(
          padding: AdminTableCardConstants.contentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminSectionHeader(
                title: 'Admin Kullanıcı Yönetimi',
                subtitle: 'Tüm admin kullanıcıları yönetin ve düzenleyin',
                action: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => _AdminUserFormDialog(),
                    );
                    if (result == true) {
                      await viewModel.fetchAdminUsers();
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Yeni Admin'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              if (viewModel.isLoading) const AdminLoadingWidget(),
              if (!viewModel.isLoading && users.isEmpty)
                const AdminEmptyStateWidget(message: 'Hiç admin kullanıcı yok.', icon: Icons.people_outlined),
              if (!viewModel.isLoading && users.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: AdminDataTable(
                      columns: const [
                        DataColumn(label: Text('Kullanıcı Adı')),
                        DataColumn(label: Text('Rol')),
                        DataColumn(label: Text('Oluşturulma Tarihi')),
                        DataColumn(label: Text('İşlemler')),
                      ],
                      rows: users.map<DataRow>((AdminUserModel user) {
                        return DataRow(
                          cells: [
                            DataCell(Text(user.username ?? '')),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
                                ),
                                child: Text(
                                  (user.role ?? '').toUpperCase(),
                                  style: const TextStyle(
                                    color: Color(0xFF8B5CF6),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                user.createdAt != null
                                    ? '${user.createdAt!.day}/${user.createdAt!.month}/${user.createdAt!.year}'
                                    : 'Bilinmiyor',
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
                                    tooltip: 'Düzenle',
                                    onPressed: () async {
                                      final result = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => _AdminUserFormDialog(user: user),
                                      );
                                      if (result == true) {
                                        await viewModel.fetchAdminUsers();
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Color(0xFFEF4444)),
                                    tooltip: 'Sil',
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Admin Kullanıcı Sil'),
                                          content: const Text('Bu admin kullanıcıyı silmek istediğinize emin misiniz?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text('Vazgeç'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                                              child: const Text('Sil'),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        await viewModel.deleteAdminUser(user.id!);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettings() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sistem Ayarları',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Center(
              child: Text(
                'Sistem ayarları paneli burada olacak',
                style: TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementFormDialog extends StatefulWidget {
  final AnnouncementModel? announcement;
  const _AnnouncementFormDialog({this.announcement});

  @override
  State<_AnnouncementFormDialog> createState() => _AnnouncementFormDialogState();
}

class _AnnouncementFormDialogState extends State<_AnnouncementFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.announcement?.title ?? '');
    _contentController = TextEditingController(text: widget.announcement?.content ?? '');
    _selectedDate = widget.announcement?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AnnouncementViewModel>(context, listen: false);
    final isEdit = widget.announcement != null;
    return AlertDialog(
      title: Text(isEdit ? 'Duyuru Düzenle' : 'Yeni Duyuru Ekle'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Başlık'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Başlık zorunlu' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Açıklama zorunlu' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Tarih: '),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _selectedDate = picked);
                    },
                    child: Text(
                      _selectedDate != null ? _selectedDate!.toIso8601String().substring(0, 10) : 'Tarih seç',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
        ElevatedButton(
          onPressed: _isSubmitting
              ? null
              : () async {
                  if (_formKey.currentState?.validate() != true) return;
                  setState(() => _isSubmitting = true);
                  final model = AnnouncementModel(
                    id: widget.announcement?.id,
                    title: _titleController.text.trim(),
                    content: _contentController.text.trim(),
                    date: _selectedDate,
                  );
                  bool success;
                  if (isEdit) {
                    success = await viewModel.updateAnnouncement(model);
                  } else {
                    success = await viewModel.addAnnouncement(model);
                  }
                  setState(() => _isSubmitting = false);
                  if (success) {
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarısız')));
                  }
                },
          child: Text(isEdit ? 'Güncelle' : 'Ekle'),
        ),
      ],
    );
  }
}

class _EventFormDialog extends StatefulWidget {
  final EventModel? event;
  const _EventFormDialog({this.event});

  @override
  State<_EventFormDialog> createState() => _EventFormDialogState();
}

class _EventFormDialogState extends State<_EventFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _imageUrlController;
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descriptionController = TextEditingController(text: widget.event?.description ?? '');
    _locationController = TextEditingController(text: widget.event?.location ?? '');
    _imageUrlController = TextEditingController(text: widget.event?.imageUrl ?? '');
    _selectedDate = widget.event?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EventViewModel>(context, listen: false);
    final isEdit = widget.event != null;
    return AlertDialog(
      title: Text(isEdit ? 'Etkinlik Düzenle' : 'Yeni Etkinlik Ekle'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Başlık'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Başlık zorunlu' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Açıklama zorunlu' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Konum'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Konum zorunlu' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Görsel URL'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Görsel URL zorunlu' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Tarih: '),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _selectedDate = picked);
                    },
                    child: Text(
                      _selectedDate != null ? _selectedDate!.toIso8601String().substring(0, 10) : 'Tarih seç',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
        ElevatedButton(
          onPressed: _isSubmitting
              ? null
              : () async {
                  if (_formKey.currentState?.validate() != true) return;
                  setState(() => _isSubmitting = true);
                  final model = EventModel(
                    id: widget.event?.id,
                    title: _titleController.text.trim(),
                    description: _descriptionController.text.trim(),
                    location: _locationController.text.trim(),
                    imageUrl: _imageUrlController.text.trim(),
                    date: _selectedDate,
                  );
                  bool success;
                  if (isEdit) {
                    success = await viewModel.updateEvent(model);
                  } else {
                    success = await viewModel.addEvent(model);
                  }
                  setState(() => _isSubmitting = false);
                  if (success) {
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarısız')));
                  }
                },
          child: Text(isEdit ? 'Güncelle' : 'Ekle'),
        ),
      ],
    );
  }
}

class _NewsFormDialog extends StatefulWidget {
  final NewsModel? news;
  const _NewsFormDialog({this.news});

  @override
  State<_NewsFormDialog> createState() => _NewsFormDialogState();
}

class _NewsFormDialogState extends State<_NewsFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _imageUrlController;
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.news?.title ?? '');
    _contentController = TextEditingController(text: widget.news?.content ?? '');
    _imageUrlController = TextEditingController(text: widget.news?.imageUrl ?? '');
    _selectedDate = widget.news?.publishedAt ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NewsViewModel>(context, listen: false);
    final isEdit = widget.news != null;
    return AlertDialog(
      title: Text(isEdit ? 'Haber Düzenle' : 'Yeni Haber Ekle'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Başlık'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Başlık zorunlu' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Açıklama zorunlu' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Görsel URL'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Görsel URL zorunlu' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Tarih: '),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _selectedDate = picked);
                    },
                    child: Text(
                      _selectedDate != null ? _selectedDate!.toIso8601String().substring(0, 10) : 'Tarih seç',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
        ElevatedButton(
          onPressed: _isSubmitting
              ? null
              : () async {
                  if (_formKey.currentState?.validate() != true) return;
                  setState(() => _isSubmitting = true);
                  final model = NewsModel(
                    id: widget.news?.id,
                    title: _titleController.text.trim(),
                    content: _contentController.text.trim(),
                    imageUrl: _imageUrlController.text.trim(),
                    publishedAt: _selectedDate?.toUtc(), // <-- UTC olarak gönder
                  );
                  bool success;
                  if (isEdit) {
                    success = await viewModel.updateNews(model);
                  } else {
                    success = await viewModel.addNews(model);
                  }
                  setState(() => _isSubmitting = false);
                  if (success) {
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarısız')));
                  }
                },
          child: Text(isEdit ? 'Güncelle' : 'Ekle'),
        ),
      ],
    );
  }
}

class _CityServiceFormDialog extends StatefulWidget {
  final CityServiceModel? service;
  const _CityServiceFormDialog({this.service});

  @override
  State<_CityServiceFormDialog> createState() => _CityServiceFormDialogState();
}

class _CityServiceFormDialogState extends State<_CityServiceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _iconUrlController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.service?.title ?? '');
    _descriptionController = TextEditingController(text: widget.service?.description ?? '');
    _iconUrlController = TextEditingController(text: widget.service?.iconUrl ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _iconUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CityServiceViewModel>(context, listen: false);
    final isEdit = widget.service != null;
    return AlertDialog(
      title: Text(isEdit ? 'Hizmet Düzenle' : 'Yeni Hizmet Ekle'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Başlık'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Başlık zorunlu' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Açıklama zorunlu' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _iconUrlController,
                decoration: const InputDecoration(labelText: 'İkon URL'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'İkon URL zorunlu' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
        ElevatedButton(
          onPressed: _isSubmitting
              ? null
              : () async {
                  if (_formKey.currentState?.validate() != true) return;
                  setState(() => _isSubmitting = true);
                  final model = CityServiceModel(
                    id: widget.service?.id,
                    title: _titleController.text.trim(),
                    description: _descriptionController.text.trim(),
                    iconUrl: _iconUrlController.text.trim(),
                  );
                  bool success;
                  if (isEdit) {
                    success = await viewModel.updateCityService(model);
                  } else {
                    success = await viewModel.addCityService(model);
                  }
                  setState(() => _isSubmitting = false);
                  if (success) {
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarısız')));
                  }
                },
          child: Text(isEdit ? 'Güncelle' : 'Ekle'),
        ),
      ],
    );
  }
}

class _ProjectFormDialog extends StatefulWidget {
  final ProjectModel? project;
  const _ProjectFormDialog({this.project});

  @override
  State<_ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<_ProjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project?.title ?? '');
    _descriptionController = TextEditingController(text: widget.project?.description ?? '');
    _imageUrlController = TextEditingController(text: widget.project?.imageUrl ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProjectViewModel>(context, listen: false);
    final isEdit = widget.project != null;
    return AlertDialog(
      title: Text(isEdit ? 'Proje Düzenle' : 'Yeni Proje Ekle'),
      content: SizedBox(
        width: 400,
        height: 400, // Fixed height to prevent overflow
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Başlık'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Başlık zorunlu' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Açıklama'),
                  maxLines: 3,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Açıklama zorunlu' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'Resim URL (Opsiyonel)'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null; // Optional field
                    // Basic URL validation
                    try {
                      Uri.parse(v.trim());
                      return null;
                    } catch (e) {
                      return 'Geçerli bir URL giriniz';
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
        ElevatedButton(
          onPressed: _isSubmitting
              ? null
              : () async {
                  if (_formKey.currentState?.validate() != true) return;
                  setState(() => _isSubmitting = true);
                  final model = ProjectModel(
                    id: widget.project?.id,
                    title: _titleController.text.trim(),
                    description: _descriptionController.text.trim(),
                    imageUrl: _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
                  );
                  bool success;
                  if (isEdit) {
                    success = await viewModel.updateProject(model);
                  } else {
                    success = await viewModel.addProject(model);
                  }
                  setState(() => _isSubmitting = false);
                  if (success) {
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarısız')));
                  }
                },
          child: Text(isEdit ? 'Güncelle' : 'Ekle'),
        ),
      ],
    );
  }
}

class _AdminUserFormDialog extends StatefulWidget {
  final AdminUserModel? user;
  const _AdminUserFormDialog({this.user});

  @override
  State<_AdminUserFormDialog> createState() => _AdminUserFormDialogState();
}

class _AdminUserFormDialogState extends State<_AdminUserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _roleController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user?.username ?? '');
    _passwordController = TextEditingController();
    _roleController = TextEditingController(text: widget.user?.role ?? 'admin');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AdminUserViewModel>(context, listen: false);
    final isEdit = widget.user != null;
    return AlertDialog(
      title: Text(isEdit ? 'Admin Kullanıcı Düzenle' : 'Yeni Admin Kullanıcı Ekle'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Kullanıcı adı zorunlu' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: isEdit ? 'Şifre (Boş bırakılırsa değişmez)' : 'Şifre'),
                obscureText: true,
                validator: (v) {
                  if (isEdit && (v == null || v.trim().isEmpty)) return null; // Optional for edit
                  if (v == null || v.trim().isEmpty) return 'Şifre zorunlu';
                  if (v.trim().length < 6) return 'Şifre en az 6 karakter olmalı';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Rol'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Rol zorunlu' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
        ElevatedButton(
          onPressed: _isSubmitting
              ? null
              : () async {
                  if (_formKey.currentState?.validate() != true) return;
                  setState(() => _isSubmitting = true);

                  final model = CreateAdminUserModel(
                    username: _usernameController.text.trim(),
                    password: _passwordController.text.trim(),
                    role: _roleController.text.trim(),
                  );

                  bool success;
                  if (isEdit) {
                    success = await viewModel.updateAdminUser(widget.user!.id!, model);
                  } else {
                    success = await viewModel.createAdminUser(model);
                  }

                  setState(() => _isSubmitting = false);
                  if (success) {
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarısız')));
                  }
                },
          child: Text(isEdit ? 'Güncelle' : 'Ekle'),
        ),
      ],
    );
  }
}
