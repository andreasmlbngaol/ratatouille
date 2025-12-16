import 'package:flutter/material.dart';

class FilterResepWidget extends StatefulWidget {
  const FilterResepWidget({super.key});

  @override
  State<FilterResepWidget> createState() => _FilterResepWidgetState();
}

class _FilterResepWidgetState extends State<FilterResepWidget> {
  int selectedRating = 4;
  final TextEditingController minController = TextEditingController();
  final TextEditingController maxController = TextEditingController();

  @override
  void dispose() {
    minController.dispose();
    maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDDE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔶 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                "Filter Resep",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// ⭐ RATING
          const Text(
            "Rating",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF5E2A25),
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF5E2A25)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRating = index + 1;
                    });
                  },
                  child: Icon(
                    Icons.star,
                    size: 32,
                    color: index < selectedRating
                        ? const Color(0xFFFFA726)
                        : Colors.grey,
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 6),

          /// TERENDAH - TERTINGGI
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Terendah",
                style: TextStyle(fontSize: 12, color: Color(0xFFB85C38)),
              ),
              Text(
                "Tertinggi",
                style: TextStyle(fontSize: 12, color: Color(0xFFB85C38)),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// ⏱ PERKIRAAN WAKTU
          const Text(
            "Perkiraan waktu",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF5E2A25),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Text("MIN"),
              const SizedBox(width: 8),
              Expanded(
                child: _timeField(minController),
              ),
              const SizedBox(width: 16),
              const Text("MAX"),
              const SizedBox(width: 8),
              Expanded(
                child: _timeField(maxController),
              ),
            ],
          ),

          const SizedBox(height: 28),

          /// 🔘 BUTTON
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB71C1C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Batalkan",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F5242),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    debugPrint(
                      "Rating: $selectedRating, "
                          "Min: ${minController.text}, "
                          "Max: ${maxController.text}",
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Terapkan",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _timeField(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
