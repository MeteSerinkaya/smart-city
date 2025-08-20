import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// A responsive sliding window carousel that shows up to [maxVisible] items
/// and allows navigating one-by-one with next/previous buttons.
///
/// - Left button is hidden at the initial state (startIndex == 0).
/// - Right button advances the window by 1; when the end is reached and
///   [enableLoop] is true, it wraps back to the start (startIndex = 0).
/// - If item count <= visible count, navigation buttons are hidden.
class SlidingWindowCarousel<T> extends StatefulWidget {
  const SlidingWindowCarousel({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.maxVisible = 3,
    this.enableLoop = true,
    this.gap = 32,
    this.padding,
    this.backgroundColor,
    this.borderRadius = 0,
    this.itemAspectRatio = 0.75,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int absoluteIndex) itemBuilder;

  /// Maximum number of items to show at once on wide screens.
  final int maxVisible;
  final bool enableLoop;
  final double gap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double borderRadius;
  final double itemAspectRatio; // width / height

  @override
  State<SlidingWindowCarousel<T>> createState() => _SlidingWindowCarouselState<T>();
}

class _SlidingWindowCarouselState<T> extends State<SlidingWindowCarousel<T>> {
  int _startIndex = 0;
  int _lastStartIndex = 0;
  int _direction = 0; // -1: prev, 1: next, 0: initial

  void _goNext(int total, int visible) {
    if (total <= visible) return; // nothing to do
    final canAdvanceWithinRange = _startIndex + visible < total;
    if (canAdvanceWithinRange) {
      setState(() {
        _lastStartIndex = _startIndex;
        _startIndex += 1;
        _direction = 1;
      });
    } else if (widget.enableLoop) {
      setState(() {
        _lastStartIndex = _startIndex;
        _startIndex = 0;
        _direction = 1;
      });
    }
  }

  void _goPrev() {
    if (_startIndex == 0) return;
    setState(() {
      _lastStartIndex = _startIndex;
      _startIndex -= 1;
      _direction = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final total = widget.items.length;
        final double availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        int visible = 1;
        if (availableWidth > 1400) {
          visible = widget.maxVisible.clamp(1, 4).toInt();
        } else if (availableWidth > 1000) {
          visible = widget.maxVisible.clamp(1, 3).toInt();
        } else if (availableWidth > 700) {
          visible = 2.clamp(1, widget.maxVisible).toInt();
        } else {
          visible = 1;
        }
        visible = visible.clamp(1, widget.maxVisible).toInt();

        final bool showNav = total > visible;
        final bool showPrev = showNav && _startIndex > 0;
        final bool showNext = showNav; // always show next when nav is active

        // Clamp startIndex if data shrank
        if (_startIndex > 0 && _startIndex + visible > total) {
          _startIndex = (total - visible).clamp(0, total).toInt();
        }

        // Reserve horizontal space for outside nav buttons (constant when navigation is active)
        const double buttonSize = 44;
        const double buttonGap = 12;
        final double reservedLeft = showNav ? (buttonSize + buttonGap) : 0;
        final double reservedRight = showNav ? (buttonSize + buttonGap) : 0;
        final double contentWidth = showNav
            ? (availableWidth - reservedLeft - reservedRight).clamp(0, availableWidth)
            : availableWidth;

        final endIndexExclusive = (_startIndex + visible).clamp(0, total).toInt();
        final int displayCount = showNav ? visible : total;
        final int gapsCount = displayCount > 0 ? (displayCount - 1) : 0;
        final double totalGapsWidth = widget.gap * gapsCount;
        final double totalContentWidth = (contentWidth - totalGapsWidth).clamp(0, contentWidth);
        final double baseItemWidth = (displayCount == 0)
            ? totalContentWidth
            : (totalContentWidth / displayCount).floorToDouble();
        final double remainderWidth = totalContentWidth - (baseItemWidth * (displayCount == 0 ? 1 : displayCount));
        // Distribute the remainder (<= displayCount px) from the left to keep slot widths stable across pages
        final List<double> slotWidths = List<double>.generate(displayCount, (j) {
          final needsExtra = j < remainderWidth.round();
          return baseItemWidth + (needsExtra ? 1.0 : 0.0);
        });
        final double itemHeight = baseItemWidth / widget.itemAspectRatio;

        final List<Widget> tiles = <Widget>[];
        for (int i = _startIndex; i < endIndexExclusive; i++) {
          final int j = i - _startIndex; // relative index in the window
          final double widthForThisTile = (j < slotWidths.length) ? slotWidths[j] : baseItemWidth;
          tiles.add(
            SizedBox(
              width: widthForThisTile,
              child: widget.itemBuilder(context, widget.items[i], i),
            ),
          );
          if (i < endIndexExclusive - 1) {
            tiles.add(SizedBox(width: widget.gap));
          }
        }

        final Widget contentChild = SizedBox(
          key: ValueKey<int>(_startIndex),
          width: contentWidth,
          height: itemHeight,
          child: Row(children: tiles),
        );

        final content = Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: AnimatedSwitcher(
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              duration: const Duration(milliseconds: 320),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                if (_direction == 0) {
                  return FadeTransition(opacity: animation, child: child);
                }
                final beginOffset = _direction > 0 ? const Offset(0.12, 0) : const Offset(-0.12, 0);
                final slide = Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(animation);
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: slide, child: child),
                );
              },
              child: contentChild,
            ),
          ),
        );

        if (!showNav) {
          return content;
        }

        return SizedBox(
          width: availableWidth,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: reservedLeft,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedOpacity(
                    opacity: showPrev ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 180),
                    child: IgnorePointer(
                      ignoring: !showPrev,
                      child: _NavGlassButton(icon: Icons.chevron_left, onTap: _goPrev, tooltip: 'Önceki'),
                    ),
                  ),
                ),
              ),
              SizedBox(width: contentWidth, child: content),
              SizedBox(
                width: reservedRight,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _NavGlassButton(
                    icon: Icons.chevron_right,
                    onTap: () => _goNext(total, visible),
                    tooltip: 'Sonraki',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavGlassButton extends StatefulWidget {
  const _NavGlassButton({required this.icon, required this.onTap, this.tooltip});

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  State<_NavGlassButton> createState() => _NavGlassButtonState();
}

class _NavGlassButtonState extends State<_NavGlassButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final button = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..translate(0.0, _hovered ? -1.5 : 0.0)
            ..scale(_hovered ? 1.06 : 1.0),
          width: 44,
          height: 44,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background blur
                BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: const SizedBox(),
                ),
                // Gradient circle
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF0A4A9D).withOpacity(0.60),
                        const Color(0xFF0A4A9D).withOpacity(0.90),
                      ],
                    ),
                    border: Border.all(color: Colors.white.withOpacity(0.28), width: 1),
                    boxShadow: _hovered
                        ? [BoxShadow(color: const Color(0xFF0A4A9D).withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))]
                        : [BoxShadow(color: const Color(0xFF0A4A9D).withOpacity(0.22), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                ),
                Center(child: Icon(widget.icon, color: Colors.white, size: 22)),
              ],
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip == null) return button;
    return Tooltip(message: widget.tooltip!, child: button);
  }
}


