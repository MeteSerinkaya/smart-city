import 'package:flutter/widgets.dart';

class SectionRef {
  final String label;
  final GlobalKey key;
  const SectionRef({required this.label, required this.key});
}

class ScrollSectionTracker {
  final ScrollController scrollController;
  final List<SectionRef> sectionsInOrder;

  const ScrollSectionTracker({
    required this.scrollController,
    required this.sectionsInOrder,
  });

  String computeActiveLabel({double viewportBias = 0.35}) {
    if (!scrollController.hasClients || sectionsInOrder.isEmpty) {
      return sectionsInOrder.isNotEmpty ? sectionsInOrder.first.label : 'Ana Sayfa';
    }

    final double viewportHeight = scrollController.position.viewportDimension;
    final double focusLine = scrollController.offset + viewportHeight * viewportBias;

    // Build list of start offsets for each section in document coordinates
    final List<_SectionStart> starts = [];
    for (final ref in sectionsInOrder) {
      final ctx = ref.key.currentContext;
      if (ctx == null) continue;
      final renderBox = ctx.findRenderObject();
      if (renderBox is RenderBox) {
        final dy = renderBox.localToGlobal(Offset.zero).dy;
        final startOffset = scrollController.offset + dy;
        starts.add(_SectionStart(label: ref.label, startOffset: startOffset));
      }
    }

    // If we failed to measure, fallback to first
    if (starts.isEmpty) return sectionsInOrder.first.label;

    // Sort by start offset
    starts.sort((a, b) => a.startOffset.compareTo(b.startOffset));

    // Find the last section whose start is <= focusLine
    String active = starts.first.label;
    for (final s in starts) {
      if (s.startOffset <= focusLine) {
        active = s.label;
      } else {
        break;
      }
    }
    return active;
  }

  /// Computes active label with hysteresis to prevent jitter near boundaries.
  /// - viewportBias: 0.0 top, 1.0 bottom. Suggested 0.35 for natural feel.
  /// - hysteresisPx: additional distance required past a boundary before switching.
  String computeActiveLabelWithHysteresis(
    String previousActiveLabel, {
    double viewportBias = 0.35,
    double hysteresisPx = 120,
  }) {
    if (!scrollController.hasClients || sectionsInOrder.isEmpty) {
      return sectionsInOrder.isNotEmpty ? sectionsInOrder.first.label : previousActiveLabel;
    }

    final double viewportHeight = scrollController.position.viewportDimension;
    final double focusLine = scrollController.offset + viewportHeight * viewportBias;

    final List<_SectionStart> starts = [];
    for (final ref in sectionsInOrder) {
      final ctx = ref.key.currentContext;
      if (ctx == null) continue;
      final renderBox = ctx.findRenderObject();
      if (renderBox is RenderBox) {
        final dy = renderBox.localToGlobal(Offset.zero).dy;
        final startOffset = scrollController.offset + dy;
        starts.add(_SectionStart(label: ref.label, startOffset: startOffset));
      }
    }
    if (starts.isEmpty) return previousActiveLabel;

    starts.sort((a, b) => a.startOffset.compareTo(b.startOffset));

    // candidate is last start <= focusLine
    String candidate = starts.first.label;
    int candidateIndex = 0;
    for (int i = 0; i < starts.length; i++) {
      if (starts[i].startOffset <= focusLine) {
        candidate = starts[i].label;
        candidateIndex = i;
      } else {
        break;
      }
    }

    if (candidate == previousActiveLabel) return candidate;

    final int prevIndex = starts.indexWhere((s) => s.label == previousActiveLabel);
    if (prevIndex == -1) return candidate; // fallback if unknown previous

    final double candidateStart = starts[candidateIndex].startOffset;
    final double prevStart = starts[prevIndex].startOffset;

    // Determine direction
    if (candidateIndex > prevIndex) {
      // moving forward: require focusLine passes candidateStart + hysteresis
      if (focusLine >= candidateStart + hysteresisPx) {
        return candidate;
      } else {
        return previousActiveLabel;
      }
    } else {
      // moving backward: require focusLine before prevStart - hysteresis
      if (focusLine <= prevStart - hysteresisPx) {
        return candidate;
      } else {
        return previousActiveLabel;
      }
    }
  }
}

class _SectionStart {
  final String label;
  final double startOffset;
  const _SectionStart({required this.label, required this.startOffset});
}
