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
import 'package:smart_city/core/components/app_bar/main_app_bar.dart';
import 'package:smart_city/core/init/notifier/theme_notifier.dart';
import 'package:smart_city/view/view/admin/hero_image_management.dart';
import 'package:smart_city/view/viewmodel/project/project_view_model.dart';

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
      appBar: const MainAppBar(),
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),
          // Main Content
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(2, 0))],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Admin Panel',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
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
                const Divider(height: 32),
                _buildThemeToggle(),
                _buildMenuItem(icon: Icons.logout, title: 'Çıkış', index: 6, isLogout: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required int index, bool isLogout = false}) {
    final isSelected = _selectedIndex == index;
    final color = isLogout ? const Color(0xFFEF4444) : const Color(0xFF6B7280);
    final selectedColor = isLogout ? const Color(0xFFEF4444) : const Color(0xFF3B82F6);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? selectedColor.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(color: selectedColor.withOpacity(0.3)) : null,
            ),
            child: Row(
              children: [
                Icon(icon, color: isSelected ? selectedColor : color, size: 20),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? selectedColor : color,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                themeNotifier.toggleTheme();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF6B7280), width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      themeNotifier.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: const Color(0xFF6B7280),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      themeNotifier.isDarkMode ? 'Açık Tema' : 'Koyu Tema',
                      style: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.normal, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
    return Container(
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
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildStatCard(
              title: 'Toplam Duyuru',
              value: '24',
              icon: Icons.campaign,
              color: const Color(0xFF3B82F6),
              change: '+12%',
              isPositive: true,
            ),
            _buildStatCard(
              title: 'Aktif Etkinlik',
              value: '8',
              icon: Icons.event,
              color: const Color(0xFF10B981),
              change: '+5%',
              isPositive: true,
            ),
            _buildStatCard(
              title: 'Toplam Haber',
              value: '156',
              icon: Icons.article,
              color: const Color(0xFFF59E0B),
              change: '+23%',
              isPositive: true,
            ),
            _buildStatCard(
              title: 'Aktif Kullanıcı',
              value: '2.5K',
              icon: Icons.people,
              color: const Color(0xFF8B5CF6),
              change: '+8%',
              isPositive: true,
            ),
          ],
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
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
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
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xFF6B7280))),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(color: const Color(0xFF1E3A8A).withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280))),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(color: const Color(0xFF1E3A8A).withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Son Aktiviteler', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildActivityItem(
            icon: Icons.campaign,
            title: 'Yeni duyuru eklendi',
            subtitle: 'Havuzbaşı meydanında yeni araç filosu tanıtılacak',
            time: '2 saat önce',
            color: const Color(0xFF3B82F6),
          ),
          _buildActivityItem(
            icon: Icons.event,
            title: 'Etkinlik güncellendi',
            subtitle: 'Erzurum Yaz Festivali tarihi değiştirildi',
            time: '4 saat önce',
            color: const Color(0xFF10B981),
          ),
          _buildActivityItem(
            icon: Icons.article,
            title: 'Haber yayınlandı',
            subtitle: 'Yeni şehir projeleri hakkında haber',
            time: '6 saat önce',
            color: const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF6B7280))),
              ],
            ),
          ),
          Text(time, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF9CA3AF))),
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
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Duyuru Yönetimi',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (viewModel.isLoading) const Center(child: CircularProgressIndicator()),
                  if (!viewModel.isLoading && announcements.isEmpty)
                    const Center(
                      child: Text('Hiç duyuru yok.', style: TextStyle(fontSize: 18, color: Color(0xFF6B7280))),
                    ),
                  if (!viewModel.isLoading && announcements.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Başlık')),
                          DataColumn(label: Text('Açıklama')),
                          DataColumn(label: Text('Tarih')),
                          DataColumn(label: Text('İşlemler')),
                        ],
                        rows: announcements.map((announcement) {
                          return DataRow(
                            cells: [
                              DataCell(Text(announcement.title ?? '')),
                              DataCell(Text(announcement.content ?? '')),
                              DataCell(
                                Text(
                                  announcement.date != null
                                      ? announcement.date!.toIso8601String().substring(0, 10)
                                      : '',
                                ),
                              ),
                              DataCell(
                                Row(
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
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFFEF4444),
                                                ),
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
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Etkinlik Yönetimi',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (viewModel.isLoading) const Center(child: CircularProgressIndicator()),
                  if (!viewModel.isLoading && events.isEmpty)
                    const Center(
                      child: Text('Hiç etkinlik yok.', style: TextStyle(fontSize: 18, color: Color(0xFF6B7280))),
                    ),
                  if (!viewModel.isLoading && events.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: DataTable(
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
                              DataCell(Text(event.title ?? '')),
                              DataCell(Text(event.description ?? '')),
                              DataCell(Text(event.location ?? '')),
                              DataCell(Text(event.date != null ? event.date!.toIso8601String().substring(0, 10) : '')),
                              DataCell(
                                Row(
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
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFFEF4444),
                                                ),
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
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Haber Yönetimi',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (viewModel.isLoading) const Center(child: CircularProgressIndicator()),
                  if (!viewModel.isLoading && newsList.isEmpty)
                    const Center(
                      child: Text('Hiç haber yok.', style: TextStyle(fontSize: 18, color: Color(0xFF6B7280))),
                    ),
                  if (!viewModel.isLoading && newsList.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Başlık')),
                          DataColumn(label: Text('Açıklama')),
                          DataColumn(label: Text('Tarih')),
                          DataColumn(label: Text('İşlemler')),
                        ],
                        rows: newsList.map((news) {
                          return DataRow(
                            cells: [
                              DataCell(Text(news.title ?? '')),
                              DataCell(Text(news.content ?? '')),
                              DataCell(
                                Text(
                                  news.publishedAt != null ? news.publishedAt!.toIso8601String().substring(0, 10) : '',
                                ),
                              ),
                              DataCell(
                                Row(
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
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFFEF4444),
                                                ),
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
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Şehir Hizmetleri Yönetimi',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (viewModel.isLoading) const Center(child: CircularProgressIndicator()),
                  if (!viewModel.isLoading && cityServiceList.isEmpty)
                    const Center(
                      child: Text('Hiç şehir hizmeti yok.', style: TextStyle(fontSize: 18, color: Color(0xFF6B7280))),
                    ),
                  if (!viewModel.isLoading && cityServiceList.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Başlık')),
                          DataColumn(label: Text('Açıklama')),
                          DataColumn(label: Text('İkon URL')),
                          DataColumn(label: Text('İşlemler')),
                        ],
                        rows: cityServiceList.map((service) {
                          return DataRow(
                            cells: [
                              DataCell(Text(service.title ?? '')),
                              DataCell(Text(service.description ?? '')),
                              DataCell(Text(service.iconUrl ?? '')),
                              DataCell(
                                Row(
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
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFFEF4444),
                                                ),
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
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Projeler Yönetimi',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton.icon(
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (viewModel.isLoading) const Center(child: CircularProgressIndicator()),
                    if (!viewModel.isLoading && projects.isEmpty)
                      const Center(
                        child: Text('Hiç proje yok.', style: TextStyle(fontSize: 18, color: Color(0xFF6B7280))),
                      ),
                    if (!viewModel.isLoading && projects.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 20,
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
                                    SizedBox(
                                      width: 150,
                                      child: Text(project.title ?? '', overflow: TextOverflow.ellipsis, maxLines: 2),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        project.description ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 150,
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
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xFFEF4444),
                                                    ),
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
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUsers() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kullanıcı Yönetimi',
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
                'Kullanıcı yönetim paneli burada olacak',
                style: TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
              ),
            ),
          ),
        ],
      ),
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
