import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/view/viewmodel/event/event_view_model.dart';
import 'package:smart_city/view/authentication/test/model/eventmodel/event_model.dart';

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final viewModel = Provider.of<EventViewModel>(context, listen: false);
      viewModel.fetchEvents();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final viewModel = Provider.of<EventViewModel>(context, listen: false);
        
        if (viewModel.isLoading) {
          return _buildLoadingState();
        }
        
        if (viewModel.hasError) {
          return _buildErrorState(viewModel);
        }
        
        if (viewModel.eventList == null || viewModel.eventList!.isEmpty) {
          return _buildEmptyState();
        }
        
        return _buildEventGrid(viewModel.eventList!);
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
          ),
          const SizedBox(height: 16),
          Text(
            'Etkinlikler yükleniyor...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(EventViewModel viewModel) {
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
            viewModel.errorMessage ?? 'Etkinlikler yüklenirken bir sorun oluştu',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => viewModel.retryFetchEvents(),
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
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
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event_outlined,
              size: 48,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz etkinlik bulunmuyor',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF374151),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yeni etkinlikler eklendiğinde burada görünecek',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEventGrid(List<EventModel> events) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 900) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return _buildEventCard(event);
          },
        );
      },
    );
  }

  Widget _buildEventCard(EventModel event) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resim alanı
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: event.imageUrl != null && event.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      event.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          child: const Icon(
                            Icons.event,
                            size: 48,
                            color: Color(0xFF10B981),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.event,
                      size: 48,
                      color: Color(0xFF10B981),
                    ),
                  ),
          ),
          // İçerik
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title ?? 'Başlık Yok',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (event.description != null) ...[
                    Text(
                      event.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],
                  const Spacer(),
                  // Tarih ve konum
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: const Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatDate(event.date),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF9CA3AF),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (event.location != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: const Color(0xFF9CA3AF),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF9CA3AF),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tarih belirtilmemiş';
    
    final now = DateTime.now();
    final difference = date.difference(now);
    
    if (difference.isNegative) {
      return 'Geçmiş etkinlik';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} gün sonra';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat sonra';
    } else {
      return 'Bugün';
    }
  }
}
