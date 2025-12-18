import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ClaraDetailPage extends StatelessWidget {
  const ClaraDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color creamColor = Color(0xFFFFFDDE); // Background utama
    const Color orangeColor = Color(0xFFF3551E); // Header orange
    const Color brownText = Color(0xFF5E2A25); // Warna teks coklat

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

              /// KONTEN UTAMA SCROLLABLE
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      // Foto Profil
                      Container(
                        padding: const EdgeInsets.all(4), 
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                        child: const CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage('assets/images/clara.png'),
                          backgroundColor: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // KOTAK 1: Info (Gradasi Gambar 1) [Teal - Merah - Kuning]
                      _gradientCard(
                        colors: const [
                          Color(0xFF1C4341), // Teal Gelap
                          Color(0xFFE93E5A), // Merah Pink
                          Color(0xFFFFE202), // Kuning
                        ],
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _InfoRow(label: 'Nama', value: 'Clara Angelin Pijoh'),
                            _InfoRow(label: 'NIM', value: '231401086'),
                            _InfoRow(label: 'KOM', value: 'B'),
                            _InfoRow(label: 'Makanan Kesukaan', value: 'Nasi goreng'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // KOTAK 2: Quote (Gradasi Gambar 2) [Merah - Coklat - Ungu]
                      _gradientCard(
                        colors: const [
                          Color(0xFFFF021C), // Merah
                          Color(0xFF43381C), // Coklat Gelap (Transisi)
                          Color(0xFF9A02FF), // Ungu
                        ],
                        child: Column(
                          children: [
                            Text(
                              '"Jangan pernah kasih aku masak #serius"',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.comicNeue(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '"Clara 1945"',
                                style: GoogleFonts.comicNeue(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // KOTAK 3: Social (Gradasi Gambar 3) [Hijau - Biru - Merah]
                      _gradientCard(
                        colors: const [
                          Color(0xFF1AFF1A), // Hijau Neon
                          Color(0xFF43381C), // Coklat (Transisi)
                          Color(0xFF022DFF), // Biru
                          Color(0xFFFF0202), // Merah
                        ],
                        child: const Column(
                          children: [
                            _SocialRow(icon: Icons.email, text: 'claraangelinn@gmail.com'),
                            _SocialRow(icon: Icons.camera_alt, text: 'mictaangelin'), // Instagram
                            _SocialRow(icon: Icons.code, text: 'indomiekwah'), // Github
                            _SocialRow(icon: Icons.work, text: 'Clara Angelin Pijoh'), // LinkedIn
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

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

  // Widget Helper untuk Kotak Bergradasi
  Widget _gradientCard({
    required List<Color> colors,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // Widget Helper untuk Titik Indikator
  Widget _buildDot(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFF5A1F) : Colors.grey.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}

// Widget Baris Info (Nama, NIM, dll) - SEMUA TEXT MENGGUNAKAN COMIC NEUE
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
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            ": ",
            style: GoogleFonts.comicNeue(color: Colors.white), // Font Comic Neue
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.comicNeue(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Baris Social Media - SEMUA TEXT MENGGUNAKAN COMIC NEUE
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
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
