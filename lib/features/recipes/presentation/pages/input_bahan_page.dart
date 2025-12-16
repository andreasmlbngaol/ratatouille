import 'package:flutter/material.dart';

class InputBahanPage extends StatefulWidget {
  const InputBahanPage({super.key});

  @override
  State<InputBahanPage> createState() => _InputBahanPageState();
}

class _InputBahanPageState extends State<InputBahanPage> {
  final TextEditingController _bahanController = TextEditingController();
  final List<String> _bahanList = [];

  void _tambahBahan() {
    final text = _bahanController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _bahanList.add(text);
      _bahanController.clear();
    });
  }

  void _hapusBahan(int index) {
    setState(() {
      _bahanList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8D9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF15A24),
        title: const Text(
          'Buat Resep',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bahan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            /// List bahan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.brown.shade300),
              ),
              child: _bahanList.isEmpty
                  ? const Text(
                'Belum ada bahan',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.brown),
              )
                  : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  _bahanList.length,
                      (index) => Chip(
                    label: Text(_bahanList[index]),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () => _hapusBahan(index),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Masukkan bahan',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            /// Input bahan
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _bahanController,
                    decoration: InputDecoration(
                      hintText: 'Tambahkan bahan...',
                      filled: true,
                      fillColor: const Color(0xFFE6F0E6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _tambahBahan(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: const Color(0xFF3E5C4A),
                  onPressed: _tambahBahan,
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Text(
              'Ketik bahan lalu pilih bahan yang tersedia atau tambah bahan baru agar koki lain dapat filter kulkasnya!',
              style: TextStyle(fontSize: 12, color: Colors.brown),
            ),

            const Spacer(),

            /// Next button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E5C4A),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: _bahanList.isEmpty
                    ? null
                    : () {
                  // TODO: navigasi ke halaman berikutnya
                },
                icon: const Text('Next'),
                label: const Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
