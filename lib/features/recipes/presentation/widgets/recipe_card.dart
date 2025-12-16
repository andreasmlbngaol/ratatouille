import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String author;
  final double rating; // contoh: 4.5
  final String date;
  final int totalReviews;
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.author,
    required this.rating,
    required this.date,
    required this.totalReviews,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF3F5242),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            /// 🖼 IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imageAsset,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            /// 📄 CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F5242),
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// AUTHOR
                  Text(
                    "oleh $author",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7A7A7A),
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// ⭐ RATING
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating.floor()
                            ? Icons.star
                            : Icons.star_border,
                        size: 18,
                        color: const Color(0xFFFFA726),
                      );
                    }),
                  ),

                  const SizedBox(height: 6),

                  /// DATE & REVIEW
                  Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "$totalReviews nilai",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
