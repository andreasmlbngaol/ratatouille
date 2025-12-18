import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna sesuai Desain
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
          /// 🎨 GRADIENT OVERLAY BOTTOM (Dipindahkan ke atas Pattern agar terlihat)
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

              /// LIST DEVELOPER
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      // LOGO RATATOUILLE
                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/ratatuli.png",
                          height: 100, // Adjusted height
                        ),
                      ),

                      // ITEM 1: Andreas (Foto Kiri)
                      GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.andreDetailPage);
                        },
                        child: _DeveloperCard(
                          name: "Andreas",
                          role: "Full Stack Developer",
                          imageAsset: "assets/images/andre.png", // Sesuaikan path
                          isPhotoLeft: true,
                          brownText: brownText,
                          cardColor: devCardColor,
                          arrowColor: arrowBtnColor,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ITEM 2: Bintang (Foto Kanan)
                      GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.bintangDetailPage);
                        },
                        child: _DeveloperCard(
                          name: "Bintang",
                          role: "Versatile Developer",
                          imageAsset: "assets/images/bintang.png", // Sesuaikan path
                          isPhotoLeft: false, // Foto di kanan
                          brownText: brownText,
                          cardColor: devCardColor,
                          arrowColor: arrowBtnColor,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ITEM 3: Clara (Foto Kiri)
                      GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.claraDetailPage);
                        },
                        child: _DeveloperCard(
                          name: "Clara",
                          role: "UI/UX Designer",
                          imageAsset: "assets/images/clara.png", // Sesuaikan path
                          isPhotoLeft: true,
                          brownText: brownText,
                          cardColor: devCardColor,
                          arrowColor: arrowBtnColor,
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
}

// WIDGET KHUSUS KARTU DEVELOPER
class _DeveloperCard extends StatelessWidget {
  final String name;
  final String role;
  final String imageAsset;
  final bool isPhotoLeft;
  final Color brownText;
  final Color cardColor;
  final Color arrowColor;

  const _DeveloperCard({
    required this.name,
    required this.role,
    required this.imageAsset,
    required this.isPhotoLeft,
    required this.brownText,
    required this.cardColor,
    required this.arrowColor,
  });

  @override
  Widget build(BuildContext context) {
    // Ukuran komponen
    const double avatarSize = 90;

    // Widget Avatar
    Widget avatarWidget = Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2), // Opsional border putih
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          imageAsset,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey,
            child: const Icon(Icons.person, color: Colors.white, size: 40),
          ),
        ),
      ),
    );

    // Widget Info Card (Nama & Role)
    Widget infoCardWidget = Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                color: brownText,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              role,
              style: TextStyle(
                color: brownText.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );

    // Widget Tombol Panah Kecil
    Widget arrowButtonWidget = Container(
      height: 70, // Tinggi disesuaikan agar proporsional dengan card
      width: 40,
      decoration: BoxDecoration(
        color: arrowColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          isPhotoLeft ? Icons.chevron_right : Icons.chevron_left,
          color: brownText,
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: isPhotoLeft
          ? [
        // LAYOUT: FOTO - CARD - PANAH
        avatarWidget,
        const SizedBox(width: 12),
        infoCardWidget,
        const SizedBox(width: 8),
        arrowButtonWidget,
      ]
          : [
        // LAYOUT: CARD - PANAH - FOTO
        infoCardWidget,
        const SizedBox(width: 8),
        arrowButtonWidget,
        const SizedBox(width: 12),
        avatarWidget,
      ],
    );
  }
}
