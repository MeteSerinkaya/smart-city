import 'package:flutter/material.dart';
import 'dart:ui';

/// Hero image üzerinde overlay olarak detay bilgileri gösteren yeni tasarım
class HeroDetailScaffold extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String? date;
  final String? location;
  final String? description;
  final List<Widget>? bottomActions;
  final String? heroTag;

  const HeroDetailScaffold({
    super.key,
    required this.title,
    this.imageUrl,
    this.date,
    this.location,
    this.description,
    this.bottomActions,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Image Section with Card
            Container(
              height: 400,
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Image Background
                    if (imageUrl != null && imageUrl!.isNotEmpty)
                      Positioned.fill(
                        child: Hero(
                          tag: heroTag ?? imageUrl!,
                          child: Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFE5E7EB),
                                child: const Center(
                                  child: Icon(Icons.image_not_supported, size: 64, color: Color(0xFF9CA3AF)),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: const Color(0xFFE5E7EB),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A4A9D)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    else
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF0A4A9D), Color(0xFF1E40AF), Color(0xFF3B82F6)],
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.announcement, size: 120, color: Colors.white.withOpacity(0.3)),
                          ),
                        ),
                      ),

                    // Gradient Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0x66000000), Color(0xCC000000)],
                            stops: [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Information Card - Moved to bottom center for better visual balance
                    // Sol Alt Köşede Kompakt Card - Tüm Sayfalar İçin (Wrap ile overflow önleme)
                    Positioned(
                      left: 24,
                      bottom: 24,
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 340, maxHeight: 220),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Title - Kompakt ve okunabilir
                                  Flexible(
                                    child: Text(
                                      title,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2D3748),
                                        height: 1.2,
                                        letterSpacing: -0.2,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Date and Location Pills - Wrap ile overflow önleme
                                  if (date != null || location != null)
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 8,
                                      children: [
                                        if (date != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.calendar_today, size: 12, color: const Color(0xFF0A4A9D)),
                                                const SizedBox(width: 6),
                                                Flexible(
                                                  child: Text(
                                                    date!,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xFF0A4A9D),
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (location != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.location_on, size: 12, color: const Color(0xFF0A4A9D)),
                                                const SizedBox(width: 6),
                                                Flexible(
                                                  child: Text(
                                                    location!,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xFF0A4A9D),
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),

                                  // Action Buttons - Wrap ile overflow önleme
                                  if (bottomActions != null) ...[
                                    const SizedBox(height: 18),
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 8,
                                      children: bottomActions!.map((action) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                                          ),
                                          child: action,
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Description Card with Actions
            Container(
              margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description Section
                  if (description != null) ...[
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A4A9D).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.description, color: Color(0xFF0A4A9D), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Açıklama',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      description!,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
