import 'package:flutter/material.dart';

/// Admin panel için standardize edilmiş tablo kartı
class AdminTableCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const AdminTableCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? AdminTableCardConstants.defaultPadding,
      decoration: AdminTableCardConstants.defaultDecoration,
      child: child,
    );
  }
}

/// Admin tablo kartları için sabit değerler
class AdminTableCardConstants {
  AdminTableCardConstants._();

  // Padding değerleri
  static const EdgeInsetsGeometry defaultPadding = EdgeInsets.all(0);
  static const EdgeInsetsGeometry contentPadding = EdgeInsets.all(24);

  // Boyut değerleri
  static const double maxWidth = 1200;
  static const double minHeight = 400;
  static const double maxHeight = 600;

  // Border radius
  static const double borderRadius = 20;

  // Decoration
  static BoxDecoration get defaultDecoration => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.white.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: 0,
          ),
        ],
      );
}

/// Admin panel DataTable için özelleştirilmiş widget
class AdminDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double? columnSpacing;
  final bool showCheckboxColumn;

  const AdminDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.columnSpacing,
    this.showCheckboxColumn = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AdminTableCardConstants.maxWidth,
        ),
        child: Container(
          decoration: AdminTableCardConstants.defaultDecoration,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AdminTableCardConstants.borderRadius),
            child: DataTable(
              columnSpacing: columnSpacing ?? 20,
              showCheckboxColumn: showCheckboxColumn,
              headingRowColor: MaterialStateProperty.all(
                const Color(0xFF1E293B).withOpacity(0.05),
              ),
              headingTextStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFF1E293B),
              ),
              dataTextStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
              columns: columns,
              rows: rows,
            ),
          ),
        ),
      ),
    );
  }
}

/// Admin panel için standardize edilmiş başlık widget'ı
class AdminSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;

  const AdminSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                    color: const Color(0xFF1E293B),
                    letterSpacing: -0.5,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

/// Admin panel için standardize edilmiş loading widget'ı
class AdminLoadingWidget extends StatelessWidget {
  const AdminLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminTableCard(
      height: AdminTableCardConstants.minHeight,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF3B82F6),
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Yükleniyor...',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Admin panel için standardize edilmiş empty state widget'ı
class AdminEmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData? icon;

  const AdminEmptyStateWidget({
    super.key,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AdminTableCard(
      height: AdminTableCardConstants.minHeight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF64748B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 20),
            ],
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
