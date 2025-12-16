import 'package:flutter/material.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  int portion = 1;
  bool showIngredients = true;
  bool showSteps = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDDE),
      body: Column(
        children: [
          /// 🖼 HEADER IMAGE
          Stack(
            children: [
              Image.asset(
                'assets/images/bakso_mercon_detail.png',
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
                  const Text(
                    "Bakso Mercon",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E2A25),
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// AUTHOR
                  Row(
                    children: const [
                      Icon(Icons.restaurant, size: 16, color: Colors.orange),
                      SizedBox(width: 6),
                      Text(
                        "Clara Angelin",
                        style: TextStyle(
                          color: Color(0xFFB85C38),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "diperbarui 23 Oktober 2025",
                        style: TextStyle(
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
                      _infoCard("10", "Komentar", Icons.chat_bubble_outline),
                      _infoCard("10", "Disimpan", Icons.bookmark_border),
                      _infoCard("5.0", "10 nilai\nPenilaian", Icons.star),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// DESCRIPTION
                  const Text(
                    "Bakso mercon adalah hidangan pedas menggugah selera yang "
                        "terbuat dari daging sapi cincang lembut, dicampur bumbu khas Nusantara. "
                        "Bola daging disajikan sambal cabai rawit melimpah yang meledak di mulut "
                        "saat digigit. Kuahnya gurih pedas berpadu aroma bawang dan kaldu sapi.",
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
                      const Text(
                        "30 menit",
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

                  if (showIngredients)
                    _ingredientItem("Bakso Sapi", "10", "Butir"),
                  if (showIngredients)
                    _ingredientItem("Cabai merah besar", "3", "Buah"),
                  if (showIngredients)
                    _ingredientItem("Cabai setan", "1", "Buah"),
                  if (showIngredients)
                    _ingredientItem("Minyak Goreng", "2", "Sdm"),
                  if (showIngredients)
                    _ingredientItem("Air", "50", "mL"),
                  if (showIngredients)
                    _ingredientItem("Garam", "1/4", "Sdt"),
                  if (showIngredients)
                    _ingredientItem("Kecap Manis", "1", "Sdm"),

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
                    _stepItem(
                        "Panaskan minyak, tumis cabai merah dan cabai setan hingga harum."),
                  if (showSteps)
                    _stepItem(
                        "Masukkan bakso, aduk rata hingga bakso agak kecoklatan."),
                  if (showSteps)
                    _stepItem(
                        "Tambahkan air, garam, dan kecap manis. Masak hingga air menyusut."),
                  if (showSteps)
                    _stepItem("Angkat dan sajikan hangat."),
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
          color: Colors.orange,
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

  Widget _ingredientItem(String name, String qty, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text("• $name")),
          Text("$qty $unit"),
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
