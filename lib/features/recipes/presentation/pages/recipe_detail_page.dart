import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/data/constant/app_constant.dart';

import '../provider/recipe_detail_provider.dart';

class RecipeDetailPage extends StatefulWidget {
  final int id;

  const RecipeDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late int portion = 1;
  bool showIngredients = true;
  bool showSteps = true;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<RecipeDetailProvider>();
      await provider.fetch(widget.id);

      if (provider.detail != null) {
        setState(() {
          portion = provider.detail!.recipe.portion;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeDetailProvider>();

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(provider.errorMessage!)),
      );
    }

    final detail = provider.detail;

    if(detail == null) {
      return Center(
          child: CircularProgressIndicator()
      );
    }

    final images = detail.recipe.images;
    final description = detail.recipe.description;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDDE),
      body: Column(
          children: [
            /// 🖼 HEADER IMAGE
            Stack(
              children: [
                images.isNotEmpty ?
                CachedNetworkImage(
                  imageUrl: "${AppConstant.baseUrl}${images.first.url}",
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                : Image.asset(
                  'assets/images/default_cover_picture.png',
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.orange,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),

            /// 📄 CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    Text(
                      detail.recipe.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5E2A25),
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// AUTHOR
                    Row(
                      children: [
                        const Icon(Icons.restaurant, size: 16, color: Colors.orange),
                        const SizedBox(width: 6),
                        Text(
                          detail.author.name,
                          style: const TextStyle(
                            color: Color(0xFFB85C38),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "diperbarui ${detail.recipe.updatedAt}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// INFO CARD
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoCard(detail.comments.length.toString(), "Komentar", Icons.chat_bubble_outline),
                        _infoCard(detail.favoriteCount.toString(), detail.isFavorited != null ? "Disimpan" : "Simpan", Icons.bookmark_border),
                        _infoCard(detail.rating.average.toStringAsFixed(1), "${detail.rating.count} nilai\nPenilaian", Icons.star),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// DESCRIPTION
                    Text(
                      description ?? "Deskripsi belum tersedia",
                      style: TextStyle(
                        color: Color(0xFF5E2A25),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// TIME & PORTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Perkiraan waktu",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5E2A25),
                          ),
                        ),
                        Text(
                          "${detail.recipe.estTimeInMinutes} menit",
                          style: TextStyle(
                            color: Color(0xFF5E2A25),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Porsi sajian",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5E2A25),
                          ),
                        ),
                        Row(
                          children: [
                            _portionButton(
                              icon: Icons.remove,
                              onTap: () {
                                if (portion > 1) {
                                  setState(() => portion--);
                                }
                              },
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                portion.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _portionButton(
                              icon: Icons.add,
                              onTap: () {
                                setState(() => portion++);
                              },
                            ),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// 🥕 INGREDIENTS
                    _sectionHeader(
                      title: "Bahan",
                      expanded: showIngredients,
                      onTap: () {
                        setState(() {
                          showIngredients = !showIngredients;
                        });
                      },
                    ),

                    if(showIngredients)
                      ...detail.ingredients.map(
                          (e) {
                            final prtn = portion / detail.recipe.portion;
                            final qty = e.amount != null ? e.amount! * prtn : null;

                            return _ingredientItem(
                                e.tag.name,
                                qty,
                                e.unit
                            );
                          }
                      ),

                    const SizedBox(height: 20),

                    /// 👨‍🍳 STEPS
                    _sectionHeader(
                      title: "Langkah-langkah",
                      expanded: showSteps,
                      onTap: () {
                        setState(() {
                          showSteps = !showSteps;
                        });
                      },
                    ),

                    if (showSteps)
                      ...detail.steps.map(
                          (e) => _stepItem(
                              e.content
                          )
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  /// 🔸 WIDGET BANTUAN
  Widget _infoCard(String value, String label, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF5E2A25),
            ),
          ),
          const SizedBox(height: 4),
          Icon(icon, color: Colors.orange),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    required bool expanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: Color(0xFFF3551E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _ingredientItem(String name, double? qty, String? unit) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text("• $name")),
          qty == null || unit == null
              ? const Text("Secukupnya")
              : Text(
            qty % 1 == 0
                ? "${qty.toInt()} $unit"
                : "${qty.toStringAsFixed(1)} $unit",
          ),
        ],
      ),
    );
  }

  Widget _stepItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        "• $text",
        style: const TextStyle(height: 1.4),
      ),
    );
  }

  Widget _portionButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
