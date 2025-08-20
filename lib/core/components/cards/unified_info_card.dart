import 'package:flutter/material.dart';

class UnifiedInfoCard extends StatefulWidget {
  final String? imageUrl;
  final IconData fallbackIcon;
  final String title;
  final String? description;
  final List<Widget> bottomRowChildren;
  final List<Widget>? secondaryBottomRowChildren;

  final double borderRadius;
  final EdgeInsets contentPadding;
  final Color contentBackgroundColor;

  final bool showBlueOverlayBottom;
  final double overlayHeight;
  final bool showLeftPrimaryStrip;

  final List<Widget> actionIconsTopRight;
  final Widget? topLeftOverlayWidget;
  final Widget? topRightOverlayWidget;

  const UnifiedInfoCard({
    super.key,
    required this.imageUrl,
    required this.fallbackIcon,
    required this.title,
    this.description,
    required this.bottomRowChildren,
    this.secondaryBottomRowChildren,
    this.borderRadius = 16,
    this.contentPadding = const EdgeInsets.all(14),
    this.contentBackgroundColor = const Color(0xFFF5F9FF),
    this.showBlueOverlayBottom = true,
    this.overlayHeight = 56,
    this.showLeftPrimaryStrip = true,
    this.actionIconsTopRight = const [],
    this.topLeftOverlayWidget,
    this.topRightOverlayWidget,
  });

  @override
  State<UnifiedInfoCard> createState() => _UnifiedInfoCardState();
}

class _UnifiedInfoCardState extends State<UnifiedInfoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.08),
              blurRadius: _isHovered ? 16 : 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area with overlays
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.borderRadius),
                  topRight: Radius.circular(widget.borderRadius),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                      Image.network(
                        _buildFullImageUrl(widget.imageUrl!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(widget.fallbackIcon, size: 48, color: Colors.black.withOpacity(0.6)),
                          );
                        },
                      )
                    else
                      Center(child: Icon(widget.fallbackIcon, size: 48, color: Colors.black.withOpacity(0.6))),

                    if (widget.showBlueOverlayBottom)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: IgnorePointer(
                          child: SizedBox(
                            height: widget.overlayHeight,
                            child: const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Color(0x800A4A9D), Color(0x000A4A9D)],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    if (widget.showLeftPrimaryStrip)
                      const Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: SizedBox(
                          width: 3,
                          child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFF0A4A9D))),
                        ),
                      ),

                    if (widget.actionIconsTopRight.isNotEmpty)
                      Positioned(top: 10, right: 10, child: Row(children: widget.actionIconsTopRight)),

                    if (widget.topLeftOverlayWidget != null)
                      Positioned(top: 10, left: 10, child: widget.topLeftOverlayWidget!),
                    if (widget.topRightOverlayWidget != null)
                      Positioned(top: 10, right: 10, child: widget.topRightOverlayWidget!),
                  ],
                ),
              ),
            ),

            // Content area
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.contentBackgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(widget.borderRadius),
                    bottomRight: Radius.circular(widget.borderRadius),
                  ),
                ),
                child: Padding(
                  padding: widget.contentPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF1F2937)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (widget.description != null && widget.description!.isNotEmpty) ...[
                        Text(
                          widget.description!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: const Color(0xFF6B7280), height: 1.2),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                      ],
                      const Spacer(),
                      Row(children: widget.bottomRowChildren),
                      if (widget.secondaryBottomRowChildren != null) ...[
                        const SizedBox(height: 2),
                        Row(children: widget.secondaryBottomRowChildren!),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildFullImageUrl(String imageUrl) {
    // Eğer zaten tam URL ise, olduğu gibi döndür
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }

    // Eğer relative path ise, base URL ekle
    if (imageUrl.startsWith('/')) {
      return 'https://localhost:7276$imageUrl';
    }

    // Eğer sadece dosya adı ise, upload klasörü ekle
    return 'https://localhost:7276/upload/$imageUrl';
  }
}
