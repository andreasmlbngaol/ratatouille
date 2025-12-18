import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AndreDetailPage extends StatelessWidget {
  const AndreDetailPage({super.key});

  // Fungsi helper untuk membuka URL
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $urlString');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  // Fungsi khusus untuk email
  Future<void> _launchEmail(String email) async {
    final Uri url = Uri(
      scheme: 'mailto',
      path: email,
    );
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        debugPrint('Could not launch email');
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
    }
  }

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
                          backgroundImage: AssetImage('assets/images/andre.png'),
                          backgroundColor: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Info Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: devCardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: arrowBtnColor, width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InfoRow(label: 'Nama', value: 'Andreas M Lbn Gaol', textColor: brownText),
                            const SizedBox(height: 12),
                            InfoRow(label: 'NIM', value: '221401067', textColor: brownText),
                            const SizedBox(height: 12),
                            InfoRow(label: 'KOM', value: 'B', textColor: brownText),
                            const SizedBox(height: 12),
                            InfoRow(
                              label: 'Makanan Kesukaan',
                              value: 'Makanan yang dibaguri',
                              textColor: brownText,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Description Card (Gambar Andre Ajaib)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: devCardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: arrowBtnColor, width: 1.5),
                        ),
                        child: Image.asset(
                          'assets/images/andre_ajaib.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Social Media (Clickable)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Email
                          IconButton(
                            onPressed: () => _launchEmail('goto:lgandre45@gmail.com'), // Ganti email sesuai data
                            icon: Icon(Icons.mail, size: 30, color: brownText),
                          ),
                          const SizedBox(width: 10),
                          
                          // Instagram
                          IconButton(
                            onPressed: () => _launchUrl('https://instagram.com/andreasmlbngaol_'), // Ganti URL
                            icon: Icon(Icons.camera_alt, size: 30, color: brownText),
                          ),
                          const SizedBox(width: 10),
                          
                          // GitHub / Code
                          IconButton(
                            onPressed: () => _launchUrl('https://www.linkedin.com/in/andreas-manatar-lumban-gaol-a11a641a8/'), // Ganti URL
                            icon: Icon(Icons.code, size: 30, color: brownText),
                          ),
                          const SizedBox(width: 10),
                          
                          // LinkedIn / Work
                          IconButton(
                            onPressed: () => _launchUrl('https://linkedin.com/in/andreas-gaol'), // Ganti URL
                            icon: Icon(Icons.work, size: 30, color: brownText),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.textColor = const Color(0xFF5E2A25),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
        ),
        Text(':', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: textColor),
          ),
        ),
      ],
    );
  }
}
