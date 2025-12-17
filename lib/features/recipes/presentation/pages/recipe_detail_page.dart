import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/data/constant/app_constant.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ratatouille/features/kulkas/presentation/widgets/rating_dialog.dart';

import '../../../../core/presentation/app_routes.dart';
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
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);

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

  String _formatDate(int epochMillis) {
    final date = DateTime.fromMillisecondsSinceEpoch(epochMillis);
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  String _formatNumber(double value) {
    final formatter = NumberFormat('#,##0.##', 'id_ID');
    return formatter.format(value);
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
    final currentUser = provider.currentUserId;

    if(detail == null) {
      return const Scaffold(
        body: Center(
            child: CircularProgressIndicator()
        ),
      );
    }

    final images = detail.recipe.images;
    final description = detail.recipe.description;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDDE),
      body: Column(
        children: [
          /// 🖼 HEADER IMAGE CAROUSEL
          Stack(
            children: [
              images.isNotEmpty ?
              SizedBox(
                height: 260,
                width: double.infinity,
                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      currentImageIndex = index;
                    });
                  },
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: "${AppConstant.baseUrl}${images[index].url}",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/default_cover_picture.png',
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              )
                  : Image.asset(
                'assets/images/default_cover_picture.png',
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              /// Back Button
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFFF3551E),
                    size: 28,
                  ),
                ),
              ),

              /// Image Counter
              if (images.isNotEmpty)
                Positioned(
                  bottom: 12,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "${currentImageIndex + 1}/${images.length}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
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
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5E2A25),
                      ),
                    ),

                  const SizedBox(height: 6),

                  /// AUTHOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.restaurant, size: 16, color: Color(0xFFF3551E)),
                            const SizedBox(width: 6),
                            Text(
                              detail.author.name,
                              style: const TextStyle(
                                color: Color(0xFFB85C38),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        Text(
                          "diperbarui ${_formatDate(detail.recipe.updatedAt)}",
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () => {
                            context.push(
                                "${AppRoutes.commentPage}/${detail.recipe.id}"
                            )
                          },
                          child: _infoCardComment(detail.comments.length.toString())
                      ),

                      GestureDetector(
                        onTap: () async {
                          if(detail.isFavorited != null) {
                            if(!detail.isFavorited!) {
                              await context
                                  .read<RecipeDetailProvider>()
                                  .saveRecipe(detail.recipe.id);
                            } else {
                              await context
                                  .read<RecipeDetailProvider>()
                                  .removeSavedRecipe(detail.recipe.id);
                            }
                          }
                        },
                        child: _infoCardFavorite(
                          detail.favoriteCount.toString(),
                          detail.isFavorited ?? false,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if(detail.author.id != currentUser?.id) {
                            showDialog(
                            context: context,
                            builder: (context) => RatingDialog(
                              recipeId: detail.recipe.id,
                            ),
                          );
                          }
                        },
                        child: _infoCardRating(
                          detail.rating.average.toStringAsFixed(1),
                          detail.rating.count.toString(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// DESCRIPTION
                  Center(
                    child: Text(
                      description ?? "Deskripsi belum tersedia",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF5E2A25),
                        height: 1.5,
                      ),
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
                        style: const TextStyle(
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
                    ...detail.steps.asMap().entries.map(
                            (entry) => _stepItem(
                          stepNumber: entry.key + 1,
                          text: entry.value.content,
                          images: entry.value.images,
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
  Widget _infoCardComment(String value) {
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: Color(0xFFF3551E)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF5E2A25),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chat_bubble, color: Color(0xFF3F5242), size: 37),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Komentar",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _infoCardFavorite(String value, bool isFavorited) {
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: Color(0xFFF3551E)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF5E2A25),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.bookmark,
                color: isFavorited ? const Color(0xFFF3551E) : const Color(0xFF818181),
                size: 37,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isFavorited ? "Disimpan" : "Simpan",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _infoCardRating(String avg, String count) {
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: Color(0xFFF3551E)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    avg,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF5E2A25),
                    ),
                  ),
                  Text(
                    "$count nilai",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star, color: Color(0xFFF5A12D), size: 37),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Penilaian",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
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
          color: const Color(0xFFF3551E),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text("• $name")),
          qty == null || unit == null
              ? const Text("Secukupnya")
              : Text(
            "${_formatNumber(qty)} $unit",
          ),
        ],
      ),
    );
  }

  Widget _stepItem({
    required int stepNumber,
    required String text,
    required List<dynamic> images,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Step Number
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF3551E),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          /// Text & Images
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(height: 1.4),
                ),
                if (images.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: images.map((img) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: "${AppConstant.baseUrl}${img.url}",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
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
          border: Border.all(width: 2.0, color: Color(0xFFF3551E)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}