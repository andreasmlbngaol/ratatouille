import 'package:flutter/material.dart';
import 'package:ratatouille/features/recipes/presentation/widgets/recipe_card.dart';

class MyRecipePage extends StatelessWidget {
  const MyRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF1BE),
      body: Column(
          children: [
            // ===== HEADER ORANGE =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
              decoration: const BoxDecoration(
                color: Color(0xFFFF6A2A),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Resepku',
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              ),
            ),


            const SizedBox(height: 16),

            // ===== LIST RESEP =====
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: RecipeCard(
                      imageUrl:
                      "/uploads/images/3y9t1ASFHQR9HzUmhtB27lWWLDV2/recipe-4/1765958994764.webp",
                      title: "Ronaldo Juna",
                      subtitle: "izin",
                      rating: 1.0,
                      date: "ronaldo",
                      totalReviews: 1,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
}
