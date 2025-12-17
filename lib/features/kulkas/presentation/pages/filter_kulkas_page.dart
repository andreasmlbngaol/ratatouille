import 'package:flutter/material.dart';

class FilterKulkasPage extends StatefulWidget {
  const FilterKulkasPage({super.key});

  @override
  State<FilterKulkasPage> createState() => _FilterKulkasPageState();
}

class _FilterKulkasPageState extends State<FilterKulkasPage> {
  int selectedRating = 4;

  final TextEditingController includeController = TextEditingController();
  final TextEditingController excludeController = TextEditingController();
  final TextEditingController minTimeController = TextEditingController();
  final TextEditingController maxTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7CC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFFFF5A1F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Filter Kulkas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cari resep berdasarkan bahan kulkas-mu!',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 16),

                    _sectionTitle('Include bahan'),
                    _emptyBox(),
                    _inputField(includeController),

                    const SizedBox(height: 20),

                    _sectionTitle('Exclude bahan'),
                    _emptyBox(),
                    _inputField(excludeController),

                    const SizedBox(height: 20),

                    _sectionTitle('Rating'),
                    _ratingBox(),

                    const SizedBox(height: 20),

                    _sectionTitle('Perkiraan waktu'),
                    Row(
                      children: [
                        Expanded(child: _timeField('MIN', minTimeController)),
                        const SizedBox(width: 16),
                        Expanded(child: _timeField('MAX', maxTimeController)),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBA1813),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Batalkan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500, // medium
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3F5242),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Terapkan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500, // medium
                              ),
                            ),
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _emptyBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.brown, width: 1.5),
      ),
      alignment: Alignment.center,
      child: const Text('Belum ada tampilan'),
    );
  }

  Widget _inputField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Tambahkan bahan...',
        filled: true,
        fillColor: const Color(0xFFE7F1E7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _ratingBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.brown, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          final starIndex = index + 1;
          return IconButton(
            onPressed: () {
              setState(() => selectedRating = starIndex);
            },
            icon: Icon(
              Icons.star,
              size: 36,
              color: starIndex <= selectedRating
                  ? Colors.orange
                  : Colors.grey,
            ),
          );
        }),
      ),
    );
  }

  Widget _timeField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
