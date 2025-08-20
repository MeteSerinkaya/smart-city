import 'package:flutter/material.dart';

class NavigationItemColors {
  static const Color activeColor = Color(0xFF0A4A9D); // Koyu mavi
  static const Color inactiveColor = Color(0xFF1F2937); // Koyu gri
  static const Color transparentActiveColor = Colors.white;
  static const Color transparentInactiveColor = Colors.white70;

  static Color getColor(String item, String activeItem, bool isTransparent) {
    final bool isActive = item == activeItem;
    if (isTransparent) {
      return isActive ? transparentActiveColor : transparentInactiveColor;
    } else {
      return isActive ? activeColor : inactiveColor;
    }
  }

  static Color getBackgroundColor(String item, String activeItem, bool isTransparent, bool isHovered) {
    final bool isActive = item == activeItem;
    if (isTransparent) {
      if (isActive) {
        return Colors.white.withOpacity(0.3);
      } else if (isHovered) {
        return Colors.white.withOpacity(0.15);
      }
      return Colors.transparent;
    } else {
      if (isActive) {
        return activeColor.withOpacity(0.15);
      } else if (isHovered) {
        return inactiveColor.withOpacity(0.08);
      }
      return Colors.transparent;
    }
  }

  static Color getBorderColor(String item, String activeItem, bool isTransparent) {
    final bool isActive = item == activeItem;
    if (isTransparent) {
      return isActive ? Colors.white : Colors.transparent;
    } else {
      return isActive ? activeColor : Colors.transparent;
    }
  }
}


