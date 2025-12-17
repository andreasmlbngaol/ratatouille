import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/features/recipes/presentation/provider/recipe_detail_provider.dart';

class RatingDialog extends StatefulWidget {
  final int recipeId;

  const RatingDialog({
    super.key,
    required this.recipeId,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int selectedRating = 0;
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Beri penilaian',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7A1E1E),
              ),
            ),
            const SizedBox(height: 16),

            // Rating stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  iconSize: 32,
                  onPressed: isSubmitting
                      ? null
                      : () {
                    setState(() {
                      selectedRating = index + 1;
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    color: index < selectedRating
                        ? Colors.orange
                        : Colors.orange.withOpacity(0.3),
                  ),
                );
              }),
            ),

            // Labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Terkecil',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Tertinggi',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E4F3E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: isSubmitting || selectedRating == 0
                        ? null
                        : () async {
                      setState(() {
                        isSubmitting = true;
                      });

                      await context
                          .read<RecipeDetailProvider>()
                          .submitRating(widget.recipeId, selectedRating);

                      if (mounted) {
                        Navigator.pop(context, selectedRating);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Penilaian Anda berhasil disimpan'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: isSubmitting
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text('Simpan'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB71C1C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: isSubmitting
                        ? null
                        : () {
                      Navigator.pop(context);
                    },
                    child: const Text('Batal'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}