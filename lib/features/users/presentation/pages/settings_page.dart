import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/features/users/presentation/provider/auth_provider.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna sesuai Desain
    const Color creamColor = Color(0xFFFFFDDE); // Background utama
    const Color orangeColor = Color(0xFFF3551E); // Header orange
    const Color brownText = Color(0xFF5E2A25); // Warna teks coklat
    const Color cardColor = Color(0xFFFFF8E1); // Warna background card (kuning muda)
    const Color cardBorderColor = Color(0xFFD7CCC8); // Warna border card
    const Color logoutRedColor = Color(0xFFB71C1C); // Warna merah tombol logout

    return Scaffold(
      backgroundColor: creamColor,
      body: Stack(
        children: [
          /// 🍴 PATTERN BAWAH KIRI (Sama seperti referensi)
          Positioned(
            bottom: 0,
            left: 0,
            child: Opacity(
              opacity: 0.6, // Sesuaikan transparansi jika perlu
              child: Image.asset(
                'assets/images/Resep_bottom_left.png',
                width: 140,
              ),
            ),
          ),

          /// 🍴 PATTERN BAWAH KANAN (Sama seperti referensi)
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
              /// 🔶 HEADER PENGATURAN
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
                      "Pengaturan",
                      style: TextStyle(
                        fontFamily: 'Serif', // Menggunakan font serif sesuai gambar
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              /// ITEM LIST
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Column(
                    children: [
                      // ITEM 1: EMAIL (Read Only / Display)
                      _buildSettingItem(
                        bgColor: cardColor,
                        borderColor: cardBorderColor,
                        child: Row(
                          children: [
                            // Icon Google (Simulasi)
                            SizedBox(
                              width: 24,
                              height: 24,
                              // Ganti dengan SvgPicture.asset("assets/icons/google.svg") jika ada
                              child: const Icon(Icons.g_mobiledata, color: Colors.blue, size: 30),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Email",
                              style: TextStyle(
                                color: brownText,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            // Email User
                            Consumer<AuthProvider>(
                              builder: (context, auth, _) {
                                return Text(
                                  auth.user?.email ?? "andreasm...@gmail.com",
                                  style: TextStyle(
                                    color: brownText.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ITEM 2: TENTANG KAMI (Clickable)
                      GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.developerPage);
                        },
                        child: _buildSettingItem(
                          bgColor: cardColor,
                          borderColor: cardBorderColor,
                          child: const Row(
                            children: [
                              Text(
                                "Tentang kami",
                                style: TextStyle(
                                  color: brownText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Spacer(),
                              Icon(Icons.chevron_right, color: brownText),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // TOMBOL KELUAR (Logout)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            return ElevatedButton(
                              onPressed: () async {
                                await authProvider.signOut();
                                if (context.mounted) {
                                  context.go(AppRoutes.signIn);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: logoutRedColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                shadowColor: Colors.black45,
                              ),
                              child: const Text(
                                "Keluar dari Akun",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
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

  // Widget Helper untuk membuat Kotak Item (Email & Tentang Kami)
  Widget _buildSettingItem({
    required Color bgColor,
    required Color borderColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: child,
    );
  }
}
