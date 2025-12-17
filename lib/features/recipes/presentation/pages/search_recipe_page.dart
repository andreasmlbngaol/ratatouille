import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/app_routes.dart';
import '../provider/search_recipe_provider.dart';

class SearchRecipePage extends StatefulWidget {
  const SearchRecipePage({super.key});

  @override
  State<SearchRecipePage> createState() => _SearchRecipePageState();
}

class _SearchRecipePageState extends State<SearchRecipePage> {
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
                      onPressed: () => context.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),

                    /// SEARCH FIELD
                    Expanded(
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: 'Cari resep...',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                final query = _searchController.text.trim();
                                if (query.length < 3) return;

                                context.push(
                                  AppRoutes.searchResultPage,
                                );
                              },
                            ),
                            border: InputBorder.none,
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onChanged: (value) {
                            context
                                .read<SearchRecipeProvider>()
                                .search(query: value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 📄 SEARCH RESULT
              Expanded(
                child: Consumer<SearchRecipeProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (provider.errorMessage != null) {
                      return Center(
                        child: Text(provider.errorMessage!),
                      );
                    }

                    if (provider.results.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada hasil'),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: provider.results.length,
                      separatorBuilder: (_, _) => const Divider(
                        color: Color(0xFFD9A88C),
                        height: 1,
                      ),
                      itemBuilder: (_, index) {
                        final recipe = provider.results[index];
                        return ListTile(
                          title: Text(
                            recipe.recipe.name,
                            style: const TextStyle(
                              color: Color(0xFF5E2A25),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            debugPrint('Pilih ${recipe.recipe.name}');
                            context.push(
                              "${AppRoutes.recipeDetail}/${recipe.recipe.id}"
                            );
                          },
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
