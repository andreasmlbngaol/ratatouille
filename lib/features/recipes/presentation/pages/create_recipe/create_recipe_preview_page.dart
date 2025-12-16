import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';
import 'package:ratatouille/features/recipes/presentation/provider/create_recipe_provider.dart';

class CreateRecipePreviewPage extends StatefulWidget {
  const CreateRecipePreviewPage({super.key});

  @override
  State<CreateRecipePreviewPage> createState() => _CreateRecipePreviewPageState();
}

class _CreateRecipePreviewPageState extends State<CreateRecipePreviewPage> {
  Color get bg => const Color(0xFFFFFDDE);
  Color get accent => const Color(0xFFF3551E);
  Color get textDark => const Color(0xFF5E2A25);
  Color get textGreen => const Color(0xFF3F5242);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<CreateRecipeProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: bg,
            appBar: AppBar(
              foregroundColor: bg,
              backgroundColor: accent,
              title: Text(
                'Preview Resep',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: bg,
                ),
              ),
              automaticallyImplyLeading: false,
            ),

            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                final success = await provider.publishRecipe();

                if (mounted) {
                  if (success) {
                    provider.reset(); // Clear provider
                    context.go(AppRoutes.home);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.errorMessage ?? 'Gagal menyimpan resep'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              backgroundColor: textGreen,
              icon: Icon(Icons.check, color: bg),
              label: Text(
                "Simpan",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: bg,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            body: _buildBody(provider, context),
          );
        },
      ),
    );
  }

  Widget _buildBody(CreateRecipeProvider provider, BuildContext context) {
    if (provider.errorMessage != null && provider.errorMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        provider.clearError();
      });
    }

    if (provider.recipe == null) {
      return Center(
        child: Text(
          'Recipe data not found',
          style: TextStyle(color: textDark),
        ),
      );
    }

    final recipe = provider.recipe!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          if (recipe.images.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl:
                "https://ratatouille.sanalab.live${recipe.images.first.url}",
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDFA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: textDark, width: 2),
              ),
              child: Icon(Icons.image, size: 48, color: textDark),
            ),

          const SizedBox(height: 20),

          // NAME
          Text(
            recipe.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 8),

          // DESCRIPTION
          if (recipe.description != null && recipe.description!.isNotEmpty)
            Text(
              recipe.description!,
              style:
              TextStyle(fontSize: 14, color: textDark.withOpacity(0.7)),
            ),

          const SizedBox(height: 20),

          // META INFO
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MetaInfoCard(
                icon: Icons.timer,
                label: 'Waktu',
                value: '${recipe.estTimeInMinutes} menit',
                color: textDark,
              ),
              _MetaInfoCard(
                icon: Icons.people,
                label: 'Porsi',
                value: '${recipe.portion}',
                color: textDark,
              ),
              _MetaInfoCard(
                icon: Icons.visibility,
                label: 'Status',
                value: recipe.isPublic ? 'Publik' : 'Privat',
                color: textDark,
              ),
            ],
          ),

          const SizedBox(height: 28),

          // INGREDIENTS
          Text(
            'Bahan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: textDark,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),

          if (provider.ingredients.isEmpty)
            Text(
              'Belum ada bahan',
              style: TextStyle(color: textDark.withOpacity(0.6)),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = provider.ingredients[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 20, color: textGreen),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ingredient.tag.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: textDark,
                              ),
                            ),
                            Text(
                              '${ingredient.amount ?? '-'} ${ingredient.unit ?? ''}${ingredient.alternative != null ? ' (atau ${ingredient.alternative})' : ''}',
                              style: TextStyle(
                                fontSize: 12,
                                color: textDark.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          const SizedBox(height: 28),

          // STEPS
          Text(
            'Langkah-langkah',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: textDark,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),

          if (provider.steps.isEmpty)
            Text(
              'Belum ada langkah',
              style: TextStyle(color: textDark.withOpacity(0.6)),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.steps.length,
              itemBuilder: (context, index) {
                final step = provider.steps[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: accent,
                            child: Text(
                              '${step.stepNumber}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: bg,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              step.content,
                              style: TextStyle(
                                fontSize: 14,
                                color: textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (step.images.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          height: 180,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: step.images.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(width: 10),
                            itemBuilder: (_, imgIndex) {
                              final img = step.images[imgIndex];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  "https://ratatouille.sanalab.live${img.url}",
                                  width: 180,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _MetaInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetaInfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      width: 110,
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
