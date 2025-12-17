import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';
import 'package:ratatouille/features/recipes/presentation/provider/my_recipe_provider.dart';
import 'package:ratatouille/features/recipes/presentation/widgets/recipe_card.dart';

class MyRecipePage extends StatefulWidget {
  const MyRecipePage({super.key});

  @override
  State<MyRecipePage> createState() => _MyRecipePageState();
}

class _MyRecipePageState extends State<MyRecipePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyRecipeProvider>().fetchMyRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF1BE),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF6A2A), // Oranye
              Color(0xFFFFFDDE), // Kuning
            ],
            stops: [0.1, 0.1], // 0 = atas, 1 = bawah
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ===== HEADER ORANGE =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                child: Consumer<MyRecipeProvider>(
                  builder: (context, provider, _) {
                    // Loading state
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // Error state
                    if (provider.errorMessage != null &&
                        provider.errorMessage!.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error: ${provider.errorMessage}',
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => provider.fetchMyRecipes(),
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      );
                    }

                    // Empty state
                    if (provider.recipes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.restaurant_menu,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Belum ada resep yang dibuat',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // List of recipes
                    return ListView.builder(
                      itemCount: provider.recipes.length,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, index) {
                        final recipe = provider.recipes[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: RecipeCard(
                            imageUrl: recipe.recipe.images.firstOrNull?.url,
                            title: recipe.recipe.name,
                            subtitle: recipe.recipe.isPublic ? "Publik" : "Privat",
                            rating: recipe.rating.average,
                            date: recipe.recipe.updatedAt,
                            totalReviews: recipe.rating.count,
                            onTap: () {
                              context.push(
                                "${AppRoutes.recipeDetail}/${recipe.recipe.id}"
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}