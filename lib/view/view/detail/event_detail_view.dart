import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/view/viewmodel/event/event_view_model.dart';
import 'package:smart_city/view/authentication/test/model/eventmodel/event_model.dart';
import 'package:smart_city/core/components/app_bar/main_app_bar.dart';
import 'package:smart_city/core/components/cards/hover_card.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/core/components/detail/hero_detail_scaffold.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';


class EventDetailView extends StatefulWidget {
  final int? eventId;
  const EventDetailView({super.key, this.eventId});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> with TickerProviderStateMixin {
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
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final viewModel = Provider.of<EventViewModel>(context, listen: false);
      
      // Eğer eventId varsa tek event getir, yoksa tüm etkinlikleri getir
      if (widget.eventId != null) {
        viewModel.getEventById(widget.eventId!);
      } else {
        viewModel.fetchEvents();
      }
      
      _initialized = true;

      // Animasyonları başlat
      _fadeController.forward();
      _slideController.forward();
    }
  }

  // Arama fonksiyonu
  List<EventModel> _filterEvents(List<EventModel> events) {
    if (_searchQuery.isEmpty) return events;

    return events.where((event) {
      final query = _searchQuery.toLowerCase();
      return event.title?.toLowerCase().contains(query) == true ||
          event.description?.toLowerCase().contains(query) == true ||
          event.location?.toLowerCase().contains(query) == true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const MainAppBar(
        isTransparent: false,
        onNavTap: null,
        activeItemOverride: 'Etkinlikler',
        showOnlyActiveItem: true,
        showBackButton: true,
      ),
      body: Observer(
        builder: (context) {
          final viewModel = Provider.of<EventViewModel>(context, listen: false);

          if (viewModel.isLoading) {
            return _buildLoadingState();
          }

          // Eğer eventId varsa tek event göster
          if (widget.eventId != null) {
            if (viewModel.singleEvent == null) {
              return _buildEventNotFoundState();
            }
            return _buildSingleEventView(viewModel.singleEvent!);
          }

          // Eğer eventId yoksa tüm etkinlikleri göster
          if (viewModel.eventList == null || viewModel.eventList!.isEmpty) {
            return _buildEmptyState();
          }

          final events = _filterEvents(viewModel.eventList!);

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: CustomScrollView(
                slivers: [
                  // Tüm Etkinlikler Başlığı
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
                      child: Text(
                        'Tüm Etkinlikler',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ),

                  // Search Bar
                  SliverToBoxAdapter(child: _buildSearchBar()),

                  // Event Count
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                      child: Text(
                        '${events.length} etkinlik bulundu',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ),
                  ),

                  // Events Grid
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final event = events[index];
                        final eventDate = event.date;
                        final isPast = eventDate != null ? DateTime.now().isAfter(eventDate) : false;

                        return _buildEventCard(event, index);
                      }, childCount: events.length),
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
    return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A4A9D))));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('Henüz etkinlik bulunmuyor', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildEventNotFoundState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('Etkinlik bulunamadı', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text('Aradığınız etkinlik mevcut değil veya kaldırılmış olabilir.', 
               style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildSingleEventView(EventModel event) {
    final DateTime? eventDate = event.date;
    final String? resolvedImage = (event.imageUrl != null && event.imageUrl!.isNotEmpty)
        ? _buildFullImageUrl(event.imageUrl!)
        : null;

    // Format date for display
    final String? formattedDate = eventDate != null 
        ? '${eventDate.day.toString().padLeft(2, '0')}/${eventDate.month.toString().padLeft(2, '0')}/${eventDate.year}'
        : null;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: HeroDetailScaffold(
          title: event.title ?? 'Başlık Yok',
          imageUrl: resolvedImage,
          date: formattedDate,
          location: event.location,
          description: event.description,
          heroTag: 'event_${event.id ?? event.title ?? ''}',
          bottomActions: _buildEventActions(event),
        ),
      ),
    );
  }

  // Search Bar Widget'ı
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
            hintText: 'Etkinlik ara...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEventActions(EventModel event) {
    return [
      // Paylaş Butonu - Tüm Sayfalarda Tutarlı Tasarım
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        ),
        child: InkWell(
          onTap: _copyCurrentUrl,
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
      
      const SizedBox(width: 12),
      
      // Takvime Ekle Butonu - Tüm Sayfalarda Tutarlı Tasarım
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        ),
        child: InkWell(
          onTap: () => _addToGoogleCalendar(event),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.event_available_outlined, size: 16, color: const Color(0xFF666666)),
              const SizedBox(width: 8),
              Text(
                'Takvime Ekle',
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
    ];
  }

  void _copyCurrentUrl() {
    final url = Uri.base.toString();
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bağlantı kopyalandı')),
    );
  }

  Future<void> _addToGoogleCalendar(EventModel event) async {
    final DateTime? start = event.date;
    if (start == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarih bilgisi bulunamadı')),
      );
      return;
    }
    final end = start.add(const Duration(hours: 2));
    final s = _toGCalDate(start.toUtc());
    final e = _toGCalDate(end.toUtc());
    final title = Uri.encodeComponent(event.title ?? 'Etkinlik');
    final details = Uri.encodeComponent(event.description ?? '');
    final location = Uri.encodeComponent(event.location ?? '');
    final url = 'https://calendar.google.com/calendar/render?action=TEMPLATE&text=$title&dates=$s/$e&details=$details&location=$location&sf=true&output=xml';
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _toGCalDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}${two(dt.month)}${two(dt.day)}T${two(dt.hour)}${two(dt.minute)}${two(dt.second)}Z';
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

  Widget _buildEventCard(EventModel event, int index) {
    final DateTime now = DateTime.now();
    final DateTime? eventDate = event.date;
    final bool isPast = eventDate != null ? now.isAfter(eventDate) : false;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(opacity: value, child: _buildAnimatedEventCard(event, eventDate, isPast)),
        );
      },
    );
  }

  Widget _buildAnimatedEventCard(EventModel event, DateTime? eventDate, bool isPast) {
    return HoverCard(
      imageUrl: event.imageUrl,
      title: event.title ?? 'Başlık Yok',
      description: event.description ?? 'Açıklama yok',
      date: eventDate,
      location: event.location,
      cardType: CardType.event,
      statusText: isPast ? 'Geçmiş' : 'Yakında',
      statusColor: isPast ? Colors.grey[400] : const Color(0xFF10B981),
      statusIcon: isPast ? Icons.schedule : Icons.upcoming,
      onTap: () => context.go('/events/${event.id ?? ''}'),
    );
  }
}
