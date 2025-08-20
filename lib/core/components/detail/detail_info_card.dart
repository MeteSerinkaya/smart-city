import 'package:flutter/material.dart';

class DetailInfoCard extends StatefulWidget {
  final IconData? leadingIcon;
  final String? title;
  final Widget? trailing;
  final Widget child;

  const DetailInfoCard({
    super.key,
    this.leadingIcon,
    this.title,
    this.trailing,
    required this.child,
  });

  @override
  State<DetailInfoCard> createState() => _DetailInfoCardState();
}

class _DetailInfoCardState extends State<DetailInfoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: _hovered ? (Matrix4.identity()..translate(0.0, -2.0)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hovered ? 0.08 : 0.04),
              blurRadius: _hovered ? 16 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null || widget.leadingIcon != null || widget.trailing != null)
                Row(
                  children: [
                    if (widget.leadingIcon != null) ...[
                      Icon(widget.leadingIcon, color: const Color(0xFF0A4A9D)),
                      const SizedBox(width: 8),
                    ],
                    if (widget.title != null)
                      Expanded(
                        child: Text(
                          widget.title!,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1F2937),
                              ),
                        ),
                      ),
                    if (widget.trailing != null) widget.trailing!,
                  ],
                ),
              if (widget.title != null || widget.leadingIcon != null || widget.trailing != null)
                const SizedBox(height: 12),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}


