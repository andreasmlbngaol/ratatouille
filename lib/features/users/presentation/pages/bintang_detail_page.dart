import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// =============================
// DETAIL DEVELOPER PAGE
// =============================
class BintangDetailPage extends StatelessWidget {
  const BintangDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color creamColor = Color(0xFFFFFDDE); // Background utama
    const Color orangeColor = Color(0xFFF3551E); // Header orange
    const Color brownText = Color(0xFF5E2A25); // Warna teks coklat

    // Warna khusus kartu developer (Kuning lebih tua sedikit dari background)
    const Color devCardColor = Color(0xFFFFF3C4);
    const Color arrowBtnColor = Color(0xFFFFE082); // Warna tombol panah

    return Scaffold(
      backgroundColor: creamColor,
      body: Stack(
        children: [
          /// 🎨 GRADIENT OVERLAY BOTTOM
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFFFF3D00).withOpacity(0.4),
                    const Color(0xFFFFFDDE).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          /// 🍴 PATTERN BAWAH KIRI
          Positioned(
            bottom: 0,
            left: 0,
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/images/Resep_bottom_left.png',
                width: 140,
              ),
            ),
          ),

          /// 🍴 PATTERN BAWAH KANAN
          Positioned(
            bottom: 0,
            right: 0,
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/images/Resep_bottom_right.png',
                width: 140,
              ),
            ),
          ),

          /// KONTEN UTAMA
          Column(
            children: [
              /// 🔶 HEADER TENTANG KAMI
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                    16,
                    MediaQuery.of(context).padding.top + 20,
                    16,
                    24
                ),
                decoration: const BoxDecoration(
                  color: orangeColor,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Tentang kami",
                      style: TextStyle(
                        fontFamily: 'Serif',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // ===== MAIN CONTENT =====
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Profile Image
                      const SizedBox(height: 16),
                      // Foto Profil
                      Container(
                        padding: const EdgeInsets.all(4), // Border putih tipis jika mau
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                        child: const CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage('assets/images/bintang.png'),
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _infoCard(),
                      const SizedBox(height: 16),
                      _quoteCard(),
                      const SizedBox(height: 16),
                      _socialCard(),


                    ],
                  ),
                ),
              ),
              /// FOOTER TEXT
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "Created by Suka Kotlin",
                  style: TextStyle(
                    color: brownText,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C4), // Disesuaikan dengan devCardColor
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFE082), width: 1.5), // Disesuaikan border
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(label: 'Nama', value: 'Bintang Aulia'),
          _InfoRow(label: 'NIM', value: '231401074'),
          _InfoRow(label: 'Kom', value: 'B'),
          _InfoRow(label: 'Makanan Kesukaan', value: 'Mie Tumis Ikan Teri'),
        ],
      ),
    );
  }

  Widget _quoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C4), // Disesuaikan
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFE082), width: 1.5),
      ),
      child: const Column(
        children: [
          Text('"Adili Patrick Kluivert"', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text('- Shin Tae Yong', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _socialCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C4),
        border: Border.all(color: const Color(0xFFFFE082), width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          _SocialRow(icon: Icons.email, text: 'bintangaulia@students.usu.ac.id'),
          _SocialRow(icon: Icons.camera_alt, text: '_bintang_aulia'),
          _SocialRow(icon: Icons.code, text: 'BintangAull'),
          _SocialRow(icon: Icons.work, text: 'Bintang Aulia'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          const Text(": "),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SocialRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF5E2A25)),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Color(0xFF5E2A25))),
        ],
      ),
    );
  }
}
