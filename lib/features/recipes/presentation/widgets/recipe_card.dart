import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/data/constant/app_constant.dart';

class RecipeCard extends StatelessWidget {
  final String? imageUrl ;
  final String title;
  final String? subtitle;
  final double rating; // contoh: 4.5
  final String date;
  final int totalReviews;
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
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
            SizedBox(
              width: 116,
              height: 116,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: imageUrl == null
                    ? Image.asset(
                  "assets/images/default_cover_picture.png",
                  fit: BoxFit.cover,
                )
                    : CachedNetworkImage(
                  imageUrl: imageUrl!.startsWith("https")
                      ? imageUrl!
                      : "${AppConstant.baseUrl}$imageUrl",
                  fit: BoxFit.cover,
                ),
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
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F5242),
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 6),

                  /// subtitle
                  if (subtitle != null)
                    Text(
                      subtitle!,
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
                        size: 24,
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
                          fontSize: 12,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "$totalReviews nilai",
                        style: const TextStyle(
                          fontSize: 12,
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
