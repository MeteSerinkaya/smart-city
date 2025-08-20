import 'package:flutter/material.dart';

enum CardType { event, news, cityService, project }

class HoverCard extends StatefulWidget {
  final String? imageUrl;
  final String title;
  final String description;
  final DateTime? date;
  final String? location;
  final CardType cardType;
  final VoidCallback onTap;
  final String? statusText;
  final Color? statusColor;
  final IconData? statusIcon;

  const HoverCard({
    super.key,
    this.imageUrl,
    required this.title,
    required this.description,
    this.date,
    this.location,
    required this.cardType,
    required this.onTap,
    this.statusText,
    this.statusColor,
    this.statusIcon,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late AnimationController _buttonController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _buttonOpacityAnimation;
  late Animation<double> _overlayAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _buttonOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));

    _overlayAnimation = Tween<double>(
      begin: 0.0,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _hoverController.forward();
      _buttonController.forward();
    } else {
      _hoverController.reverse();
      _buttonController.reverse();
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tarih belirtilmemiş';

    final now = DateTime.now();
    final difference = date.difference(now);

    if (widget.cardType == CardType.event) {
      // Event için gelecek tarih formatı
      if (difference.isNegative) {
        return 'Geçmiş etkinlik';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} gün sonra';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} saat sonra';
      } else {
        return 'Bugün';
      }
    } else {
      // News için geçmiş tarih formatı
      if (difference.isNegative) {
        final daysAgo = difference.inDays.abs();
        if (daysAgo == 0) return 'Bugün';
        if (daysAgo == 1) return 'Dün';
        if (daysAgo < 7) return '$daysAgo gün önce';
        if (daysAgo < 30) return '${(daysAgo / 7).round()} hafta önce';
        return '${(daysAgo / 30).round()} ay önce';
      } else {
        if (difference.inDays > 0) {
          return '${difference.inDays} gün sonra';
        } else if (difference.inHours > 0) {
          return '${difference.inHours} saat sonra';
        } else {
          return 'Yakında';
        }
      }
    }
  }

  String _monthShortTR(int month) {
    const months = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
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

  Color _getCardColor() {
    switch (widget.cardType) {
      case CardType.event:
        return const Color(0xFF0A4A9D); // Mavi tonları
      case CardType.news:
        return const Color(0xFF00A8E8); // Açık mavi
      case CardType.cityService:
        return const Color(0xFF8B5CF6); // Mor
      case CardType.project:
        return const Color(0xFF06B6D4); // Camgöbeği
    }
  }

  IconData _getFallbackIcon() {
    switch (widget.cardType) {
      case CardType.event:
        return Icons.event;
      case CardType.news:
        return Icons.article;
      case CardType.cityService:
        return Icons.business_center;
      case CardType.project:
        return Icons.engineering;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    // Image Section with Hover Effect
                    Expanded(
                      flex: 4,
                      child: Stack(
                        children: [
                          // Background Image
                          Positioned.fill(
                            child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                                ? Image.network(
                                    _buildFullImageUrl(widget.imageUrl!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: const Color(0xFFE5E7EB),
                                        child: Icon(
                                          _getFallbackIcon(),
                                          size: 48,
                                          color: Colors.grey[400],
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: const Color(0xFFE5E7EB),
                                    child: Icon(
                                      _getFallbackIcon(),
                                      size: 48,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                          ),
                          
                          // Dark Overlay on Hover
                          AnimatedBuilder(
                            animation: _overlayAnimation,
                            builder: (context, child) {
                              return Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(_overlayAnimation.value),
                                ),
                              );
                            },
                          ),
                          
                          // Detail Button (appears on hover)
                          AnimatedBuilder(
                            animation: _buttonOpacityAnimation,
                            builder: (context, child) {
                              return Positioned.fill(
                                child: Center(
                                  child: Opacity(
                                    opacity: _buttonOpacityAnimation.value,
                                    child: Transform.scale(
                                      scale: _buttonOpacityAnimation.value,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: widget.onTap,
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[800]!.withOpacity(0.9),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.grey[600]!.withOpacity(0.3),
                                                width: 1,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.3),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 6),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.visibility,
                                                  color: Colors.grey[100],
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'Detayları Gör',
                                                  style: TextStyle(
                                                    color: Colors.grey[100],
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          
                          // Date Widget (top-left)
                          if (widget.date != null)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.date!.day.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _getCardColor(),
                                      ),
                                    ),
                                    Text(
                                      _monthShortTR(widget.date!.month),
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          
                          // Status Widget (top-right)
                          if (widget.statusText != null)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: widget.statusColor ?? _getCardColor(),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (widget.statusIcon != null) ...[
                                      Icon(
                                        widget.statusIcon!,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 4),
                                    ],
                                    Text(
                                      widget.statusText!,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    // Content Section
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1F2937),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.description,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            if (widget.date != null || (widget.location != null && widget.location!.isNotEmpty))
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (widget.date != null)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 12,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              _formatDate(widget.date),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (widget.location != null && widget.location!.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 12,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              widget.location!,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            // Şehir hizmetleri için 7/24 Çevrimiçi bilgisi
                            if (widget.cardType == CardType.cityService) ...[
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 12,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '7/24',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.wifi,
                                            size: 12,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Çevrimiçi',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                            // Projeler için Aktif bilgisi
                            if (widget.cardType == CardType.project) ...[
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        size: 12,
                                        color: Colors.green[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Aktif',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.green[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
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
              ),
            ),
          );
        },
      ),
    );
  }
}
