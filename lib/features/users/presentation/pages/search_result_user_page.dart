import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/data/constant/app_constant.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7CC),
      body: SafeArea(
        child: Column(
          children: [
            // Header with search
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFFF5A1F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            'Cari Pengguna...',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Result list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  UserResultCard(name: 'Chef Renata', recipeCount: 500),
                  UserResultCard(name: 'Chef Sanji', recipeCount: 143),
                  UserResultCard(name: 'Chef Gusteau', recipeCount: 125),
                  UserResultCard(name: 'Haji Ronaldo', recipeCount: 143),
                  UserResultCard(name: 'Hokage Joko', recipeCount: 1),
                  UserResultCard(name: 'Gordon Ramsey', recipeCount: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserResultCard extends StatelessWidget {
  final String name;
  final int recipeCount;
  final String? imageUrl;

  const UserResultCard({
    super.key,
    required this.name,
    required this.recipeCount,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.deepOrange, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Image
          SizedBox(
            width: 52,
            height: 52,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: imageUrl == null
                  ? Image.asset(
                'assets/images/default_user.png',
                fit: BoxFit.cover,
              )
                  : CachedNetworkImage(
                imageUrl: imageUrl!.startsWith('https')
                    ? imageUrl!
                    : '${AppConstant.baseUrl}$imageUrl',
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/default_user.png'),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // User info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$recipeCount Resep dibuat',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.brown,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

