import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';
import 'package:ratatouille/features/recipes/presentation/widgets/recipe_card.dart';

import '../provider/fridge_filter_provider.dart';

class ResultFridgeFilterPage extends StatefulWidget {
  const ResultFridgeFilterPage({super.key});

  @override
  State<ResultFridgeFilterPage> createState() => _ResultFridgeFilterPageState();
}

class _ResultFridgeFilterPageState extends State<ResultFridgeFilterPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDDE),
      body: Stack(
        children: [
          /// 🎨 GRADIENT OVERLAY BOTTOM
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFFFF3D00).withOpacity(0.4),
                    const Color(0xFFFFFDDE).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          /// 🍴 PATTERN BAWAH KIRI
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/Resep_bottom_left.png',
              width: 160,
            ),
          ),

          /// 🍴 PATTERN BAWAH KANAN
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Resep_bottom_right.png',
              width: 160,
            ),
          ),

          Column(
            children: [
              /// 🔶 HEADER SEARCH
              Container(
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6A2A),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    /// BACK
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),

                    /// SEARCH FIELD
                    Expanded(
                      child: Text(
                          'Filter Kulkas',
                        style: Theme.of(context)
                        .textTheme.titleLarge,
                      )
                    ),
                  ],
                ),
              ),

              /// List of recipes from FridgeFilterProvider
              Expanded(
                child: Consumer<FridgeFilterProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.results.isEmpty) {
                      return const Center(
                        child: Text("Tidak ada hasil pencarian"),
                      );
                    }

                    return ListView.builder(
                      itemCount: provider.results.length,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, index) {
                        final recipe = provider.results[index];
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
        ],
      ),
    );
  }
}