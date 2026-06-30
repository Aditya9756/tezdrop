import 'package:flutter/material.dart';

/// Renders a product's `image` field smartly:
/// - If it looks like a real image URL (http:// or https://), loads it
///   as a network image with a loading spinner and error fallback.
/// - Otherwise (emoji string, empty, or anything else), renders it as
///   large emoji text — exactly the current behavior.
///
/// This lets the vendor app progressively add real photos per-product
/// in Firebase without breaking products that still only have an emoji.
class ProductImage extends StatelessWidget {
  final String image;
  final double size;
  final double emojiFontSize;
  final BorderRadius? borderRadius;

  const ProductImage({
    super.key,
    required this.image,
    this.size = 56,
    this.emojiFontSize = 28,
    this.borderRadius,
  });

  bool get _isUrl =>
      image.trim().startsWith('http://') || image.trim().startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(12);

    if (!_isUrl) {
      // Emoji fallback — same as before
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: radius,
        ),
        child: Center(
          child: Text(
            image.isEmpty ? '🍽️' : image,
            style: TextStyle(fontSize: emojiFontSize),
          ),
        ),
      );
    }

    // Real vendor-uploaded image
    return ClipRRect(
      borderRadius: radius,
      child: Image.network(
        image,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: size,
            height: size,
            color: const Color(0xFFF3F4F6),
            child: Center(
              child: SizedBox(
                width: size * 0.35,
                height: size * 0.35,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // Image URL broken/unreachable — fall back to a generic plate emoji
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: radius,
            ),
            child: Center(
              child: Text('🍽️', style: TextStyle(fontSize: emojiFontSize)),
            ),
          );
        },
      ),
    );
  }
}