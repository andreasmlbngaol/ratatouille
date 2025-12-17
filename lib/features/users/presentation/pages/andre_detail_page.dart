import 'package:flutter/material.dart';

class AndreDetailPage extends StatelessWidget {
  const AndreDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7CC),
      body: Stack(
        children: [
          // ===== BACKGROUND PATTERN =====
          Positioned(
            bottom: -10,
            left: -10,
            child: Image.asset(
              'assets/images/Resep_bottom_left.png',
              width: 140,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: -10,
            right: -10,
            child: Image.asset(
              'assets/images/Resep_bottom_right.png',
              width: 140,
              fit: BoxFit.contain,
            ),
          ),

          // ===== MAIN CONTENT =====
          SafeArea(
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
                        'Tentang kami',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Profile Image
                const CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage('assets/images/andre.png'),
                ),

                const SizedBox(height: 20),

                // Info Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0B3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange, width: 1.5),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoRow(label: 'Nama', value: 'Andreas M Lbn Gaol'),
                      SizedBox(height: 6),
                      InfoRow(label: 'NIM', value: '221401067'),
                      SizedBox(height: 6),
                      InfoRow(label: 'KOM', value: 'B'),
                      SizedBox(height: 6),
                      InfoRow(
                        label: 'Makanan Kesukaan',
                        value: 'Makanan yang dibaguri',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Description Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  height: 110,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0B3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange, width: 1.5),
                  ),
                  child: const Text(
                    'Tambahkan deskripsi singkat tentang developer di sini.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                const Spacer(),

                // Social Media
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.mail, size: 30),
                    SizedBox(width: 20),
                    Icon(Icons.camera_alt, size: 30),
                    SizedBox(width: 20),
                    Icon(Icons.code, size: 30),
                    SizedBox(width: 20),
                    Icon(Icons.work, size: 30),
                  ],
                ),

                const SizedBox(height: 16),

                // Footer
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Created by Suka Kotlin',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Text(':'),
        const SizedBox(width: 8),
        Expanded(child: Text(value)),
      ],
    );
  }
}
